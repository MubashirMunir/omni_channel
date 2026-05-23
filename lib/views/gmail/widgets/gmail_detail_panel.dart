import 'package:elite_csr/views/gmail/widgets/show_reply_dialog.dart';
import 'package:flutter/material.dart';
import '../../../models/gmail_model.dart';

import '../controller.dart';
import 'bottom_reply_bar.dart';
import 'compose_dialog.dart';

class GmailDetailPanel extends StatelessWidget {
  final GmailController ctrl;
  final bool showBackButton;
  final VoidCallback? onBack;

  const GmailDetailPanel({super.key,
    required this.ctrl,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mail = ctrl.selectedEmail.value;



    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
        Container(
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
      ),

      Expanded(
        child: mail == null
            ? Center(
          child: Text(
            "Select a conversation",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
            ),
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Subject sirf top par 1 dafa show hoga
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 12),
              child: Text(
                mail.subject,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            /// Thread mails / replies list
            Expanded(
              child: ListView.separated(
                controller: ctrl.mailScrollController,
                padding: const EdgeInsets.fromLTRB(28, 10, 28, 34),
                itemCount: ctrl.threadMails.length,
                separatorBuilder: (_, __) => const SizedBox(height: 22),
                itemBuilder: (context, index) {
                  final item = ctrl.threadMails[index];
                  final isMine = item.fromEmail == ctrl.threadMails;

                  return GmailThreadMessageItem(
                    mail: item,
                    isMine: isMine,
                    theme: theme,
                    onStarTap: () => ctrl.toggleStar(item),
                  );
                },              ),
            ),
          ],
        ),
      ),
          BottomReplyBar(
            ctrl: ctrl,
            mail: ctrl.selectedEmail.value!,
          ),
        ],
      ),
    );
  }
}
class GmailThreadMessageItem extends StatelessWidget {
  final GmailMessageModel mail;
  final bool isMine;
  final ThemeData theme;
  final VoidCallback onStarTap;

  const GmailThreadMessageItem({
    super.key,
    required this.mail,
    required this.isMine,
    required this.theme,
    required this.onStarTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = mail.fromName.trim();
    final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isMine ? 70 : 0,
          right: isMine ? 0 : 70,
        ),
        padding: EdgeInsets.all(isMine ? 16 : 0),
        decoration: BoxDecoration(
          color: isMine
              ? theme.cardColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: isMine
              ? Border.all(
            color: theme.dividerColor.withOpacity(0.22),
          )
              : null,
          boxShadow: isMine
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ]
              : [],
        ),
        child: Column(
          crossAxisAlignment:
          isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: isMine ? TextDirection.rtl : TextDirection.ltr,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                  child: Text(
                    firstLetter,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: isMine
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        isMine ? 'Me' : mail.fromName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '<${mail.fromEmail}>',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'to ${mail.toEmail}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  mail.time,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                    fontSize: 13,
                  ),
                ),

                if (!isMine)
                  IconButton(
                    onPressed: onStarTap,
                    icon: Icon(
                      mail.isStarred ? Icons.star : Icons.star_border,
                      color: mail.isStarred ? Colors.amber : theme.hintColor,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            SelectableText(
              mail.body,
              textAlign: isMine ? TextAlign.right : TextAlign.left,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                fontSize: 15.5,
                color: theme.colorScheme.onSurface,
              ),
            ),

            if (mail.hasAttachment) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.attach_file,
                      color: theme.colorScheme.onSurface,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'attachment.pdf',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.download_outlined,
                      color: theme.colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}