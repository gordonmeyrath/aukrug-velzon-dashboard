class CommunityUser {
  final String id;
  final String name;
  final String? avatar;
  final String? bio;
  final int followersCount;
  final int followingCount;
  final DateTime joinedAt;

  CommunityUser({
    required this.id,
    required this.name,
    this.avatar,
    this.bio,
    required this.followersCount,
    required this.followingCount,
    required this.joinedAt,
  });

  factory CommunityUser.fromJson(Map<String, dynamic> json) {
    return CommunityUser(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      bio: json['bio'],
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      joinedAt: DateTime.parse(json['joinedAt']),
    );
  }
}

class CommunityGroup {
  final String id;
  final String title;
  final String description;
  final int membersCount;
  final bool isPublic;
  final bool isJoined;

  CommunityGroup({
    required this.id,
    required this.title,
    required this.description,
    required this.membersCount,
    required this.isPublic,
    this.isJoined = false,
  });

  factory CommunityGroup.fromJson(Map<String, dynamic> json) {
    return CommunityGroup(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      membersCount: json['membersCount'] ?? 0,
      isPublic: json['isPublic'] ?? true,
      isJoined: json['isJoined'] ?? false,
    );
  }
}

class CommunityPost {
  final String id;
  final String authorId;
  final String content;
  final List<String> mediaUrls;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final String? authorName;

  CommunityPost({
    required this.id,
    required this.authorId,
    required this.content,
    required this.mediaUrls,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    this.authorName,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'],
      authorId: json['authorId'],
      content: json['content'],
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      authorName: json['authorName'],
    );
  }
}

class CommunityMessage {
  final String id;
  final String content;
  final String senderId;
  final String senderName;
  final String conversationId;
  final DateTime sentAt;
  final DateTime? readAt;

  CommunityMessage({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.conversationId,
    required this.sentAt,
    this.readAt,
  });

  factory CommunityMessage.fromJson(Map<String, dynamic> json) {
    return CommunityMessage(
      id: json['id'],
      content: json['content'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      conversationId: json['conversationId'],
      sentAt: DateTime.parse(json['sentAt']),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
    );
  }
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

class CommunityEvent {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final String location;
  final String organizerId;
  final String organizerName;
  final int attendeesCount;

  CommunityEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.location,
    required this.organizerId,
    required this.organizerName,
    required this.attendeesCount,
  });
}

class MarketplaceListing {
  final String id;
  final String title;
  final String description;
  final double price;
  final String sellerId;
  final String sellerName;
  final String category;
  final String condition;
  final DateTime createdAt;

  MarketplaceListing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.sellerId,
    required this.sellerName,
    required this.category,
    required this.condition,
    required this.createdAt,
  });
}
