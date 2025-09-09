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
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final String? groupId;
  final List<String> attachments;
  final int likesCount;
  final int commentsCount;

  CommunityPost({
    required this.id,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    this.groupId,
    this.attachments = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'] as String,
      content: json['content'] as String,
      authorId: json['author_id'] as String,
      authorName: json['author_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      groupId: json['group_id'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)?.cast<String>() ?? [],
      likesCount: json['likes_count'] as int? ?? 0,
      commentsCount: json['comments_count'] as int? ?? 0,
    );
  }
}

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

  factory CommunityMessage.fromJson(Map<String, dynamic> json) {
    return CommunityMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String,
      conversationId: json['conversation_id'] as String,
      sentAt: DateTime.parse(json['sent_at'] as String),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null,
      attachments: (json['attachments'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
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
    GroupSettings? settings,
    GroupStatistics? statistics,
    GroupLocation? location,
    @void Default([]) List<GroupRule> rules,
    @void Default([]) List<GroupEvent> upcomingEvents,
  }) = _CommunityGroup;

  void CommunityGroup.fromJson(Map<String, dynamic> json) =>
      _$CommunityGroupFromJson(json);
}

/// Group categories for better organization
enum GroupCategory {
  @JsonValue('neighborhood')
  neighborhood,
  @JsonValue('interests')
  interests,
  @JsonValue('sports')
  sports,
  @JsonValue('culture')
  culture,
  @JsonValue('business')
  business,
  @JsonValue('education')
  education,
  @JsonValue('volunteer')
  volunteer,
  @JsonValue('emergency')
  emergency,
  @JsonValue('events')
  events,
  @JsonValue('marketplace')
  marketplace,
  @JsonValue('parents')
  parents,
  @JsonValue('seniors')
  seniors,
  @JsonValue('youth')
  youth,
  @JsonValue('pets')
  pets,
  @JsonValue('garden')
  garden,
  @JsonValue('other')
  other;

  String get displayName {
    switch (this) {
      case GroupCategory.neighborhood:
        return 'Nachbarschaft';
      case GroupCategory.interests:
        return 'Interessensgruppen';
      case GroupCategory.sports:
        return 'Sport & Fitness';
      case GroupCategory.culture:
        return 'Kultur & Kunst';
      case GroupCategory.business:
        return 'Gewerbe & Business';
      case GroupCategory.education:
        return 'Bildung & Lernen';
      case GroupCategory.volunteer:
        return 'Ehrenamt';
      case GroupCategory.emergency:
        return 'Notfälle & Hilfe';
      case GroupCategory.events:
        return 'Veranstaltungen';
      case GroupCategory.marketplace:
        return 'Marktplatz';
      case GroupCategory.parents:
        return 'Eltern & Familie';
      case GroupCategory.seniors:
        return 'Senioren';
      case GroupCategory.youth:
        return 'Jugend';
      case GroupCategory.pets:
        return 'Haustiere';
      case GroupCategory.garden:
        return 'Garten & Natur';
      case GroupCategory.other:
        return 'Sonstiges';
    }
  }

  String get icon {
    switch (this) {
      case GroupCategory.neighborhood:
        return '🏘️';
      case GroupCategory.interests:
        return '💭';
      case GroupCategory.sports:
        return '⚽';
      case GroupCategory.culture:
        return '🎭';
      case GroupCategory.business:
        return '💼';
      case GroupCategory.education:
        return '📚';
      case GroupCategory.volunteer:
        return '🤝';
      case GroupCategory.emergency:
        return '🚨';
      case GroupCategory.events:
        return '🎉';
      case GroupCategory.marketplace:
        return '🛒';
      case GroupCategory.parents:
        return '👨‍👩‍👧‍👦';
      case GroupCategory.seniors:
        return '👴';
      case GroupCategory.youth:
        return '👶';
      case GroupCategory.pets:
        return '🐕';
      case GroupCategory.garden:
        return '🌱';
      case GroupCategory.other:
        return '📁';
    }
  }
}

