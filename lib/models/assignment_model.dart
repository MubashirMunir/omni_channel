class ConversationAssignmentModel {
  /// Jis agent ko conversation assigned hai.
  final int agentId;

  /// Assigned agent ka display name.
  final String agentName;

  /// Agent ki optional profile image.
  final String? agentProfileImage;

  /// Conversation agent ko kab assign hui.
  final DateTime? assignedAt;

  /// Assignment kis user/admin ne ki.
  final int? assignedByUserId;

  /// Assignment karne wale user ka naam.
  final String? assignedByUserName;

  const ConversationAssignmentModel({
    required this.agentId,
    required this.agentName,
    this.agentProfileImage,
    this.assignedAt,
    this.assignedByUserId,
    this.assignedByUserName,
  });

  /// ==========================================
  /// CREATE MODEL FROM API JSON
  /// ==========================================
  factory ConversationAssignmentModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ConversationAssignmentModel(
      agentId: _parseInt(
        json['agentId'] ??
            json['assignedAgentId'] ??
            json['userId'] ??
            json['id'],
      ),
      agentName: (
          json['agentName'] ??
              json['assignedAgentName'] ??
              json['userName'] ??
              json['name'] ??
              ''
      ).toString().trim(),
      agentProfileImage: _parseNullableString(
        json['agentProfileImage'] ??
            json['profileImage'] ??
            json['profileImageUrl'] ??
            json['avatar'],
      ),
      assignedAt: _parseDateTime(
        json['assignedAt'] ??
            json['assignmentDate'] ??
            json['createdAt'],
      ),
      assignedByUserId: _parseNullableInt(
        json['assignedByUserId'] ??
            json['assignedBy'] ??
            json['createdByUserId'],
      ),
      assignedByUserName: _parseNullableString(
        json['assignedByUserName'] ??
            json['assignedByName'] ??
            json['createdByUserName'],
      ),
    );
  }

  /// ==========================================
  /// CONVERT MODEL TO JSON
  /// ==========================================
  Map<String, dynamic> toJson() {
    return {
      'agentId': agentId,
      'agentName': agentName,
      'agentProfileImage': agentProfileImage,
      'assignedAt': assignedAt?.toIso8601String(),
      'assignedByUserId': assignedByUserId,
      'assignedByUserName': assignedByUserName,
    };
  }

  /// ==========================================
  /// COPY MODEL WITH UPDATED VALUES
  /// ==========================================
  ConversationAssignmentModel copyWith({
    int? agentId,
    String? agentName,
    String? agentProfileImage,
    DateTime? assignedAt,
    int? assignedByUserId,
    String? assignedByUserName,
    bool clearAgentProfileImage = false,
    bool clearAssignedAt = false,
    bool clearAssignedByUserId = false,
    bool clearAssignedByUserName = false,
  }) {
    return ConversationAssignmentModel(
      agentId: agentId ?? this.agentId,
      agentName: agentName ?? this.agentName,
      agentProfileImage: clearAgentProfileImage
          ? null
          : agentProfileImage ?? this.agentProfileImage,
      assignedAt: clearAssignedAt
          ? null
          : assignedAt ?? this.assignedAt,
      assignedByUserId: clearAssignedByUserId
          ? null
          : assignedByUserId ?? this.assignedByUserId,
      assignedByUserName: clearAssignedByUserName
          ? null
          : assignedByUserName ?? this.assignedByUserName,
    );
  }

  /// UI mein safe agent name.
  String get displayName {
    if (agentName.trim().isNotEmpty) {
      return agentName.trim();
    }

    return 'Agent #$agentId';
  }

  /// Agent profile image available hai ya nahi.
  bool get hasProfileImage {
    return agentProfileImage != null &&
        agentProfileImage!.trim().isNotEmpty;
  }

  /// Assignment kis user ne ki uska safe display.
  String get assignedByDisplayName {
    if (assignedByUserName != null &&
        assignedByUserName!.trim().isNotEmpty) {
      return assignedByUserName!.trim();
    }

    if (assignedByUserId != null) {
      return 'User #$assignedByUserId';
    }

    return 'Unknown';
  }

  /// ==========================================
  /// SAFE PARSING HELPERS
  /// ==========================================
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

    return int.tryParse(value.toString()) ?? 0;
  }

  static int? _parseNullableInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString());
  }

  static String? _parseNullableString(dynamic value) {
    if (value == null) {
      return null;
    }

    final result = value.toString().trim();

    if (result.isEmpty ||
        result.toLowerCase() == 'null') {
      return null;
    }

    return result;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    final text = value.toString().trim();

    if (text.isEmpty ||
        text.toLowerCase() == 'null') {
      return null;
    }

    return DateTime.tryParse(text);
  }

  @override
  String toString() {
    return 'ConversationAssignmentModel('
        'agentId: $agentId, '
        'agentName: $agentName, '
        'assignedAt: $assignedAt, '
        'assignedByUserId: $assignedByUserId, '
        'assignedByUserName: $assignedByUserName'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ConversationAssignmentModel &&
        other.agentId == agentId &&
        other.assignedAt == assignedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      agentId,
      assignedAt,
    );
  }
}