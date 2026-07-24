import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../theme/theme.dart';
import '../controller.dart';

class MessageInput extends StatelessWidget {
  final DashboardController controller;
  final VoidCallback onSend;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

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

  // ============================================================
  // NORMAL MESSAGE INPUT
  // ============================================================

  Widget _normalInput(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// =====================================================
        /// SELECTED IMAGE PREVIEW
        /// =====================================================

        Obx(() {
          final file = controller.selectedAttachment.value;
          final type = controller.selectedAttachmentType.value;

          /// No attachment
          if (file == null) {
            return const SizedBox.shrink();
          }

          /// Currently only image preview
          if (type != "image") {
            return const SizedBox.shrink();
          }

          /// Image bytes unavailable
          if (file.bytes == null || file.bytes!.isEmpty) {
            return const SizedBox.shrink();
          }

          return




            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 110,
                margin: const EdgeInsets.only(
                  left: 4,
                  right: 4,
                  bottom: 4,
                ),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.black,
                  borderRadius: BorderRadius.circular(
                    AppTheme.radiusLG(context),
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    /// IMAGE PREVIEW
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(
                        file.bytes!,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                        errorBuilder: (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return Container(
                            width: 90,
                            height: 90,
                            alignment: Alignment.center,
                            color: Colors.white.withOpacity(0.10),
                            child: const Icon(
                              Icons.broken_image_outlined,
                              color: Colors.white54,
                              size: 32,
                            ),
                          );
                        },
                      ),
                    ),

                    /// REMOVE IMAGE - TOP RIGHT
                    Positioned(
                      top: -7,
                      right: -7,
                      child: InkWell(
                        onTap: controller.clearSelectedAttachment,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.80),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white24,
                            ),
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );        }),

        /// =====================================================
        /// TEXT / MESSAGE INPUT
        /// =====================================================

        Container(
          margin: const EdgeInsets.all(4),
          constraints: const BoxConstraints(
            minHeight: 50,
            maxHeight: 145,
          ),
          decoration: BoxDecoration(
            color: AppTheme.black,
            borderRadius: BorderRadius.circular(
              AppTheme.radiusLG(context),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// =================================================
              /// PREFIX ICONS
              /// =================================================

              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  bottom: 5,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// EMOJI
                    IconButton(
                      onPressed: controller.toggleEmojiBoard,
                      icon: Obx(
                            () => Icon(
                          controller.showEmojiBoard.value
                              ? Icons.keyboard_alt_outlined
                              : Icons.emoji_emotions_outlined,
                          color: AppTheme.white,
                        ),
                      ),
                    ),

                    /// IMAGE / ATTACHMENT
                    IconButton(
                      onPressed:
                      controller.isPickingAttachment.value
                          ? null
                          : controller.pickImage,
                      icon: controller.isPickingAttachment.value
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(
                        Icons.add,
                      ),
                      color: AppTheme.white,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                  ],
                ),
              ),

              /// =================================================
              /// TEXT FIELD
              /// =================================================

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
                    style:
                    Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      fontSize: 14,
                      color: AppTheme.white,
                    ),
                    decoration: InputDecoration(
                      hintText: controller.selectedAttachment.value != null
                          ? "Add a caption..."
                          : "Type a message",
                      hintStyle: TextStyle(
                        color: AppTheme.white.withOpacity(0.55),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 20,
                      ),
                    ),
                  ),
                ),
              ),

              /// =================================================
              /// SEND / MIC BUTTON
              /// =================================================

              Padding(
                padding: const EdgeInsets.only(
                  right: 6,
                  bottom: 6,
                ),
                child: Obx(() {
                  /// This Obx is important because selectedAttachment
                  /// is Rx and Send button must update when image selected.
                  final hasAttachment =
                      controller.selectedAttachment.value != null;

                  return ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller.msgController,
                    builder: (
                        context,
                        value,
                        child,
                        ) {
                      final hasText =
                          value.text.trim().isNotEmpty;

                      /// Text OR image = Send button
                      final canSend =
                          hasText || hasAttachment;

                      return AnimatedSwitcher(
                        duration:
                        const Duration(milliseconds: 120),

                        child: canSend
                            ? IconButton(
                          key: const ValueKey(
                            "send_button",
                          ),
                          onPressed: onSend,
                          style: IconButton.styleFrom(
                            backgroundColor:
                            AppTheme.primaryColor,
                            fixedSize:
                            const Size(40, 40),
                            shape: const CircleBorder(),
                            padding: EdgeInsets.zero,
                            tapTargetSize:
                            MaterialTapTargetSize
                                .shrinkWrap,
                          ),
                          icon: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                        )
                            : IconButton(
                          key: const ValueKey(
                            "mic_button",
                          ),
                          onPressed:
                          controller.startVoiceRecording,
                          style: IconButton.styleFrom(
                            backgroundColor:
                            AppTheme.primaryColor,
                            fixedSize:
                            const Size(40, 40),
                            shape: const CircleBorder(),
                            padding: EdgeInsets.zero,
                            tapTargetSize:
                            MaterialTapTargetSize
                                .shrinkWrap,
                          ),
                          icon: const Icon(
                            Icons.mic,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // RECORDING INPUT
  // ============================================================

  Widget _recordingInput(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      constraints: const BoxConstraints(
        minHeight: 58,
        maxHeight: 70,
      ),
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(
          AppTheme.radiusLG(context),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 6),

          /// DELETE / CANCEL
          IconButton(
            onPressed: controller.cancelVoiceRecording,
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.red,
              size: 24,
            ),
          ),

          const SizedBox(width: 4),

          /// RED MIC
          const Icon(
            Icons.mic,
            color: Colors.red,
            size: 20,
          ),

          const SizedBox(width: 8),

          /// TIMER
          Obx(
                () => Text(
              controller.voiceRecordingTime.value,
              style:
              Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color: AppTheme.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// SIMPLE VOICE LEVEL BAR
          Expanded(
            child: Obx(
                  () => ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: controller.voiceLevel.value,
                  minHeight: 5,
                  backgroundColor:
                  Colors.white.withOpacity(0.15),
                  valueColor:
                  AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryColor,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          /// PAUSE / RESUME
          Obx(
                () => IconButton(
              onPressed:
              controller.togglePauseResumeVoiceRecording,
              icon: Icon(
                controller.isVoicePaused.value
                    ? Icons.play_arrow_rounded
                    : Icons.pause_rounded,
                color: AppTheme.white,
                size: 24,
              ),
            ),
          ),

          /// SEND VOICE
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Obx(
                  () => IconButton(
                onPressed:
                controller.isVoiceSending.value
                    ? null
                    : controller.stopVoiceRecordingAndSend,
                style: IconButton.styleFrom(
                  backgroundColor:
                  AppTheme.primaryColor,
                  fixedSize: const Size(40, 40),
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                  tapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,
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
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILE SIZE FORMAT
  // ============================================================

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return "$bytes B";
    }

    if (bytes < 1024 * 1024) {
      return "${(bytes / 1024).toStringAsFixed(1)} KB";
    }

    return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
  }
}