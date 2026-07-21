import 'dart:typed_data';

/// ============================================================
/// MESSAGE TYPE
/// ============================================================

enum MessageType {
  text,
  image,
  video,
  audio,
  document,
  unknown,
}

/// ============================================================
/// MESSAGE STATUS
/// ============================================================

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

/// ============================================================
/// MESSAGE MODEL
/// ============================================================

class MessageModel {
  /// Unique message ID
  final String id;

  /// Sender number / ID
  final String from;

  /// Receiver number / ID
  final String to;

  /// Text message or media caption
  final String text;

  /// True when message belongs to current user
  final bool isMe;

  /// Display time
  final String time;

  /// Actual timestamp
  final DateTime? timestamp;

  /// Message type
  final MessageType type;

  /// Message delivery status
  final MessageStatus status;

  // ============================================================
  // IMAGE SUPPORT
  // ============================================================

  /// Local selected image bytes.
  ///
  /// Flutter Web me image preview ke liye useful.
  final Uint8List? imageBytes;

  /// Public/server image URL.
  ///
  /// Example:
  /// https://example.com/image.jpg
  final String? imageUrl;

  /// WhatsApp uploaded image media ID.
  ///
  /// Example:
  /// 123456789098765
  ///
  /// IMPORTANT:
  /// Ye imageUrl se different hai.
  final String? imageMediaId;

  // ============================================================
  // AUDIO / VOICE NOTE SUPPORT
  // ============================================================

  /// Local audio path / Blob URL / public server URL.
  ///
  /// Flutter Web recording ke baad ye ho sakta hai:
  ///
  /// blob:http://localhost:xxxxx
  ///
  /// Ya server upload ke baad:
  ///
  /// https://example.com/audio/voice.webm
  ///
  /// IMPORTANT:
  /// Isko WhatsApp media ID samajh kar send nahi karna.
  final String? audioPath;

  /// WhatsApp uploaded audio media ID.
  ///
  /// WhatsApp Cloud API par audio upload hone ke baad
  /// jo media ID milti hai wo yahan store hogi.
  final String? audioMediaId;

  /// Audio duration in seconds.
  final int? audioDuration;

  // ============================================================
  // REPLY SUPPORT
  // ============================================================

  /// Original message ID jis par reply kiya gaya.
  final String? replyToMessageId;

  /// UI me quoted/replied text show karne ke liye.
  final String? replyToText;

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  const MessageModel({
    required this.id,
    this.from = '',
    this.to = '',
    this.text = '',
    this.isMe = false,
    this.time = '',
    this.timestamp,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,

    // IMAGE
    this.imageBytes,
    this.imageUrl,
    this.imageMediaId,

    // AUDIO
    this.audioPath,
    this.audioMediaId,
    this.audioDuration,

    // REPLY
    this.replyToMessageId,
    this.replyToText,
  });

  // ============================================================
  // FROM NORMAL JSON
  // ============================================================

  factory MessageModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final MessageType messageType = _messageTypeFromString(
      json['type']?.toString(),
    );

    final DateTime? createdAt = _parseDateTime(
      json['timestamp'] ??
          json['created_at'] ??
          json['createdAt'],
    );

    final String providedTime =
    _safeString(json['time']);

