import 'message_model.dart';

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
