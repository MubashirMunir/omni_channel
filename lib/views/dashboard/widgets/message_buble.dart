import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/message_model.dart';
import '../../../theme/theme.dart';
import '../../../widgets/text_widget.dart';

class MessageBubble extends StatefulWidget {
  final MessageModel message;
  final String platform;


  const MessageBubble({super.key, required this.message
  ,
    required this.platform,

  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool isHover = false;
  bool isMenuOpen = false;
  @override
  Widget build(BuildContext context) {
    final message = widget.message;
    final platform = widget.platform;
    final bool isWhatsApp = platform.toLowerCase() == "whatsapp";
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (_) {
          if (!isMenuOpen) {
            setState(() {
              isHover = false;
            });
          }
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              constraints: const BoxConstraints(maxWidth: 380),
              decoration: BoxDecoration(
                color: message.isMe
                    ? AppTheme.primaryColor
                    : const Color(0xffF3F6FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radiusSM(context)),
                  topRight: Radius.circular(AppTheme.radiusSM(context)),
                  bottomLeft: Radius.circular(
                    message.isMe ? AppTheme.radiusSM(context) : 0,
                  ),
                  bottomRight: Radius.circular(
                    message.isMe ? 0 : AppTheme.radiusSM(context),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(right: message.isMe ? 10 : 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextWidget(
                      message.text,
                      color: message.isMe ? Colors.white : Colors.black,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 4),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextWidget(
                          message.time,
                          style: Theme.of(context).textTheme.bodySmall,
                          color: message.isMe ? Colors.white70 : AppTheme.textColor,
                        ),

                        if (message.isMe && isWhatsApp) ...[
                          const SizedBox(width: 4),
                          _messageStatusIcon(message.status),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (isHover)
              Positioned(
                top: -8,
                right: -7,

                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  menuPadding: EdgeInsets.zero,
                  tooltip: "",
                  position: PopupMenuPosition.under,

                  onOpened: () {
                    setState(() {
                      isMenuOpen = true;
                      isHover = true;
                    });
                  },

                  onCanceled: () {
                    setState(() {
                      isMenuOpen = false;
                      isHover = false;
                    });
                  },

                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 25,
                    color: message.isMe ? Colors.white : Colors.black,
                  ),

                  onSelected: (value) async {
                    setState(() {
                      isMenuOpen = false;
                      isHover = false;
                    });

                    if (value == "copy") {
                      await Clipboard.setData(
                        ClipboardData(text: message.text),
                      );


                    }

                    if (value == "reply") {
                      // reply logic
                    }

                    if (value == "delete") {
                      // delete logic
                    }
                  },

                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "reply",
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back, size: 15),
                          SizedBox(width: 6),
                          Text("Reply"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "copy",
                      child: Row(
                        children: [
                          Icon(Icons.copy_rounded, size: 15),
                          SizedBox(width: 6),
                          Text("Copy"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "delete",
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 15),
                          SizedBox(width: 6),
                          Text("Delete"),
                        ],
                      ),
                    ),
                  ],
                )
              ),
          ],
        ),
      ),
    );
  }
}
Widget _messageStatusIcon(MessageStatus status) {
  switch (status) {
    case MessageStatus.sending:
      return const Icon(
        Icons.access_time_rounded,
        size: 14,
        color: Colors.white70,
      );

    case MessageStatus.sent:
      return const Icon(
        Icons.done,
        size: 15,
        color: Colors.white70,
      );

    case MessageStatus.delivered:
      return const Icon(
        Icons.done_all,
        size: 15,
        color: Colors.white70,
      );

    case MessageStatus.read:
      return const Icon(
        Icons.done_all,
        size: 15,
        color: Colors.lightBlueAccent,
      );

    case MessageStatus.failed:
      return const Icon(
        Icons.error_outline,
        size: 15,
        color: Colors.redAccent,
      );
  }
}