/// Group types for different access levels
enum GroupType {
  @JsonValue('public')
  public,
  @JsonValue('private')
  private,
  @JsonValue('secret')
  secret,
  @JsonValue('official')
  official;

  String get displayName {
    switch (this) {
      case GroupType.public:
        return 'Öffentlich';
      case GroupType.private:
        return 'Privat';
      case GroupType.secret:
        return 'Geheim';
      case GroupType.official:
        return 'Offiziell';
    }
  }
}

/// Group settings for customization
@freezed
class GroupSettings with _$GroupSettings {
  const factory GroupSettings({
    @Default(true) bool allowPosts,
    @Default(true) bool allowEvents,
    @Default(true) bool allowPolls,
    @Default(true) bool allowMarketplace,
    @Default(false) bool moderateNewMembers,
    @Default(false) bool moderatePosts,
    @Default(24) int autoDeletePostsAfterHours,
    @Default([]) List<String> bannedWords,
    @Default(100) int maxMembersCount,
    @Default(true) bool enableNotifications,
    @Default(true) bool enableChat,
    @Default(false) bool enableVideoChat,
    @Default(true) bool showMemberList,
    @Default(false) bool allowAnonymousPosts,
  }) = _GroupSettings;

  factory GroupSettings.fromJson(Map<String, dynamic> json) =>
      _$GroupSettingsFromJson(json);
}

/// Group statistics for insights
@freezed
class GroupStatistics with _$GroupStatistics {
  const factory GroupStatistics({
    @Default(0) int totalPosts,
    @Default(0) int totalComments,
    @Default(0) int totalEvents,
    @Default(0) int totalPolls,
    @Default(0) int activeMembers,
    @Default(0) int newMembersThisWeek,
    @Default(0) int engagementScore,
    DateTime? lastActivityAt,
    @Default({}) Map<String, int> weeklyStats,
    @Default({}) Map<String, int> monthlyStats,
  }) = _GroupStatistics;

  factory GroupStatistics.fromJson(Map<String, dynamic> json) =>
      _$GroupStatisticsFromJson(json);
}

/// Group location for local communities
@freezed
class GroupLocation with _$GroupLocation {
  const factory GroupLocation({
    required double latitude,
    required double longitude,
    String? address,
    String? neighborhood,
    String? city,
    String? state,
    String? country,
    @Default(1000) double radiusInMeters,
    @Default(false) bool showExactLocation,
  }) = _GroupLocation;

  factory GroupLocation.fromJson(Map<String, dynamic> json) =>
      _$GroupLocationFromJson(json);
}

/// Group rules for governance
@freezed
class GroupRule with _$GroupRule {
  const factory GroupRule({
    required String id,
    required String title,
    required String description,
    @Default(false) bool isEnforced,
    @Default(0) int violationCount,
    DateTime? createdAt,
  }) = _GroupRule;

  factory GroupRule.fromJson(Map<String, dynamic> json) =>
      _$GroupRuleFromJson(json);
}

/// Enhanced Community Post
@freezed
class CommunityPost with _$CommunityPost {
  const factory CommunityPost({
    required String id,
    required String groupId,
    required String authorId,
    required String authorName,
    required String content,
    required PostType type,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? scheduledAt,
    @Default([]) List<String> imageUrls,
    @Default([]) List<String> videoUrls,
    @Default([]) List<String> documentUrls,
    @Default([]) List<PostReaction> reactions,
    @Default([]) List<String> commentIds,
    @Default([]) List<String> tags,
    @Default([]) List<String> mentions,
    @Default(false) bool isPinned,
    @Default(false) bool isAnonymous,
    @Default(false) bool isModerated,
    @Default(false) bool isReported,
    @Default(true) bool isActive,
    PostPoll? poll,
    PostEvent? event,
    PostMarketplace? marketplace,
    PostLocation? location,
    PostMetadata? metadata,
  }) = _CommunityPost;

  factory CommunityPost.fromJson(Map<String, dynamic> json) =>
      _$CommunityPostFromJson(json);
}

