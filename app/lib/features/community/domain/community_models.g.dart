// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommunityUserImpl _$$CommunityUserImplFromJson(Map<String, dynamic> json) =>
    _$CommunityUserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      verificationStatus: json['verificationStatus'] as String,
      registeredAt: DateTime.parse(json['registeredAt'] as String),
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      preferences: json['preferences'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool? ?? true,
      isPremium: json['isPremium'] as bool? ?? false,
    );

Map<String, dynamic> _$$CommunityUserImplToJson(_$CommunityUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'verificationStatus': instance.verificationStatus,
      'registeredAt': instance.registeredAt.toIso8601String(),
      'profileImageUrl': instance.profileImageUrl,
      'bio': instance.bio,
      'phoneNumber': instance.phoneNumber,
      'interests': instance.interests,
      'preferences': instance.preferences,
      'isActive': instance.isActive,
      'isPremium': instance.isPremium,
    };

_$CommunityGroupImpl _$$CommunityGroupImplFromJson(Map<String, dynamic> json) =>
    _$CommunityGroupImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      imageUrl: json['imageUrl'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      members:
          (json['members'] as List<dynamic>?)?.map((e) => e as String).toList(),
      settings: json['settings'] as Map<String, dynamic>?,
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
      isPublic: json['isPublic'] as bool? ?? true,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$CommunityGroupImplToJson(
        _$CommunityGroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'tags': instance.tags,
      'members': instance.members,
      'settings': instance.settings,
      'memberCount': instance.memberCount,
      'isPublic': instance.isPublic,
      'isActive': instance.isActive,
    };

_$CommunityPostImpl _$$CommunityPostImplFromJson(Map<String, dynamic> json) =>
    _$CommunityPostImpl(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      groupId: json['groupId'] as String?,
      imageUrl: json['imageUrl'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      location: json['location'] as Map<String, dynamic>?,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      shareCount: (json['shareCount'] as num?)?.toInt() ?? 0,
      isEdited: json['isEdited'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$CommunityPostImplToJson(_$CommunityPostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'content': instance.content,
      'category': instance.category,
      'createdAt': instance.createdAt.toIso8601String(),
      'groupId': instance.groupId,
      'imageUrl': instance.imageUrl,
      'tags': instance.tags,
      'attachments': instance.attachments,
      'location': instance.location,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'shareCount': instance.shareCount,
      'isEdited': instance.isEdited,
      'isPinned': instance.isPinned,
      'isActive': instance.isActive,
    };

_$CommunityMessageImpl _$$CommunityMessageImplFromJson(
        Map<String, dynamic> json) =>
    _$CommunityMessageImpl(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      content: json['content'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
      recipientId: json['recipientId'] as String?,
      groupId: json['groupId'] as String?,
      replyToId: json['replyToId'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      messageType: json['messageType'] as String? ?? 'text',
      isRead: json['isRead'] as bool? ?? false,
      isDelivered: json['isDelivered'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$CommunityMessageImplToJson(
        _$CommunityMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'content': instance.content,
      'sentAt': instance.sentAt.toIso8601String(),
      'recipientId': instance.recipientId,
      'groupId': instance.groupId,
      'replyToId': instance.replyToId,
      'attachments': instance.attachments,
      'metadata': instance.metadata,
      'messageType': instance.messageType,
      'isRead': instance.isRead,
      'isDelivered': instance.isDelivered,
      'isActive': instance.isActive,
    };

_$CommunityEventImpl _$$CommunityEventImplFromJson(Map<String, dynamic> json) =>
    _$CommunityEventImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      organizerId: json['organizerId'] as String,
      organizerName: json['organizerName'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      attendees: (json['attendees'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      details: json['details'] as Map<String, dynamic>?,
      visibility: json['visibility'] as String? ?? 'public',
      maxAttendees: (json['maxAttendees'] as num?)?.toInt() ?? 0,
      currentAttendees: (json['currentAttendees'] as num?)?.toInt() ?? 0,
      requiresApproval: json['requiresApproval'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$CommunityEventImplToJson(
        _$CommunityEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'organizerId': instance.organizerId,
      'organizerName': instance.organizerName,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'location': instance.location,
      'imageUrl': instance.imageUrl,
      'tags': instance.tags,
      'attendees': instance.attendees,
      'details': instance.details,
      'visibility': instance.visibility,
      'maxAttendees': instance.maxAttendees,
      'currentAttendees': instance.currentAttendees,
      'requiresApproval': instance.requiresApproval,
      'isActive': instance.isActive,
    };

_$MarketplaceListingImpl _$$MarketplaceListingImplFromJson(
        Map<String, dynamic> json) =>
    _$MarketplaceListingImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      condition: json['condition'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      specifications: json['specifications'] as Map<String, dynamic>?,
      location: json['location'] as String?,
      contactMethod: json['contactMethod'] as String?,
      currency: json['currency'] as String? ?? 'EUR',
      status: json['status'] as String? ?? 'available',
      isNegotiable: json['isNegotiable'] as bool? ?? false,
      isHighlighted: json['isHighlighted'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$MarketplaceListingImplToJson(
        _$MarketplaceListingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'sellerId': instance.sellerId,
      'sellerName': instance.sellerName,
      'price': instance.price,
      'category': instance.category,
      'condition': instance.condition,
      'createdAt': instance.createdAt.toIso8601String(),
      'images': instance.images,
      'tags': instance.tags,
      'specifications': instance.specifications,
      'location': instance.location,
      'contactMethod': instance.contactMethod,
      'currency': instance.currency,
      'status': instance.status,
      'isNegotiable': instance.isNegotiable,
      'isHighlighted': instance.isHighlighted,
      'isActive': instance.isActive,
    };

_$CommunityCommentImpl _$$CommunityCommentImplFromJson(
        Map<String, dynamic> json) =>
    _$CommunityCommentImpl(
      id: json['id'] as String,
      postId: json['postId'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      parentCommentId: json['parentCommentId'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      replyCount: (json['replyCount'] as num?)?.toInt() ?? 0,
      isEdited: json['isEdited'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$CommunityCommentImplToJson(
        _$CommunityCommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'parentCommentId': instance.parentCommentId,
      'attachments': instance.attachments,
      'likeCount': instance.likeCount,
      'replyCount': instance.replyCount,
      'isEdited': instance.isEdited,
      'isActive': instance.isActive,
    };

_$CommunityNotificationImpl _$$CommunityNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$CommunityNotificationImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      actionUrl: json['actionUrl'] as String?,
      relatedId: json['relatedId'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      priority: json['priority'] as String? ?? 'info',
      isRead: json['isRead'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$CommunityNotificationImplToJson(
        _$CommunityNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'createdAt': instance.createdAt.toIso8601String(),
      'actionUrl': instance.actionUrl,
      'relatedId': instance.relatedId,
      'data': instance.data,
      'priority': instance.priority,
      'isRead': instance.isRead,
      'isActive': instance.isActive,
    };
