import 'package:elite_csr/views/gmail/widgets/show_reply_dialog.dart';
import 'package:flutter/material.dart';

import '../../../models/gmail_model.dart';
import '../controller.dart';

class BottomReplyBar extends StatelessWidget {
  final GmailController ctrl;
  final GmailMessageModel mail;

  const BottomReplyBar({
    required this.ctrl,
    required this.mail,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withOpacity(0.25),
          ),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => showReplyDialog(ctrl, mail),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: theme.dividerColor.withOpacity(0.20),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.reply,
                size: 19,
                color: theme.hintColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Reply to ${mail.fromName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ),
              Icon(
                Icons.open_in_new,
                size: 18,
                color: theme.hintColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