/// Post types for different content
enum PostType {
  @JsonValue('text')
  text,
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
  @JsonValue('poll')
  poll,
  @JsonValue('event')
  event,
  @JsonValue('marketplace')
  marketplace,
  @JsonValue('announcement')
  announcement,
  @JsonValue('question')
  question,
  @JsonValue('recommendation')
  recommendation,
  @JsonValue('emergency')
  emergency,
  @JsonValue('volunteer')
  volunteer;

  String get displayName {
    switch (this) {
      case PostType.text:
        return 'Text';
      case PostType.image:
        return 'Foto';
      case PostType.video:
        return 'Video';
      case PostType.poll:
        return 'Umfrage';
      case PostType.event:
        return 'Veranstaltung';
      case PostType.marketplace:
        return 'Marktplatz';
      case PostType.announcement:
        return 'Ankündigung';
      case PostType.question:
        return 'Frage';
      case PostType.recommendation:
        return 'Empfehlung';
      case PostType.emergency:
        return 'Notfall';
      case PostType.volunteer:
        return 'Ehrenamt';
    }
  }

  String get icon {
    switch (this) {
      case PostType.text:
        return '📝';
      case PostType.image:
        return '📷';
      case PostType.video:
        return '🎥';
      case PostType.poll:
        return '📊';
      case PostType.event:
        return '📅';
      case PostType.marketplace:
        return '🛍️';
      case PostType.announcement:
        return '📢';
      case PostType.question:
        return '❓';
      case PostType.recommendation:
        return '⭐';
      case PostType.emergency:
        return '🚨';
      case PostType.volunteer:
        return '🤝';
    }
  }
}

/// Post reactions for engagement
@freezed
class PostReaction with _$PostReaction {
  const factory PostReaction({
    required String userId,
    required String userName,
    required ReactionType type,
    required DateTime createdAt,
  }) = _PostReaction;

  factory PostReaction.fromJson(Map<String, dynamic> json) =>
      _$PostReactionFromJson(json);
}

/// Reaction types
enum ReactionType {
  @JsonValue('like')
  like,
  @JsonValue('love')
  love,
  @JsonValue('laugh')
  laugh,
  @JsonValue('surprise')
  surprise,
  @JsonValue('sad')
  sad,
  @JsonValue('angry')
  angry,
  @JsonValue('helpful')
  helpful,
  @JsonValue('support')
  support;

  String get emoji {
    switch (this) {
      case ReactionType.like:
        return '👍';
      case ReactionType.love:
        return '❤️';
      case ReactionType.laugh:
        return '😂';
      case ReactionType.surprise:
        return '😮';
      case ReactionType.sad:
        return '😢';
      case ReactionType.angry:
        return '😠';
      case ReactionType.helpful:
        return '💡';
      case ReactionType.support:
        return '🤝';
    }
  }
}

/// Poll functionality
@freezed
class PostPoll with _$PostPoll {
  const factory PostPoll({
    required String question,
    required List<PollOption> options,
    required DateTime endsAt,
    @Default(false) bool allowMultipleChoices,
    @Default(false) bool showResults,
    @Default(false) bool isAnonymous,
    @Default(0) int totalVotes,
  }) = _PostPoll;

  factory PostPoll.fromJson(Map<String, dynamic> json) =>
      _$PostPollFromJson(json);
}

/// Poll options
@freezed
class PollOption with _$PollOption {
  const factory PollOption({
    required String id,
    required String text,
    @Default(0) int votes,
    @Default([]) List<String> voters,
  }) = _PollOption;

  factory PollOption.fromJson(Map<String, dynamic> json) =>
      _$PollOptionFromJson(json);
}

/// Event within posts
@freezed
class PostEvent with _$PostEvent {
  const factory PostEvent({
    required String title,
    required DateTime startTime,
    DateTime? endTime,
    String? location,
    double? latitude,
    double? longitude,
    String? description,
    @Default(0) int maxAttendees,
    @Default([]) List<String> attendeeIds,
    @Default([]) List<String> interestedIds,
    @Default(false) bool requiresApproval,
    @Default(true) bool isPublic,
    double? price,
    String? currency,
    String? registrationUrl,
  }) = _PostEvent;

