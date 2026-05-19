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
  /// scroll to end automatic
  final ScrollController messageScrollController = ScrollController();
  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (messageScrollController.hasClients) {
        messageScrollController.animateTo(
          messageScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

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
  /// FILTERS
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
    scrollToBottom();
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
    final list = filteredConversations
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
    return getByPlatform(platform).length;
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
  void loadMessages(String conversationId) {
    final convo = conversations.firstWhereOrNull(
          (e) => e.id == conversationId,
    );

    if (convo == null) return;

    messages = _messagesByConversation.putIfAbsent(
      conversationId,
          () => _getDefaultMessagesByPlatform(convo.platform),
    );

    update();
  }
  /// =========================
  /// CLEANUP
  /// =========================
  List<MessageModel> _getDefaultMessagesByPlatform(String platform) {
    final channel = platform.toLowerCase();

    if (channel == "whatsapp") {
      return [
        MessageModel(
          id: "w1",
          text: "Assalam o Alaikum 👋",
          isMe: false,
          time: "10:20 AM",
        ),
        MessageModel(
          id: "w2",
          text: "Wa Alaikum Salam! How can I help you?",
          isMe: true,
          time: "10:21 AM",
        ),
        MessageModel(
          id: "w3",
          text: "Mujhe pricing package ki details chahiye.",
          isMe: false,
          time: "10:22 AM",
        ),
        MessageModel(
          id: "w4",
          text: "Sure, humare paas Basic, Pro aur Enterprise plans hain.",
          isMe: true,
          time: "10:23 AM",
        ),
        MessageModel(
          id: "w5",
          text: "Pro plan me kya kya included hai?",
          isMe: false,
          time: "10:24 AM",
        ),
        MessageModel(
          id: "w6",
          text:
          "Pro plan me WhatsApp inbox, team assignment, unread filter, analytics aur lead tracking included hai.",
          isMe: true,
          time: "10:25 AM",
        ),
        MessageModel(
          id: "w7",
          text: "Can you share package pictures too?",
          isMe: false,
          time: "10:26 AM",
        ),
        MessageModel(
          id: "w8",
          text: "Yes, main package screenshots abhi share kar deta hun.",
          isMe: true,
          time: "10:27 AM",
        ),
      ];
    }

    if (channel == "facebook") {
      return [
        MessageModel(
          id: "f1",
          text: "Hi, I saw your CRM ad on Facebook.",
          isMe: false,
          time: "09:05 AM",
        ),
        MessageModel(
          id: "f2",
          text: "Hello! Thanks for reaching out. What would you like to know?",
          isMe: true,
          time: "09:06 AM",
        ),
        MessageModel(
          id: "f3",
          text: "Can this CRM connect with my Facebook page?",
          isMe: false,
          time: "09:07 AM",
        ),
        MessageModel(
          id: "f4",
          text:
          "Yes, you can connect your Facebook page and manage page messages from one dashboard.",
          isMe: true,
          time: "09:08 AM",
        ),
        MessageModel(
          id: "f5",
          text: "Can my team reply to customers from the same dashboard?",
          isMe: false,
          time: "09:09 AM",
        ),
        MessageModel(
          id: "f6",
          text:
          "Yes, you can add agents, assign conversations, and monitor replies.",
          isMe: true,
          time: "09:10 AM",
        ),
        MessageModel(
          id: "f7",
          text: "Is there any monthly package?",
          isMe: false,
          time: "09:11 AM",
        ),
        MessageModel(
          id: "f8",
          text: "Yes, monthly packages are available. I can share details.",
          isMe: true,
          time: "09:12 AM",
        ),
      ];
    }

    if (channel == "instagram") {
      return [
        MessageModel(
          id: "i1",
          text: "Hey, I need help with my order.",
          isMe: false,
          time: "11:15 AM",
        ),
        MessageModel(
          id: "i2",
          text: "Sure! Please share your order number.",
          isMe: true,
          time: "11:16 AM",
        ),
        MessageModel(
          id: "i3",
          text: "Order number is #ELT-1029.",
          isMe: false,
          time: "11:17 AM",
        ),
        MessageModel(
          id: "i4",
          text: "Thanks. Let me check the order status for you.",
          isMe: true,
          time: "11:18 AM",
        ),
        MessageModel(
          id: "i5",
          text: "Also, do you provide support on Instagram DM?",
          isMe: false,
          time: "11:19 AM",
        ),
        MessageModel(
          id: "i6",
          text:
          "Yes, Instagram DM support can be managed from this CRM dashboard.",
          isMe: true,
          time: "11:20 AM",
        ),
        MessageModel(
          id: "i7",
          text: "Can I assign DMs to my team members?",
          isMe: false,
          time: "11:21 AM",
        ),
        MessageModel(
          id: "i8",
          text:
          "Yes, every Instagram conversation can be assigned to a specific agent.",
          isMe: true,
          time: "11:22 AM",
        ),
      ];
    }

    return [
      MessageModel(
        id: "d1",
        text: "Hello 👋",
        isMe: false,
        time: "10:20 AM",
      ),
      MessageModel(
        id: "d2",
        text: "Hi! How can I help you?",
        isMe: true,
        time: "10:21 AM",
      ),
    ];
  }
  @override
  void onClose() {
    msgController.dispose();
    super.onClose();
  }
}