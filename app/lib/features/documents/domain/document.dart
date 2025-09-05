import 'package:freezed_annotation/freezed_annotation.dart';

part 'document.freezed.dart';
part 'document.g.dart';

/// Document model for municipal forms and downloads
@freezed
class Document with _$Document {
  const factory Document({
    required int id,
    required String title,
    required String description,
    required DocumentCategory category,
    required String fileUrl,
    required String fileName,
    required int fileSizeBytes,
    String? fileType,
    DateTime? lastUpdated,
    List<String>? tags,
    @Default(false) bool requiresAuthentication,
    @Default(false) bool isPopular,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Document;

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);
}

/// Document categories for municipal services
enum DocumentCategory {
  @JsonValue('applications')
  applications,

  @JsonValue('permits')
  permits,

  @JsonValue('taxes')
  taxes,

  @JsonValue('social_services')
  socialServices,

  @JsonValue('civil_registry')
  civilRegistry,

  @JsonValue('planning')
  planning,

  @JsonValue('announcements')
  announcements,

  @JsonValue('regulations')
  regulations,

  @JsonValue('emergency')
  emergency,

  @JsonValue('other')
  other;

  /// Get display name for category in German
  String get displayName {
    switch (this) {
      case DocumentCategory.applications:
        return 'Anträge';
      case DocumentCategory.permits:
        return 'Genehmigungen';
      case DocumentCategory.taxes:
        return 'Steuern & Abgaben';
      case DocumentCategory.socialServices:
        return 'Soziale Dienste';
      case DocumentCategory.civilRegistry:
        return 'Standesamt';
      case DocumentCategory.planning:
        return 'Bauleitplanung';
      case DocumentCategory.announcements:
        return 'Bekanntmachungen';
      case DocumentCategory.regulations:
        return 'Satzungen';
      case DocumentCategory.emergency:
        return 'Notfälle';
      case DocumentCategory.other:
        return 'Sonstige';
    }
  }

  /// Get icon for category
  String get iconName {
    switch (this) {
      case DocumentCategory.applications:
        return 'description';
      case DocumentCategory.permits:
        return 'verified';
      case DocumentCategory.taxes:
        return 'account_balance';
      case DocumentCategory.socialServices:
        return 'people';
      case DocumentCategory.civilRegistry:
        return 'how_to_reg';
      case DocumentCategory.planning:
        return 'architecture';
      case DocumentCategory.announcements:
        return 'campaign';
      case DocumentCategory.regulations:
        return 'gavel';
      case DocumentCategory.emergency:
        return 'emergency';
      case DocumentCategory.other:
        return 'folder';
    }
  }
}
