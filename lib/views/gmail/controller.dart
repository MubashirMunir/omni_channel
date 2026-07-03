import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/gmail_model.dart';

class GmailController extends GetxController {
  final RxList<GmailMessageModel> emails = <GmailMessageModel>[].obs;
  final Rxn<GmailMessageModel> selectedEmail = Rxn<GmailMessageModel>();

  final TextEditingController searchController = TextEditingController();

  /// Reply dialog controllers
  final TextEditingController replyToController = TextEditingController();
  final TextEditingController replyCcController = TextEditingController();
  final TextEditingController replySubjectController = TextEditingController();
  final TextEditingController replyBodyController = TextEditingController();

  /// Compose dialog controllers
  final TextEditingController composeToController = TextEditingController();
  final TextEditingController composeCcController = TextEditingController();
  final TextEditingController composeSubjectController = TextEditingController();
  final TextEditingController composeBodyController = TextEditingController();

  /// Thread scroll controller
  final ScrollController mailScrollController = ScrollController();

  /// Apni email yahan set karo
  final String myEmail = 'me@gmail.com';

  /// Current selected conversation ki mails + replies
  List<GmailMessageModel> threadMails = [];

  /// Har conversation ki replies alag save hongi
  final Map<String, List<GmailMessageModel>> repliesByConversation = {};

  /// Dialog multiple times open na ho
  bool isReplyDialogOpen = false;

  List<GmailMessageModel> get filteredEmails {
    final query = searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return emails;
    }

