// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      phone: json['phone'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      preferences: json['preferences'] == null
          ? const UserPreferences()
          : UserPreferences.fromJson(
              json['preferences'] as Map<String, dynamic>),
      privacySettings: json['privacySettings'] == null
          ? const PrivacySettings()
          : PrivacySettings.fromJson(
              json['privacySettings'] as Map<String, dynamic>),
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'phone': instance.phone,
      'createdAt': instance.createdAt?.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'preferences': instance.preferences,
      'privacySettings': instance.privacySettings,
      'isEmailVerified': instance.isEmailVerified,
      'isAnonymous': instance.isAnonymous,
    };

_$UserPreferencesImpl _$$UserPreferencesImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPreferencesImpl(
      language: json['language'] as String? ?? 'de',
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      gpsAccuracy:
          $enumDecodeNullable(_$LocationAccuracyEnumMap, json['gpsAccuracy']) ??
              LocationAccuracy.balanced,
      photoQuality:
          $enumDecodeNullable(_$ImageQualityEnumMap, json['photoQuality']) ??
              ImageQuality.standard,
      enableAnalytics: json['enableAnalytics'] as bool? ?? false,
      enableCrashReporting: json['enableCrashReporting'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserPreferencesImplToJson(
        _$UserPreferencesImpl instance) =>
    <String, dynamic>{
      'language': instance.language,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'enableNotifications': instance.enableNotifications,
      'gpsAccuracy': _$LocationAccuracyEnumMap[instance.gpsAccuracy]!,
      'photoQuality': _$ImageQualityEnumMap[instance.photoQuality]!,
      'enableAnalytics': instance.enableAnalytics,
      'enableCrashReporting': instance.enableCrashReporting,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

const _$LocationAccuracyEnumMap = {
  LocationAccuracy.low: 'low',
  LocationAccuracy.balanced: 'balanced',
  LocationAccuracy.high: 'high',
  LocationAccuracy.precise: 'precise',
};

const _$ImageQualityEnumMap = {
  ImageQuality.low: 'low',
  ImageQuality.standard: 'standard',
  ImageQuality.high: 'high',
};

_$PrivacySettingsImpl _$$PrivacySettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$PrivacySettingsImpl(
      consentToLocationProcessing:
          json['consentToLocationProcessing'] as bool? ?? false,
      consentToPhotoProcessing:
          json['consentToPhotoProcessing'] as bool? ?? false,
      consentToAnalytics: json['consentToAnalytics'] as bool? ?? false,
      consentToMarketing: json['consentToMarketing'] as bool? ?? false,
      consentToDataSharing: json['consentToDataSharing'] as bool? ?? false,
      allowReportSubmission: json['allowReportSubmission'] as bool? ?? true,
      allowLocationTracking: json['allowLocationTracking'] as bool? ?? false,
      allowUsageAnalytics: json['allowUsageAnalytics'] as bool? ?? false,
      allowPersonalization: json['allowPersonalization'] as bool? ?? false,
      dataRetentionPeriod: $enumDecodeNullable(
              _$DataRetentionPeriodEnumMap, json['dataRetentionPeriod']) ??
          DataRetentionPeriod.oneYear,
      autoDeleteOldReports: json['autoDeleteOldReports'] as bool? ?? false,
      anonymizeOldData: json['anonymizeOldData'] as bool? ?? false,
      lastDataExportRequest: json['lastDataExportRequest'] == null
          ? null
          : DateTime.parse(json['lastDataExportRequest'] as String),
      lastDataDeletionRequest: json['lastDataDeletionRequest'] == null
          ? null
          : DateTime.parse(json['lastDataDeletionRequest'] as String),
      consentGivenAt: json['consentGivenAt'] == null
          ? null
          : DateTime.parse(json['consentGivenAt'] as String),
      consentWithdrawnAt: json['consentWithdrawnAt'] == null
          ? null
          : DateTime.parse(json['consentWithdrawnAt'] as String),
      allowEmailContact: json['allowEmailContact'] as bool? ?? false,
      allowPhoneContact: json['allowPhoneContact'] as bool? ?? false,
      preferredContactReason: $enumDecodeNullable(
              _$ContactReasonEnumMap, json['preferredContactReason']) ??
          ContactReason.essential,
    );

Map<String, dynamic> _$$PrivacySettingsImplToJson(
        _$PrivacySettingsImpl instance) =>
    <String, dynamic>{
      'consentToLocationProcessing': instance.consentToLocationProcessing,
      'consentToPhotoProcessing': instance.consentToPhotoProcessing,
      'consentToAnalytics': instance.consentToAnalytics,
      'consentToMarketing': instance.consentToMarketing,
      'consentToDataSharing': instance.consentToDataSharing,
      'allowReportSubmission': instance.allowReportSubmission,
      'allowLocationTracking': instance.allowLocationTracking,
      'allowUsageAnalytics': instance.allowUsageAnalytics,
      'allowPersonalization': instance.allowPersonalization,
      'dataRetentionPeriod':
          _$DataRetentionPeriodEnumMap[instance.dataRetentionPeriod]!,
      'autoDeleteOldReports': instance.autoDeleteOldReports,
      'anonymizeOldData': instance.anonymizeOldData,
      'lastDataExportRequest':
          instance.lastDataExportRequest?.toIso8601String(),
      'lastDataDeletionRequest':
          instance.lastDataDeletionRequest?.toIso8601String(),
      'consentGivenAt': instance.consentGivenAt?.toIso8601String(),
      'consentWithdrawnAt': instance.consentWithdrawnAt?.toIso8601String(),
      'allowEmailContact': instance.allowEmailContact,
      'allowPhoneContact': instance.allowPhoneContact,
      'preferredContactReason':
          _$ContactReasonEnumMap[instance.preferredContactReason]!,
    };

const _$DataRetentionPeriodEnumMap = {
  DataRetentionPeriod.threeMonths: 'three_months',
  DataRetentionPeriod.sixMonths: 'six_months',
  DataRetentionPeriod.oneYear: 'one_year',
  DataRetentionPeriod.twoYears: 'two_years',
  DataRetentionPeriod.custom: 'custom',
};

const _$ContactReasonEnumMap = {
  ContactReason.essential: 'essential',
  ContactReason.reportsUpdates: 'reports_updates',
  ContactReason.serviceNotifications: 'service_notifications',
  ContactReason.all: 'all',
};

_$UserSessionImpl _$$UserSessionImplFromJson(Map<String, dynamic> json) =>
    _$UserSessionImpl(
      sessionId: json['sessionId'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      lastActivityAt: json['lastActivityAt'] == null
          ? null
          : DateTime.parse(json['lastActivityAt'] as String),
      deviceId: json['deviceId'] as String?,
      deviceInfo: json['deviceInfo'] as String?,
      isActive: json['isActive'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserSessionImplToJson(_$UserSessionImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'lastActivityAt': instance.lastActivityAt?.toIso8601String(),
      'deviceId': instance.deviceId,
      'deviceInfo': instance.deviceInfo,
      'isActive': instance.isActive,
    };

_$UserDataExportImpl _$$UserDataExportImplFromJson(Map<String, dynamic> json) =>
    _$UserDataExportImpl(
      userId: json['userId'] as String,
      exportedAt: DateTime.parse(json['exportedAt'] as String),
      userData: json['userData'] as Map<String, dynamic>,
      reports: (json['reports'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      preferences: json['preferences'] as Map<String, dynamic>,
      privacySettings: json['privacySettings'] as Map<String, dynamic>,
      exportFormat: json['exportFormat'] as String?,
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$UserDataExportImplToJson(
        _$UserDataExportImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'exportedAt': instance.exportedAt.toIso8601String(),
      'userData': instance.userData,
      'reports': instance.reports,
      'preferences': instance.preferences,
      'privacySettings': instance.privacySettings,
      'exportFormat': instance.exportFormat,
      'fileSizeBytes': instance.fileSizeBytes,
    };
