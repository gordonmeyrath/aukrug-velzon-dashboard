// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RouteItemImpl _$$RouteItemImplFromJson(Map<String, dynamic> json) =>
    _$RouteItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      distance: (json['distance'] as num).toDouble(),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      difficulty: $enumDecode(_$RouteDifficultyEnumMap, json['difficulty']),
      waypoints: (json['waypoints'] as List<dynamic>)
          .map((e) => RoutePoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: $enumDecode(_$RouteTypeEnumMap, json['type']),
      highlights: (json['highlights'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      downloadUrl: json['downloadUrl'] as String?,
      elevationProfile: json['elevationProfile'] as String?,
    );

Map<String, dynamic> _$$RouteItemImplToJson(_$RouteItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'distance': instance.distance,
      'duration': instance.duration.inMicroseconds,
      'difficulty': _$RouteDifficultyEnumMap[instance.difficulty]!,
      'waypoints': instance.waypoints,
      'type': _$RouteTypeEnumMap[instance.type]!,
      'highlights': instance.highlights,
      'imageUrls': instance.imageUrls,
      'downloadUrl': instance.downloadUrl,
      'elevationProfile': instance.elevationProfile,
    };

const _$RouteDifficultyEnumMap = {
  RouteDifficulty.leicht: 'leicht',
  RouteDifficulty.mittel: 'mittel',
  RouteDifficulty.schwer: 'schwer',
};

const _$RouteTypeEnumMap = {
  RouteType.wandern: 'wandern',
  RouteType.radfahren: 'radfahren',
  RouteType.laufen: 'laufen',
  RouteType.nordic_walking: 'nordic_walking',
};

_$RoutePointImpl _$$RoutePointImplFromJson(Map<String, dynamic> json) =>
    _$RoutePointImpl(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$RoutePointImplToJson(_$RoutePointImpl instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'name': instance.name,
      'description': instance.description,
    };
