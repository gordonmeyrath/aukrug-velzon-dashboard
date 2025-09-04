import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

/// Event model for community events and happenings
@freezed
class Event with _$Event {
  const factory Event({
    required int id,
    required String title,
    required String description,
    required DateTime startDate,
    DateTime? endDate,
    String? location,
    double? latitude,
    double? longitude,
    String? imageUrl,
    String? category,
    String? organizer,
    String? website,
    String? ticketUrl,
    double? price,
    int? maxParticipants,
    int? currentParticipants,
    List<String>? tags,
    @Default(false) bool isBookmarked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

/// Event categories
enum EventCategory {
  festival,
  sport,
  culture,
  family,
  education,
  business,
  community,
  other;

  String get displayName {
    switch (this) {
      case EventCategory.festival:
        return 'Festival';
      case EventCategory.sport:
        return 'Sport';
      case EventCategory.culture:
        return 'Kultur';
      case EventCategory.family:
        return 'Familie';
      case EventCategory.education:
        return 'Bildung';
      case EventCategory.business:
        return 'Wirtschaft';
      case EventCategory.community:
        return 'Gemeinde';
      case EventCategory.other:
        return 'Sonstiges';
    }
  }
}
