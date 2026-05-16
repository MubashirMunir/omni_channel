import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/message_model.dart';
import '../../../theme/theme.dart';
import '../../../widgets/text_widget.dart';
import '../controller.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),

        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

        constraints: const BoxConstraints(maxWidth: 380),

        decoration: BoxDecoration(
          color: message.isMe ? AppTheme.primaryColor : const Color(0xffF3F6FA),

          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isMe ? 16 : 0),
            bottomRight: Radius.circular(message.isMe ? 0 : 16),
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            /// MESSAGE TEXT
            TextWidget(
              message.text,
              color: message.isMe ? Colors.white : Colors.black87,
              // fontSize: 14,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 6),

            /// TIME
            TextWidget(
              message.time,
              // fontSize: 10,
              style: Theme.of(context).textTheme.bodySmall,
              color: message.isMe ? Colors.white70 : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

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
    return Container(
      margin: EdgeInsets.all(4),
      constraints: const BoxConstraints(minHeight: 50, maxHeight: 145),
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// PREFIX ICONS - BOTTOM FIXED
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  color: AppTheme.white,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
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
            child: TextField(
              controller: controller.msgController,
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.white),
              decoration: InputDecoration(
                hintText: "Type a message",
                fillColor: AppTheme.textColor,

                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,

                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 18,
                ),
              ),
            ),
          ),

          /// SUFFIX SEND BUTTON - BOTTOM FIXED
          Padding(
            padding: const EdgeInsets.only(right: 6, bottom: 5),
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
                          key: const ValueKey("send_button"),
                          onPressed: () {},
                          style: IconButton.styleFrom(
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
} // class MessageInput extends StatelessWidget {

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
//     return TextField(
//       controller: controller.msgController,
//       maxLines: 5,
//       minLines: 1,
//       style: Theme.of(
//         context,
//       ).textTheme.bodyMedium?.copyWith(color: AppTheme.white),
//       decoration: InputDecoration(
//         prefixIcon: Row(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(width: 8),
//
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.emoji_emotions_outlined),
//               color: AppTheme.white,
//               padding: EdgeInsets.zero,
//               constraints: const BoxConstraints(
//                 minWidth: 36,
//                 minHeight: 36,
//               ),
//             ),
//
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.add),
//               color: AppTheme.white,
//               padding: EdgeInsets.zero,
//               constraints: const BoxConstraints(
//                 minWidth: 36,
//                 minHeight: 36,
//               ),
//             ),
//
//             // const SizedBox(width: 6),
//           ],
//         ),
//         suffixIcon: ValueListenableBuilder<TextEditingValue>(
//           valueListenable: controller.msgController,
//           builder: (context, value, child) {
//             final hasText = value.text.trim().isNotEmpty;
//
//             return AnimatedSwitcher(
//               duration: const Duration(milliseconds: 10),
//               child: hasText
//                   ? IconButton(
//                 key: const ValueKey("send_button"),
//                 onPressed: onSend,
//                 style: IconButton.styleFrom(
//                   backgroundColor: AppTheme.primaryColor,
//                   fixedSize: const Size(40, 40), // button size
//                   // minimumSize: const Size(34, 34),
//                   // maximumSize: const Size(34, 34),
//                   shape: const CircleBorder(),
//                   padding: EdgeInsets.zero,
//                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                 ),
//                 icon: const Icon(
//                   Icons.send_rounded,
//                   color: Colors.white,
//                   size: 15, // icon size
//                 ),
//               )
//                   : const SizedBox(
//                 key: ValueKey("empty_button"),
//                 width: 40,
//                 height: 40,
//               ),
//             );
//           },
//         ),
//
//         suffixIconConstraints: const BoxConstraints(
//           minWidth: 46,
//           minHeight: 0,
//         ),
//         prefixIconConstraints: const BoxConstraints(
//           minWidth: 80,
//           minHeight: 0,
//         ),
//
//         hintText: "Type a message",
//         filled: true,
//         fillColor: Theme.of(context).cardColor,
//
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppTheme.radiusLG(context)),
//           borderSide: BorderSide.none,
//         ),
//
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppTheme.radiusLG(context)),
//           borderSide: BorderSide.none,
//         ),
//
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppTheme.radiusLG(context)),
//           borderSide: BorderSide.none,
//         ),
//
//         disabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppTheme.radiusLG(context)),
//           borderSide: BorderSide.none,
//         ),
//
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppTheme.radiusLG(context)),
//           borderSide: BorderSide.none,
//         ),
//
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppTheme.radiusLG(context)),
//           borderSide: BorderSide.none,
//         ),
//
//         isDense: true,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 15,
//           vertical: 18,
//         ),
//       ),
//     );
//   }
// }
