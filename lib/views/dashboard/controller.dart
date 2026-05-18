
import 'dart:ui_web';

import 'package:elite_csr/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/convo_list.dart';
import '../../models/message_model.dart';
import '../../widgets/formatted_time.dart';


class DashboardController extends GetxController {
  var convoModel = Rxn<ConversationModel>();
  List<ConversationModel> list =[];
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

  /// SELECTED CHAT

  /// MESSAGES
  List<MessageModel> messages = [];

  /// OPEN CHAT
  void selectConversation(ConversationModel convo) {
    convoModel.value = convo;
    loadMessages(convo.id??'');
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
    final text = msgController.text.trim();

    if (text.isEmpty) return;

    final now = DateTime.now();

    messages.add(
      MessageModel(
        id: now.toString(),
        text: text,
        isMe: true,
        time: "Now",
      ),
    );

    final selected = convoModel.value;

    if (selected != null) {
      final index = conversations.indexWhere(
            (e) => e.id == selected.id,
      );

      if (index != -1) {
        conversations[index] = conversations[index].copyWith(
          message: text,
          time: formatTime(now),
          updatedAt: now,
        );

        conversations.sort(
              (a, b) => b.updatedAt.compareTo(a.updatedAt),
        );

        convoModel.value = conversations.firstWhere(
              (e) => e.id == selected.id,
        );
      }
    }

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