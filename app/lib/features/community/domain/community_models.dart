// Community-Modelle

class CommunityUser {
  final String id;
  final String name;
  final String? email;
  final String? avatarUrl;

  CommunityUser({
    required this.id,
    required this.name,
    this.email,
    this.avatarUrl,
  });

  factory CommunityUser.fromJson(Map<String, dynamic> json) {
    return CommunityUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}

class CommunityGroup {
  final String id;
  final String title;
  final String description;
  final int membersCount;
  final bool isJoined;
  final bool isPublic;
  
  CommunityGroup({
    required this.id, 
    required this.title, 
    required this.description, 
    required this.membersCount, 
    this.isJoined = false,
    this.isPublic = true,
  });
  
  factory CommunityGroup.fromJson(Map<String, dynamic> json) {
    return CommunityGroup(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      membersCount: json['membersCount'] as int,
      isJoined: json['isJoined'] as bool? ?? false,
      isPublic: json['isPublic'] as bool? ?? true,
    );
  }
}

class CommunityPost {
  final String id;
  final String content;
  final CommunityUser author;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  
  CommunityPost({
    required this.id,
    required this.content,
    required this.author,
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
  });
  
  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'] as String,
      content: json['content'] as String,
      author: CommunityUser.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      likesCount: json['likesCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }
}

class CommunityEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final List<CommunityUser> attendees;
  
  CommunityEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    this.attendees = const [],
  });
  
  factory CommunityEvent.fromJson(Map<String, dynamic> json) {
    return CommunityEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String,
      attendees: (json['attendees'] as List?)
          ?.map((e) => CommunityUser.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class CommunityConversation {
  final String id;
  final String title;
  final List<CommunityUser> participants;
  final CommunityMessage? lastMessage;
  
  CommunityConversation({
    required this.id,
    required this.title,
    required this.participants,
    this.lastMessage,
  });
  
  factory CommunityConversation.fromJson(Map<String, dynamic> json) {
    return CommunityConversation(
      id: json['id'] as String,
      title: json['title'] as String,
      participants: (json['participants'] as List)
          .map((e) => CommunityUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] != null 
          ? CommunityMessage.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CommunityMessage {
  final String id;
  final String content;
  final CommunityUser sender;
  final DateTime sentAt;
  
  CommunityMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.sentAt,
  });
  
  factory CommunityMessage.fromJson(Map<String, dynamic> json) {
    return CommunityMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      sender: CommunityUser.fromJson(json['sender'] as Map<String, dynamic>),
      sentAt: DateTime.parse(json['sentAt'] as String),
    );
  }
}

class MarketplaceListing {
  final String id;
  final String title;
  final String description;
  final double price;
  final CommunityUser seller;
  final String? imageUrl;
  final DateTime createdAt;
  
  MarketplaceListing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.seller,
    this.imageUrl,
    required this.createdAt,
  });
  
  factory MarketplaceListing.fromJson(Map<String, dynamic> json) {
    return MarketplaceListing(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      seller: CommunityUser.fromJson(json['seller'] as Map<String, dynamic>),
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
