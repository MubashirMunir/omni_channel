import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/gmail_model.dart';
import '../../responsive/sizes.dart';
import 'controller.dart';

extension _GmailThemeColors on BuildContext {
  ThemeData get gmailTheme => Theme.of(this);
  ColorScheme get gmailScheme => gmailTheme.colorScheme;
  Color get gmailSurface => gmailScheme.surface;
  Color get gmailText => gmailScheme.onSurface;
  Color get gmailMuted => gmailScheme.onSurfaceVariant;
  Color get gmailPrimary => gmailScheme.primary;
  Color get gmailOnPrimary => gmailScheme.onPrimary;
  Color get gmailPrimaryContainer => gmailScheme.primaryContainer;
  Color get gmailOnPrimaryContainer => gmailScheme.onPrimaryContainer;
  Color get gmailSecondary => gmailScheme.secondary;
  Color get gmailAccent => gmailScheme.tertiary;
  Color get gmailError => gmailScheme.error;
  Color get gmailBorder => gmailScheme.outlineVariant;
  Color get gmailOutline => gmailScheme.outline;
  Color get gmailSearchSurface => Color.alphaBlend(
    gmailScheme.primary.withOpacity(0.08),
    gmailScheme.surface,
  );
  Color get gmailReadSurface => Color.alphaBlend(
    gmailScheme.primary.withOpacity(0.035),
    gmailScheme.surface,
  );
  Color get gmailSubtleSurface => Color.alphaBlend(
    gmailScheme.primary.withOpacity(0.02),
    gmailScheme.surface,
  );
  Color get gmailSelected => gmailScheme.primaryContainer;
  Color get gmailLabelSurface => gmailScheme.secondaryContainer;
  Color get gmailComposeHeader => gmailScheme.inverseSurface;
  Color get gmailComposeHeaderText => gmailScheme.onInverseSurface;
}

Color _readableForeground(BuildContext context, Color background) {
  return ThemeData.estimateBrightnessForColor(background) == Brightness.dark
      ? context.gmailOnPrimary
      : context.gmailText;
}

class GmailCenterView extends StatelessWidget {
  final String accountName;
  final String accountEmail;

  GmailCenterView({
    super.key,
    required this.accountName,
    required this.accountEmail,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GmailController>(
      init: GmailController(),
      builder: (GmailController controller) {
        final bool isCompact =
            Responsive.isMobile(context) || Responsive.isTablet(context);
        return Scaffold(
          drawer: isCompact
              ? Drawer(
            width: 286,
            child: SafeArea(
              child: _GmailNavigation(
                controller: controller,
                accountName: accountName,
                accountEmail: accountEmail,
                compact: false,
                closeDrawerAfterTap: true,
              ),
            ),
          )
              : null,
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    _GmailTopBar(
                      controller: controller,
                      accountName: accountName,
                      accountEmail: accountEmail,
                      compact: isCompact,
                    ),
                    Expanded(
                      child: isCompact
                          ? _MobileBody(controller: controller)
                          : _DesktopBody(
                        controller: controller,
                        accountName: accountName,
                        accountEmail: accountEmail,
                      ),
                    ),
                  ],
                ),
                if (controller.composeOpen)
                  _ComposeWindow(
                    controller: controller,
                    compact: isCompact,
                  ),
              ],
            ),
          ),
          floatingActionButton: isCompact && !controller.composeOpen
              ? FloatingActionButton.extended(
            onPressed: controller.openCompose,

            elevation: 2,
            icon: Icon(Icons.edit_outlined),
            label: Text(
              'Compose',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          )
              : null,
        );
      },
    );
  }
}

class _DesktopBody extends StatelessWidget {
  final GmailController controller;
  final String accountName;
  final String accountEmail;

  _DesktopBody({
    required this.controller,
    required this.accountName,
    required this.accountEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 180),
          width: controller.sidebarExpanded ? 256 : 72,
          child: _GmailNavigation(
            controller: controller,
            accountName: accountName,
            accountEmail: accountEmail,
            compact: !controller.sidebarExpanded,
            closeDrawerAfterTap: false,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                child: controller.selectedMessage == null
                    ? _MailboxView(controller: controller)
                    : _MessageView(
                  controller: controller,
                  showBackButton: true,
                ),
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 180),
          width: controller.rightRailVisible ? 56 : 18,
          child: _GoogleAppsRail(controller: controller),
        ),
      ],
    );
  }
}

class _MobileBody extends StatelessWidget {
  final GmailController controller;

