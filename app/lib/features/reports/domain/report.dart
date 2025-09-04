import 'package:freezed_annotation/freezed_annotation.dart';

part 'report.freezed.dart';
part 'report.g.dart';

/// Report model for municipal issue reporting (Mängelmelder)
@freezed
class Report with _$Report {
  const factory Report({
    required int id,
    required String title,
    required String description,
    required ReportCategory category,
    required ReportPriority priority,
    required ReportStatus status,
    required ReportLocation location,
    List<String>? imageUrls,
    String? contactName,
    String? contactEmail,
    String? contactPhone,
    @Default(false) bool isAnonymous,
    DateTime? submittedAt,
    DateTime? updatedAt,
    String? municipalityResponse,
    DateTime? responseAt,
    String? referenceNumber,
  }) = _Report;

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
}

/// Location information for reports
@freezed
class ReportLocation with _$ReportLocation {
  const factory ReportLocation({
    required double latitude,
    required double longitude,
    String? address,
    String? description,
    String? landmark,
  }) = _ReportLocation;

  factory ReportLocation.fromJson(Map<String, dynamic> json) => _$ReportLocationFromJson(json);
}

/// Categories for municipal issue reports
enum ReportCategory {
  @JsonValue('roads_traffic')
  roadsTraffic,
  
  @JsonValue('public_lighting')
  publicLighting,
  
  @JsonValue('waste_management')
  wasteManagement,
  
  @JsonValue('parks_green_spaces')
  parksGreenSpaces,
  
  @JsonValue('water_drainage')
  waterDrainage,
  
  @JsonValue('public_facilities')
  publicFacilities,
  
  @JsonValue('vandalism')
  vandalism,
  
  @JsonValue('environmental')
  environmental,
  
  @JsonValue('accessibility')
  accessibility,
  
  @JsonValue('other')
  other;

  /// Get display name for category in German
  String get displayName {
    switch (this) {
      case ReportCategory.roadsTraffic:
        return 'Straßen & Verkehr';
      case ReportCategory.publicLighting:
        return 'Öffentliche Beleuchtung';
      case ReportCategory.wasteManagement:
        return 'Abfallwirtschaft';
      case ReportCategory.parksGreenSpaces:
        return 'Parks & Grünflächen';
      case ReportCategory.waterDrainage:
        return 'Wasser & Entwässerung';
      case ReportCategory.publicFacilities:
        return 'Öffentliche Einrichtungen';
      case ReportCategory.vandalism:
        return 'Vandalismus';
      case ReportCategory.environmental:
        return 'Umwelt';
      case ReportCategory.accessibility:
        return 'Barrierefreiheit';
      case ReportCategory.other:
        return 'Sonstige';
    }
  }

  /// Get icon name for category
  String get iconName {
    switch (this) {
      case ReportCategory.roadsTraffic:
        return 'directions_car';
      case ReportCategory.publicLighting:
        return 'lightbulb';
      case ReportCategory.wasteManagement:
        return 'delete';
      case ReportCategory.parksGreenSpaces:
        return 'park';
      case ReportCategory.waterDrainage:
        return 'water_drop';
      case ReportCategory.publicFacilities:
        return 'domain';
      case ReportCategory.vandalism:
        return 'report_problem';
      case ReportCategory.environmental:
        return 'eco';
      case ReportCategory.accessibility:
        return 'accessible';
      case ReportCategory.other:
        return 'help_outline';
    }
  }

  /// Get color for category
  String get colorName {
    switch (this) {
      case ReportCategory.roadsTraffic:
        return 'blue';
      case ReportCategory.publicLighting:
        return 'yellow';
      case ReportCategory.wasteManagement:
        return 'brown';
      case ReportCategory.parksGreenSpaces:
        return 'green';
      case ReportCategory.waterDrainage:
        return 'cyan';
      case ReportCategory.publicFacilities:
        return 'purple';
      case ReportCategory.vandalism:
        return 'red';
      case ReportCategory.environmental:
        return 'teal';
      case ReportCategory.accessibility:
        return 'orange';
      case ReportCategory.other:
        return 'grey';
    }
  }
}

/// Priority levels for reports
enum ReportPriority {
  @JsonValue('low')
  low,
  
  @JsonValue('medium')
  medium,
  
  @JsonValue('high')
  high,
  
  @JsonValue('urgent')
  urgent;

  /// Get display name for priority in German
  String get displayName {
    switch (this) {
      case ReportPriority.low:
        return 'Niedrig';
      case ReportPriority.medium:
        return 'Mittel';
      case ReportPriority.high:
        return 'Hoch';
      case ReportPriority.urgent:
        return 'Dringend';
    }
  }

  /// Get color for priority
  String get colorName {
    switch (this) {
      case ReportPriority.low:
        return 'grey';
      case ReportPriority.medium:
        return 'yellow';
      case ReportPriority.high:
        return 'orange';
      case ReportPriority.urgent:
        return 'red';
    }
  }
}

/// Status of report processing
enum ReportStatus {
  @JsonValue('submitted')
  submitted,
  
  @JsonValue('received')
  received,
  
  @JsonValue('in_progress')
  inProgress,
  
  @JsonValue('resolved')
  resolved,
  
  @JsonValue('closed')
  closed,
  
  @JsonValue('rejected')
  rejected;

  /// Get display name for status in German
  String get displayName {
    switch (this) {
      case ReportStatus.submitted:
        return 'Eingereicht';
      case ReportStatus.received:
        return 'Erhalten';
      case ReportStatus.inProgress:
        return 'In Bearbeitung';
      case ReportStatus.resolved:
        return 'Behoben';
      case ReportStatus.closed:
        return 'Geschlossen';
      case ReportStatus.rejected:
        return 'Abgelehnt';
    }
  }

  /// Get color for status
  String get colorName {
    switch (this) {
      case ReportStatus.submitted:
        return 'grey';
      case ReportStatus.received:
        return 'blue';
      case ReportStatus.inProgress:
        return 'orange';
      case ReportStatus.resolved:
        return 'green';
      case ReportStatus.closed:
        return 'grey';
      case ReportStatus.rejected:
        return 'red';
    }
  }
}
