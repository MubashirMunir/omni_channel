import 'assignment_model.dart';
import 'conversation_handling_test.dart';

class ConversationModel {
  final String id;
  final String name;
  final String platform;
  final String message;
  final String time;
  final int unread;
  final String profile;

  /// Current conversation assignment.
  ///
  /// Null ka matlab:
  /// conversation kisi agent ko assigned nahi.
  final ConversationAssignmentModel? assignment;

  /// Conversation ka current workflow status.
  final ConversationHandlingStatus handlingStatus;

  /// Conversation resolve hone ki date/time.
  final DateTime? resolvedAt;

  /// Conversation resolve karne wale user ki ID.
  final int? resolvedByUserId;

  /// Conversation resolve karne wale user ka naam.
  final String? resolvedByUserName;

  /// Conversation last update time.
  final DateTime updatedAt;

  ConversationModel({
    required this.id,
    required this.name,
    required this.platform,
    required this.message,
    required this.time,
    required this.unread,
    required this.profile,
    this.assignment,
    ConversationHandlingStatus? handlingStatus,
    this.resolvedAt,
    this.resolvedByUserId,
    this.resolvedByUserName,
    DateTime? updatedAt,
  })  : handlingStatus = handlingStatus ??
      (
          assignment == null
              ? ConversationHandlingStatus.unassigned
              : ConversationHandlingStatus.open
      ),
        updatedAt = updatedAt ?? DateTime.now();

  /// ==========================================================
  /// FROM JSON
  /// ==========================================================

  factory ConversationModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final dynamic rawAssignment =
        json['assignment'] ??
            json['assignedAgent'] ??
            json['assigned_agent'];

    ConversationAssignmentModel? parsedAssignment;

    if (rawAssignment is Map) {
      parsedAssignment =
          ConversationAssignmentModel.fromJson(
            Map<String, dynamic>.from(rawAssignment),
          );
    }

    /// Old API/dummy support:
    /// assigned: true/false
    final bool legacyAssigned = _parseBool(
      json['assigned'],
    );

    final dynamic rawStatus =
        json['handlingStatus'] ??
            json['handling_status'] ??
            json['conversationStatus'] ??
            json['conversation_status'];

    final ConversationHandlingStatus parsedStatus;

    if (rawStatus != null &&
        rawStatus.toString().trim().isNotEmpty) {
      parsedStatus =
          parseConversationHandlingStatus(rawStatus);
    } else if (parsedAssignment != null ||
        legacyAssigned) {
      parsedStatus =
          ConversationHandlingStatus.open;
    } else {
      parsedStatus =
          ConversationHandlingStatus.unassigned;
    }