  factory PostEvent.fromJson(Map<String, dynamic> json) =>
      _$PostEventFromJson(json);
}

/// Marketplace functionality
@freezed
class PostMarketplace with _$PostMarketplace {
  const factory PostMarketplace({
    required String title,
    required String description,
    required double price,
    required String currency,
    required MarketplaceCategory category,
    required MarketplaceCondition condition,
    @Default([]) List<String> imageUrls,
    String? location,
    double? latitude,
    double? longitude,
    @Default(true) bool isAvailable,
    @Default(false) bool isNegotiable,
    @Default(false) bool allowsDelivery,
    DateTime? availableUntil,
    @Default([]) List<String> interestedUserIds,
  }) = _PostMarketplace;

  factory PostMarketplace.fromJson(Map<String, dynamic> json) =>
      _$PostMarketplaceFromJson(json);
}

/// Marketplace categories
enum MarketplaceCategory {
  @JsonValue('electronics')
  electronics,
  @JsonValue('furniture')
  furniture,
  @JsonValue('clothing')
  clothing,
  @JsonValue('books')
  books,
  @JsonValue('sports')
  sports,
  @JsonValue('tools')
  tools,
  @JsonValue('garden')
  garden,
  @JsonValue('vehicles')
  vehicles,
  @JsonValue('services')
  services,
  @JsonValue('food')
  food,
  @JsonValue('other')
  other;

  String get displayName {
    switch (this) {
      case MarketplaceCategory.electronics:
        return 'Elektronik';
      case MarketplaceCategory.furniture:
        return 'Möbel';
      case MarketplaceCategory.clothing:
        return 'Kleidung';
      case MarketplaceCategory.books:
        return 'Bücher';
      case MarketplaceCategory.sports:
        return 'Sport';
      case MarketplaceCategory.tools:
        return 'Werkzeuge';
      case MarketplaceCategory.garden:
        return 'Garten';
      case MarketplaceCategory.vehicles:
        return 'Fahrzeuge';
      case MarketplaceCategory.services:
        return 'Dienstleistungen';
      case MarketplaceCategory.food:
        return 'Lebensmittel';
      case MarketplaceCategory.other:
        return 'Sonstiges';
    }
  }
}

/// Item condition
enum MarketplaceCondition {
  @JsonValue('new')
  newItem,
  @JsonValue('like_new')
  likeNew,
  @JsonValue('good')
  good,
  @JsonValue('fair')
  fair,
  @JsonValue('poor')
  poor;

  String get displayName {
    switch (this) {
      case MarketplaceCondition.newItem:
        return 'Neu';
      case MarketplaceCondition.likeNew:
        return 'Wie neu';
      case MarketplaceCondition.good:
        return 'Gut';
      case MarketplaceCondition.fair:
        return 'Ordentlich';
      case MarketplaceCondition.poor:
        return 'Schlecht';
    }
  }
}

/// Post location
@freezed
class PostLocation with _$PostLocation {
  const factory PostLocation({
    required double latitude,
    required double longitude,
    String? address,
    String? name,
    @Default(false) bool showExactLocation,
  }) = _PostLocation;

  factory PostLocation.fromJson(Map<String, dynamic> json) =>
      _$PostLocationFromJson(json);
}

/// Post metadata for analytics
@freezed
class PostMetadata with _$PostMetadata {
  const factory PostMetadata({
    @Default(0) int views,
    @Default(0) int shares,
    @Default(0) int saves,
    @Default(0) int reports,
    @Default({}) Map<String, dynamic> analytics,
    @Default([]) List<String> hashtags,
    String? sourceApp,
    String? sourceVersion,
  }) = _PostMetadata;

  factory PostMetadata.fromJson(Map<String, dynamic> json) =>
      _$PostMetadataFromJson(json);
}

