
import 'dart:ui_web';

import 'package:elite_csr/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/convo_list.dart';
import '../../models/message_model.dart';


class DashboardController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final RxBool showEmojiBoard = false.obs;

  void toggleEmojiBoard() {
    showEmojiBoard.value = !showEmojiBoard.value;
  }

  void hideEmojiBoard() {
    showEmojiBoard.value = false;
  }

  void showEmojiKeyboard() {
    showEmojiBoard.value = true;
  }
  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  TextEditingController msgController =
  TextEditingController();

  /// ACTIVE TAB
  var selectedTab = "All".obs;
  String? expandedList;
  /// CONVERSATIONS
  List<ConversationModel> conversations = [
    ConversationModel(
      id: "1",
      name: "Alisha Ali",
      platform: "WhatsApp",
      message: "Hello, I need help with pricing.",
      time: "10:30 AM",
      unread: 2,
      profile: "https://i.pravatar.cc/150?img=1",
      assigned: true,
    ),

    ConversationModel(
      id: "2",
      name: "Sana Khan",
      platform: "WhatsApp",
      message: "Can you share package details?",
      time: "09:15 AM",
      unread: 0,
      profile: "https://i.pravatar.cc/150?img=2",
      assigned: false,
    ), ConversationModel(
      id: "2",
      name: "Mubashir Munir",
      platform: "WhatsApp",
      message: "Can you share package pictures too?",
      time: "09:15 AM",
      unread: 0,
      profile: "https://i.pravatar.cc/150?img=2",
      assigned: false,
    ),
  ];

  /// SELECTED CHAT
  var selectedConversation =
  Rxn<ConversationModel>();

  /// MESSAGES
  List<MessageModel> messages = [];

  /// OPEN CHAT
  void selectConversation(ConversationModel convo) {
    selectedConversation.value = convo;
    loadMessages(convo.id);
  }

  /// LOAD CHAT MESSAGES
  void loadMessages(String id) {

    messages = [

      MessageModel(
        id: "1",
        text: "Hello 👋",
        isMe: false,
        time: "10:20",
      ),

      MessageModel(
        id: "2",
        text: "Hi! How can I help?",
        isMe: true,
        time: "10:21",
      ),
    ];

    update();
  }

  /// SEND MESSAGE
  void sendMessage() {

    if (msgController.text.trim().isEmpty) {
      return;
    }

    messages.add(
      MessageModel(
        id: DateTime.now().toString(),

        text: msgController.text,

        isMe: true,

        time: "Now",
      ),
    );

    msgController.clear();

    update();
  }

  /// FILTERS
  List<ConversationModel>
  get filteredConversations {

    if (selectedTab.value == "Unread") {

      return conversations
          .where((e) => e.unread > 0)
          .toList();
    }

    if (selectedTab.value == "Assigned") {

      return conversations
          .where((e) => e.assigned)
          .toList();
    }

    return conversations;
  }
}