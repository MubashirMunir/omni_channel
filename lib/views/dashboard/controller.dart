// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../models/convo_list.dart';
// import '../../models/message_model.dart';
// import '../../widgets/formatted_time.dart';
//
//
// class DashboardController extends GetxController {
//   var convoModel = Rxn<ConversationModel>();
//   var messanger = Rxn<ConversationModel>();
//   RxInt selectedIndex = 0.obs;
//   final RxBool showEmojiBoard = false.obs;
//
//   void toggleEmojiBoard() {
//     showEmojiBoard.value = !showEmojiBoard.value;
//   }
//
//   void hideEmojiBoard() {
//     showEmojiBoard.value = false;
//   }
//
//   void showEmojiKeyboard() {
//     showEmojiBoard.value = true;
//   }
//   void changeIndex(int index) {
//     selectedIndex.value = index;
//   }
//
//   TextEditingController msgController =
//   TextEditingController();
//
//   /// ACTIVE TAB
//   var selectedTab = "All".obs;
//   String? expandedList;
//   /// CONVERSATIONS
//
//   /// SELECTED CHAT
//
//   /// MESSAGES
//   List<MessageModel> messages = [];
//
//   /// OPEN CHAT
//   void selectConversation(ConversationModel convo) {
//     convoModel.value = convo;
//     loadMessages(convo.id);
//   }
//
//   /// LOAD CHAT MESSAGES
//   void loadMessages(String id) {
//
//     messages = [
//
//       MessageModel(
//         id: "1",
//         text: "Hello 👋",
//         isMe: false,
//         time: "10:20",
//       ),
//
//       MessageModel(
//         id: "2",
//         text: "Hi! How can I help?",
//         isMe: true,
//         time: "10:21",
//       ),
//     ];
//
//     update();
//   }
//   /// SEND MESSAGE
//   void sendMessage() {
//     final text = msgController.text.trim();
//
//     if (text.isEmpty) return;
//
//     final now = DateTime.now();
//
//     messages.add(
//       MessageModel(
//         id: now.toString(),
//         text: text,
//         isMe: true,
//         time: "Now",
//       ),
//     );
//
//     final selected = convoModel.value;
//
//     if (selected != null) {
//       final index = conversations.indexWhere(
//             (e) => e.id == selected.id,
//       );
//
//       if (index != -1) {
//         conversations[index] = conversations[index].copyWith(
//           message: text,
//           time: formatTime(now),
//           updatedAt: now,
//         );
//
//         conversations.sort(
//               (a, b) => b.updatedAt.compareTo(a.updatedAt),
//         );
//
//         convoModel.value = conversations.firstWhere(
//               (e) => e.id == selected.id,
//         );
//       }
//     }
//
//     msgController.clear();
//
//     update();
//   }
//   /// FILTERS
//   List<ConversationModel>
//   get filteredConversations {
//
//     if (selectedTab.value == "Unread") {
//
//       return conversations
//           .where((e) => e.unread > 0)
//           .toList();
//     }
//
//     if (selectedTab.value == "Assigned") {
//
//       return conversations
//           .where((e) => e.assigned)
//           .toList();
//     }
//
//     return conversations;
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/convo_list.dart' as convo_data;
import '../../models/message_model.dart';
import '../../widgets/formatted_time.dart';

class DashboardController extends GetxController {
  /// =========================
  /// SELECTED CONVERSATION
  /// =========================

  var convoModel = Rxn<convo_data.ConversationModel>();

  /// =========================
  /// UI STATES
  /// =========================

  RxInt selectedIndex = 0.obs;
  RxString selectedTab = "All".obs;
  final RxBool showEmojiBoard = false.obs;

  String? expandedList;

  /// =========================
  /// TEXT CONTROLLERS
  /// =========================

  final TextEditingController msgController = TextEditingController();

  /// =========================
  /// CONVERSATIONS MASTER LIST
  /// =========================

  final List<convo_data.ConversationModel> conversations =
  List<convo_data.ConversationModel>.from(convo_data.conversations);

  /// =========================
  /// MESSAGES
  /// =========================

  List<MessageModel> messages = [];

  final Map<String, List<MessageModel>> _messagesByConversation = {};

  /// =========================
  /// BOTTOM / SIDE INDEX
  /// =========================

  void changeIndex(int index) {
    selectedIndex.value = index;
    update();
  }

  /// =========================
  /// TABS
  /// =========================

