// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DocumentImpl _$$DocumentImplFromJson(Map<String, dynamic> json) =>
    _$DocumentImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      category: $enumDecode(_$DocumentCategoryEnumMap, json['category']),
      fileUrl: json['fileUrl'] as String,
      fileName: json['fileName'] as String,
      fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
      fileType: json['fileType'] as String?,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      requiresAuthentication: json['requiresAuthentication'] as bool? ?? false,
      isPopular: json['isPopular'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$DocumentImplToJson(_$DocumentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': _$DocumentCategoryEnumMap[instance.category]!,
      'fileUrl': instance.fileUrl,
      'fileName': instance.fileName,
      'fileSizeBytes': instance.fileSizeBytes,
      'fileType': instance.fileType,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'tags': instance.tags,
      'requiresAuthentication': instance.requiresAuthentication,
      'isPopular': instance.isPopular,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$DocumentCategoryEnumMap = {
  DocumentCategory.applications: 'applications',
  DocumentCategory.permits: 'permits',
  DocumentCategory.taxes: 'taxes',
  DocumentCategory.socialServices: 'social_services',
  DocumentCategory.civilRegistry: 'civil_registry',
  DocumentCategory.planning: 'planning',
  DocumentCategory.announcements: 'announcements',
  DocumentCategory.regulations: 'regulations',
  DocumentCategory.emergency: 'emergency',
  DocumentCategory.other: 'other',
};