/// Enhanced Group Event
@freezed
class GroupEvent with _$GroupEvent {
  const factory GroupEvent({
    required String id,
    required String groupId,
    required String organizerId,
    required String title,
    required String description,
    required DateTime startTime,
    DateTime? endTime,
    required EventType type,
    required EventLocation location,
    @Default([]) List<String> attendeeIds,
    @Default([]) List<String> interestedIds,
    @Default([]) List<String> maybeIds,
    @Default([]) List<String> imageUrls,
    @Default(0) int maxAttendees,
    @Default(false) bool requiresApproval,
    @Default(true) bool isPublic,
    @Default(false) bool isRecurring,
    double? price,
    String? currency,
    String? registrationUrl,
    EventRecurrence? recurrence,
    EventReminder? reminder,
    @Default({}) Map<String, dynamic> customFields,
  }) = _GroupEvent;

  factory GroupEvent.fromJson(Map<String, dynamic> json) =>
      _$GroupEventFromJson(json);
}

/// Event types
enum EventType {
  @JsonValue('meeting')
  meeting,
  @JsonValue('social')
  social,
  @JsonValue('sports')
  sports,
  @JsonValue('educational')
  educational,
  @JsonValue('volunteer')
  volunteer,
  @JsonValue('cultural')
  cultural,
  @JsonValue('business')
  business,
  @JsonValue('emergency')
  emergency,
  @JsonValue('other')
  other;

  String get displayName {
    switch (this) {
      case EventType.meeting:
        return 'Treffen';
      case EventType.social:
        return 'Sozial';
      case EventType.sports:
        return 'Sport';
      case EventType.educational:
        return 'Bildung';
      case EventType.volunteer:
        return 'Ehrenamt';
      case EventType.cultural:
        return 'Kultur';
      case EventType.business:
        return 'Business';
      case EventType.emergency:
        return 'Notfall';
      case EventType.other:
        return 'Sonstiges';
    }
  }
}

/// Event location
@freezed
class EventLocation with _$EventLocation {
  const factory EventLocation({
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    @Default(false) bool isOnline,
    String? onlineUrl,
    String? onlinePlatform,
    String? accessCode,
  }) = _EventLocation;

  factory EventLocation.fromJson(Map<String, dynamic> json) =>
      _$EventLocationFromJson(json);
}

/// Event recurrence
@freezed
class EventRecurrence with _$EventRecurrence {
  const factory EventRecurrence({
    required RecurrenceType type,
    @Default(1) int interval,
    DateTime? endDate,
    @Default([]) List<int> daysOfWeek,
    @Default([]) List<int> daysOfMonth,
    @Default([]) List<int> monthsOfYear,
  }) = _EventRecurrence;

  factory EventRecurrence.fromJson(Map<String, dynamic> json) =>
      _$EventRecurrenceFromJson(json);
}

/// Recurrence types
enum RecurrenceType {
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
  @JsonValue('yearly')
  yearly,
}

/// Event reminders
@freezed
class EventReminder with _$EventReminder {
  const factory EventReminder({
    @Default(true) bool enabled,
    @Default([15, 60, 1440]) List<int> minutesBefore,
    @Default(true) bool pushNotification,
    @Default(true) bool emailNotification,
    @Default(false) bool smsNotification,
  }) = _EventReminder;

  factory EventReminder.fromJson(Map<String, dynamic> json) =>
      _$EventReminderFromJson(json);
}

/// Enhanced Community Message
@freezed
class CommunityMessage with _$CommunityMessage {
  const factory CommunityMessage({
    required String id,
    required String senderId,
    required String senderName,
    required String content,
    required MessageType type,
    required DateTime sentAt,
    String? chatId,
    String? groupId,
    String? recipientId,
    @Default([]) List<String> imageUrls,
    @Default([]) List<String> videoUrls,
    @Default([]) List<String> audioUrls,
    @Default([]) List<String> documentUrls,
    @Default([]) List<MessageReaction> reactions,
    String? replyToMessageId,
    @Default(false) bool isEdited,
    @Default(false) bool isDeleted,
    @Default(false) bool isSystem,
    @Default([]) List<String> readBy,
    DateTime? editedAt,
    DateTime? deletedAt,
    MessageLocation? location,
    MessageMetadata? metadata,
  }) = _CommunityMessage;

  factory CommunityMessage.fromJson(Map<String, dynamic> json) =>
      _$CommunityMessageFromJson(json);
}

