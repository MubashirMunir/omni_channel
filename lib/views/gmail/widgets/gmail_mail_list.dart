import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../controller.dart';
import 'compose_dialog.dart';
import 'list_tile.dart';

class GmailMailList extends StatelessWidget {
  final GmailController ctrl;

  const GmailMailList({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mails = ctrl.filteredEmails;

    return Container(
      child: Column(
        children: [
          Container(
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: 14),
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
                Text(
                  'Inbox',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: ctrl.fetchDemoEmails,
                  icon: Icon(
                    Icons.refresh,
                    size: 20,
                    color: theme.colorScheme.onSurface.withOpacity(0.75),
                  ),
                ),
                IconButton(
                  onPressed: () => showComposeDialog(ctrl),
                  icon: Icon(
                    Icons.edit,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              controller: ctrl.searchController,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Search mail',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.hintColor,
                ),
                filled: true,
                fillColor: theme.cardColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppTheme.radiusLG(context),
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: mails.isEmpty
                ? Center(
              child: Text(
                'No emails found',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            )
                : ListView.separated(
              itemCount: mails.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: theme.dividerColor.withOpacity(0.18),
              ),
              itemBuilder: (context, index) {
                final mail = mails[index];
                final selected = ctrl.selectedEmail.value?.id == mail.id;

                return MailListTile(
                  mail: mail,
                  selected: selected,
                  onTap: () => ctrl.selectEmail(mail),
                  onStarTap: () => ctrl.toggleStar(mail),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
