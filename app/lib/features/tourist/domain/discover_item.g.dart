// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiscoverItemImpl _$$DiscoverItemImplFromJson(Map<String, dynamic> json) =>
    _$DiscoverItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      category: $enumDecode(_$DiscoverCategoryEnumMap, json['category']),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      isFeatured: json['isFeatured'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      openingHours: json['openingHours'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$$DiscoverItemImplToJson(_$DiscoverItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'category': _$DiscoverCategoryEnumMap[instance.category]!,
      'lat': instance.lat,
      'lng': instance.lng,
      'isFeatured': instance.isFeatured,
      'rating': instance.rating,
      'tags': instance.tags,
      'openingHours': instance.openingHours,
      'websiteUrl': instance.websiteUrl,
      'phoneNumber': instance.phoneNumber,
    };

const _$DiscoverCategoryEnumMap = {
  DiscoverCategory.sehenswuerdigkeit: 'sehenswuerdigkeit',
  DiscoverCategory.gastronomie: 'gastronomie',
  DiscoverCategory.unterkunft: 'unterkunft',
  DiscoverCategory.aktivitaet: 'aktivitaet',
  DiscoverCategory.kultur: 'kultur',
  DiscoverCategory.natur: 'natur',
  DiscoverCategory.shopping: 'shopping',
};
