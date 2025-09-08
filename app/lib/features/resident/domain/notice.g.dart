// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoticeImpl _$$NoticeImplFromJson(Map<String, dynamic> json) => _$NoticeImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: $enumDecode(_$NoticeCategoryEnumMap, json['category']),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      isImportant: json['isImportant'] as bool,
      isPinned: json['isPinned'] as bool? ?? false,
      attachmentUrls: (json['attachmentUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      validUntil: json['validUntil'] == null
          ? null
          : DateTime.parse(json['validUntil'] as String),
      authorName: json['authorName'] as String?,
      departmentName: json['departmentName'] as String?,
    );

Map<String, dynamic> _$$NoticeImplToJson(_$NoticeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'category': _$NoticeCategoryEnumMap[instance.category]!,
      'publishedAt': instance.publishedAt.toIso8601String(),
      'isImportant': instance.isImportant,
      'isPinned': instance.isPinned,
      'attachmentUrls': instance.attachmentUrls,
      'validUntil': instance.validUntil?.toIso8601String(),
      'authorName': instance.authorName,
      'departmentName': instance.departmentName,
    };

const _$NoticeCategoryEnumMap = {
  NoticeCategory.allgemein: 'allgemein',
  NoticeCategory.bauen: 'bauen',
  NoticeCategory.verkehr: 'verkehr',
  NoticeCategory.umwelt: 'umwelt',
  NoticeCategory.kultur: 'kultur',
  NoticeCategory.sport: 'sport',
  NoticeCategory.verwaltung: 'verwaltung',
  NoticeCategory.termine: 'termine',
};