  void changeTab(String tab) {
    selectedTab.value = tab;
    update();
  }

  /// =========================
  /// EXPANSION LIST
  /// =========================

  void toggleExpandedList(String title, bool value) {
    expandedList = value ? title : null;
    update();
  }

  /// =========================
  /// EMOJI BOARD
  /// =========================

  void toggleEmojiBoard() {
    showEmojiBoard.value = !showEmojiBoard.value;
    update();
  }

  void hideEmojiBoard() {
    showEmojiBoard.value = false;
    update();
  }

  void showEmojiKeyboard() {
    showEmojiBoard.value = true;
    update();
  }

  void addEmoji(String emoji) {
    final oldText = msgController.text;
    final selection = msgController.selection;

    final cursorPosition = selection.baseOffset < 0
        ? oldText.length
        : selection.baseOffset;

    final newText = oldText.replaceRange(
      cursorPosition,
      cursorPosition,
      emoji,
    );

    msgController.text = newText;

    msgController.selection = TextSelection.collapsed(
      offset: cursorPosition + emoji.length,
    );

    update();
  }

  /// =========================
  /// SELECT / OPEN CHAT
  /// =========================

  void selectConversation(convo_data.ConversationModel convo) {
    final index = conversations.indexWhere((e) => e.id == convo.id);

    if (index != -1) {
      conversations[index] = conversations[index].copyWith(
        unread: 0,
      );

      convoModel.value = conversations[index];
    } else {
      convoModel.value = convo;
    }

    loadMessages(convo.id);
    update();
  }

  /// =========================
  /// LOAD CHAT MESSAGES
  /// =========================

  void loadMessages(String conversationId) {
    messages = _messagesByConversation.putIfAbsent(
      conversationId,
          () => [
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
      ],
    );

    update();
  }

  /// =========================
  /// SEND MESSAGE
  /// =========================

  void sendMessage() {
    final text = msgController.text.trim();

    if (text.isEmpty) return;

    final selected = convoModel.value;

    if (selected == null) return;

    final now = DateTime.now();

    final newMessage = MessageModel(
      id: now.toString(),
      text: text,
      isMe: true,
      time: formatTime(now),
    );

    messages.add(newMessage);

    _messagesByConversation[selected.id] = messages;

    final index = conversations.indexWhere(
          (e) => e.id == selected.id,
    );

    if (index != -1) {
      conversations[index] = conversations[index].copyWith(
        message: text,
        time: formatTime(now),
        updatedAt: now,
        unread: 0,
      );

      sortConversations();

      convoModel.value = conversations.firstWhere(
            (e) => e.id == selected.id,
      );
    }

    msgController.clear();
    hideEmojiBoard();

    update();
  }

  /// =========================
  /// SORTING
  /// =========================

  void sortConversations() {
    conversations.sort(
          (a, b) => b.updatedAt.compareTo(a.updatedAt),
    );
  }

  /// =========================
  /// PLATFORM FILTER
  /// =========================

  List<convo_data.ConversationModel> getByPlatform(String platform) {
    final list = conversations
        .where(
          (e) => e.platform.toLowerCase() == platform.toLowerCase(),
    )
        .toList();

    list.sort(
          (a, b) => b.updatedAt.compareTo(a.updatedAt),
    );

    return list;
  }

  int countByPlatform(String platform) {
    return conversations
        .where(
          (e) => e.platform.toLowerCase() == platform.toLowerCase(),
    )
        .length;
  }

  /// =========================
  /// TAB FILTERS
  /// =========================

  List<convo_data.ConversationModel> get filteredConversations {
    List<convo_data.ConversationModel> list;

    if (selectedTab.value == "Unread") {
      list = conversations.where((e) => e.unread > 0).toList();
    } else if (selectedTab.value == "Assigned") {
      list = conversations.where((e) => e.assigned).toList();
    } else {
      list = conversations.toList();
    }

    list.sort(
          (a, b) => b.updatedAt.compareTo(a.updatedAt),
    );

    return list;
  }

  /// =========================
  /// SELECTED CHAT HELPERS
  /// =========================

  bool get hasSelectedConversation {
    return convoModel.value != null;
  }

  convo_data.ConversationModel? get selectedConversation {
    return convoModel.value;
  }

  /// =========================
  /// CLEANUP
  /// =========================

  @override
  void onClose() {
    msgController.dispose();
    super.onClose();
  }
}