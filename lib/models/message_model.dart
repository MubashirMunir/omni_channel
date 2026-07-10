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

  final String from;
  final String to;

  final String text;

  final bool isMe;

  final String time;

  final DateTime? timestamp;

  final MessageType type;

  final MessageStatus status;

  /// Voice note / audio support
  final String? audioPath;
  final int? audioDuration;

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
    this.audioPath,
    this.audioDuration,
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
      audioPath: json['audio_path']?.toString() ??
          json['audioPath']?.toString() ??
          json['media_url']?.toString(),
      audioDuration: int.tryParse(
        json['audio_duration']?.toString() ??
            json['audioDuration']?.toString() ??
            '',
      ),
      replyToMessageId: json['reply_to_message_id']?.toString(),
      replyToText: json['reply_to_text']?.toString(),
    );
  }

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

    final type = _messageTypeFromString(
      json['type']?.toString(),
    );

    return MessageModel(
      id: json['id']?.toString() ?? '',
      from: json['from']?.toString() ?? '',
      text: type == MessageType.audio
          ? ''
          : json['text']?['body']?.toString() ?? '',
      isMe: false,
      time: dateTime == null ? '' : _formatTime(dateTime),
      timestamp: dateTime,
      type: type,
      status: MessageStatus.delivered,

      /// WhatsApp audio object example:
      /// "audio": {
      ///   "id": "...",
      ///   "mime_type": "audio/ogg; codecs=opus",
      ///   "sha256": "..."
      /// }
      audioPath: json['audio']?['id']?.toString(),
      audioDuration: int.tryParse(
        json['audio']?['duration']?.toString() ?? '',
      ),

      replyToMessageId: json['context']?['id']?.toString(),
    );
  }

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

  factory MessageModel.localAudio({
    required String audioPath,
    required int audioDuration,
    String to = '',
  }) {
    final now = DateTime.now();

    return MessageModel(
      id: now.microsecondsSinceEpoch.toString(),
      to: to,
      text: '',
      isMe: true,
      time: _formatTime(now),
      timestamp: now,
      type: MessageType.audio,
      status: MessageStatus.sending,
      audioPath: audioPath,
      audioDuration: audioDuration,
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
    String? audioPath,
    int? audioDuration,
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
      audioPath: audioPath ?? this.audioPath,
      audioDuration: audioDuration ?? this.audioDuration,
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
      "audio_path": audioPath,
      "audio_duration": audioDuration,
      "reply_to_message_id": replyToMessageId,
      "reply_to_text": replyToText,
    };
  }

  Map<String, dynamic> toWhatsAppSendJson({
    required String phoneNumber,
    String messagingProduct = "whatsapp",
  }) {
    if (type == MessageType.audio) {
      return {
        "messaging_product": messagingProduct,
        "to": phoneNumber,
        "type": "audio",
        "audio": {
          "id": audioPath,
        },
        if (replyToMessageId != null)
          "context": {
            "message_id": replyToMessageId,
          },
      };
    }

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
      case "voice":
      case "voice_note":
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