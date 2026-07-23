class AgentModel {
  final int id;
  final String name;
  final String? email;
  final String? profileImage;

  /// Agent system mein active hai ya disabled.
  final bool isActive;

  /// Agent currently online hai ya offline.
  final bool isOnline;

  /// Agent ke paas currently kitni active chats hain.
  final int activeChats;

  const AgentModel({
    required this.id,
    required this.name,
    this.email,
    this.profileImage,
    this.isActive = true,
    this.isOnline = false,
    this.activeChats = 0,
  });

  /// ==========================================
  /// CREATE MODEL FROM API JSON
  /// ==========================================
  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      id: _parseInt(
        json['id'] ??
            json['agentId'] ??
            json['userId'],
      ),
      name: (
          json['name'] ??
              json['agentName'] ??
              json['fullName'] ??
              json['userName'] ??
              ''
      ).toString().trim(),
      email: _parseNullableString(
        json['email'],
      ),
      profileImage: _parseNullableString(
        json['profileImage'] ??
            json['profileImageUrl'] ??
            json['imageUrl'] ??
            json['avatar'],
      ),
      isActive: _parseBool(
        json['isActive'],
        defaultValue: true,
      ),
      isOnline: _parseBool(
        json['isOnline'] ??
            json['online'],
        defaultValue: false,
      ),
      activeChats: _parseInt(
        json['activeChats'] ??
            json['activeChatCount'] ??
            json['assignedChatsCount'],
      ),
    );
  }

  /// ==========================================
  /// CONVERT MODEL TO JSON
  /// ==========================================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'isActive': isActive,
      'isOnline': isOnline,
      'activeChats': activeChats,
    };
  }

  /// ==========================================
  /// COPY MODEL WITH UPDATED VALUES
  /// ==========================================
  AgentModel copyWith({
    int? id,
    String? name,
    String? email,
    String? profileImage,
    bool? isActive,
    bool? isOnline,
    int? activeChats,
    bool clearEmail = false,
    bool clearProfileImage = false,
  }) {
    return AgentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: clearEmail
          ? null
          : email ?? this.email,
      profileImage: clearProfileImage
          ? null
          : profileImage ?? this.profileImage,
      isActive: isActive ?? this.isActive,
      isOnline: isOnline ?? this.isOnline,
      activeChats: activeChats ?? this.activeChats,
    );
  }

  /// Dropdown aur UI mein agent display karne ke liye.
  String get displayName {
    if (name.trim().isNotEmpty) {
      return name.trim();
    }

    if (email != null && email!.trim().isNotEmpty) {
      return email!.trim();
    }

    return 'Agent #$id';
  }

  /// Agent image available hai ya nahi.
  bool get hasProfileImage {
    return profileImage != null &&
        profileImage!.trim().isNotEmpty;
  }

  /// Agent assignment dropdown mein selectable hoga.
  bool get canReceiveChats => isActive;

  /// Agent ke initials, example Ahmed Ali = AA
  String get initials {
    final words = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) {
      return 'A';
    }

    if (words.length == 1) {
      return words.first
          .substring(0, 1)
          .toUpperCase();
    }

    return '${words.first.substring(0, 1)}'
        '${words.last.substring(0, 1)}'
        .toUpperCase();
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

    return int.tryParse(
      value.toString(),
    ) ??
        0;
  }

  static bool _parseBool(
      dynamic value, {
        required bool defaultValue,
      }) {
    if (value == null) {
      return defaultValue;
    }

    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    final normalizedValue =
    value.toString().trim().toLowerCase();

    if (normalizedValue == 'true' ||
        normalizedValue == '1' ||
        normalizedValue == 'yes') {
      return true;
    }

    if (normalizedValue == 'false' ||
        normalizedValue == '0' ||
        normalizedValue == 'no') {
      return false;
    }

    return defaultValue;
  }

  static String? _parseNullableString(
      dynamic value,
      ) {
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

  @override
  String toString() {
    return 'AgentModel('
        'id: $id, '
        'name: $name, '
        'email: $email, '
        'isActive: $isActive, '
        'isOnline: $isOnline, '
        'activeChats: $activeChats'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AgentModel &&
        other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}