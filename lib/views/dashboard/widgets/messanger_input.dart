import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller.dart';

class MessengerMessageInput extends StatelessWidget {
  final DashboardController controller;
  final VoidCallback onSend;

  const MessengerMessageInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  static const Color messengerBlue = Color(0xFF0084FF);
  static const Color inputBg = Color(0xFFF0F2F5);
  static const Color darkText = Color(0xFF050505);
  static const Color hintColor = Color(0xFF65676B);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isRecording =
          controller.isVoiceRecording.value || controller.isVoicePaused.value;

      if (isRecording) {
        return _recordingInput(context);
      }

      return _normalInput(context);
    });
  }

  /// =========================
  /// NORMAL MESSENGER INPUT
  /// =========================
  Widget _normalInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withOpacity(0.06))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// PLUS BUTTON
          _actionIcon(
            icon: Icons.add_circle_outline_rounded,
            onPressed: () {
              // TODO: attachment menu
            },
          ),

          const SizedBox(width: 2),

          /// GALLERY BUTTON
          _actionIcon(
            icon: Icons.image_outlined,
            onPressed: () {
              // TODO: image / gallery picker
            },
          ),

          const SizedBox(width: 5),

          /// MESSAGE FIELD
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 42, maxHeight: 135),
              decoration: BoxDecoration(
                color: inputBg,
                borderRadius: BorderRadius.circular(24),
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
                          fillColor: Colors.transparent,
                        filled: true,
                          hintText: "Aa",
                          hintStyle: TextStyle(color: hintColor, fontSize: 15),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        //   isDense: true,
                        //   contentPadding: EdgeInsets.fromLTRB(16, 12, 8, 11),
                        ),
                      ),
                    ),
                  ),

                  /// EMOJI BUTTON
                  Padding(
                    padding: const EdgeInsets.only(right: 3, bottom: 3),
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
                          color: messengerBlue,
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

          /// SEND OR MIC
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller.msgController,
            builder: (context, value, child) {
              final hasText = value.text.trim().isNotEmpty;

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: hasText ? _sendButton() : _micButton(),
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
      key: const ValueKey("messenger_send_button"),
      onPressed: onSend,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 42, minHeight: 42),
      splashRadius: 21,
      icon: const Icon(Icons.send_rounded, color: messengerBlue, size: 25),
    );
  }

  /// =========================
  /// MIC BUTTON
  /// =========================
  Widget _micButton() {
    return IconButton(
      key: const ValueKey("messenger_mic_button"),
      onPressed: controller.startVoiceRecording,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 42, minHeight: 42),
      splashRadius: 21,
      icon: const Icon(Icons.mic_rounded, color: messengerBlue, size: 25),
    );
  }

  /// =========================
  /// LEFT ACTION ICONS
  /// =========================
  Widget _actionIcon({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 38, minHeight: 42),
      splashRadius: 20,
      icon: Icon(icon, color: messengerBlue, size: 25),
    );
  }

  /// =========================
  /// VOICE RECORDING INPUT
  /// =========================
  Widget _recordingInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withOpacity(0.06))),
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 52, maxHeight: 58),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: inputBg,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            /// DELETE / CANCEL
            IconButton(
              onPressed: controller.cancelVoiceRecording,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
                size: 23,
              ),
            ),

            const SizedBox(width: 2),

            /// RED MIC
            const Icon(Icons.mic_rounded, color: Colors.redAccent, size: 20),

            const SizedBox(width: 7),

            /// RECORDING TIMER
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

            /// VOICE LEVEL BAR
            Expanded(
              child: Obx(
                () => ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: controller.voiceLevel.value,
                    minHeight: 4,
                    backgroundColor: Colors.black.withOpacity(0.10),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      messengerBlue,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 6),

            /// PAUSE / RESUME
            Obx(
              () => IconButton(
                onPressed: controller.togglePauseResumeVoiceRecording,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                icon: Icon(
                  controller.isVoicePaused.value
                      ? Icons.play_arrow_rounded
                      : Icons.pause_rounded,
                  color: messengerBlue,
                  size: 25,
                ),
              ),
            ),

            const SizedBox(width: 2),

            /// SEND VOICE NOTE
            Obx(
              () => IconButton(
                onPressed: controller.isVoiceSending.value
                    ? null
                    : controller.stopVoiceRecordingAndSend,
                style: IconButton.styleFrom(
                  backgroundColor: messengerBlue,
                  fixedSize: const Size(40, 40),
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: controller.isVoiceSending.value
                    ? const SizedBox(
                        width: 17,
                        height: 17,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
