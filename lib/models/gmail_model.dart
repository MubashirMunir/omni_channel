class GmailMessageModel {
  final String id;
  final String threadId;

  final String fromName;
  final String fromEmail;
  final String toEmail;

  final String subject;
  final String snippet;
  final String body;
  final String time;

  bool isUnread;
  bool isStarred;
  bool hasAttachment;

  final List<String> labels;

  GmailMessageModel({
    required this.id,
    this.threadId = '',
    required this.fromName,
    required this.fromEmail,
    required this.toEmail,
    required this.subject,
    required this.snippet,
    required this.body,
    required this.time,
    this.isUnread = false,
    this.isStarred = false,
    this.hasAttachment = false,
    this.labels = const [],
  });
}