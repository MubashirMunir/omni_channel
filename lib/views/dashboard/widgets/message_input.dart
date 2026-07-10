// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
//
// import '../../../theme/theme.dart';
// import '../controller.dart';
//
// class MessageInput extends StatelessWidget {
//   final DashboardController controller;
//   final VoidCallback onSend;
//
//   const MessageInput({
//     super.key,
//     required this.controller,
//     required this.onSend,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(4),
//       constraints: const BoxConstraints(minHeight: 50, maxHeight: 145),
//       decoration: BoxDecoration(
//         color: AppTheme.black,
//         borderRadius: BorderRadius.circular(AppTheme.radiusLG(context)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           /// PREFIX ICONS - BOTTOM FIXED
//           Padding(
//             padding: const EdgeInsets.only(left: 8, bottom: 5),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   onPressed: controller.toggleEmojiBoard,
//                   icon: Obx(
//                         () => Icon(
//                       controller.showEmojiBoard.value
//                           ? Icons.keyboard_alt_outlined
//                           : Icons.emoji_emotions_outlined,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {},
//                   icon: const Icon(Icons.add),
//                   color: AppTheme.white,
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(
//                     minWidth: 36,
//                     minHeight: 36,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           /// TEXT FIELD
//           Expanded(
//             child: CallbackShortcuts(
//               bindings: {
//                 const SingleActivator(
//                   LogicalKeyboardKey.enter,
//                   control: true,
//                 ): () {
//                   onSend(); // ya controller.sendMessage();
//                 },
//
//                 // Mac ke liye Command + Enter
//                 const SingleActivator(
//                   LogicalKeyboardKey.enter,
//                   meta: true,
//                 ): () {
//                   onSend(); // ya controller.sendMessage();
//                 },
//               },
//               child: TextField(
//                 controller: controller.msgController,
//                 minLines: 1,
//                 maxLines: 5,
//                 keyboardType: TextInputType.multiline,
//                 textInputAction: TextInputAction.newline,
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   fontSize: 14,
//                   color: AppTheme.white,
//                 ),
//                 decoration: InputDecoration(
//                   hintText: "Type a message",
//                   fillColor: AppTheme.textColor,
//
//                   border: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                   disabledBorder: InputBorder.none,
//                   errorBorder: InputBorder.none,
//                   focusedErrorBorder: InputBorder.none,
//
//                   isDense: true,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 20,
//                   ),
//                 ),
//               ),
//             )
//           ),
//
//           /// SUFFIX SEND BUTTON - BOTTOM FIXED
//           Padding(
//             padding: const EdgeInsets.only(right: 6, bottom: 6),
//             child: ValueListenableBuilder<TextEditingValue>(
//               valueListenable: controller.msgController,
//               builder: (context, value, child) {
//                 final hasText = value.text.trim().isNotEmpty;
//
//                 return AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 120),
//                   child: hasText
//                       ? IconButton(
//                     key: const ValueKey("send_button"),
//                     onPressed: onSend,
//                     style: IconButton.styleFrom(
//                       backgroundColor: AppTheme.primaryColor,
//                       fixedSize: const Size(40, 40),
//                       shape: const CircleBorder(),
//                       padding: EdgeInsets.zero,
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                     icon: const Icon(
//                       Icons.send_rounded,
//                       color: Colors.white,
//                       size: 15,
//                     ),
//                   )
//                       : IconButton(
//                     key: const ValueKey("send_button"),
//                     onPressed: () {},
//                     style: IconButton.styleFrom(
//                       fixedSize: const Size(40, 40),
//                       shape: const CircleBorder(),
//                       padding: EdgeInsets.zero,
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                     icon: const Icon(
//                       Icons.mic,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
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
          controller.isVoiceRecording.value || controller.isVoicePaused.value;

      if (isRecording) {
        return _recordingInput(context);
      }

      return _normalInput(context);
    });
  }

  Widget _normalInput(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      constraints: const BoxConstraints(minHeight: 50, maxHeight: 145),
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// PREFIX ICONS
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: AppTheme.white,
                ),
                decoration: InputDecoration(
                  hintText: "Type a message",
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

          /// SEND / MIC BUTTON
          Padding(
            padding: const EdgeInsets.only(right: 6, bottom: 6),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller.msgController,
              builder: (context, value, child) {
                final hasText = value.text.trim().isNotEmpty;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 120),
                  child: hasText
                      ? IconButton(
                    key: const ValueKey("send_button"),
                    onPressed: onSend,
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      fixedSize: const Size(40, 40),
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                      : IconButton(
                    key: const ValueKey("mic_button"),
                    onPressed: controller.startVoiceRecording,
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      fixedSize: const Size(40, 40),
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _recordingInput(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      constraints: const BoxConstraints(minHeight: 58, maxHeight: 70),
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG(context)),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                  backgroundColor: Colors.white.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(
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
              onPressed: controller.togglePauseResumeVoiceRecording,
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
                onPressed: controller.isVoiceSending.value
                    ? null
                    : controller.stopVoiceRecordingAndSend,
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
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
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}