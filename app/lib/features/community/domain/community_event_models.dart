class CommunityEvent {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String? location;
  final String organizerId;
  final int attendeeCount;

  CommunityEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.location,
    required this.organizerId,
    required this.attendeeCount,
  });
}

class CommunityConversation {
  final String id;
  final String title;
  final List<String> participantIds;
  final CommunityMessage? lastMessage;
  final DateTime updatedAt;
  final int unreadCount;

  CommunityConversation({
    required this.id,
    required this.title,
    required this.participantIds,
    this.lastMessage,
    required this.updatedAt,
    required this.unreadCount,
  });
}

class CommunityMessage {
  final String id;
  final String content;
  final String senderId;
  final String senderName;
  final String conversationId;
  final DateTime sentAt;
  final DateTime? readAt;
  final List<String> attachments;

  CommunityMessage({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.conversationId,
    required this.sentAt,
    this.readAt,
    this.attachments = const [],
  });
}
