import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/gmail_model.dart';

class GmailController extends GetxController {
  GmailFolder selectedFolder = GmailFolder.inbox;
  GmailCategory selectedCategory = GmailCategory.primary;

  String? selectedMessageId;
  String searchQuery = '';

  bool sidebarExpanded = true;
  bool rightRailVisible = true;
  bool composeOpen = false;
  bool composeMaximized = false;
  bool refreshing = false;

  final Set<String> selectedMessageIds = <String>{};

  final TextEditingController toController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  final List<GmailMessage> _messages = <GmailMessage>[
    GmailMessage(
      id: '1',
      senderName: 'Elite ERP',
      senderEmail: 'notifications@eliteerp.com',
      recipients: <String>['support@elitecsr.com'],
      subject: 'Daily production summary',
      preview: 'Today’s production summary is ready for review.',
      body:
          'Hello,\n\nYour daily production summary is ready. Total production, pending jobs, machine utilization and quality alerts are now available in the ERP dashboard.\n\nRegards,\nElite ERP Team',
      receivedAt: DateTime.now().subtract(const Duration(minutes: 14)),
      folder: GmailFolder.inbox,
      category: GmailCategory.primary,
      isRead: false,
      isStarred: true,
      isImportant: true,
      hasAttachment: true,
      attachmentName: 'production-summary.pdf',
      label: 'ERP',
    ),
    GmailMessage(
      id: '2',
      senderName: 'Ahmad Textile',
      senderEmail: 'accounts@ahmadtextile.com',
      recipients: <String>['support@elitecsr.com'],
      subject: 'Invoice confirmation required',
      preview: 'Please confirm the attached invoice before 4:00 PM.',
      body:
          'Assalam-o-Alaikum,\n\nPlease review the attached invoice and confirm it before 4:00 PM today.\n\nThank you.',
      receivedAt: DateTime.now().subtract(const Duration(hours: 2)),
      folder: GmailFolder.inbox,
      category: GmailCategory.primary,
      isRead: false,
      isImportant: true,
      hasAttachment: true,
      attachmentName: 'invoice-4582.pdf',
    ),
    GmailMessage(
      id: '3',
      senderName: 'Google Workspace',
      senderEmail: 'workspace-noreply@google.com',
      recipients: <String>['support@elitecsr.com'],
      subject: 'New features available for your team',
      preview: 'Discover productivity updates available this month.',
      body:
          'Hi,\n\nNew collaboration and productivity features are now available for your organization.\n\nGoogle Workspace Team',
      receivedAt: DateTime.now().subtract(const Duration(hours: 5)),
      folder: GmailFolder.inbox,
      category: GmailCategory.updates,
      isRead: true,
    ),
    GmailMessage(
      id: '4',
      senderName: 'Daraz',
      senderEmail: 'offers@daraz.pk',
      recipients: <String>['support@elitecsr.com'],
      subject: 'Big savings this weekend',
      preview: 'Special offers are live across selected categories.',
      body:
          'Hello,\n\nWeekend deals are now live. Browse selected products and limited-time offers.\n\nDaraz Team',
      receivedAt: DateTime.now().subtract(const Duration(hours: 7)),
      folder: GmailFolder.inbox,
      category: GmailCategory.promotions,
      isRead: true,
    ),
    GmailMessage(
      id: '5',
      senderName: 'LinkedIn',
      senderEmail: 'messages-noreply@linkedin.com',
      recipients: <String>['support@elitecsr.com'],
      subject: 'You appeared in 19 searches this week',
      preview: 'See who is discovering your profile.',
      body:
          'Your profile appeared in 19 searches this week. Review your profile analytics for more details.',
      receivedAt: DateTime.now().subtract(const Duration(days: 1)),
      folder: GmailFolder.inbox,
      category: GmailCategory.social,
      isRead: true,
    ),
    GmailMessage(
      id: '6',
      senderName: 'Support Team',
      senderEmail: 'support@example.com',
      recipients: <String>['support@elitecsr.com'],
      subject: 'Ticket #4582 has been resolved',
      preview: 'The reported login issue has been resolved.',
      body:
          'Hi,\n\nThe login issue reported in ticket #4582 has been resolved. Please verify it from your side.\n\nSupport Team',
      receivedAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      folder: GmailFolder.inbox,
      category: GmailCategory.primary,
      isRead: true,
      label: 'Support',
    ),
    GmailMessage(
      id: '7',
      senderName: 'You',
      senderEmail: 'support@elitecsr.com',
      recipients: <String>['client@example.com'],
      subject: 'ERP proposal',
      preview: 'Please find the ERP proposal attached.',
      body:
          'Hello,\n\nPlease find the ERP proposal attached. Let me know if any changes are required.\n\nRegards',
      receivedAt: DateTime.now().subtract(const Duration(days: 2)),
      folder: GmailFolder.sent,
      category: GmailCategory.primary,
      isRead: true,
      hasAttachment: true,
      attachmentName: 'elite-erp-proposal.pdf',
    ),
    GmailMessage(
      id: '8',
      senderName: 'Draft',
      senderEmail: '',
      recipients: <String>['manager@example.com'],
      subject: 'Follow-up meeting',
      preview: 'Can we schedule a follow-up meeting next week?',
      body:
          'Hello,\n\nCan we schedule a follow-up meeting next week to discuss the implementation plan?',
      receivedAt: DateTime.now().subtract(const Duration(days: 3)),
      folder: GmailFolder.drafts,
      category: GmailCategory.primary,
      isRead: true,
    ),
  ];

