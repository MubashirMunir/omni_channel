import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/message_model.dart';
import '../../../theme/theme.dart';
import '../../../widgets/text_widget.dart';

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
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.08),
          ),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),

      child: Row(
        children: [

          /// ATTACHMENT BUTTON
          _actionButton(
            icon: Icons.attach_file_rounded,
          ),

          SizedBox(width: 12.w),

          /// EMOJI BUTTON
          _actionButton(
            icon: Icons.emoji_emotions_outlined,
          ),

          SizedBox(width: 16.w),

          /// MESSAGE FIELD
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                minHeight: 58.h,
                maxHeight: 140.h,
              ),

              decoration: BoxDecoration(
                color: const Color(0xffF6F8FC),

                borderRadius:
                BorderRadius.circular(12.r),

                border: Border.all(
                  color: Colors.grey.withOpacity(0.06),
                ),
              ),

              child: TextField(
                controller: controller,

                maxLines: null,

                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),

                decoration: InputDecoration(
                  hintText:
                  "Write a message...",

                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13.sp,
                  ),

                  border: InputBorder.none,

                  contentPadding:
                  EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 18.h,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 16.w),

          /// VOICE BUTTON
          _actionButton(
            icon: Icons.mic_none_rounded,
          ),

          SizedBox(width: 12.w),

          /// SEND BUTTON
          GestureDetector(
            onTap: onSend,

            child: AnimatedContainer(
              duration:
              const Duration(milliseconds: 200),

              width: 40.w,
              height: 40.w,

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor
                        .withOpacity(0.85),
                  ],
                ),

                borderRadius:
                BorderRadius.circular(18.r),

                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor
                        .withOpacity(0.35),

                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
  }) {
    return Container(

      width: 40.w,
      height: 40.w,

      decoration: BoxDecoration(
        color: const Color(0xffF6F8FC),

        borderRadius:
        BorderRadius.circular(16.r),

        border: Border.all(
          color: Colors.grey.withOpacity(0.06),
        ),
      ),

      child: Icon(
        icon,
        color: Colors.grey.shade700,
        size: 22.sp,
      ),
    );
  }
}