    return MessageModel(
      id: _safeString(json['id']),

      from: _safeString(json['from']),

      to: _safeString(json['to']),

      text: _firstNonEmptyString([
        json['text'],
        json['message'],
        json['body'],
        json['caption'],
      ]),

      isMe: _parseBool(
        json['is_me'] ?? json['isMe'],
      ),

      time: providedTime.isNotEmpty
          ? providedTime
          : createdAt != null
          ? _formatTime(createdAt)
          : '',

      timestamp: createdAt,

      type: messageType,

      status: _messageStatusFromString(
        json['status']?.toString(),
      ),

      // ========================================================
      // IMAGE
      // ========================================================

      imageUrl: _firstNullableString([
        json['image_url'],
        json['imageUrl'],
        if (messageType == MessageType.image)
          json['media_url'],
      ]),

      imageMediaId: _firstNullableString([
        json['image_media_id'],
        json['imageMediaId'],
        if (messageType == MessageType.image)
          json['media_id'],
      ]),

      // ========================================================
      // AUDIO
      // ========================================================

      audioPath: _firstNullableString([
        json['audio_path'],
        json['audioPath'],
        json['audio_url'],
        json['audioUrl'],
        if (messageType == MessageType.audio)
          json['media_url'],
      ]),

      audioMediaId: _firstNullableString([
        json['audio_media_id'],
        json['audioMediaId'],
        if (messageType == MessageType.audio)
          json['media_id'],
      ]),

      audioDuration: _parseInt(
        json['audio_duration'] ??
            json['audioDuration'] ??
            json['duration'],
      ),

      // ========================================================
      // REPLY
      // ========================================================

      replyToMessageId: _firstNullableString([
        json['reply_to_message_id'],
        json['replyToMessageId'],
      ]),

      replyToText: _firstNullableString([
        json['reply_to_text'],
        json['replyToText'],
      ]),
    );
  }

  // ============================================================
  // WHATSAPP WEBHOOK
  // ============================================================

  factory MessageModel.fromWhatsAppWebhook(
      Map<String, dynamic> json,
      ) {
    final DateTime? dateTime = _parseWhatsAppTimestamp(
      json['timestamp'],
    );

    final MessageType messageType =
    _messageTypeFromString(
      json['type']?.toString(),
    );

    String messageText = '';

    // ----------------------------------------------------------
    // TEXT
    // ----------------------------------------------------------

    if (messageType == MessageType.text) {
      final dynamic textData = json['text'];

      if (textData is Map) {
        messageText =
            _safeString(textData['body']);
      }
    }

    // ----------------------------------------------------------
    // IMAGE CAPTION
    // ----------------------------------------------------------

    if (messageType == MessageType.image) {
      final dynamic imageData = json['image'];

      if (imageData is Map) {
        messageText =
            _safeString(imageData['caption']);
      }
    }

    // ----------------------------------------------------------
    // DOCUMENT CAPTION
    // ----------------------------------------------------------

    if (messageType == MessageType.document) {
      final dynamic documentData =
      json['document'];

      if (documentData is Map) {
        messageText =
            _safeString(documentData['caption']);
      }
    }

    String? imageMediaId;
    String? audioMediaId;
    int? audioDuration;

    // ----------------------------------------------------------
    // IMAGE MEDIA ID
    // ----------------------------------------------------------

    final dynamic imageData = json['image'];

    if (imageData is Map) {
      imageMediaId =
          _nullableString(imageData['id']);
    }

    // ----------------------------------------------------------
    // AUDIO MEDIA ID
    // ----------------------------------------------------------

    final dynamic audioData = json['audio'];

    if (audioData is Map) {
      audioMediaId =
          _nullableString(audioData['id']);

      audioDuration =
          _parseInt(audioData['duration']);
    }

    // ----------------------------------------------------------
    // REPLY CONTEXT
    // ----------------------------------------------------------

    String? replyMessageId;

    final dynamic contextData = json['context'];

    if (contextData is Map) {
      replyMessageId =
          _nullableString(contextData['id']);
    }

    return MessageModel(
      id: _safeString(json['id']),

      from: _safeString(json['from']),

      to: '',

      text: messageText,

      isMe: false,

      time: dateTime != null
          ? _formatTime(dateTime)
          : '',

      timestamp: dateTime,

      type: messageType,

      status: MessageStatus.delivered,

      // IMAGE
      imageMediaId: imageMediaId,

      // AUDIO
      audioMediaId: audioMediaId,
      audioDuration: audioDuration,

      // REPLY
      replyToMessageId: replyMessageId,
    );
  }

  // ============================================================
  // LOCAL TEXT MESSAGE
  // ============================================================

  factory MessageModel.localSending({
    required String text,
    required String to,
    String? replyToMessageId,
    String? replyToText,
  }) {
    final DateTime now = DateTime.now();

    return MessageModel(
      id: now.microsecondsSinceEpoch.toString(),

      from: '',

      to: to,

      text: text,

      isMe: true,

      time: _formatTime(now),

      timestamp: now,

      type: MessageType.text,

      status: MessageStatus.sending,

      replyToMessageId: replyToMessageId,

      replyToText: replyToText,
    );
  }

  // ============================================================
  // LOCAL IMAGE MESSAGE
  // ============================================================

  factory MessageModel.localImage({
    required Uint8List imageBytes,
    String imageUrl = '',
    String imageMediaId = '',
    String to = '',
    String caption = '',
    String? replyToMessageId,
    String? replyToText,
  }) {
    final DateTime now = DateTime.now();

    return MessageModel(
      id: now.microsecondsSinceEpoch.toString(),

      from: '',

      to: to,

      text: caption,

      isMe: true,

      time: _formatTime(now),

      timestamp: now,

      type: MessageType.image,

      status: MessageStatus.sending,

      imageBytes: imageBytes,

      imageUrl: imageUrl.trim().isEmpty
          ? null
          : imageUrl.trim(),

      imageMediaId:
      imageMediaId.trim().isEmpty
          ? null
          : imageMediaId.trim(),

      replyToMessageId:
      replyToMessageId,

      replyToText: replyToText,
    );
  }

  // ============================================================
  // LOCAL AUDIO / VOICE NOTE MESSAGE
  // ============================================================

  factory MessageModel.localAudio({
    required String audioPath,
    required int audioDuration,
    String audioMediaId = '',
    String to = '',
    String? replyToMessageId,
    String? replyToText,
  }) {
    final DateTime now = DateTime.now();

    return MessageModel(
      id: now.microsecondsSinceEpoch.toString(),

      from: '',

      to: to,

      text: '',

      isMe: true,

      time: _formatTime(now),

      timestamp: now,

      type: MessageType.audio,

      status: MessageStatus.sending,

      audioPath: audioPath.trim().isEmpty
          ? null
          : audioPath.trim(),

      audioMediaId:
      audioMediaId.trim().isEmpty
          ? null
          : audioMediaId.trim(),

      audioDuration:
      audioDuration < 0 ? 0 : audioDuration,

      replyToMessageId:
      replyToMessageId,

      replyToText: replyToText,
    );
  }

  // ============================================================
  // COPY WITH
  // ============================================================

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

    // IMAGE
    Uint8List? imageBytes,
    String? imageUrl,
    String? imageMediaId,

    // AUDIO
    String? audioPath,
    String? audioMediaId,
    int? audioDuration,

    // REPLY
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

      // IMAGE
      imageBytes:
      imageBytes ?? this.imageBytes,

      imageUrl:
      imageUrl ?? this.imageUrl,

      imageMediaId:
      imageMediaId ?? this.imageMediaId,

      // AUDIO
      audioPath:
      audioPath ?? this.audioPath,

      audioMediaId:
      audioMediaId ?? this.audioMediaId,

      audioDuration:
      audioDuration ?? this.audioDuration,

      // REPLY
      replyToMessageId:
      replyToMessageId ??
          this.replyToMessageId,

      replyToText:
      replyToText ?? this.replyToText,
    );
  }

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'from': from,

      'to': to,

      'text': text,

      'is_me': isMe,

      'time': time,

      'timestamp':
      timestamp?.toIso8601String(),

      'type': type.name,

      'status': status.name,

      // ========================================================
      // IMAGE
      // ========================================================

      /// imageBytes intentionally JSON me nahi bhejte.
      /// Ye multipart upload me jayegi.
      'image_url': imageUrl,

      'image_media_id': imageMediaId,

      // ========================================================
      // AUDIO
      // ========================================================

      'audio_path': audioPath,

      'audio_media_id': audioMediaId,

      'audio_duration': audioDuration,

      // ========================================================
      // REPLY
      // ========================================================

      'reply_to_message_id':
      replyToMessageId,

      'reply_to_text': replyToText,
    };
  }

  // ============================================================
  // WHATSAPP SEND JSON
  // ============================================================

  Map<String, dynamic> toWhatsAppSendJson({
    required String phoneNumber,
    String messagingProduct = 'whatsapp',
  }) {
    final String receiver = phoneNumber.trim();

    if (receiver.isEmpty) {
      throw ArgumentError(
        'WhatsApp phone number cannot be empty.',
      );
    }

    // ==========================================================
    // AUDIO
    // ==========================================================

    if (type == MessageType.audio) {
      final Map<String, dynamic> audio = {};

      // Preferred:
      // Already uploaded WhatsApp media ID
      if (audioMediaId != null &&
          audioMediaId!.trim().isNotEmpty) {
        audio['id'] =
            audioMediaId!.trim();
      }

      // Optional:
      // Public HTTP/HTTPS audio URL
      else if (audioPath != null &&
          _isHttpUrl(audioPath!)) {
        audio['link'] =
            audioPath!.trim();
      }

      // Local Blob URL cannot be sent directly
      else {
        throw StateError(
          'Audio ko WhatsApp par send karne se pehle '
              'upload karo aur audioMediaId set karo. '
              'Local blob/audioPath direct WhatsApp API ko '
              'send nahi kiya ja sakta.',
        );
      }

      return {
        'messaging_product':
        messagingProduct,

        'to': receiver,

        'type': 'audio',

        'audio': audio,

        if (_hasValue(replyToMessageId))
          'context': {
            'message_id':
            replyToMessageId!.trim(),
          },
      };
    }

    // ==========================================================
    // IMAGE
    // ==========================================================

    if (type == MessageType.image) {
      final Map<String, dynamic> image = {};

      // WhatsApp uploaded media ID
      if (imageMediaId != null &&
          imageMediaId!.trim().isNotEmpty) {
        image['id'] =
            imageMediaId!.trim();
      }

      // Public image URL
      else if (imageUrl != null &&
          _isHttpUrl(imageUrl!)) {
        image['link'] =
            imageUrl!.trim();
      }

      // Neither media ID nor public URL
      else {
        throw StateError(
          'Image ko WhatsApp par send karne se pehle '
              'upload karo aur imageMediaId ya public '
              'imageUrl provide karo.',
        );
      }

      // IMPORTANT:
      // WhatsApp caption IMAGE object ke andar hota hai.
      if (text.trim().isNotEmpty) {
        image['caption'] = text.trim();
      }

      return {
        'messaging_product':
        messagingProduct,

        'to': receiver,

        'type': 'image',

        'image': image,

        if (_hasValue(replyToMessageId))
          'context': {
            'message_id':
            replyToMessageId!.trim(),
          },
      };
    }

    // ==========================================================
    // TEXT
    // ==========================================================

    return {
      'messaging_product':
      messagingProduct,

      'to': receiver,

      'type': 'text',

      'text': {
        'body': text,
      },

      if (_hasValue(replyToMessageId))
        'context': {
          'message_id':
          replyToMessageId!.trim(),
        },
    };
  }

  // ============================================================
  // HELPER: HAS LOCAL AUDIO
  // ============================================================

  bool get hasAudio {
    return _hasValue(audioPath) ||
        _hasValue(audioMediaId);
  }

  // ============================================================
  // HELPER: HAS IMAGE
  // ============================================================

  bool get hasImage {
    return imageBytes != null ||
        _hasValue(imageUrl) ||
        _hasValue(imageMediaId);
  }

  // ============================================================
  // HELPER: CAN SEND AUDIO TO WHATSAPP
  // ============================================================

  bool get canSendAudioToWhatsApp {
    if (type != MessageType.audio) {
      return false;
    }

    if (_hasValue(audioMediaId)) {
      return true;
    }

    if (_hasValue(audioPath) &&
        _isHttpUrl(audioPath!)) {
      return true;
    }

    return false;
  }

  // ============================================================
  // HELPER: CAN SEND IMAGE TO WHATSAPP
  // ============================================================

  bool get canSendImageToWhatsApp {
    if (type != MessageType.image) {
      return false;
    }

    if (_hasValue(imageMediaId)) {
      return true;
    }

    if (_hasValue(imageUrl) &&
        _isHttpUrl(imageUrl!)) {
      return true;
    }

    return false;
  }

  // ============================================================
  // MESSAGE TYPE PARSER
  // ============================================================

  static MessageType _messageTypeFromString(
      String? value,
      ) {
    switch (value?.trim().toLowerCase()) {
      case 'text':
        return MessageType.text;

      case 'image':
        return MessageType.image;

      case 'video':
        return MessageType.video;

      case 'audio':
      case 'voice':
      case 'voice_note':
      case 'voice-note':
        return MessageType.audio;

      case 'document':
      case 'file':
        return MessageType.document;

      default:
        return MessageType.unknown;
    }
  }

  // ============================================================
  // MESSAGE STATUS PARSER
  // ============================================================

  static MessageStatus _messageStatusFromString(
      String? value,
      ) {
    switch (value?.trim().toLowerCase()) {
      case 'sending':
        return MessageStatus.sending;

      case 'sent':
        return MessageStatus.sent;

      case 'delivered':
        return MessageStatus.delivered;

      case 'read':
        return MessageStatus.read;

      case 'failed':
      case 'error':
        return MessageStatus.failed;

      default:
        return MessageStatus.sent;
    }
  }

  // ============================================================
  // BOOL PARSER
  // ============================================================

  static bool _parseBool(
      dynamic value,
      ) {
    if (value == null) {
      return false;
    }

    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    final String normalized =
    value.toString().trim().toLowerCase();

    return normalized == 'true' ||
        normalized == '1' ||
        normalized == 'yes' ||
        normalized == 'y';
  }

  // ============================================================
  // INT PARSER
  // ============================================================

  static int? _parseInt(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.round();
    }

    return int.tryParse(
      value.toString().trim(),
    );
  }

  // ============================================================
  // NORMAL DATE/TIME PARSER
  // ============================================================

  static DateTime? _parseDateTime(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    final String raw =
    value.toString().trim();

    if (raw.isEmpty ||
        raw.toLowerCase() == 'null') {
      return null;
    }

    // Unix timestamp support
    final int? numeric =
    int.tryParse(raw);

    if (numeric != null) {
      try {
        // Seconds
        if (numeric < 100000000000) {
          return DateTime
              .fromMillisecondsSinceEpoch(
            numeric * 1000,
            isUtc: true,
          )
              .toLocal();
        }

        // Milliseconds
        return DateTime
            .fromMillisecondsSinceEpoch(
          numeric,
          isUtc: true,
        )
            .toLocal();
      } catch (_) {
        return null;
      }
    }

    final DateTime? parsed =
    DateTime.tryParse(raw);

    if (parsed == null) {
      return null;
    }

    return parsed.isUtc
        ? parsed.toLocal()
        : parsed;
  }

  // ============================================================
  // WHATSAPP TIMESTAMP PARSER
  // ============================================================

  static DateTime? _parseWhatsAppTimestamp(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    final int? seconds =
    int.tryParse(
      value.toString().trim(),
    );

    if (seconds == null) {
      return null;
    }

    try {
      return DateTime
          .fromMillisecondsSinceEpoch(
        seconds * 1000,
        isUtc: true,
      )
          .toLocal();
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // SAFE STRING
  // ============================================================

  static String _safeString(
      dynamic value,
      ) {
    if (value == null) {
      return '';
    }

    final String result =
    value.toString().trim();

    if (result.toLowerCase() == 'null') {
      return '';
    }

    return result;
  }

  // ============================================================
  // NULLABLE STRING
  // ============================================================

  static String? _nullableString(
      dynamic value,
      ) {
    final String result =
    _safeString(value);

    return result.isEmpty
        ? null
        : result;
  }

  // ============================================================
  // FIRST NON EMPTY STRING
  // ============================================================

  static String _firstNonEmptyString(
      List<dynamic> values,
      ) {
    for (final dynamic value in values) {
      final String result =
      _safeString(value);

      if (result.isNotEmpty) {
        return result;
      }
    }

    return '';
  }

  // ============================================================
  // FIRST NULLABLE STRING
  // ============================================================

  static String? _firstNullableString(
      List<dynamic> values,
      ) {
    for (final dynamic value in values) {
      final String result =
      _safeString(value);

      if (result.isNotEmpty) {
        return result;
      }
    }

    return null;
  }

  // ============================================================
  // HAS VALUE
  // ============================================================

  static bool _hasValue(
      String? value,
      ) {
    return value != null &&
        value.trim().isNotEmpty;
  }

  // ============================================================
  // HTTP / HTTPS URL CHECK
  // ============================================================

  static bool _isHttpUrl(
      String value,
      ) {
    final Uri? uri =
    Uri.tryParse(value.trim());

    if (uri == null) {
      return false;
    }

    return uri.scheme == 'http' ||
        uri.scheme == 'https';
  }

  // ============================================================
  // TIME FORMAT
  // ============================================================

  static String _formatTime(
      DateTime dateTime,
      ) {
    final int hour =
    dateTime.hour == 0
        ? 12
        : dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour;

    final String minute =
    dateTime.minute
        .toString()
        .padLeft(2, '0');

    final String period =
    dateTime.hour >= 12
        ? 'PM'
        : 'AM';

    return '$hour:$minute $period';
  }

  // ============================================================
  // DEBUG
  // ============================================================

  @override
  String toString() {
    return 'MessageModel('
        'id: $id, '
        'from: $from, '
        'to: $to, '
        'type: $type, '
        'status: $status, '
        'isMe: $isMe, '
        'audioPath: $audioPath, '
        'audioMediaId: $audioMediaId, '
        'audioDuration: $audioDuration'
        ')';
  }
}