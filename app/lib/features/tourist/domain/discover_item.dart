import 'package:freezed_annotation/freezed_annotation.dart';

part 'discover_item.freezed.dart';
part 'discover_item.g.dart';

@freezed
class DiscoverItem with _$DiscoverItem {
  const factory DiscoverItem({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required DiscoverCategory category,
    required double lat,
    required double lng,
    @Default(false) bool isFeatured,
    @Default(0) int rating,
    @Default([]) List<String> tags,
    String? openingHours,
    String? websiteUrl,
    String? phoneNumber,
  }) = _DiscoverItem;

  factory DiscoverItem.fromJson(Map<String, dynamic> json) =>
      _$DiscoverItemFromJson(json);
}

enum DiscoverCategory {
  sehenswuerdigkeit,
  gastronomie,
  unterkunft,
  aktivitaet,
  kultur,
  natur,
  shopping,
}

extension DiscoverCategoryExt on DiscoverCategory {
  String get displayName {
    switch (this) {
      case DiscoverCategory.sehenswuerdigkeit:
        return 'Sehenswürdigkeit';
      case DiscoverCategory.gastronomie:
        return 'Gastronomie';
      case DiscoverCategory.unterkunft:
        return 'Unterkunft';
      case DiscoverCategory.aktivitaet:
        return 'Aktivität';
      case DiscoverCategory.kultur:
        return 'Kultur';
      case DiscoverCategory.natur:
        return 'Natur';
      case DiscoverCategory.shopping:
        return 'Shopping';
    }
  }

  String get icon {
    switch (this) {
      case DiscoverCategory.sehenswuerdigkeit:
        return '🏛️';
      case DiscoverCategory.gastronomie:
        return '🍽️';
      case DiscoverCategory.unterkunft:
        return '🏨';
      case DiscoverCategory.aktivitaet:
        return '🎯';
      case DiscoverCategory.kultur:
        return '🎭';
      case DiscoverCategory.natur:
        return '🌳';
      case DiscoverCategory.shopping:
        return '🛍️';
    }
  }
}
