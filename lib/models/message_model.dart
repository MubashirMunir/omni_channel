enum MessageType {
  text,
  image,
  video,
  audio,
  document,
  unknown,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

class MessageModel {
  final String id;

  /// Customer ya business phone/user id
  final String from;

  /// Receiver id, optional practice ke liye
  final String to;

  /// Message text/body
  final String text;

  /// true = agent/business message
  /// false = customer message
  final bool isMe;

  /// UI formatted time
  final String time;

  /// Real timestamp API ke liye useful
  final DateTime? timestamp;

  /// text/image/video/document etc
  final MessageType type;

  /// sending/sent/delivered/read/failed
  final MessageStatus status;

  /// Reply/quote ke liye
  final String? replyToMessageId;
  final String? replyToText;

  MessageModel({
    required this.id,
    this.from = '',
    this.to = '',
    required this.text,
    required this.isMe,
    required this.time,
    this.timestamp,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    this.replyToMessageId,
    this.replyToText,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.tryParse(
      json['timestamp']?.toString() ??
          json['created_at']?.toString() ??
          '',
    );

    return MessageModel(
      id: json['id']?.toString() ?? '',
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
      text: json['text']?.toString() ??
          json['message']?.toString() ??
          json['body']?.toString() ??
          '',
      isMe: json['is_me'] ?? json['isMe'] ?? false,
      time: json['time']?.toString() ?? '',
      timestamp: createdAt,
      type: _messageTypeFromString(json['type']?.toString()),
      status: _messageStatusFromString(json['status']?.toString()),
      replyToMessageId: json['reply_to_message_id']?.toString(),
      replyToText: json['reply_to_text']?.toString(),
    );
  }

  /// WhatsApp Cloud API incoming webhook text message style
  factory MessageModel.fromWhatsAppWebhook(
      Map<String, dynamic> json,
      ) {
    final timestampSeconds = int.tryParse(
      json['timestamp']?.toString() ?? '',
    );

    final dateTime = timestampSeconds == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
      timestampSeconds * 1000,
    );

    return MessageModel(
      id: json['id']?.toString() ?? '',
      from: json['from']?.toString() ?? '',
      text: json['text']?['body']?.toString() ?? '',
      isMe: false,
      time: dateTime == null ? '' : _formatTime(dateTime),
      timestamp: dateTime,
      type: _messageTypeFromString(json['type']?.toString()),
      status: MessageStatus.delivered,
      replyToMessageId: json['context']?['id']?.toString(),
    );
  }

  /// Jab tum apni taraf se message send karo
  factory MessageModel.localSending({
    required String text,
    required String to,
  }) {
    final now = DateTime.now();

    return MessageModel(
      id: now.microsecondsSinceEpoch.toString(),
      to: to,
      text: text,
      isMe: true,
      time: _formatTime(now),
      timestamp: now,
      type: MessageType.text,
      status: MessageStatus.sending,
    );
  }

  MessageModel copyWith({
    String? id,
    String? from,
    String? to,
    String? text,
    bool? isMe,
    String? time,
    DateTime? timestamp,
    MessageType? type,
    MessageStatus? status,
    String? replyToMessageId,
    String? replyToText,
  }) {
    return MessageModel(
      id: id ?? this.id,
      from: from ?? this.from,
      to: to ?? this.to,
      text: text ?? this.text,
      isMe: isMe ?? this.isMe,
      time: time ?? this.time,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      status: status ?? this.status,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      replyToText: replyToText ?? this.replyToText,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "from": from,
      "to": to,
      "text": text,
      "is_me": isMe,
      "time": time,
      "timestamp": timestamp?.toIso8601String(),
      "type": type.name,
      "status": status.name,
      "reply_to_message_id": replyToMessageId,
      "reply_to_text": replyToText,
    };
  }

  /// WhatsApp Cloud API send text message style payload
  Map<String, dynamic> toWhatsAppSendJson({
    required String phoneNumber,
    String messagingProduct = "whatsapp",
  }) {
    return {
      "messaging_product": messagingProduct,
      "to": phoneNumber,
      "type": "text",
      "text": {
        "body": text,
      },
      if (replyToMessageId != null)
        "context": {
          "message_id": replyToMessageId,
        },
    };
  }

  static MessageType _messageTypeFromString(String? value) {
    switch (value) {
      case "text":
        return MessageType.text;
      case "image":
        return MessageType.image;
      case "video":
        return MessageType.video;
      case "audio":
        return MessageType.audio;
      case "document":
        return MessageType.document;
      default:
        return MessageType.unknown;
    }
  }

  static MessageStatus _messageStatusFromString(String? value) {
    switch (value) {
      case "sending":
        return MessageStatus.sending;
      case "sent":
        return MessageStatus.sent;
      case "delivered":
        return MessageStatus.delivered;
      case "read":
        return MessageStatus.read;
      case "failed":
        return MessageStatus.failed;
      default:
        return MessageStatus.sent;
    }
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour == 0
        ? 12
        : dateTime.hour;

    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? "PM" : "AM";

    return "$hour:$minute $period";
  }
}

/// DUMMY DATA
List<MessageModel> messages = [
  MessageModel(
    id: "wamid.001",
    from: "923001234567",
    text: "Hello 👋 I need information about your CRM pricing packages.",
    isMe: false,
    time: "10:20 AM",
    type: MessageType.text,
    status: MessageStatus.delivered,
  ),

  MessageModel(
    id: "wamid.002",
    to: "923001234567",
    text: "Sure 👍 Which package are you interested in?",
    isMe: true,
    time: "10:21 AM",
    type: MessageType.text,
    status: MessageStatus.read,
  ),

  MessageModel(
    id: "wamid.003",
    from: "923001234567",
    text: "I want multi-agent inbox with WhatsApp integration.",
    isMe: false,
    time: "10:22 AM",
    type: MessageType.text,
    status: MessageStatus.delivered,
  ),

  MessageModel(
    id: "wamid.004",
    to: "923001234567",
    text: "Yes, we support WhatsApp Cloud API, Facebook and Instagram DMs.",
    isMe: true,
    time: "10:23 AM",
    type: MessageType.text,
    status: MessageStatus.delivered,
  ),

  MessageModel(
    id: "wamid.005",
    from: "923001234567",
    text: "Great. Can I assign conversations to team members?",
    isMe: false,
    time: "10:24 AM",
    type: MessageType.text,
    status: MessageStatus.delivered,
    replyToMessageId: "wamid.004",
    replyToText: "Yes, we support WhatsApp Cloud API, Facebook and Instagram DMs.",
  ),

  MessageModel(
    id: "wamid.006",
    to: "923001234567",
    text: "Absolutely. Team assignment and internal notes are included.",
    isMe: true,
    time: "10:25 AM",
    type: MessageType.text,
    status: MessageStatus.sent,
  ),

  MessageModel(
    id: "wamid.007",
    from: "923001234567",
    text: "Perfect 👍 Please share demo access.",
    isMe: false,
    time: "10:26 AM",
    type: MessageType.text,
    status: MessageStatus.delivered,
  ),
];