  List<GmailMessage> get visibleMessages {
    Iterable<GmailMessage> result = _messages;

    switch (selectedFolder) {
      case GmailFolder.inbox:
        result = result.where(
          (GmailMessage message) =>
              message.folder == GmailFolder.inbox &&
              message.category == selectedCategory,
        );
        break;
      case GmailFolder.starred:
        result = result.where(
          (GmailMessage message) =>
              message.isStarred && message.folder != GmailFolder.trash,
        );
        break;
      case GmailFolder.snoozed:
        result = result.where(
          (GmailMessage message) => message.folder == GmailFolder.snoozed,
        );
        break;
      case GmailFolder.important:
        result = result.where(
          (GmailMessage message) =>
              message.isImportant && message.folder != GmailFolder.trash,
        );
        break;
      case GmailFolder.sent:
      case GmailFolder.drafts:
      case GmailFolder.spam:
      case GmailFolder.trash:
        result = result.where(
          (GmailMessage message) => message.folder == selectedFolder,
        );
        break;
      case GmailFolder.allMail:
        result = result.where(
          (GmailMessage message) =>
              message.folder != GmailFolder.spam &&
              message.folder != GmailFolder.trash,
        );
        break;
    }

    final String query = searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((GmailMessage message) {
        return message.senderName.toLowerCase().contains(query) ||
            message.senderEmail.toLowerCase().contains(query) ||
            message.subject.toLowerCase().contains(query) ||
            message.preview.toLowerCase().contains(query) ||
            message.body.toLowerCase().contains(query);
      });
    }

