enum ConversationHandlingStatus {
  unassigned,
  open,
  pending,
  resolved,
}

/// API se aane wali string ko safe enum mein convert karega.
ConversationHandlingStatus parseConversationHandlingStatus(
    dynamic value,
    ) {
  final status = value
      ?.toString()
      .trim()
      .toLowerCase()
      .replaceAll('_', '')
      .replaceAll('-', '')
      .replaceAll(' ', '');

  switch (status) {
  /// Conversation kisi agent ko assigned nahi.
    case 'unassigned':
    case 'new':
    case 'none':
      return ConversationHandlingStatus.unassigned;

  /// Active assigned conversation.
    case 'open':
    case 'assigned':
    case 'active':
    case 'reopened':
    case 'inprogress':
      return ConversationHandlingStatus.open;

  /// Customer ya internal response ka wait.
    case 'pending':
    case 'waiting':
    case 'onhold':
    case 'hold':
      return ConversationHandlingStatus.pending;

  /// Conversation complete/closed.
    case 'resolved':
    case 'closed':
    case 'completed':
    case 'done':
      return ConversationHandlingStatus.resolved;

    default:
      return ConversationHandlingStatus.unassigned;
  }
}

/// UI aur API ke liye useful getters.
extension ConversationHandlingStatusExtension
on ConversationHandlingStatus {
  /// Backend ko bhejne ke liye standard value.
  String get apiValue {
    switch (this) {
      case ConversationHandlingStatus.unassigned:
        return 'unassigned';

      case ConversationHandlingStatus.open:
        return 'open';

      case ConversationHandlingStatus.pending:
        return 'pending';

      case ConversationHandlingStatus.resolved:
        return 'resolved';
    }
  }

  /// UI mein display karne ke liye.
  String get displayName {
    switch (this) {
      case ConversationHandlingStatus.unassigned:
        return 'Unassigned';

      case ConversationHandlingStatus.open:
        return 'Open';

      case ConversationHandlingStatus.pending:
        return 'Pending';

      case ConversationHandlingStatus.resolved:
        return 'Resolved';
    }
  }

  /// Short badge text.
  String get badgeText {
    switch (this) {
      case ConversationHandlingStatus.unassigned:
        return 'Unassigned';

      case ConversationHandlingStatus.open:
        return 'Open';

      case ConversationHandlingStatus.pending:
        return 'Pending';

      case ConversationHandlingStatus.resolved:
        return 'Resolved';
    }
  }

  bool get isUnassigned =>
      this == ConversationHandlingStatus.unassigned;

  bool get isOpen =>
      this == ConversationHandlingStatus.open;

  bool get isPending =>
      this == ConversationHandlingStatus.pending;

  bool get isResolved =>
      this == ConversationHandlingStatus.resolved;

  /// Agent active conversation par reply kar sakta hai.
  bool get canReply {
    return this == ConversationHandlingStatus.open ||
        this == ConversationHandlingStatus.pending;
  }

  /// Conversation resolve ki ja sakti hai.
  bool get canResolve {
    return this == ConversationHandlingStatus.open ||
        this == ConversationHandlingStatus.pending;
  }

  /// Conversation dobara open ki ja sakti hai.
  bool get canReopen =>
      this == ConversationHandlingStatus.resolved;
}