  _MobileBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.gmailSurface,
      child: controller.selectedMessage == null
          ? _MailboxView(
        controller: controller,
        mobile: true,
      )
          : _MessageView(
        controller: controller,
        showBackButton: true,
        mobile: true,
      ),
    );
  }
}

class _GmailTopBar extends StatelessWidget {
  final GmailController controller;
  final String accountName;
  final String accountEmail;
  final bool compact;

  _GmailTopBar({
    required this.controller,
    required this.accountName,
    required this.accountEmail,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Padding(
        padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: <Widget>[
              Builder(
                builder: (BuildContext innerContext) {
                  return IconButton(
                    tooltip: 'Main menu',
                    onPressed: () => Scaffold.of(innerContext).openDrawer(),
                    icon: Icon(Icons.menu),
                  );
                },
              ),
              Expanded(
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search in mail',
                    border: InputBorder.none,
                    isDense: true,
                    suffixIcon: controller.searchQuery.isEmpty
                        ? null
                        : IconButton(
                      tooltip: 'Clear search',
                      onPressed: controller.clearSearch,
                      icon: Icon(Icons.close),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 7),
                child: _AccountAvatar(
                  accountName: accountName,
                  size: 34,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 64,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: controller.sidebarExpanded ? 256 : 72,
            child: Row(
              children: <Widget>[
                SizedBox(width: 12),
                IconButton(
                  tooltip: 'Main menu',
                  onPressed: controller.toggleSidebar,
                  icon: Icon(Icons.menu),
                ),
                if (controller.sidebarExpanded) ...<Widget>[
                  SizedBox(width: 10),
                  _GmailBrand(),
                ],
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 720),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.gmailSearchSurface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 4),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.search, size: 22),
                      ),
                      Expanded(
                        child: TextField(
                          controller: controller.searchController,
                          onChanged: controller.updateSearch,
                          decoration: InputDecoration(
                            hintText: 'Search mail',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      if (controller.searchQuery.isNotEmpty)
                        IconButton(
                          tooltip: 'Clear search',
                          onPressed: controller.clearSearch,
                          icon: Icon(Icons.close),
                        ),
                      IconButton(
                        tooltip: 'Show search options',
                        onPressed: () {},
                        icon: Icon(Icons.tune),
                      ),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          IconButton(
            tooltip: 'Help',
            onPressed: () {},
            icon: Icon(Icons.help_outline),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () {},
            icon: Icon(Icons.settings_outlined),
          ),
          IconButton(
            tooltip: 'Google apps',
            onPressed: controller.toggleRightRail,
            icon: Icon(Icons.apps),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Tooltip(
              message: '$accountName\n$accountEmail',
              child: _AccountAvatar(
                accountName: accountName,
                size: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GmailBrand extends StatelessWidget {
  _GmailBrand();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Icon(
              Icons.mail_outline_rounded,
              size: 31,
            ),
            Positioned(
              top: 8,
              child: Container(
                width: 12,
                height: 2.5,
              ),
            ),
          ],
        ),
        SizedBox(width: 8),
        Text(
          'Gmail',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _AccountAvatar extends StatelessWidget {
  final String accountName;
  final double size;

  _AccountAvatar({
    required this.accountName,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final String letter = accountName.trim().isEmpty
        ? '?'
        : accountName.trim().substring(0, 1).toUpperCase();

    return CircleAvatar(
      radius: size / 2,

      child: Text(
        letter,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: size * 0.42,
        ),
      ),
    );
  }
}

class _GmailNavigation extends StatelessWidget {
  final GmailController controller;
  final String accountName;
  final String accountEmail;
  final bool compact;
  final bool closeDrawerAfterTap;

  _GmailNavigation({
    required this.controller,
    required this.accountName,
    required this.accountEmail,
    required this.compact,
    required this.closeDrawerAfterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (closeDrawerAfterTap)
            Padding(
              padding: EdgeInsets.fromLTRB(14, 10, 14, 8),
              child: Row(
                children: <Widget>[
                  _GmailBrand(),
                  Spacer(),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              compact ? 10 : 14,
              10,
              compact ? 10 : 14,
              14,
            ),
            child: compact
                ? Tooltip(
              message: 'Compose',
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: controller.openCompose,
                child: Container(
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Icon(Icons.edit_outlined),
                ),
              ),
            )
                : FilledButton.icon(
              onPressed: controller.openCompose,
              icon: Icon(Icons.edit_outlined),
              label: Text(
                'Compose',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: FilledButton.styleFrom(
                minimumSize: Size(0, 56),
                alignment: Alignment.centerLeft,

                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _NavItem(
                  controller: controller,
                  icon: Icons.inbox_outlined,
                  activeIcon: Icons.inbox,
                  label: 'Inbox',
                  folder: GmailFolder.inbox,
                  compact: compact,
                  closeDrawerAfterTap: closeDrawerAfterTap,
                ),
                _NavItem(
                  controller: controller,
                  icon: Icons.star_border,
                  activeIcon: Icons.star,
                  label: 'Starred',
                  folder: GmailFolder.starred,
                  compact: compact,
                  closeDrawerAfterTap: closeDrawerAfterTap,
                ),
                _NavItem(
                  controller: controller,
                  icon: Icons.schedule_outlined,
                  activeIcon: Icons.schedule,
                  label: 'Snoozed',
                  folder: GmailFolder.snoozed,
                  compact: compact,
                  closeDrawerAfterTap: closeDrawerAfterTap,
                ),
                _NavItem(
                  controller: controller,
                  icon: Icons.label_important_outline,
                  activeIcon: Icons.label_important,
                  label: 'Important',
                  folder: GmailFolder.important,
                  compact: compact,
                  closeDrawerAfterTap: closeDrawerAfterTap,
                ),
                _NavItem(
                  controller: controller,
                  icon: Icons.send_outlined,
                  activeIcon: Icons.send,
                  label: 'Sent',
                  folder: GmailFolder.sent,
                  compact: compact,
                  closeDrawerAfterTap: closeDrawerAfterTap,
                ),
                _NavItem(
                  controller: controller,
                  icon: Icons.note_outlined,
                  activeIcon: Icons.note,
                  label: 'Drafts',
                  folder: GmailFolder.drafts,
                  compact: compact,
                  closeDrawerAfterTap: closeDrawerAfterTap,
                ),
                _NavItem(
                  controller: controller,
                  icon: Icons.mail_outline,
                  activeIcon: Icons.mail,
                  label: 'All Mail',
                  folder: GmailFolder.allMail,
                  compact: compact,
                  closeDrawerAfterTap: closeDrawerAfterTap,
                ),
                _NavItem(
                  controller: controller,
                  icon: Icons.report_gmailerrorred_outlined,
                  activeIcon: Icons.report,
                  label: 'Spam',
                  folder: GmailFolder.spam,
                  compact: compact,
                  closeDrawerAfterTap: closeDrawerAfterTap,
                ),
                _NavItem(
                  controller: controller,
                  icon: Icons.delete_outline,
                  activeIcon: Icons.delete,
                  label: 'Trash',
                  folder: GmailFolder.trash,
                  compact: compact,
                  closeDrawerAfterTap: closeDrawerAfterTap,
                ),
                if (!compact) ...<Widget>[
                  SizedBox(height: 14),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Labels',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Create new label',
                          onPressed: () {},
                          icon: Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                  _LabelItem(
                    label: 'ERP',
                  ),
                  _LabelItem(
                    label: 'Support',
                  ),
                  _LabelItem(
                    label: 'Clients',
                  ),
                ],
              ],
            ),
          ),
          if (!compact && closeDrawerAfterTap)
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  _AccountAvatar(accountName: accountName, size: 34),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          accountName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          accountEmail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final GmailController controller;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final GmailFolder folder;
  final bool compact;
  final bool closeDrawerAfterTap;

  _NavItem({
    required this.controller,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.folder,
    required this.compact,
    required this.closeDrawerAfterTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = controller.selectedFolder == folder;
    final int unread = controller.unreadCount(folder);

    final Widget child = InkWell(
      borderRadius: BorderRadius.horizontal(
        right: Radius.circular(compact ? 28 : 20),
      ),
      onTap: () {
        controller.selectFolder(folder);
        if (closeDrawerAfterTap) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        height: 36,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 0 : 26,
        ),
        decoration: BoxDecoration(
          color: active ? context.gmailPrimaryContainer : Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(compact ? 28 : 20),
          ),
        ),
        child: compact
            ? Center(
          child: Icon(
            active ? activeIcon : icon,
            size: 20,
            color: active
                ? context.gmailOnPrimaryContainer
                : context.gmailText,
          ),
        )
            : Row(
          children: <Widget>[
            Icon(
              active ? activeIcon : icon,
              size: 20,
              color: active
                  ? context.gmailOnPrimaryContainer
                  : context.gmailText,
            ),
            SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: active || unread > 0
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ),
            if (unread > 0)
              Text(
                unread.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
        right: compact ? 8 : 14,
        bottom: 1,
      ),
      child: compact
          ? Tooltip(
        message: label,
        child: child,
      )
          : child,
    );
  }
}

class _LabelItem extends StatelessWidget {
  final String label;

  _LabelItem({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 14),
      child: InkWell(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(20),
        ),
        onTap: () {},
        child: SizedBox(
          height: 36,
          child: Row(
            children: <Widget>[
              SizedBox(width: 28),
              Icon(Icons.label, size: 18),
              SizedBox(width: 18),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MailboxView extends StatelessWidget {
  final GmailController controller;
  final bool mobile;

  _MailboxView({
    required this.controller,
    this.mobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _MailboxToolbar(
          controller: controller,
          mobile: mobile,
        ),
        if (controller.selectedFolder == GmailFolder.inbox)
          _CategoryTabs(controller: controller),
        Expanded(
          child: controller.visibleMessages.isEmpty
              ? _EmptyMailbox()
              : ListView.builder(
            itemCount: controller.visibleMessages.length,
            itemBuilder: (BuildContext context, int index) {
              return _MessageRow(
                controller: controller,
                message: controller.visibleMessages[index],
                mobile: mobile,
              );
            },
          ),
        ),
        if (!mobile)
          Container(
            height: 44,
            padding: EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: context.gmailBorder),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  controller.visibleMessages.isEmpty
                      ? '0 of 0'
                      : '1–${controller.visibleMessages.length} of ${controller.visibleMessages.length}',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.gmailMuted,
                  ),
                ),
                SizedBox(width: 12),
                IconButton(
                  tooltip: 'Newer',
                  onPressed: null,
                  icon: Icon(Icons.chevron_left),
                ),
                IconButton(
                  tooltip: 'Older',
                  onPressed: null,
                  icon: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _MailboxToolbar extends StatelessWidget {
  final GmailController controller;
  final bool mobile;

  _MailboxToolbar({
    required this.controller,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = controller.selectedMessageIds.isNotEmpty;

    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: mobile ? 8 : 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.gmailBorder),
        ),
      ),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: controller.allVisibleSelected,
            tristate: controller.selectedMessageIds.isNotEmpty &&
                !controller.allVisibleSelected,
            onChanged: (_) => controller.toggleSelectAllVisible(),
          ),
          IconButton(
            tooltip: 'Select',
            onPressed: controller.toggleSelectAllVisible,
            icon: Icon(Icons.arrow_drop_down, size: 20),
          ),
          if (hasSelection) ...<Widget>[
            IconButton(
              tooltip: 'Archive',
              onPressed: controller.archiveSelectedMessages,
              icon: Icon(Icons.archive_outlined),
            ),
            IconButton(
              tooltip: 'Report spam',
              onPressed: controller.reportSelectedAsSpam,
              icon: Icon(Icons.report_gmailerrorred_outlined),
            ),
            IconButton(
              tooltip: 'Delete',
              onPressed: controller.deleteSelectedMessages,
              icon: Icon(Icons.delete_outline),
            ),
            SizedBox(width: 4),
            VerticalDivider(
              width: 10,
              indent: 11,
              endIndent: 11,
            ),
            IconButton(
              tooltip: 'Mark as read',
              onPressed: () => controller.markSelectedAsRead(true),
              icon: Icon(Icons.mark_email_read_outlined),
            ),
            IconButton(
              tooltip: 'Mark as unread',
              onPressed: () => controller.markSelectedAsRead(false),
              icon: Icon(Icons.mark_email_unread_outlined),
            ),
          ] else ...<Widget>[
            IconButton(
              tooltip: 'Refresh',
              onPressed: controller.refreshing
                  ? null
                  : controller.refreshInbox,
              icon: controller.refreshing
                  ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Icon(Icons.refresh),
            ),
            IconButton(
              tooltip: 'More',
              onPressed: () {},
              icon: Icon(Icons.more_vert),
            ),
          ],
          Spacer(),
          if (!mobile) ...<Widget>[
            Text(
              controller.visibleMessages.isEmpty
                  ? '0 of 0'
                  : '1–${controller.visibleMessages.length} of ${controller.visibleMessages.length}',
              style: TextStyle(
                fontSize: 12,
                color: context.gmailMuted,
              ),
            ),
            IconButton(
              tooltip: 'Newer',
              onPressed: null,
              icon: Icon(Icons.chevron_left),
            ),
            IconButton(
              tooltip: 'Older',
              onPressed: null,
              icon: Icon(Icons.chevron_right),
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  final GmailController controller;

  _CategoryTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    final List<_CategoryData> categories = <_CategoryData>[
      _CategoryData(
        category: GmailCategory.primary,
        label: 'Primary',
        icon: Icons.inbox_outlined,
        color: context.gmailPrimary,
      ),
      _CategoryData(
        category: GmailCategory.promotions,
        label: 'Promotions',
        icon: Icons.local_offer_outlined,
        color: context.gmailSecondary,
      ),
      _CategoryData(
        category: GmailCategory.social,
        label: 'Social',
        icon: Icons.people_outline,
        color: context.gmailPrimary,
      ),
      _CategoryData(
        category: GmailCategory.updates,
        label: 'Updates',
        icon: Icons.info_outline,
        color: context.gmailAccent,
      ),
    ];

    return SizedBox(
      height: 56,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool narrow = constraints.maxWidth < 680;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              final _CategoryData item = categories[index];
              final bool active =
                  controller.selectedCategory == item.category;
              final int unread =
              controller.categoryUnreadCount(item.category);

              return InkWell(
                onTap: () => controller.selectCategory(item.category),
                child: Container(
                  width: narrow ? 148 : 220,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: active ? item.color : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        item.icon,
                        size: 20,
                        color: active
                            ? item.color
                            : context.gmailMuted,
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 14,
                            color: active
                                ? item.color
                                : context.gmailText,
                            fontWeight: active
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      if (unread > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: item.color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            unread.toString(),
                            style: TextStyle(
                              color: _readableForeground(context, item.color),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CategoryData {
  final GmailCategory category;
  final String label;
  final IconData icon;
  final Color color;

  _CategoryData({
    required this.category,
    required this.label,
    required this.icon,
    required this.color,
  });
}

class _MessageRow extends StatelessWidget {
  final GmailController controller;
  final GmailMessage message;
  final bool mobile;

  _MessageRow({
    required this.controller,
    required this.message,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = controller.selectedMessageIds.contains(message.id);

    return Material(
      color: selected
          ? context.gmailSelected
          : message.isRead
          ? context.gmailReadSurface
          : context.gmailSurface,
      child: InkWell(
        onTap: () => controller.openMessage(message),
        child:  Container(
        height: mobile ? null : 40,
        constraints: mobile
            ? const BoxConstraints(
          minHeight: 88,
        )
            : null,
        padding: EdgeInsets.symmetric(
          horizontal: mobile ? 8 : 10,
          vertical: mobile ? 8 : 0,
        ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: context.gmailBorder),
            ),
          ),
          child: mobile
              ? _MobileMessageRowContent(
            controller: controller,
            message: message,
          )
              : _DesktopMessageRowContent(
            controller: controller,
            message: message,
          ),
        ),
      ),
    );
  }
}

class _DesktopMessageRowContent extends StatelessWidget {
  final GmailController controller;
  final GmailMessage message;

  _DesktopMessageRowContent({
    required this.controller,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 34,
          child: Checkbox(
            value: controller.selectedMessageIds.contains(message.id),
            onChanged: (_) =>
                controller.toggleMessageSelection(message.id),
          ),
        ),
        SizedBox(
          width: 34,
          child: IconButton(
            tooltip: message.isStarred ? 'Unstar' : 'Star',
            onPressed: () => controller.toggleStar(message.id),
            icon: Icon(
              message.isStarred ? Icons.star : Icons.star_border,
              size: 20,
              color: message.isStarred
                  ? context.gmailAccent
                  : context.gmailMuted,
            ),
          ),
        ),
        SizedBox(
          width: 34,
          child: IconButton(
            tooltip: message.isImportant
                ? 'Mark as not important'
                : 'Mark as important',
            onPressed: () => controller.toggleImportant(message.id),
            icon: Icon(
              message.isImportant
                  ? Icons.label_important
                  : Icons.label_important_outline,
              size: 19,
              color: message.isImportant
                  ? context.gmailAccent
                  : context.gmailMuted,
            ),
          ),
        ),
        SizedBox(
          width: 190,
          child: Text(
            message.senderName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight:
              message.isRead ? FontWeight.w500 : FontWeight.w700,
            ),
          ),
        ),
        if (message.label != null)
          Container(
            margin: EdgeInsets.only(right: 8),
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: context.gmailLabelSurface,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              message.label!,
              style: TextStyle(
                fontSize: 10,
                color: context.gmailText,
              ),
            ),
          ),
        Expanded(
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: TextStyle(
                color: context.gmailText,
                fontSize: 14,
                fontWeight:
                message.isRead ? FontWeight.w400 : FontWeight.w600,
              ),
              children: <InlineSpan>[
                TextSpan(text: message.subject),
                TextSpan(
                  text: ' - ${message.preview}',
                  style: TextStyle(
                    color: context.gmailMuted,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (message.hasAttachment)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.attach_file,
              size: 17,
              color: context.gmailMuted,
            ),
          ),
        SizedBox(
          width: 76,
          child: Text(
            _formatListDate(message.receivedAt),
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              color: context.gmailText,
              fontWeight:
              message.isRead ? FontWeight.w500 : FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}

class _MobileMessageRowContent extends StatelessWidget {
  final GmailController controller;
  final GmailMessage message;

  _MobileMessageRowContent({
    required this.controller,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 3),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: context.gmailSearchSurface,
            foregroundColor: context.gmailPrimary,
            child: Text(
              _initials(message.senderName),
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      message.senderName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: message.isRead
                            ? FontWeight.w600
                            : FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    _formatListDate(message.receivedAt),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: message.isRead
                          ? FontWeight.w500
                          : FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3),
              Text(
                message.subject,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: message.isRead
                      ? FontWeight.w500
                      : FontWeight.w700,
                ),
              ),
              SizedBox(height: 2),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      message.preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.gmailMuted,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  IconButton(
                    constraints: BoxConstraints(
                      minWidth: 36,
                      minHeight: 34,
                    ),
                    padding: EdgeInsets.zero,
                    tooltip: message.isStarred ? 'Unstar' : 'Star',
                    onPressed: () => controller.toggleStar(message.id),
                    icon: Icon(
                      message.isStarred ? Icons.star : Icons.star_border,
                      size: 20,
                      color: message.isStarred
                          ? context.gmailAccent
                          : context.gmailMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MessageView extends StatelessWidget {
  final GmailController controller;
  final bool showBackButton;
  final bool mobile;

  _MessageView({
    required this.controller,
    required this.showBackButton,
    this.mobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final GmailMessage? message = controller.selectedMessage;

    if (message == null) {
      return _EmptyMailbox();
    }

    return Column(
      children: <Widget>[
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: context.gmailBorder),
            ),
          ),
          child: Row(
            children: <Widget>[
              if (showBackButton)
                IconButton(
                  tooltip: 'Back to inbox',
                  onPressed: controller.closeMessage,
                  icon: Icon(Icons.arrow_back),
                ),
              IconButton(
                tooltip: 'Archive',
                onPressed: controller.archiveOpenMessage,
                icon: Icon(Icons.archive_outlined),
              ),
              IconButton(
                tooltip: 'Report spam',
                onPressed: controller.reportOpenMessageAsSpam,
                icon: Icon(Icons.report_gmailerrorred_outlined),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: controller.deleteOpenMessage,
                icon: Icon(Icons.delete_outline),
              ),
              VerticalDivider(
                width: 14,
                indent: 10,
                endIndent: 10,
              ),
              IconButton(
                tooltip: 'Mark unread',
                onPressed: controller.markOpenMessageAsUnread,
                icon: Icon(Icons.mark_email_unread_outlined),
              ),
              IconButton(
                tooltip: 'Snooze',
                onPressed: controller.snoozeOpenMessage,
                icon: Icon(Icons.schedule_outlined),
              ),
              Spacer(),
              if (!mobile)
                Text(
                  '1 of ${controller.visibleMessages.isEmpty ? 1 : controller.visibleMessages.length}',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.gmailMuted,
                  ),
                ),
              IconButton(
                tooltip: 'More',
                onPressed: () {},
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              mobile ? 16 : 72,
              24,
              mobile ? 16 : 56,
              40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          Text(
                            message.subject,
                            style: TextStyle(
                              fontSize: mobile ? 22 : 24,
                              height: 1.25,
                              color: context.gmailText,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (message.label != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: context.gmailLabelSurface,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                message.label!,
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Print',
                      onPressed: () {},
                      icon: Icon(Icons.print_outlined, size: 20),
                    ),
                    if (!mobile)
                      IconButton(
                        tooltip: 'Open in new window',
                        onPressed: () {},
                        icon: Icon(Icons.open_in_new, size: 20),
                      ),
                  ],
                ),
                SizedBox(height: 28),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: context.gmailSearchSurface,
                      foregroundColor: context.gmailPrimary,
                      child: Text(
                        _initials(message.senderName),
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  message.senderName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  '<${message.senderEmail}>',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: context.gmailMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3),
                          Text(
                            'to ${message.recipients.isEmpty ? 'me' : message.recipients.join(', ')}',
                            style: TextStyle(
                              color: context.gmailMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!mobile)
                      Text(
                        _formatFullDate(message.receivedAt),
                        style: TextStyle(
                          color: context.gmailMuted,
                          fontSize: 12,
                        ),
                      ),
                    IconButton(
                      tooltip: message.isStarred ? 'Unstar' : 'Star',
                      onPressed: () => controller.toggleStar(message.id),
                      icon: Icon(
                        message.isStarred ? Icons.star : Icons.star_border,
                        size: 20,
                        color: message.isStarred
                            ? context.gmailAccent
                            : context.gmailMuted,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Reply',
                      onPressed: () {},
                      icon: Icon(Icons.reply, size: 20),
                    ),
                    IconButton(
                      tooltip: 'More',
                      onPressed: () {},
                      icon: Icon(Icons.more_vert, size: 20),
                    ),
                  ],
                ),
                SizedBox(height: 28),
                SelectableText(
                  message.body,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.65,
                    color: context.gmailText,
                  ),
                ),
                if (message.hasAttachment) ...<Widget>[
                  SizedBox(height: 28),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      Container(
                        width: 220,
                        height: 56,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: context.gmailSubtleSurface,
                          border: Border.all(
                            color: context.gmailBorder,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.picture_as_pdf_outlined,
                              color: context.gmailError,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                message.attachmentName ?? 'Attachment.pdf',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Download',
                              onPressed: () {},
                              icon: Icon(
                                Icons.download_outlined,
                                size: 19,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 36),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.reply),
                      label: Text('Reply'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.gmailPrimary,
                        side: BorderSide(
                          color: context.gmailOutline,
                        ),
                        minimumSize: Size(110, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.forward),
                      label: Text('Forward'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.gmailPrimary,
                        side: BorderSide(
                          color: context.gmailOutline,
                        ),
                        minimumSize: Size(120, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GoogleAppsRail extends StatelessWidget {
  final GmailController controller;

  _GoogleAppsRail({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (!controller.rightRailVisible) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: IconButton(
          tooltip: 'Show side panel',
          onPressed: controller.toggleRightRail,
          icon: Icon(Icons.chevron_left),
        ),
      );
    }

    return Column(
      children: <Widget>[
        SizedBox(height: 12),
        _RailIcon(
          tooltip: 'Calendar',
          icon: Icons.calendar_today_outlined,
          color: context.gmailPrimary,
        ),
        SizedBox(height: 18),
        _RailIcon(
          tooltip: 'Keep',
          icon: Icons.lightbulb_outline,
          color: context.gmailAccent,
        ),
        SizedBox(height: 18),
        _RailIcon(
          tooltip: 'Tasks',
          icon: Icons.check_circle_outline,
          color: context.gmailPrimary,
        ),
        SizedBox(height: 18),
        _RailIcon(
          tooltip: 'Contacts',
          icon: Icons.person_outline,
          color: context.gmailPrimary,
        ),
        SizedBox(height: 20),
        Divider(indent: 12, endIndent: 12),
        SizedBox(height: 8),
        _RailIcon(
          tooltip: 'Get add-ons',
          icon: Icons.add,
          color: context.gmailMuted,
        ),
        Spacer(),
        IconButton(
          tooltip: 'Hide side panel',
          onPressed: controller.toggleRightRail,
          icon: Icon(Icons.chevron_right),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class _RailIcon extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color color;

  _RailIcon({
    required this.tooltip,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: () {},
      icon: Icon(icon, color: color, size: 21),
    );
  }
}

class _ComposeWindow extends StatelessWidget {
  final GmailController controller;
  final bool compact;

  _ComposeWindow({
    required this.controller,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    if (compact || controller.composeMaximized) {
      return Positioned.fill(
        child: Material(
          color: context.gmailSurface,
          child: SafeArea(
            child: _ComposeContent(
              controller: controller,
              fullscreen: true,
            ),
          ),
        ),
      );
    }

    return Positioned(
      right: controller.rightRailVisible ? 72 : 24,
      bottom: 0,
      child: Material(
        elevation: 12,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 560,
          height: 520,
          child: _ComposeContent(
            controller: controller,
            fullscreen: false,
          ),
        ),
      ),
    );
  }
}

class _ComposeContent extends StatelessWidget {
  final GmailController controller;
  final bool fullscreen;

  _ComposeContent({
    required this.controller,
    required this.fullscreen,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.gmailSurface,
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            padding: EdgeInsets.only(left: 14),
            color: context.gmailComposeHeader,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'New Message',
                    style: TextStyle(
                      color: context.gmailComposeHeaderText,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (!fullscreen)
                  IconButton(
                    tooltip: 'Minimize',
                    onPressed: () {},
                    color: context.gmailComposeHeaderText,
                    iconSize: 18,
                    icon: Icon(Icons.remove),
                  ),
                if (!fullscreen)
                  IconButton(
                    tooltip: 'Full screen',
                    onPressed: controller.toggleComposeMaximized,
                    color: context.gmailComposeHeaderText,
                    iconSize: 16,
                    icon: Icon(Icons.open_in_full),
                  ),
                IconButton(
                  tooltip: 'Save & close',
                  onPressed: () => controller.closeCompose(saveDraft: true),
                  color: context.gmailComposeHeaderText,
                  iconSize: 18,
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),
          TextField(
            controller: controller.toController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Recipients',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),
              suffixText: 'Cc  Bcc',
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: context.gmailBorder),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: context.gmailBorder),
              ),
            ),
          ),
          TextField(
            controller: controller.subjectController,
            decoration: InputDecoration(
              hintText: 'Subject',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: context.gmailBorder),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: context.gmailBorder),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller.bodyController,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: '',
                contentPadding: EdgeInsets.all(14),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            height: 54,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                FilledButton.icon(
                  onPressed: controller.sendEmail,
                  icon: Icon(Icons.arrow_drop_down, size: 18),
                  label: Text('Send'),
                  style: FilledButton.styleFrom(
                    backgroundColor: context.gmailPrimary,
                    foregroundColor: context.gmailOnPrimary,
                    minimumSize: Size(92, 38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19),
                    ),
                  ),
                ),
                SizedBox(width: 4),
                IconButton(
                  tooltip: 'Formatting options',
                  onPressed: () {},
                  icon: Icon(Icons.format_underlined),
                ),
                IconButton(
                  tooltip: 'Attach files',
                  onPressed: () {},
                  icon: Icon(Icons.attach_file),
                ),
                IconButton(
                  tooltip: 'Insert link',
                  onPressed: () {},
                  icon: Icon(Icons.link),
                ),
                if (!compactWidth(context))
                  IconButton(
                    tooltip: 'Insert emoji',
                    onPressed: () {},
                    icon: Icon(Icons.sentiment_satisfied_alt_outlined),
                  ),
                if (!compactWidth(context))
                  IconButton(
                    tooltip: 'Insert files using Drive',
                    onPressed: () {},
                    icon: Icon(Icons.add_to_drive_outlined),
                  ),
                Spacer(),
                IconButton(
                  tooltip: 'More options',
                  onPressed: () {},
                  icon: Icon(Icons.more_vert),
                ),
                IconButton(
                  tooltip: 'Discard draft',
                  onPressed: () => controller.closeCompose(saveDraft: false),
                  icon: Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyMailbox extends StatelessWidget {
  _EmptyMailbox();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.inbox_outlined,
            size: 60,
            color: context.gmailMuted,
          ),
          SizedBox(height: 12),
          Text(
            'No mail here',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.gmailMuted,
            ),
          ),
        ],
      ),
    );
  }
}

bool compactWidth(BuildContext context) {
  return MediaQuery.sizeOf(context).width < 520;
}

String _initials(String value) {
  final List<String> parts = value
      .trim()
      .split(' ')
      .where((String part) => part.isNotEmpty)
      .toList();

  if (parts.isEmpty) {
    return '?';
  }

  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }

  return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
      .toUpperCase();
}

String _formatListDate(DateTime date) {
  final DateTime now = DateTime.now();
  final bool isToday =
      now.year == date.year && now.month == date.month && now.day == date.day;

  if (isToday) {
    final int displayHour = date.hour == 0
        ? 12
        : date.hour > 12
        ? date.hour - 12
        : date.hour;
    final String minute = date.minute.toString().padLeft(2, '0');
    final String period = date.hour >= 12 ? 'PM' : 'AM';
    return '$displayHour:$minute $period';
  }

  if (now.year == date.year) {
    return '${_monthName(date.month)} ${date.day}';
  }

  return '${date.month}/${date.day}/${date.year}';
}

String _formatFullDate(DateTime date) {
  return '${_monthName(date.month)} ${date.day}, ${date.year}, '
      '${_formatListDate(date)}';
}

String _monthName(int month) {
  List<String> months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return months[month - 1];
}
