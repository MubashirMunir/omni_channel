class NotificationsModel {
  String? sId;
  String? title;
  String? body;
  String? time;
  DateTime? createdAt;

  NotificationsModel({this.sId, this.title, this.body, DateTime? createdAt,this.time})
      : createdAt = createdAt ?? DateTime.now();

  factory NotificationsModel.fromJson(Map<String, dynamic> json) => NotificationsModel(
    sId: json['sId'],
    title: json['title'],
    body: json['body'],
    time: json['time'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'sId': sId,
    'title': title,
    'time': time,
    'body': body,
    'createdAt': createdAt?.toIso8601String(),
  };
}