    return ConversationModel(
      id: _safeString(
        json['id'] ??
            json['conversationId'] ??
            json['conversation_id'],
      ),

      name: _safeString(
        json['name'] ??
            json['customerName'] ??
            json['customer_name'],
      ),

      platform: _safeString(
        json['platform'] ??
            json['channel'] ??
            json['source'],
      ),

      message: _safeString(
        json['message'] ??
            json['lastMessage'] ??
            json['last_message'],
      ),

      time: _safeString(
        json['time'] ??
            json['lastMessageTime'] ??
            json['last_message_time'],
      ),

      unread: _parseInt(
        json['unread'] ??
            json['unreadCount'] ??
            json['unread_count'],
      ),

      profile: _safeString(
        json['profile'] ??
            json['profileImage'] ??
            json['profile_image'] ??
            json['avatar'],
      ),

      assignment: parsedAssignment,

      handlingStatus: parsedStatus,

      resolvedAt: _parseDateTime(
        json['resolvedAt'] ??
            json['resolved_at'],
      ),

      resolvedByUserId: _parseNullableInt(
        json['resolvedByUserId'] ??
            json['resolved_by_user_id'],
      ),

      resolvedByUserName: _nullableString(
        json['resolvedByUserName'] ??
            json['resolved_by_user_name'],
      ),

      updatedAt: _parseDateTime(
        json['updatedAt'] ??
            json['updated_at'],
      ) ??
          DateTime.now(),
    );
  }

  /// ==========================================================
  /// TO JSON
  /// ==========================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'platform': platform,
      'message': message,
      'time': time,
      'unread': unread,
      'profile': profile,

      /// New assignment structure
      'assignment': assignment?.toJson(),

      'handlingStatus':
      handlingStatus.apiValue,

      'resolvedAt':
      resolvedAt?.toIso8601String(),

      'resolvedByUserId':
      resolvedByUserId,

      'resolvedByUserName':
      resolvedByUserName,

      'updatedAt':
      updatedAt.toIso8601String(),

      /// Temporary backward compatibility
      'assigned': isAssigned,
    };
  }

  /// ==========================================================
  /// COPY WITH
  /// ==========================================================

  ConversationModel copyWith({
    String? id,
    String? name,
    String? platform,
    String? message,
    String? time,
    int? unread,
    String? profile,
    ConversationAssignmentModel? assignment,
    ConversationHandlingStatus? handlingStatus,
    DateTime? resolvedAt,
    int? resolvedByUserId,
    String? resolvedByUserName,
    DateTime? updatedAt,

    /// Nullable properties ko explicitly clear karne ke liye.
    bool clearAssignment = false,
    bool clearResolvedAt = false,
    bool clearResolvedByUserId = false,
    bool clearResolvedByUserName = false,
  }) {
    final ConversationAssignmentModel?
    nextAssignment = clearAssignment
        ? null
        : assignment ?? this.assignment;

    final ConversationHandlingStatus nextStatus;

    if (handlingStatus != null) {
      nextStatus = handlingStatus;
    } else if (clearAssignment) {
      nextStatus =
          ConversationHandlingStatus.unassigned;
    } else if (assignment != null &&
        this.handlingStatus ==
            ConversationHandlingStatus.unassigned) {
      nextStatus =
          ConversationHandlingStatus.open;
    } else {
      nextStatus = this.handlingStatus;
    }

    return ConversationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      platform: platform ?? this.platform,
      message: message ?? this.message,
      time: time ?? this.time,
      unread: unread ?? this.unread,
      profile: profile ?? this.profile,

      assignment: nextAssignment,

      handlingStatus: nextStatus,

      resolvedAt: clearResolvedAt
          ? null
          : resolvedAt ?? this.resolvedAt,

      resolvedByUserId:
      clearResolvedByUserId
          ? null
          : resolvedByUserId ??
          this.resolvedByUserId,

      resolvedByUserName:
      clearResolvedByUserName
          ? null
          : resolvedByUserName ??
          this.resolvedByUserName,

      updatedAt:
      updatedAt ?? this.updatedAt,
    );
  }

  /// ==========================================================
  /// ASSIGNMENT GETTERS
  /// ==========================================================

  /// Proper assignment state.
  bool get isAssigned {
    return assignment != null ||
        handlingStatus !=
            ConversationHandlingStatus.unassigned;
  }

  bool get isUnassigned {
    return assignment == null &&
        handlingStatus ==
            ConversationHandlingStatus.unassigned;
  }

  bool get isOpen {
    return handlingStatus ==
        ConversationHandlingStatus.open;
  }

  bool get isPending {
    return handlingStatus ==
        ConversationHandlingStatus.pending;
  }

  bool get isResolved {
    return handlingStatus ==
        ConversationHandlingStatus.resolved;
  }

  /// Existing UI mein agar conversation.assigned use ho raha hai,
  /// to code break nahi hoga.
  bool get assigned => isAssigned;

  int? get assignedAgentId {
    return assignment?.agentId;
  }

  String get assignedAgentName {
    return assignment?.displayName ??
        'Unassigned';
  }

  String? get assignedAgentProfileImage {
    return assignment?.agentProfileImage;
  }

  bool get hasAssignedAgent {
    return assignment != null;
  }

  /// ==========================================================
  /// SAFE PARSERS
  /// ==========================================================

  static String _safeString(dynamic value) {
    if (value == null) {
      return '';
    }

    final String result =
    value.toString().trim();

    if (result.isEmpty ||
        result.toLowerCase() == 'null') {
      return '';
    }

    return result;
  }

  static String? _nullableString(
      dynamic value,
      ) {
    final String result = _safeString(value);

    return result.isEmpty ? null : result;
  }

  static int _parseInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString().trim(),
    ) ??
        0;
  }

  static int? _parseNullableInt(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString().trim(),
    );
  }

  static bool _parseBool(dynamic value) {
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

  static DateTime? _parseDateTime(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    final String raw =
    value.toString().trim();

    if (raw.isEmpty ||
        raw.toLowerCase() == 'null') {
      return null;
    }

    final int? unixValue =
    int.tryParse(raw);

    if (unixValue != null) {
      try {
        if (unixValue <
            100000000000) {
          return DateTime
              .fromMillisecondsSinceEpoch(
            unixValue * 1000,
            isUtc: true,
          )
              .toLocal();
        }

        return DateTime
            .fromMillisecondsSinceEpoch(
          unixValue,
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

  @override
  String toString() {
    return 'ConversationModel('
        'id: $id, '
        'name: $name, '
        'platform: $platform, '
        'unread: $unread, '
        'assignedAgent: $assignedAgentName, '
        'handlingStatus: $handlingStatus, '
        'updatedAt: $updatedAt'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ConversationModel &&
        other.id == id;
  }

  @override
  int get hashCode => id.hashCode;



}
final List<ConversationModel> mockConversations = [
  ConversationModel(
    id: '1',
    name: 'Alisha Ali',
    platform: 'WhatsApp',
    message: 'Hello, I need help with pricing.',
    time: '10:30 AM',
    unread: 2,
    profile: 'https://i.pravatar.cc/150?img=1',
    assignment: ConversationAssignmentModel(
      agentId: 1,
      agentName: 'Ahmed Ali',
      assignedAt: DateTime.now().subtract(
        const Duration(minutes: 20),
      ),
      assignedByUserId: 100,
      assignedByUserName: 'Admin',
    ),
    handlingStatus: ConversationHandlingStatus.open,
    updatedAt: DateTime.now().subtract(
      const Duration(minutes: 10),
    ),
  ),

  ConversationModel(
    id: '2',
    name: 'Sana Khan',
    platform: 'WhatsApp',
    message: 'Can you share package details?',
    time: '09:15 AM',
    unread: 0,
    profile: 'https://i.pravatar.cc/150?img=2',
    handlingStatus: ConversationHandlingStatus.unassigned,
    updatedAt: DateTime.now().subtract(
      const Duration(hours: 1),
    ),
  ),

  ConversationModel(
    id: '3',
    name: 'Mubashir Munir',
    platform: 'Instagram',
    message: 'Can you share package pictures too?',
    time: '09:00 AM',
    unread: 1,
    profile: 'https://i.pravatar.cc/150?img=3',
    handlingStatus: ConversationHandlingStatus.unassigned,
    updatedAt: DateTime.now().subtract(
      const Duration(hours: 2),
    ),
  ),
];