/// Message types
enum MessageType {
  @JsonValue('text')
  text,
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
  @JsonValue('audio')
  audio,
  @JsonValue('document')
  document,
  @JsonValue('location')
  location,
  @JsonValue('system')
  system,
  @JsonValue('announcement')
  announcement,
}

/// Message reactions
@freezed
class MessageReaction with _$MessageReaction {
  const factory MessageReaction({
    required String userId,
    required String emoji,
    required DateTime createdAt,
  }) = _MessageReaction;

  factory MessageReaction.fromJson(Map<String, dynamic> json) =>
      _$MessageReactionFromJson(json);
}

/// Message location
@freezed
class MessageLocation with _$MessageLocation {
  const factory MessageLocation({
    required double latitude,
    required double longitude,
    String? address,
    String? name,
  }) = _MessageLocation;

  factory MessageLocation.fromJson(Map<String, dynamic> json) =>
      _$MessageLocationFromJson(json);
}

/// Message metadata
@freezed
class MessageMetadata with _$MessageMetadata {
  const factory MessageMetadata({
    String? deviceInfo,
    String? appVersion,
    @Default({}) Map<String, dynamic> customData,
  }) = _MessageMetadata;

  factory MessageMetadata.fromJson(Map<String, dynamic> json) =>
      _$MessageMetadataFromJson(json);
}

/// Community User Profile
@freezed
class CommunityUser with _$CommunityUser {
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
  newcomer,
  @JsonValue('veteran')
  veteran,
  @JsonValue('popular')
  popular,
  @JsonValue('expert')
  expert,
  @JsonValue('moderator')
  moderator,
}

/// User settings
@freezed
class UserSettings with _$UserSettings {
  const factory UserSettings({
    @Default(true) bool allowDirectMessages,
    @Default(true) bool allowGroupInvitations,
    @Default(true) bool allowEventInvitations,
    @Default(true) bool showOnlineStatus,
    @Default(true) bool showLastSeen,
    @Default(true) bool allowLocationSharing,
    @Default(NotificationSettings()) NotificationSettings notifications,
    @Default(PrivacySettings()) PrivacySettings privacy,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}

/// Notification settings
@freezed
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    @Default(true) bool pushEnabled,
    @Default(true) bool emailEnabled,
    @Default(false) bool smsEnabled,
    @Default(true) bool groupMessages,
    @Default(true) bool directMessages,
    @Default(true) bool eventReminders,
    @Default(true) bool groupInvitations,
    @Default(true) bool newPosts,
    @Default(true) bool reactions,
    @Default(true) bool mentions,
    @Default(false) bool marketing,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}

/// Privacy settings
@freezed
class PrivacySettings with _$PrivacySettings {
  const factory PrivacySettings({
    @Default(ProfileVisibility.public) ProfileVisibility profileVisibility,
    @Default(true) bool showRealName,
    @Default(true) bool showLocation,
    @Default(true) bool showGroups,
    @Default(true) bool showBadges,
    @Default(false) bool allowDataExport,
    @Default(false) bool allowDataSharing,
  }) = _PrivacySettings;

  factory PrivacySettings.fromJson(Map<String, dynamic> json) =>
      _$PrivacySettingsFromJson(json);
}

/// Profile visibility
enum ProfileVisibility {
  @JsonValue('public')
  public,
  @JsonValue('friends')
  friends,
  @JsonValue('private')
  private,
}

/// User statistics
@freezed
class UserStatistics with _$UserStatistics {
  const factory UserStatistics({
    @Default(0) int totalPosts,
    @Default(0) int totalComments,
    @Default(0) int totalReactions,
    @Default(0) int totalEventsOrganized,
    @Default(0) int totalEventsAttended,
    @Default(0) int helpfulVotes,
    @Default(0) int reportsMade,
    @Default(0) int loginStreak,
    @Default({}) Map<String, int> weeklyActivity,
    @Default({}) Map<String, int> monthlyActivity,
  }) = _UserStatistics;

  factory UserStatistics.fromJson(Map<String, dynamic> json) =>
      _$UserStatisticsFromJson(json);
}
