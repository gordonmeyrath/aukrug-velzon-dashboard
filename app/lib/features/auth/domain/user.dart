import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// DSGVO-konforme User-Datenmodelle für lokale Authentifizierung
/// Implementiert Datenschutz by Design und by Default

/// User profile model mit minimaler Datensammlung
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
    String? phone,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    @Default(UserPreferences()) UserPreferences preferences,
    @Default(PrivacySettings()) PrivacySettings privacySettings,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isAnonymous,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// User preferences für App-Verhalten
@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @Default('de') String language,
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(true) bool enableNotifications,
    @Default(LocationAccuracy.balanced) LocationAccuracy gpsAccuracy,
    @Default(ImageQuality.standard) ImageQuality photoQuality,
    @Default(false) bool enableAnalytics,
    @Default(false) bool enableCrashReporting,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) => 
      _$UserPreferencesFromJson(json);
}

/// DSGVO-konforme Privacy Settings mit granularer Kontrolle
@freezed
class PrivacySettings with _$PrivacySettings {
  const factory PrivacySettings({
    // Einwilligungen (explizite Opt-ins)
    @Default(false) bool consentToLocationProcessing,
    @Default(false) bool consentToPhotoProcessing,
    @Default(false) bool consentToAnalytics,
    @Default(false) bool consentToMarketing,
    @Default(false) bool consentToDataSharing,
    
    // Datenverarbeitungszwecke
    @Default(true) bool allowReportSubmission, // Essential für App-Funktionalität
    @Default(false) bool allowLocationTracking,
    @Default(false) bool allowUsageAnalytics,
    @Default(false) bool allowPersonalization,
    
    // Datenspeicherung und -aufbewahrung
    @Default(DataRetentionPeriod.oneYear) DataRetentionPeriod dataRetentionPeriod,
    @Default(false) bool autoDeleteOldReports,
    @Default(false) bool anonymizeOldData,
    
    // Benutzerrechte-Status
    DateTime? lastDataExportRequest,
    DateTime? lastDataDeletionRequest,
    DateTime? consentGivenAt,
    DateTime? consentWithdrawnAt,
    
    // Kontaktpräferenzen
    @Default(false) bool allowEmailContact,
    @Default(false) bool allowPhoneContact,
    @Default(ContactReason.essential) ContactReason preferredContactReason,
  }) = _PrivacySettings;

  factory PrivacySettings.fromJson(Map<String, dynamic> json) => 
      _$PrivacySettingsFromJson(json);
}

/// Session management für sichere Authentifizierung
@freezed
class UserSession with _$UserSession {
  const factory UserSession({
    required String sessionId,
    required String userId,
    required DateTime createdAt,
    required DateTime expiresAt,
    DateTime? lastActivityAt,
    String? deviceId,
    String? deviceInfo,
    @Default(false) bool isActive,
  }) = _UserSession;

  factory UserSession.fromJson(Map<String, dynamic> json) => 
      _$UserSessionFromJson(json);
}

/// Data export model für DSGVO Artikel 20 (Datenübertragbarkeit)
@freezed
class UserDataExport with _$UserDataExport {
  const factory UserDataExport({
    required String userId,
    required DateTime exportedAt,
    required Map<String, dynamic> userData,
    required List<Map<String, dynamic>> reports,
    required Map<String, dynamic> preferences,
    required Map<String, dynamic> privacySettings,
    String? exportFormat,
    int? fileSizeBytes,
  }) = _UserDataExport;

  factory UserDataExport.fromJson(Map<String, dynamic> json) => 
      _$UserDataExportFromJson(json);
}

/// Enums für DSGVO-konforme Einstellungen

enum LocationAccuracy {
  @JsonValue('low')
  low,
  
  @JsonValue('balanced')
  balanced,
  
  @JsonValue('high')
  high,
  
  @JsonValue('precise')
  precise;

  String get displayName {
    switch (this) {
      case LocationAccuracy.low:
        return 'Niedrig (Stromsparmodus)';
      case LocationAccuracy.balanced:
        return 'Ausgewogen (Empfohlen)';
      case LocationAccuracy.high:
        return 'Hoch (Präzise)';
      case LocationAccuracy.precise:
        return 'Sehr präzise (Batterieverbrauch)';
    }
  }