    final List<GmailMessage> sorted = result.toList();
    sorted.sort(
      (GmailMessage a, GmailMessage b) =>
          b.receivedAt.compareTo(a.receivedAt),
    );
    return sorted;
  }

  GmailMessage? get selectedMessage {
    if (selectedMessageId == null) {
      return null;
    }

    for (final GmailMessage message in _messages) {
      if (message.id == selectedMessageId) {
        return message;
      }
    }
    return null;
  }

  bool get allVisibleSelected {
    final List<GmailMessage> visible = visibleMessages;
    return visible.isNotEmpty &&
        visible.every(
          (GmailMessage message) => selectedMessageIds.contains(message.id),
        );
  }

  int unreadCount(GmailFolder folder) {
    if (folder == GmailFolder.starred) {
      return _messages.where((GmailMessage message) {
        return message.isStarred &&
            !message.isRead &&
            message.folder != GmailFolder.trash;
      }).length;
    }

    if (folder == GmailFolder.important) {
      return _messages.where((GmailMessage message) {
        return message.isImportant &&
            !message.isRead &&
            message.folder != GmailFolder.trash;
      }).length;
    }

    return _messages.where((GmailMessage message) {
      return message.folder == folder && !message.isRead;
    }).length;
  }

  int categoryUnreadCount(GmailCategory category) {
    return _messages.where((GmailMessage message) {
      return message.folder == GmailFolder.inbox &&
          message.category == category &&
          !message.isRead;
    }).length;
  }

  void toggleSidebar() {
    sidebarExpanded = !sidebarExpanded;
    update();
  }

  void toggleRightRail() {
    rightRailVisible = !rightRailVisible;
    update();
  }

  void selectFolder(GmailFolder folder) {
    selectedFolder = folder;
    selectedMessageId = null;
    selectedMessageIds.clear();
    update();
  }

  void selectCategory(GmailCategory category) {
    selectedCategory = category;
    selectedMessageId = null;
    selectedMessageIds.clear();
    update();
  }

  void openMessage(GmailMessage message) {
    selectedMessageId = message.id;
    selectedMessageIds.clear();

    final int index = _messages.indexWhere(
      (GmailMessage item) => item.id == message.id,
    );
    if (index != -1 && !_messages[index].isRead) {
      _messages[index] = _messages[index].copyWith(isRead: true);
    }

    update();
  }

  void closeMessage() {
    selectedMessageId = null;
    update();
  }

  void updateSearch(String value) {
    searchQuery = value;
    selectedMessageId = null;
    selectedMessageIds.clear();
    update();
  }

  void clearSearch() {
    searchController.clear();
    updateSearch('');
  }

  void toggleMessageSelection(String messageId) {
    if (selectedMessageIds.contains(messageId)) {
      selectedMessageIds.remove(messageId);
    } else {
      selectedMessageIds.add(messageId);
    }
    update();
  }

  void toggleSelectAllVisible() {
    final List<GmailMessage> visible = visibleMessages;

    if (allVisibleSelected) {
      for (final GmailMessage message in visible) {
        selectedMessageIds.remove(message.id);
      }
    } else {
      for (final GmailMessage message in visible) {
        selectedMessageIds.add(message.id);
      }
    }
    update();
  }

  void clearSelection() {
    selectedMessageIds.clear();
    update();
  }

  void toggleStar(String messageId) {
    final int index = _messages.indexWhere(
      (GmailMessage item) => item.id == messageId,
    );
    if (index == -1) {
      return;
    }

    _messages[index] = _messages[index].copyWith(
      isStarred: !_messages[index].isStarred,
    );
    update();
  }

  void toggleImportant(String messageId) {
    final int index = _messages.indexWhere(
      (GmailMessage item) => item.id == messageId,
    );
    if (index == -1) {
      return;
    }

    _messages[index] = _messages[index].copyWith(
      isImportant: !_messages[index].isImportant,
    );
    update();
  }

  Future<void> refreshInbox() async {
    if (refreshing) {
      return;
    }

    refreshing = true;
    update();
    await Future<void>.delayed(const Duration(milliseconds: 700));
    refreshing = false;
    update();
  }

  void archiveSelectedMessages() {
    _moveMessages(selectedMessageIds, GmailFolder.allMail);
  }

  void reportSelectedAsSpam() {
    _moveMessages(selectedMessageIds, GmailFolder.spam);
  }

  void deleteSelectedMessages() {
    _moveMessages(selectedMessageIds, GmailFolder.trash);
  }

  void markSelectedAsRead(bool isRead) {
    for (int i = 0; i < _messages.length; i++) {
      if (selectedMessageIds.contains(_messages[i].id)) {
        _messages[i] = _messages[i].copyWith(isRead: isRead);
      }
    }

    selectedMessageIds.clear();
    update();
  }

  void archiveOpenMessage() {
    _moveOpenMessage(GmailFolder.allMail);
  }

  void reportOpenMessageAsSpam() {
    _moveOpenMessage(GmailFolder.spam);
  }

  void deleteOpenMessage() {
    _moveOpenMessage(GmailFolder.trash);
  }

  void markOpenMessageAsUnread() {
    final GmailMessage? message = selectedMessage;
    if (message == null) {
      return;
    }

    final int index = _messages.indexWhere(
      (GmailMessage item) => item.id == message.id,
    );

    if (index != -1) {
      _messages[index] = _messages[index].copyWith(isRead: false);
    }

    selectedMessageId = null;
    update();
  }

  void snoozeOpenMessage() {
    _moveOpenMessage(GmailFolder.snoozed);
  }

  void _moveOpenMessage(GmailFolder folder) {
    final GmailMessage? message = selectedMessage;
    if (message == null) {
      return;
    }

    _moveMessages(<String>{message.id}, folder);
    selectedMessageId = null;
    update();
  }

  void _moveMessages(Set<String> ids, GmailFolder folder) {
    if (ids.isEmpty) {
      return;
    }

    for (int i = 0; i < _messages.length; i++) {
      if (ids.contains(_messages[i].id)) {
        _messages[i] = _messages[i].copyWith(folder: folder);
      }
    }

    selectedMessageIds.clear();
    update();
  }

  void openCompose() {
    composeOpen = true;
    composeMaximized = false;
    update();
  }

  void closeCompose({bool saveDraft = true}) {
    if (saveDraft) {
      saveDraftMessage();
    } else {
      clearComposeFields();
    }

    composeOpen = false;
    composeMaximized = false;
    update();
  }

  void toggleComposeMaximized() {
    composeMaximized = !composeMaximized;
    update();
  }

  bool sendEmail() {
    final String recipient = toController.text.trim();
    final String subject = subjectController.text.trim();
    final String body = bodyController.text.trim();

    if (recipient.isEmpty || subject.isEmpty || body.isEmpty) {
      Get.snackbar(
        'Missing information',
        'Recipient, subject and message are required.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    _messages.insert(
      0,
      GmailMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        senderName: 'You',
        senderEmail: 'support@elitecsr.com',
        recipients: <String>[recipient],
        subject: subject,
        preview: body.replaceAll('\n', ' '),
        body: body,
        receivedAt: DateTime.now(),
        folder: GmailFolder.sent,
        category: GmailCategory.primary,
        isRead: true,
      ),
    );

    composeOpen = false;
    composeMaximized = false;
    clearComposeFields();
    update();
    return true;
  }

  void saveDraftMessage() {
    final String recipient = toController.text.trim();
    final String subject = subjectController.text.trim();
    final String body = bodyController.text.trim();

    if (recipient.isEmpty && subject.isEmpty && body.isEmpty) {
      clearComposeFields();
      return;
    }

    _messages.insert(
      0,
      GmailMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        senderName: 'Draft',
        senderEmail: '',
        recipients: recipient.isEmpty ? <String>[] : <String>[recipient],
        subject: subject.isEmpty ? '(no subject)' : subject,
        preview: body.isEmpty ? 'Empty draft' : body.replaceAll('\n', ' '),
        body: body,
        receivedAt: DateTime.now(),
        folder: GmailFolder.drafts,
        category: GmailCategory.primary,
        isRead: true,
      ),
    );

    clearComposeFields();
  }

  void clearComposeFields() {
    toController.clear();
    subjectController.clear();
    bodyController.clear();
  }

  @override
  void onClose() {
    toController.dispose();
    subjectController.dispose();
    bodyController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
