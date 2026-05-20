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

  void fetchDemoEmails() {
    emails.assignAll([
      GmailMessageModel(
        id: '1',
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
        hasAttachment: false, threadId: '', labels: [],
      ),
      GmailMessageModel(
        id: '2',
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
    update();
  }

  void selectEmail(GmailMessageModel mail) {
    selectedEmail.value = mail;

    mail.isUnread = false;

    emails.refresh();
    update();
  }

  void toggleStar(GmailMessageModel mail) {
    mail.isStarred = !mail.isStarred;
    emails.refresh();
    update();
  }

  void archiveSelectedEmail() {
    final mail = selectedEmail.value;
    if (mail == null) return;

    emails.removeWhere((item) => item.id == mail.id);
    selectedEmail.value = emails.isNotEmpty ? emails.first : null;

    update();
  }

  void deleteSelectedEmail() {
    final mail = selectedEmail.value;
    if (mail == null) return;

    emails.removeWhere((item) => item.id == mail.id);
    selectedEmail.value = emails.isNotEmpty ? emails.first : null;

    update();
  }

  void markSelectedUnread() {
    final mail = selectedEmail.value;
    if (mail == null) return;

    mail.isUnread = true;

    emails.refresh();
    update();
  }

  void prepareReplyDialog(GmailMessageModel mail) {
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

    Get.back();
    Get.snackbar('Sent', 'Reply sent successfully');

    clearReplyDialogFields();
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

    Get.back();
    Get.snackbar('Sent', 'Email sent successfully');

    clearComposeFields();
    update();
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

    super.onClose();
  }
}