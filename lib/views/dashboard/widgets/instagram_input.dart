import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller.dart';

class InstagramMessageInput extends StatelessWidget {
  final DashboardController controller;
  final VoidCallback onSend;

  const InstagramMessageInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  static const Color instaPurple = Color(0xFFC13584);
  static const Color instaPink = Color(0xFFE1306C);
  static const Color instaBlue = Color(0xFF405DE6);

  static const Color inputBg = Color(0xFFF7F7F7);
  static const Color darkText = Color(0xFF262626);
  static const Color hintColor = Color(0xFF8E8E8E);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isRecording =
          controller.isVoiceRecording.value ||
              controller.isVoicePaused.value;

      if (isRecording) {
        return _recordingInput(context);
      }

      return _normalInput(context);
    });
  }

  /// =========================
  /// NORMAL INSTAGRAM INPUT
  /// =========================
  Widget _normalInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.06),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// CAMERA BUTTON
          _gradientActionButton(
            icon: Icons.camera_alt_rounded,
            onPressed: () {
              // TODO: open camera
            },
          ),

          const SizedBox(width: 8),

          /// MESSAGE FIELD
          Expanded(
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 44,
                maxHeight: 135,
              ),
              decoration: BoxDecoration(
                color: inputBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFE5E5E5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// TEXT FIELD
                  Expanded(
                    child: CallbackShortcuts(
                      bindings: {
                        const SingleActivator(
                          LogicalKeyboardKey.enter,
                          control: true,
                        ): () {
                          onSend();
                        },

                        const SingleActivator(
                          LogicalKeyboardKey.enter,
                          meta: true,
                        ): () {
                          onSend();
                        },
                      },
                      child: TextField(
                        controller: controller.msgController,
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        style: const TextStyle(
                          color: darkText,
                          fontSize: 14,
                          height: 1.4,
                        ),
                        decoration: const InputDecoration(
                          filled: true

                          ,fillColor: Colors.transparent,
                          hintText: "Message...",
                          hintStyle: TextStyle(
                            color: hintColor,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          // isDense: true,
                          // contentPadding: EdgeInsets.fromLTRB(
                          //   15,
                          //   12,
                          //   6,
                          //   11,
                          // ),
                        ),
                      ),
                    ),
                  ),

                  /// EMOJI BUTTON
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 2,
                      bottom: 3,
                    ),
                    child: IconButton(
                      onPressed: controller.toggleEmojiBoard,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      splashRadius: 19,
                      icon: Obx(
                            () => Icon(
                          controller.showEmojiBoard.value
                              ? Icons.keyboard_alt_outlined
                              : Icons.sentiment_satisfied_alt_rounded,
                          color: instaPurple,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 5),

          /// IMAGE BUTTON
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller.msgController,
            builder: (context, value, child) {
              final hasText = value.text.trim().isNotEmpty;

              if (hasText) {
                return const SizedBox.shrink();
              }

              return _plainActionButton(
                icon: Icons.image_outlined,
                onPressed: () {
                  // TODO: image picker
                },
              );
            },
          ),

          /// SEND / MIC
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller.msgController,
            builder: (context, value, child) {
              final hasText = value.text.trim().isNotEmpty;

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: hasText
                    ? _sendButton()
                    : _micButton(),
              );
            },
          ),
        ],
      ),
    );
  }

  /// =========================
  /// SEND BUTTON
  /// =========================
  Widget _sendButton() {
    return IconButton(
      key: const ValueKey("instagram_send_button"),
      onPressed: onSend,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 42,
        minHeight: 42,
      ),
      splashRadius: 21,
      icon: const Icon(
        Icons.send_rounded,
        color: instaPurple,
        size: 25,
      ),
    );
  }

  /// =========================
  /// MIC BUTTON
  /// =========================
  Widget _micButton() {
    return IconButton(
      key: const ValueKey("instagram_mic_button"),
      onPressed: controller.startVoiceRecording,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 40,
        minHeight: 42,
      ),
      splashRadius: 21,
      icon: const Icon(
        Icons.mic_none_rounded,
        color: darkText,
        size: 25,
      ),
    );
  }

  /// =========================
  /// NORMAL ACTION BUTTON
  /// =========================
  Widget _plainActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 38,
        minHeight: 42,
      ),
      splashRadius: 20,
      icon: Icon(
        icon,
        color: darkText,
        size: 24,
      ),
    );
  }

  /// =========================
  /// INSTAGRAM GRADIENT BUTTON
  /// =========================
  Widget _gradientActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              instaBlue,
              instaPurple,
              instaPink,
            ],
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 21,
        ),
      ),
    );
  }

  /// =========================
  /// RECORDING INPUT
  /// =========================
  Widget _recordingInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.06),
          ),
        ),
      ),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 54,
          maxHeight: 60,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(
          color: inputBg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: const Color(0xFFE5E5E5),
          ),
        ),
        child: Row(
          children: [
            /// DELETE / CANCEL
            IconButton(
              onPressed: controller.cancelVoiceRecording,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
                size: 23,
              ),
            ),

            const SizedBox(width: 2),

            /// RECORDING DOT / MIC
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: instaPink.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mic_rounded,
                color: instaPink,
                size: 18,
              ),
            ),

            const SizedBox(width: 8),

            /// TIMER
            Obx(
                  () => Text(
                controller.voiceRecordingTime.value,
                style: const TextStyle(
                  color: darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// VOICE LEVEL
            Expanded(
              child: Obx(
                    () => ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: controller.voiceLevel.value,
                    minHeight: 4,
                    backgroundColor:
                    Colors.black.withOpacity(0.08),
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(
                      instaPurple,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 6),

            /// PAUSE / RESUME
            Obx(
                  () => IconButton(
                onPressed:
                controller.togglePauseResumeVoiceRecording,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                icon: Icon(
                  controller.isVoicePaused.value
                      ? Icons.play_arrow_rounded
                      : Icons.pause_rounded,
                  color: instaPurple,
                  size: 25,
                ),
              ),
            ),

            const SizedBox(width: 3),

            /// SEND VOICE
            Obx(
                  () => InkWell(
                onTap: controller.isVoiceSending.value
                    ? null
                    : controller.stopVoiceRecordingAndSend,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        instaBlue,
                        instaPurple,
                        instaPink,
                      ],
                    ),
                  ),
                  child: controller.isVoiceSending.value
                      ? const Center(
                    child: SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  )
                      : const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}