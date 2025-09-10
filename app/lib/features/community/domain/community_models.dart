import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_models.freezed.dart';
part 'community_models.g.dart';

/// Community User Model - für verifizierte Anwohner
@freezed
class CommunityUser with _$CommunityUser {
  const factory CommunityUser({
    required String id,
    required String email,
    required String displayName,
    required String verificationStatus,
    required DateTime registeredAt,
    String? profileImageUrl,
    String? bio,
    String? phoneNumber,
    List<String>? interests,
    Map<String, dynamic>? preferences,
    @Default(true) bool isActive,
    @Default(false) bool isPremium,
  }) = _CommunityUser;

  factory CommunityUser.fromJson(Map<String, dynamic> json) =>
      _$CommunityUserFromJson(json);
}

/// Community Group Model
@freezed
class CommunityGroup with _$CommunityGroup {
  const factory CommunityGroup({
    required String id,
    required String name,
    required String description,
    required String category,
    required String createdBy,
    required DateTime createdAt,
    String? imageUrl,
    List<String>? tags,
    List<String>? members,
    Map<String, dynamic>? settings,
    @Default(0) int memberCount,
    @Default(true) bool isPublic,
    @Default(true) bool isActive,
  }) = _CommunityGroup;

  factory CommunityGroup.fromJson(Map<String, dynamic> json) =>
      _$CommunityGroupFromJson(json);
}

/// Community Post Model
@freezed
class CommunityPost with _$CommunityPost {
  const factory CommunityPost({
    required String id,
    required String authorId,
    required String authorName,
    required String content,
    required String category,
    required DateTime createdAt,
    String? groupId,
    String? imageUrl,
    List<String>? tags,
    List<String>? attachments,
    Map<String, dynamic>? location,
    @Default(0) int likeCount,
    @Default(0) int commentCount,
    @Default(0) int shareCount,
    @Default(false) bool isEdited,
    @Default(false) bool isPinned,
    @Default(true) bool isActive,
  }) = _CommunityPost;

  factory CommunityPost.fromJson(Map<String, dynamic> json) =>
      _$CommunityPostFromJson(json);
}

/// Community Message Model
@freezed
class CommunityMessage with _$CommunityMessage {
  const factory CommunityMessage({
    required String id,
    required String senderId,
    required String senderName,
    required String content,
    required DateTime sentAt,
    String? recipientId,
    String? groupId,
    String? replyToId,
    List<String>? attachments,
    Map<String, dynamic>? metadata,
    @Default('text') String messageType,
    @Default(false) bool isRead,
    @Default(false) bool isDelivered,
    @Default(true) bool isActive,
  }) = _CommunityMessage;

  factory CommunityMessage.fromJson(Map<String, dynamic> json) =>
      _$CommunityMessageFromJson(json);
}

/// Community Event Model
@freezed
class CommunityEvent with _$CommunityEvent {
  const factory CommunityEvent({
    required String id,
    required String title,
    required String description,
    required String organizerId,
    required String organizerName,
    required DateTime startDate,
    required DateTime endDate,
    required String location,
    String? imageUrl,
    List<String>? tags,
    List<String>? attendees,
    Map<String, dynamic>? details,
    @Default('public') String visibility,
    @Default(0) int maxAttendees,
    @Default(0) int currentAttendees,
    @Default(false) bool requiresApproval,
    @Default(true) bool isActive,
  }) = _CommunityEvent;

  factory CommunityEvent.fromJson(Map<String, dynamic> json) =>
      _$CommunityEventFromJson(json);
}

/// Marketplace Listing Model
@freezed
class MarketplaceListing with _$MarketplaceListing {
  const factory MarketplaceListing({
    required String id,
    required String title,
    required String description,
    required String sellerId,
    required String sellerName,
    required double price,
    required String category,
    required String condition,
    required DateTime createdAt,
    List<String>? images,
    List<String>? tags,
    Map<String, dynamic>? specifications,
    String? location,
    String? contactMethod,
    @Default('EUR') String currency,
    @Default('available') String status,
    @Default(false) bool isNegotiable,
    @Default(false) bool isHighlighted,
    @Default(true) bool isActive,
  }) = _MarketplaceListing;

  factory MarketplaceListing.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceListingFromJson(json);
}

/// Community Comment Model
@freezed
class CommunityComment with _$CommunityComment {
  const factory CommunityComment({
    required String id,
    required String postId,
    required String authorId,
    required String authorName,
    required String content,
    required DateTime createdAt,
    String? parentCommentId,
    List<String>? attachments,
    @Default(0) int likeCount,
    @Default(0) int replyCount,
    @Default(false) bool isEdited,
    @Default(true) bool isActive,
  }) = _CommunityComment;

  factory CommunityComment.fromJson(Map<String, dynamic> json) =>
      _$CommunityCommentFromJson(json);
}

/// Notification Model for Community Features
@freezed
class CommunityNotification with _$CommunityNotification {
  const factory CommunityNotification({
    required String id,
    required String userId,
    required String type,
    required String title,
    required String message,
    required DateTime createdAt,
    String? actionUrl,
    String? relatedId,
    Map<String, dynamic>? data,
    @Default('info') String priority,
    @Default(false) bool isRead,
    @Default(true) bool isActive,
  }) = _CommunityNotification;

  factory CommunityNotification.fromJson(Map<String, dynamic> json) =>
      _$CommunityNotificationFromJson(json);
}