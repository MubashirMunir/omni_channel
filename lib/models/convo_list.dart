class ConversationModel {
  final String id;
  final String name;
  final String platform;
  final String message;
  final String time;
  final int unread;
  final String profile;
  final bool assigned;
  final DateTime updatedAt;

  ConversationModel({
    required this.id,
    required this.name,
    required this.platform,
    required this.message,
    required this.time,
    required this.unread,
    required this.profile,
    required this.assigned,
    DateTime? updatedAt,}) : updatedAt = updatedAt ?? DateTime.now();

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      platform: json['platform'] ?? '',
      message: json['message'] ?? '',
      time: json['time'] ?? '',
      unread: json['unread'] ?? 0,
      profile: json['profile'] ?? '',
      assigned: json['assigned'] ?? false,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : DateTime.now(),
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
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  ConversationModel copyWith({
    String? id,
    String? name,
    String? platform,
    String? message,
    String? time,
    int? unread,
    String? profile,
    bool? assigned,
    DateTime? updatedAt,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      platform: platform ?? this.platform,
      message: message ?? this.message,
      time: time ?? this.time,
      unread: unread ?? this.unread,
      profile: profile ?? this.profile,
      assigned: assigned ?? this.assigned,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// =======================================
/// DUMMY META CONVERSATIONS
/// =======================================

List<ConversationModel> conversations = [
  ConversationModel(
    id: "1",
    name: "Alisha Ali",
    platform: "WhatsApp",
    message: "Hello, I need help with pricing.",
    time: "10:30 AM",
    unread: 2,
    profile: "https://i.pravatar.cc/150?img=1",
    assigned: true,
    updatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
  ),

  ConversationModel(
    id: "2",
    name: "Sana Khan",
    platform: "WhatsApp",
    message: "Can you share package details?",
    time: "09:15 AM",
    unread: 0,
    profile: "https://i.pravatar.cc/150?img=2",
    assigned: false,
    updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
  ),

  ConversationModel(
    id: "3",
    name: "Mubashir Munir",
    platform: "WhatsApp",
    message: "Can you share package pictures too?",
    time: "09:15 AM",
    unread: 0,
    profile: "https://i.pravatar.cc/150?img=3",
    assigned: false,
    updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
];
List<ConversationModel> messanger = [
  ConversationModel(
    id: "1",
    name: "Alisha Ali",
    platform: "WhatsApp",
    message: "Hello, I need help with pricing.",
    time: "10:30 AM",
    unread: 2,
    profile: "https://i.pravatar.cc/150?img=1",
    assigned: true,
    updatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
  ),

  ConversationModel(
    id: "2",
    name: "Sana Khan",
    platform: "WhatsApp",
    message: "Can you share package details?",
    time: "09:15 AM",
    unread: 0,
    profile: "https://i.pravatar.cc/150?img=2",
    assigned: false,
    updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
  ),

  ConversationModel(
    id: "3",
    name: "Mubashir Munir",
    platform: "WhatsApp",
    message: "Can you share package pictures too?",
    time: "09:15 AM",
    unread: 0,
    profile: "https://i.pravatar.cc/150?img=3",
    assigned: false,
    updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
];