  String get privacyDescription {
    switch (this) {
      case LocationAccuracy.low:
        return 'Ungefähre Position (~1km Genauigkeit)';
      case LocationAccuracy.balanced:
        return 'Stadtbereich-Genauigkeit (~100m)';
      case LocationAccuracy.high:
        return 'Straßen-Genauigkeit (~10m)';
      case LocationAccuracy.precise:
        return 'Meter-Genauigkeit (~1-5m)';
    }
  }
}

enum ImageQuality {
  @JsonValue('low')
  low,
  
  @JsonValue('standard')
  standard,
  
  @JsonValue('high')
  high;

  String get displayName {
    switch (this) {
      case ImageQuality.low:
        return 'Niedrig (Datensparmodus)';
      case ImageQuality.standard:
        return 'Standard (Empfohlen)';
      case ImageQuality.high:
        return 'Hoch (Beste Qualität)';
    }
  }

  int get compressionQuality {
    switch (this) {
      case ImageQuality.low:
        return 60;
      case ImageQuality.standard:
        return 85;
      case ImageQuality.high:
        return 95;
    }
  }
}

enum DataRetentionPeriod {
  @JsonValue('three_months')
  threeMonths,
  
  @JsonValue('six_months')
  sixMonths,
  
  @JsonValue('one_year')
  oneYear,
  
  @JsonValue('two_years')
  twoYears,
  
  @JsonValue('custom')
  custom;

  String get displayName {
    switch (this) {
      case DataRetentionPeriod.threeMonths:
        return '3 Monate';
      case DataRetentionPeriod.sixMonths:
        return '6 Monate';
      case DataRetentionPeriod.oneYear:
        return '1 Jahr (Empfohlen)';
      case DataRetentionPeriod.twoYears:
        return '2 Jahre (Maximum)';
      case DataRetentionPeriod.custom:
        return 'Benutzerdefiniert';
    }
  }

  Duration get duration {
    switch (this) {
      case DataRetentionPeriod.threeMonths:
        return const Duration(days: 90);
      case DataRetentionPeriod.sixMonths:
        return const Duration(days: 180);
      case DataRetentionPeriod.oneYear:
        return const Duration(days: 365);
      case DataRetentionPeriod.twoYears:
        return const Duration(days: 730);
      case DataRetentionPeriod.custom:
        return const Duration(days: 365); // Default fallback
    }
  }
}

enum ContactReason {
  @JsonValue('essential')
  essential,
  
  @JsonValue('reports_updates')
  reportsUpdates,
  
  @JsonValue('service_notifications')
  serviceNotifications,
  
  @JsonValue('all')
  all;

  String get displayName {
    switch (this) {
      case ContactReason.essential:
        return 'Nur bei wichtigen Angelegenheiten';
      case ContactReason.reportsUpdates:
        return 'Updates zu meinen Meldungen';
      case ContactReason.serviceNotifications:
        return 'Service-Benachrichtigungen';
      case ContactReason.all:
        return 'Alle Benachrichtigungen';
    }
  }

  String get description {
    switch (this) {
      case ContactReason.essential:
        return 'Kontakt nur bei kritischen Sicherheitsupdates oder rechtlichen Anforderungen';
      case ContactReason.reportsUpdates:
        return 'Benachrichtigungen über Status-Änderungen Ihrer eingereichten Meldungen';
      case ContactReason.serviceNotifications:
        return 'Informationen über neue Features und Service-Änderungen';
      case ContactReason.all:
        return 'Alle Arten von Benachrichtigungen und Marketing-Informationen';
    }
  }
}

enum ThemeMode {
  @JsonValue('system')
  system,
  
  @JsonValue('light')
  light,
  
  @JsonValue('dark')
  dark;

  String get displayName {
    switch (this) {
      case ThemeMode.system:
        return 'System-Einstellung';
      case ThemeMode.light:
        return 'Hell';
      case ThemeMode.dark:
        return 'Dunkel';
    }
  }
}
