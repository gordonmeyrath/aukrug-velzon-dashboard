// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoticeImpl _$$NoticeImplFromJson(Map<String, dynamic> json) => _$NoticeImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      publishedDate: DateTime.parse(json['publishedDate'] as String),
      validUntil: json['validUntil'] == null
          ? null
          : DateTime.parse(json['validUntil'] as String),
      priority: $enumDecode(_$NoticePriorityEnumMap, json['priority']),
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => NoticeAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$NoticeImplToJson(_$NoticeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'publishedDate': instance.publishedDate.toIso8601String(),
      'validUntil': instance.validUntil?.toIso8601String(),
      'priority': _$NoticePriorityEnumMap[instance.priority]!,
      'category': instance.category,
      'imageUrl': instance.imageUrl,
      'attachments': instance.attachments,
      'tags': instance.tags,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$NoticePriorityEnumMap = {
  NoticePriority.low: 'low',
  NoticePriority.normal: 'normal',
  NoticePriority.high: 'high',
  NoticePriority.urgent: 'urgent',
};

_$NoticeAttachmentImpl _$$NoticeAttachmentImplFromJson(
        Map<String, dynamic> json) =>
    _$NoticeAttachmentImpl(
      name: json['name'] as String,
      url: json['url'] as String,
      type: json['type'] as String,
      size: (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$$NoticeAttachmentImplToJson(
        _$NoticeAttachmentImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'type': instance.type,
      'size': instance.size,
    };
