import 'package:flutter/material.dart';

import '../../../models/gmail_model.dart';

class MailListTile extends StatelessWidget {
  final GmailMessageModel mail;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onStarTap;

  const MailListTile({
    required this.mail,
    required this.selected,
    required this.onTap,
    required this.onStarTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final selectedColor = theme.colorScheme.primary.withOpacity(0.10);
    final unreadColor = theme.cardColor;
    final readColor = theme.scaffoldBackgroundColor;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: selected
            ? selectedColor
            : mail.isUnread
            ? unreadColor
            : readColor,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
              child: Text(
                mail.fromName.isNotEmpty ? mail.fromName[0].toUpperCase() : '?',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          mail.fromName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: mail.isUnread
                                ? FontWeight.w800
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        mail.time,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                          fontSize: 11,
                          fontWeight: mail.isUnread
                              ? FontWeight.w800
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    mail.subject,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: mail.isUnread
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          mail.snippet,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                      if (mail.hasAttachment)
                        Icon(
                          Icons.attach_file,
                          size: 16,
                          color: theme.hintColor,
                        ),
                      GestureDetector(
                        onTap: onStarTap,
                        child: Icon(
                          mail.isStarred ? Icons.star : Icons.star_border,
                          size: 19,
                          color: mail.isStarred
                              ? Colors.amber
                              : theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
