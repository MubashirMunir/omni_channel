import 'package:elite_csr/views/gmail/widgets/show_reply_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controller.dart';

class GmailActionBar extends StatelessWidget {
  final GmailController ctrl;
  final bool showBackButton;
  final VoidCallback? onBack;

  const GmailActionBar({
    required this.ctrl,
    required this.showBackButton,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mail = ctrl.selectedEmail.value;

    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withOpacity(0.25),
          ),
        ),
      ),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              onPressed: onBack,
              icon: Icon(
                Icons.arrow_back,
                color: theme.colorScheme.onSurface,
              ),
            ),

          IconButton(
            onPressed: ctrl.archiveSelectedEmail,
            icon: Icon(
              Icons.archive_outlined,
              color: theme.colorScheme.onSurface.withOpacity(0.75),
            ),
            tooltip: 'Archive',
          ),

          IconButton(
            onPressed: ctrl.deleteSelectedEmail,
            icon: Icon(
              Icons.delete_outline,
              color: theme.colorScheme.onSurface.withOpacity(0.75),
            ),
            tooltip: 'Delete',
          ),

          IconButton(
            onPressed: ctrl.markSelectedUnread,
            icon: Icon(
              Icons.mark_email_unread_outlined,
              color: theme.colorScheme.onSurface.withOpacity(0.75),
            ),
            tooltip: 'Mark unread',
          ),

          const Spacer(),

          OutlinedButton.icon(
            onPressed: mail == null
                ? null
                : () {
              showReplyDialog(ctrl, mail);
            },
            icon: const Icon(Icons.reply, size: 18),
            label: const Text('Reply'),
          ),
        ],
      ),
    );
  }
}