    return emails.where((mail) {
      return mail.fromName.toLowerCase().contains(query) ||
          mail.fromEmail.toLowerCase().contains(query) ||
          mail.subject.toLowerCase().contains(query) ||
          mail.snippet.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();

    fetchDemoEmails();

    searchController.addListener(() {
      update();
    });
  }

  String getConversationKey(GmailMessageModel mail) {
    final threadId = mail.threadId.trim();

    if (threadId.isNotEmpty) {
      return threadId;
    }

    return mail.id;
  }

  String makeSnippet(String text) {
    final cleanText = text.trim();

    if (cleanText.length <= 45) {
      return cleanText;
    }

    return '${cleanText.substring(0, 45)}...';
  }

  void buildCurrentThread() {
    final mail = selectedEmail.value;

    if (mail == null) {
      threadMails = [];
      update();
      return;
    }

    final key = getConversationKey(mail);

    threadMails = [
      mail,
      ...(repliesByConversation[key] ?? []),
    ];
  }

  void scrollThreadToBottom() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mailScrollController.hasClients) {
        mailScrollController.animateTo(
          mailScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool canOpenReplyDialog() {
    if (isReplyDialogOpen) {
      return false;
    }

    isReplyDialogOpen = true;
    return true;
  }

  void closeReplyDialogFlag() {
    isReplyDialogOpen = false;
  }

  void fetchDemoEmails() {
    emails.assignAll([
      GmailMessageModel(
        id: '1',
        threadId: 'thread_1',
        labels: const [],
        fromName: 'Shopify Support',
        fromEmail: 'support@shopify.com',
        toEmail: 'you@company.com',
        subject: 'Checkout phone validation issue',
        snippet: 'We reviewed your checkout extension and found...',
        body:
        'Hello,\n\nWe reviewed your checkout extension and found that your phone validation logic is working correctly.\n\nPlease make sure your app is deployed to the correct checkout profile.\n\nThanks,\nShopify Support',
        time: '10:30 AM',
        isUnread: true,
        isStarred: false,
        hasAttachment: false,
      ),
      GmailMessageModel(
        id: '2',
        threadId: 'thread_2',
        labels: const [],
        fromName: 'Client Project',
        fromEmail: 'client@project.com',
        toEmail: 'you@company.com',
        subject: 'CRM dashboard changes',
        snippet: 'Can you update the Gmail and WhatsApp screens...',
        body:
        'Hi,\n\nCan you update the Gmail and WhatsApp screens inside the CRM dashboard?\n\nWe need a clean responsive layout with mail list, detail view, reply dialog, and send message option.\n\nRegards,\nClient',
        time: '9:15 AM',
        isUnread: true,
        isStarred: true,
        hasAttachment: true,
      ),
      GmailMessageModel(
        id: '3',
        threadId: 'thread_3',
        labels: const [],
        fromName: 'Google Workspace',
        fromEmail: 'workspace@google.com',
        toEmail: 'you@company.com',
        subject: 'Security alert',
        snippet: 'A new sign-in was detected on your account...',
        body:
        'A new sign-in was detected on your Google Workspace account.\n\nDevice: Chrome Web\nLocation: Pakistan\n\nIf this was you, no action is required.',
        time: 'Yesterday',
        isUnread: false,
        isStarred: false,
        hasAttachment: false,
      ),
      GmailMessageModel(
        id: '4',
        threadId: 'thread_4',
        labels: const [],
        fromName: 'Billing Team',
        fromEmail: 'billing@saascrm.com',
        toEmail: 'you@company.com',
        subject: 'Invoice for May',
        snippet: 'Your invoice for this month is attached...',
        body:
        'Hello,\n\nYour invoice for May is attached with this email.\n\nPlease review the invoice and contact us if you have any questions.',
        time: 'May 18',
        isUnread: false,
        isStarred: false,
        hasAttachment: true,
      ),
    ]);

    selectedEmail.value = emails.isNotEmpty ? emails.first : null;

    buildCurrentThread();
    update();
  }

  void selectEmail(GmailMessageModel mail) {
    selectedEmail.value = mail;
    mail.isUnread = false;

    buildCurrentThread();

    emails.refresh();
    update();

    scrollThreadToBottom();
  }

  void toggleStar(GmailMessageModel mail) {
    mail.isStarred = !mail.isStarred;

    emails.refresh();
    buildCurrentThread();
    update();
  }

  void archiveSelectedEmail() {
    final mail = selectedEmail.value;

    if (mail == null) {
      return;
    }

    emails.removeWhere((item) => item.id == mail.id);

    selectedEmail.value = emails.isNotEmpty ? emails.first : null;

    buildCurrentThread();

    emails.refresh();
    update();
  }

  void deleteSelectedEmail() {
    final mail = selectedEmail.value;

    if (mail == null) {
      return;
    }

    final key = getConversationKey(mail);

    emails.removeWhere((item) => item.id == mail.id);
    repliesByConversation.remove(key);

    selectedEmail.value = emails.isNotEmpty ? emails.first : null;

    buildCurrentThread();

    emails.refresh();
    update();
  }

  void markSelectedUnread() {
    final mail = selectedEmail.value;

    if (mail == null) {
      return;
    }

    mail.isUnread = true;

    emails.refresh();
    update();
  }

  void prepareReplyDialog(GmailMessageModel mail) {
    selectedEmail.value = mail;

    replyToController.text = mail.fromEmail;
    replyCcController.clear();

    final subject = mail.subject.trim();

    replySubjectController.text = subject.toLowerCase().startsWith('re:')
        ? subject
        : 'Re: $subject';

    replyBodyController.clear();

    update();
  }

  void clearReplyDialogFields() {
    replyToController.clear();
    replyCcController.clear();
    replySubjectController.clear();
    replyBodyController.clear();
  }

  void sendReplyFromDialog() {
    final selectedMail = selectedEmail.value;

    if (selectedMail == null) {
      Get.snackbar('Error', 'No email selected');
      return;
    }

    final to = replyToController.text.trim();
    final subject = replySubjectController.text.trim();
    final body = replyBodyController.text.trim();

    if (to.isEmpty) {
      Get.snackbar('Error', 'Recipient email required');
      return;
    }

    if (subject.isEmpty) {
      Get.snackbar('Error', 'Subject required');
      return;
    }

    if (body.isEmpty) {
      Get.snackbar('Error', 'Reply message required');
      return;
    }

    final key = getConversationKey(selectedMail);

    final replyMail = GmailMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      threadId: key,
      labels: const [],
      fromName: 'Me',
      fromEmail: myEmail,
      toEmail: to,
      subject: subject,
      snippet: makeSnippet(body),
      body: body,
      time: 'Just now',
      isUnread: false,
      isStarred: false,
      hasAttachment: false,
    );

    repliesByConversation.putIfAbsent(key, () => []);
    repliesByConversation[key]!.add(replyMail);

    buildCurrentThread();

    if (Get.isDialogOpen == true) {
      Get.back();
    }

    closeReplyDialogFlag();

    clearReplyDialogFields();

    emails.refresh();
    update();

    scrollThreadToBottom();

    Get.snackbar('Sent', 'Reply sent successfully');
  }

  void cancelReplyDialog() {
    clearReplyDialogFields();

    if (Get.isDialogOpen == true) {
      Get.back();
    }

    closeReplyDialogFlag();
    update();
  }

  void clearComposeFields() {
    composeToController.clear();
    composeCcController.clear();
    composeSubjectController.clear();
    composeBodyController.clear();
  }

  void sendNewEmail() {
    final to = composeToController.text.trim();
    final subject = composeSubjectController.text.trim();
    final body = composeBodyController.text.trim();

    if (to.isEmpty) {
      Get.snackbar('Error', 'Recipient email required');
      return;
    }

    if (subject.isEmpty) {
      Get.snackbar('Error', 'Subject required');
      return;
    }

    if (body.isEmpty) {
      Get.snackbar('Error', 'Email body required');
      return;
    }

    final newMailId = DateTime.now().millisecondsSinceEpoch.toString();

    final newMail = GmailMessageModel(
      id: newMailId,
      threadId: 'thread_$newMailId',
      labels: const [],
      fromName: 'Me',
      fromEmail: myEmail,
      toEmail: to,
      subject: subject,
      snippet: makeSnippet(body),
      body: body,
      time: 'Just now',
      isUnread: false,
      isStarred: false,
      hasAttachment: false,
    );

    emails.insert(0, newMail);
    selectedEmail.value = newMail;

    buildCurrentThread();

    if (Get.isDialogOpen == true) {
      Get.back();
    }

    clearComposeFields();

    emails.refresh();
    update();

    scrollThreadToBottom();

    Get.snackbar('Sent', 'Email sent successfully');
  }

  @override
  void onClose() {
    searchController.dispose();

    replyToController.dispose();
    replyCcController.dispose();
    replySubjectController.dispose();
    replyBodyController.dispose();

    composeToController.dispose();
    composeCcController.dispose();
    composeSubjectController.dispose();
    composeBodyController.dispose();

    mailScrollController.dispose();

    super.onClose();
  }
}