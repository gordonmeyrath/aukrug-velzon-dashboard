import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice.freezed.dart';
part 'notice.g.dart';

@freezed
class Notice with _$Notice {
  const factory Notice({
    required String id,
    required String title,
    required String content,
    required NoticeCategory category,
    required DateTime publishedAt,
    required bool isImportant,
    @Default(false) bool isPinned,
    @Default([]) List<String> attachmentUrls,
    DateTime? validUntil,
    String? authorName,
    String? departmentName,
  }) = _Notice;

  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
}

enum NoticeCategory {
  allgemein,
  bauen,
  verkehr,
  umwelt,
  kultur,
  sport,
  verwaltung,
  termine,
}

extension NoticeCategoryExt on NoticeCategory {
  String get displayName {
    switch (this) {
      case NoticeCategory.allgemein:
        return 'Allgemein';
      case NoticeCategory.bauen:
        return 'Bauen & Planen';
      case NoticeCategory.verkehr:
        return 'Verkehr';
      case NoticeCategory.umwelt:
        return 'Umwelt';
      case NoticeCategory.kultur:
        return 'Kultur';
      case NoticeCategory.sport:
        return 'Sport';
      case NoticeCategory.verwaltung:
        return 'Verwaltung';
      case NoticeCategory.termine:
        return 'Termine';
    }
  }

  String get icon {
    switch (this) {
      case NoticeCategory.allgemein:
        return '📢';
      case NoticeCategory.bauen:
        return '🏗️';
      case NoticeCategory.verkehr:
        return '🚗';
      case NoticeCategory.umwelt:
        return '🌱';
      case NoticeCategory.kultur:
        return '🎭';
      case NoticeCategory.sport:
        return '⚽';
      case NoticeCategory.verwaltung:
        return '🏛️';
      case NoticeCategory.termine:
        return '📅';
    }
  }
}
