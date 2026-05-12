class MessageModel {

  final String id;
  final String text;
  final bool isMe;
  final String time;

  MessageModel({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
  });

  factory MessageModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return MessageModel(
      id: json['id'].toString(),

      text: json['text'] ?? '',

      isMe: json['is_me'] ?? true,

      time: json['time'] ?? '',
    );
  }
}


/// DUMMY DATA
List<MessageModel> messages = [

  MessageModel(
    id: "1",

    text:
    "Hello 👋 I need information about your CRM pricing packages.",

    isMe: false,

    time: "10:20 AM",
  ),

  MessageModel(
    id: "2",

    text:
    "Sure 👍 Which package are you interested in?",

    isMe: true,

    time: "10:21 AM",
  ),

  MessageModel(
    id: "3",

    text:
    "I want multi-agent inbox with WhatsApp integration.",

    isMe: false,

    time: "10:22 AM",
  ),

  MessageModel(
    id: "4",

    text:
    "Yes, we support WhatsApp Cloud API, Facebook and Instagram DMs.",

    isMe: true,

    time: "10:23 AM",
  ),

  MessageModel(
    id: "5",

    text:
    "Great. Can I assign conversations to team members?",

    isMe: false,

    time: "10:24 AM",
  ),

  MessageModel(
    id: "6",

    text:
    "Absolutely. Team assignment and internal notes are included.",

    isMe: true,

    time: "10:25 AM",
  ),

  MessageModel(
    id: "7",

    text:
    "Perfect 👍 Please share demo access.",

    isMe: false,

    time: "10:26 AM",
  ),
];