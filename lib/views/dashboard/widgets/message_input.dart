import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

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
            child: Expanded(
              child: CallbackShortcuts(
                bindings: {
                  const SingleActivator(
                    LogicalKeyboardKey.enter,
                    control: true,
                  ): () {
                    onSend(); // ya controller.sendMessage();
                  },

                  // Mac ke liye Command + Enter
                  const SingleActivator(
                    LogicalKeyboardKey.enter,
                    meta: true,
                  ): () {
                    onSend(); // ya controller.sendMessage();
                  },
                },
                child: TextField(
                  controller: controller.msgController,
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.white,
                  ),
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
            )
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
