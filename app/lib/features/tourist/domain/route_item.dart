import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_item.freezed.dart';
part 'route_item.g.dart';

@freezed
class RouteItem with _$RouteItem {
  const factory RouteItem({
    required String id,
    required String name,
    required String description,
    required double distance,
    required Duration duration,
    required RouteDifficulty difficulty,
    required List<RoutePoint> waypoints,
    required RouteType type,
    @Default([]) List<String> highlights,
    @Default([]) List<String> imageUrls,
    String? downloadUrl,
    String? elevationProfile,
  }) = _RouteItem;

  factory RouteItem.fromJson(Map<String, dynamic> json) =>
      _$RouteItemFromJson(json);
}

@freezed
class RoutePoint with _$RoutePoint {
  const factory RoutePoint({
    required double lat,
    required double lng,
    String? name,
    String? description,
  }) = _RoutePoint;

  factory RoutePoint.fromJson(Map<String, dynamic> json) =>
      _$RoutePointFromJson(json);
}

enum RouteType { wandern, radfahren, laufen, nordic_walking }

enum RouteDifficulty { leicht, mittel, schwer }

extension RouteTypeExt on RouteType {
  String get displayName {
    switch (this) {
      case RouteType.wandern:
        return 'Wandern';
      case RouteType.radfahren:
        return 'Radfahren';
      case RouteType.laufen:
        return 'Laufen';
      case RouteType.nordic_walking:
        return 'Nordic Walking';
    }
  }

  String get icon {
    switch (this) {
      case RouteType.wandern:
        return '🥾';
      case RouteType.radfahren:
        return '🚴';
      case RouteType.laufen:
        return '🏃';
      case RouteType.nordic_walking:
        return '🚶';
    }
  }
}

extension RouteDifficultyExt on RouteDifficulty {
  String get displayName {
    switch (this) {
      case RouteDifficulty.leicht:
        return 'Leicht';
      case RouteDifficulty.mittel:
        return 'Mittel';
      case RouteDifficulty.schwer:
        return 'Schwer';
    }
  }

  String get color {
    switch (this) {
      case RouteDifficulty.leicht:
        return 'green';
      case RouteDifficulty.mittel:
        return 'orange';
      case RouteDifficulty.schwer:
        return 'red';
    }
  }
}
