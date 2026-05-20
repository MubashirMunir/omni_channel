import 'package:flutter/material.dart';

import '../controller.dart';
import 'bottom_reply_bar.dart';
import 'gmail_action.dart';

class GmailDetailPanel extends StatelessWidget {
  final GmailController ctrl;
  final bool showBackButton;
  final VoidCallback? onBack;

  GmailDetailPanel({
    required this.ctrl,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mail = ctrl.selectedEmail.value;

    if (mail == null) {
      return Container(
        color: theme.scaffoldBackgroundColor,
        child: Center(
          child: Text(
            'Select an email',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          GmailActionBar(
            ctrl: ctrl,
            showBackButton: showBackButton,
            onBack: onBack,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mail.subject,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor:
                        theme.colorScheme.primary.withOpacity(0.12),
                        child: Text(
                          mail.fromName.isNotEmpty
                              ? mail.fromName[0].toUpperCase()
                              : '?',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mail.fromName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '<${mail.fromEmail}>',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.hintColor,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'to ${mail.toEmail}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.hintColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        mail.time,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                          fontSize: 13,
                        ),
                      ),

                      IconButton(
                        onPressed: () => ctrl.toggleStar(mail),
                        icon: Icon(
                          mail.isStarred ? Icons.star : Icons.star_border,
                          color: mail.isStarred
                              ? Colors.amber
                              : theme.hintColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  SelectableText(
                    mail.body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      fontSize: 15.5,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  if (mail.hasAttachment) ...[
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(14),
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
          ),

          BottomReplyBar(
            ctrl: ctrl,
            mail: mail,
          ),
        ],
      ),
    );
  }
}
