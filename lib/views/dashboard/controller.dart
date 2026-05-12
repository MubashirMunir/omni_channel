

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/message_model.dart';

class DashboardController extends GetxController {
TextEditingController msgController=TextEditingController();
  /// ACTIVE TAB
  var selectedTab = "All".obs;

  /// ACTIVE CONVERSATION
  var selectedConversation = Rxn<Map<String, dynamic>>();

  /// CONVERSATIONS LIST
  List<Map<String, dynamic>> conversations = [
    {
      "id": "1",
      "name": "Alisha Ali",
      "platform": "WhatsApp",
      "message": "Hello, I need help with pricing.",
      "time": "10:30 AM",
      "unread": 2,
      "profile": "https://i.pravatar.cc/150?img=1",
      "assigned": true,
    },
    {
      "id": "2",
      "name": "Sana Khan",
      "platform": "Facebook",
      "message": "Can you share package details?",
      "time": "09:15 AM",
      "unread": 0,
      "profile": "https://i.pravatar.cc/150?img=2",
      "assigned": false,
    },
    {
      "id": "3",
      "name": "Sarah Noor",
      "platform": "Instagram",
      "message": "I sent you a DM yesterday.",
      "time": "Yesterday",
      "unread": 5,
      "profile": "https://i.pravatar.cc/150?img=3",
      "assigned": true,
    },
    {
      "id": "4",
      "name": "Bilal",
      "platform": "TikTok",
      "message": "Interested in collaboration.",
      "time": "2d ago",
      "unread": 1,
      "profile": "https://i.pravatar.cc/150?img=4",
      "assigned": false,
    },
  ];

  /// MESSAGES (selected chat ke)
  List<MessageModel> messages = [];
void sendMessage(String text) {
  messages.add(
    MessageModel(
      id: DateTime.now().toString(),
      text: text,
      isMe: true,
      time: "now",
    ),
  );

  update();
}
  /// SELECT CONVERSATION
  void selectConversation(Map<String, dynamic> convo) {
    selectedConversation.value = convo;
    loadMessages(convo['id']);
  }

  /// LOAD MESSAGES (API later)
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
      MessageModel(
        id: "3",
        text: "I need pricing details",
        isMe: false,
        time: "10:22",
      ),
    ];

    update();
  }

  /// FILTERED CONVERSATIONS
  List<Map<String, dynamic>> get filteredConversations {

    if (selectedTab.value == "Unread") {
      return conversations
          .where((e) => (e["unread"] ?? 0) > 0)
          .toList();
    }

    if (selectedTab.value == "Assigned") {
      return conversations
          .where((e) => e["assigned"] == true)
          .toList();
    }

    return conversations;
  }

  /// PLATFORM COLOR
  Color platformColor(String platform) {
    switch (platform.toLowerCase()) {
      case "whatsapp":
        return Colors.green;
      case "facebook":
        return Colors.blue;
      case "instagram":
        return Colors.purple;
      case "tiktok":
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

  /// PLATFORM ICON
  IconData platformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case "whatsapp":
        return Icons.message;
      case "facebook":
        return Icons.facebook;
      case "instagram":
        return Icons.camera_alt_outlined;
      case "tiktok":
        return Icons.music_note;
      default:
        return Icons.chat;
    }
  }
}