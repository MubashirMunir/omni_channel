enum GmailFolder {
  inbox,
  starred,
  snoozed,
  important,
  sent,
  drafts,
  allMail,
  spam,
  trash,
}

enum GmailCategory {
  primary,
  promotions,
  social,
  updates,
}

class GmailMessage {
  final String id;
  final String senderName;
  final String senderEmail;
  final List<String> recipients;
  final String subject;
  final String preview;
  final String body;
  final DateTime receivedAt;
  final GmailFolder folder;
  final GmailCategory category;
  final bool isRead;
  final bool isStarred;
  final bool isImportant;
  final bool hasAttachment;
  final String? attachmentName;
  final String? label;

  const GmailMessage({
    required this.id,
    required this.senderName,
    required this.senderEmail,
    required this.recipients,
    required this.subject,
    required this.preview,
    required this.body,
    required this.receivedAt,
    required this.folder,
    required this.category,
    this.isRead = false,
    this.isStarred = false,
    this.isImportant = false,
    this.hasAttachment = false,
    this.attachmentName,
    this.label,
  });

  GmailMessage copyWith({
    String? id,
    String? senderName,
    String? senderEmail,
    List<String>? recipients,
    String? subject,
    String? preview,
    String? body,
    DateTime? receivedAt,
    GmailFolder? folder,
    GmailCategory? category,
    bool? isRead,
    bool? isStarred,
    bool? isImportant,
    bool? hasAttachment,
    String? attachmentName,
    String? label,
  }) {
    return GmailMessage(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      senderEmail: senderEmail ?? this.senderEmail,
      recipients: recipients ?? this.recipients,
      subject: subject ?? this.subject,
      preview: preview ?? this.preview,
      body: body ?? this.body,
      receivedAt: receivedAt ?? this.receivedAt,
      folder: folder ?? this.folder,
      category: category ?? this.category,
      isRead: isRead ?? this.isRead,
      isStarred: isStarred ?? this.isStarred,
      isImportant: isImportant ?? this.isImportant,
      hasAttachment: hasAttachment ?? this.hasAttachment,
      attachmentName: attachmentName ?? this.attachmentName,
      label: label ?? this.label,
    );
  }
}
