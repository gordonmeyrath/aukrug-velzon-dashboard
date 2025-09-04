import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.freezed.dart';
part 'place.g.dart';

/// Place model representing tourist locations and points of interest
@freezed
class Place with _$Place {
  const factory Place({
    required int id,
    required String name,
    required String description,
    required double latitude,
    required double longitude,
    String? imageUrl,
    String? category,
    String? address,
    String? website,
    String? phone,
    Map<String, String>? openingHours,
    List<String>? tags,
    @Default(false) bool isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}

/// Category for places
enum PlaceCategory {
  restaurant,
  hotel,
  attraction,
  nature,
  historic,
  shopping,
  service,
  other;

  String get displayName {
    switch (this) {
      case PlaceCategory.restaurant:
        return 'Restaurant';
      case PlaceCategory.hotel:
        return 'Unterkunft';
      case PlaceCategory.attraction:
        return 'Sehenswürdigkeit';
      case PlaceCategory.nature:
        return 'Natur';
      case PlaceCategory.historic:
        return 'Geschichte';
      case PlaceCategory.shopping:
        return 'Einkaufen';
      case PlaceCategory.service:
        return 'Service';
      case PlaceCategory.other:
        return 'Sonstiges';
    }
  }
}
