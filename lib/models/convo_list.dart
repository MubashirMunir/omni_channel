class ConversationModel {
  final String id;
  final String name;
  final String platform;
  final String message;
  final String time;
  final int unread;
  final String profile;
  final bool assigned;

  ConversationModel({
    required this.id,
    required this.name,
    required this.platform,
    required this.message,
    required this.time,
    required this.unread,
    required this.profile,
    required this.assigned,
  });

  factory ConversationModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ConversationModel(
      id: json['id'].toString(),

      name: json['name'] ?? '',

      platform: json['platform'] ?? '',

      message: json['message'] ?? '',

      time: json['time'] ?? '',

      unread: json['unread'] ?? 0,

      profile: json['profile'] ?? '',

      assigned: json['assigned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "platform": platform,
      "message": message,
      "time": time,
      "unread": unread,
      "profile": profile,
      "assigned": assigned,
    };
  }
}

/// =======================================
/// DUMMY META CONVERSATIONS
/// =======================================

