import 'package:flutter/material.dart';

import '../controller.dart';
import 'compose_dialog.dart';

class MobileGmailHeader extends StatelessWidget {
  final GmailController ctrl;
  final String accountName;
  final String accountEmail;

  const MobileGmailHeader({
    required this.ctrl,
    required this.accountName,
    required this.accountEmail,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Row(
        children: [
        Icon(
            Icons.mail_outline,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accountName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  accountEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => showComposeDialog(ctrl),
            icon: Icon(
              Icons.edit,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
