// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;
  UserPreferences get preferences => throw _privateConstructorUsedError;
  PrivacySettings get privacySettings => throw _privateConstructorUsedError;
  bool get isEmailVerified => throw _privateConstructorUsedError;
  bool get isAnonymous => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      String email,
      String? displayName,
      String? phone,
      DateTime? createdAt,
      DateTime? lastLoginAt,
      UserPreferences preferences,
      PrivacySettings privacySettings,
      bool isEmailVerified,
      bool isAnonymous});

  $UserPreferencesCopyWith<$Res> get preferences;
  $PrivacySettingsCopyWith<$Res> get privacySettings;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? phone = freezed,
    Object? createdAt = freezed,
    Object? lastLoginAt = freezed,
    Object? preferences = null,
    Object? privacySettings = null,
    Object? isEmailVerified = null,
    Object? isAnonymous = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      preferences: null == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as UserPreferences,
      privacySettings: null == privacySettings
          ? _value.privacySettings
          : privacySettings // ignore: cast_nullable_to_non_nullable
              as PrivacySettings,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserPreferencesCopyWith<$Res> get preferences {
    return $UserPreferencesCopyWith<$Res>(_value.preferences, (value) {
      return _then(_value.copyWith(preferences: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PrivacySettingsCopyWith<$Res> get privacySettings {
    return $PrivacySettingsCopyWith<$Res>(_value.privacySettings, (value) {
      return _then(_value.copyWith(privacySettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String? displayName,
      String? phone,
      DateTime? createdAt,
      DateTime? lastLoginAt,
      UserPreferences preferences,
      PrivacySettings privacySettings,
      bool isEmailVerified,
      bool isAnonymous});

  @override
  $UserPreferencesCopyWith<$Res> get preferences;
  @override
  $PrivacySettingsCopyWith<$Res> get privacySettings;
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? phone = freezed,
    Object? createdAt = freezed,
    Object? lastLoginAt = freezed,
    Object? preferences = null,
    Object? privacySettings = null,
    Object? isEmailVerified = null,
    Object? isAnonymous = null,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      preferences: null == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as UserPreferences,
      privacySettings: null == privacySettings
          ? _value.privacySettings
          : privacySettings // ignore: cast_nullable_to_non_nullable
              as PrivacySettings,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.id,
      required this.email,
      this.displayName,
      this.phone,
      this.createdAt,
      this.lastLoginAt,
      this.preferences = const UserPreferences(),
      this.privacySettings = const PrivacySettings(),
      this.isEmailVerified = false,
      this.isAnonymous = false});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String? displayName;
  @override
  final String? phone;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? lastLoginAt;
  @override
  @JsonKey()
  final UserPreferences preferences;
  @override
  @JsonKey()
  final PrivacySettings privacySettings;
  @override
  @JsonKey()
  final bool isEmailVerified;
  @override
  @JsonKey()
  final bool isAnonymous;

  @override
  String toString() {
    return 'User(id: $id, email: $email, displayName: $displayName, phone: $phone, createdAt: $createdAt, lastLoginAt: $lastLoginAt, preferences: $preferences, privacySettings: $privacySettings, isEmailVerified: $isEmailVerified, isAnonymous: $isAnonymous)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            (identical(other.preferences, preferences) ||
                other.preferences == preferences) &&
            (identical(other.privacySettings, privacySettings) ||
                other.privacySettings == privacySettings) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      displayName,
      phone,
      createdAt,
      lastLoginAt,
      preferences,
      privacySettings,
      isEmailVerified,
      isAnonymous);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String id,
      required final String email,
      final String? displayName,
      final String? phone,
      final DateTime? createdAt,
      final DateTime? lastLoginAt,
      final UserPreferences preferences,
      final PrivacySettings privacySettings,
      final bool isEmailVerified,
      final bool isAnonymous}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String? get displayName;
  @override
  String? get phone;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get lastLoginAt;
  @override
  UserPreferences get preferences;
  @override
  PrivacySettings get privacySettings;
  @override
  bool get isEmailVerified;
  @override
  bool get isAnonymous;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) {
  return _UserPreferences.fromJson(json);
}

/// @nodoc
mixin _$UserPreferences {
  String get language => throw _privateConstructorUsedError;
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  bool get enableNotifications => throw _privateConstructorUsedError;
  LocationAccuracy get gpsAccuracy => throw _privateConstructorUsedError;
  ImageQuality get photoQuality => throw _privateConstructorUsedError;
  bool get enableAnalytics => throw _privateConstructorUsedError;
  bool get enableCrashReporting => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserPreferencesCopyWith<UserPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferencesCopyWith<$Res> {
  factory $UserPreferencesCopyWith(
          UserPreferences value, $Res Function(UserPreferences) then) =
      _$UserPreferencesCopyWithImpl<$Res, UserPreferences>;
  @useResult
  $Res call(
      {String language,
      ThemeMode themeMode,
      bool enableNotifications,
      LocationAccuracy gpsAccuracy,
      ImageQuality photoQuality,
      bool enableAnalytics,
      bool enableCrashReporting});
}

/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res, $Val extends UserPreferences>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
    Object? themeMode = null,
    Object? enableNotifications = null,
    Object? gpsAccuracy = null,
    Object? photoQuality = null,
    Object? enableAnalytics = null,
    Object? enableCrashReporting = null,
  }) {
    return _then(_value.copyWith(
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      enableNotifications: null == enableNotifications
          ? _value.enableNotifications
          : enableNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      gpsAccuracy: null == gpsAccuracy
          ? _value.gpsAccuracy
          : gpsAccuracy // ignore: cast_nullable_to_non_nullable
              as LocationAccuracy,
      photoQuality: null == photoQuality
          ? _value.photoQuality
          : photoQuality // ignore: cast_nullable_to_non_nullable
              as ImageQuality,
      enableAnalytics: null == enableAnalytics
          ? _value.enableAnalytics
          : enableAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
      enableCrashReporting: null == enableCrashReporting
          ? _value.enableCrashReporting
          : enableCrashReporting // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPreferencesImplCopyWith<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  factory _$$UserPreferencesImplCopyWith(_$UserPreferencesImpl value,
          $Res Function(_$UserPreferencesImpl) then) =
      __$$UserPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String language,
      ThemeMode themeMode,
      bool enableNotifications,
      LocationAccuracy gpsAccuracy,
      ImageQuality photoQuality,
      bool enableAnalytics,
      bool enableCrashReporting});
}

/// @nodoc
class __$$UserPreferencesImplCopyWithImpl<$Res>
    extends _$UserPreferencesCopyWithImpl<$Res, _$UserPreferencesImpl>
    implements _$$UserPreferencesImplCopyWith<$Res> {
  __$$UserPreferencesImplCopyWithImpl(
      _$UserPreferencesImpl _value, $Res Function(_$UserPreferencesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
    Object? themeMode = null,
    Object? enableNotifications = null,
    Object? gpsAccuracy = null,
    Object? photoQuality = null,
    Object? enableAnalytics = null,
    Object? enableCrashReporting = null,
  }) {
    return _then(_$UserPreferencesImpl(
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      enableNotifications: null == enableNotifications
          ? _value.enableNotifications
          : enableNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      gpsAccuracy: null == gpsAccuracy
          ? _value.gpsAccuracy
          : gpsAccuracy // ignore: cast_nullable_to_non_nullable
              as LocationAccuracy,
      photoQuality: null == photoQuality
          ? _value.photoQuality
          : photoQuality // ignore: cast_nullable_to_non_nullable
              as ImageQuality,
      enableAnalytics: null == enableAnalytics
          ? _value.enableAnalytics
          : enableAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
      enableCrashReporting: null == enableCrashReporting
          ? _value.enableCrashReporting
          : enableCrashReporting // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferencesImpl implements _UserPreferences {
  const _$UserPreferencesImpl(
      {this.language = 'de',
      this.themeMode = ThemeMode.system,
      this.enableNotifications = true,
      this.gpsAccuracy = LocationAccuracy.balanced,
      this.photoQuality = ImageQuality.standard,
      this.enableAnalytics = false,
      this.enableCrashReporting = false});

  factory _$UserPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferencesImplFromJson(json);

  @override
  @JsonKey()
  final String language;
  @override
  @JsonKey()
  final ThemeMode themeMode;
  @override
  @JsonKey()
  final bool enableNotifications;
  @override
  @JsonKey()
  final LocationAccuracy gpsAccuracy;
  @override
  @JsonKey()
  final ImageQuality photoQuality;
  @override
  @JsonKey()
  final bool enableAnalytics;
  @override
  @JsonKey()
  final bool enableCrashReporting;

  @override
  String toString() {
    return 'UserPreferences(language: $language, themeMode: $themeMode, enableNotifications: $enableNotifications, gpsAccuracy: $gpsAccuracy, photoQuality: $photoQuality, enableAnalytics: $enableAnalytics, enableCrashReporting: $enableCrashReporting)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferencesImpl &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.enableNotifications, enableNotifications) ||
                other.enableNotifications == enableNotifications) &&
            (identical(other.gpsAccuracy, gpsAccuracy) ||
                other.gpsAccuracy == gpsAccuracy) &&
            (identical(other.photoQuality, photoQuality) ||
                other.photoQuality == photoQuality) &&
            (identical(other.enableAnalytics, enableAnalytics) ||
                other.enableAnalytics == enableAnalytics) &&
            (identical(other.enableCrashReporting, enableCrashReporting) ||
                other.enableCrashReporting == enableCrashReporting));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      language,
      themeMode,
      enableNotifications,
      gpsAccuracy,
      photoQuality,
      enableAnalytics,
      enableCrashReporting);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      __$$UserPreferencesImplCopyWithImpl<_$UserPreferencesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPreferencesImplToJson(
      this,
    );
  }
}

abstract class _UserPreferences implements UserPreferences {
  const factory _UserPreferences(
      {final String language,
      final ThemeMode themeMode,
      final bool enableNotifications,
      final LocationAccuracy gpsAccuracy,
      final ImageQuality photoQuality,
      final bool enableAnalytics,
      final bool enableCrashReporting}) = _$UserPreferencesImpl;

  factory _UserPreferences.fromJson(Map<String, dynamic> json) =
      _$UserPreferencesImpl.fromJson;

  @override
  String get language;
  @override
  ThemeMode get themeMode;
  @override
  bool get enableNotifications;
  @override
  LocationAccuracy get gpsAccuracy;
  @override
  ImageQuality get photoQuality;
  @override
  bool get enableAnalytics;
  @override
  bool get enableCrashReporting;
  @override
  @JsonKey(ignore: true)
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PrivacySettings _$PrivacySettingsFromJson(Map<String, dynamic> json) {
  return _PrivacySettings.fromJson(json);
}

/// @nodoc
mixin _$PrivacySettings {
// Einwilligungen (explizite Opt-ins)
  bool get consentToLocationProcessing => throw _privateConstructorUsedError;
  bool get consentToPhotoProcessing => throw _privateConstructorUsedError;
  bool get consentToAnalytics => throw _privateConstructorUsedError;
  bool get consentToMarketing => throw _privateConstructorUsedError;
  bool get consentToDataSharing =>
      throw _privateConstructorUsedError; // Datenverarbeitungszwecke
  bool get allowReportSubmission =>
      throw _privateConstructorUsedError; // Essential für App-Funktionalität
  bool get allowLocationTracking => throw _privateConstructorUsedError;
  bool get allowUsageAnalytics => throw _privateConstructorUsedError;
  bool get allowPersonalization =>
      throw _privateConstructorUsedError; // Datenspeicherung und -aufbewahrung
  DataRetentionPeriod get dataRetentionPeriod =>
      throw _privateConstructorUsedError;
  bool get autoDeleteOldReports => throw _privateConstructorUsedError;
  bool get anonymizeOldData =>
      throw _privateConstructorUsedError; // Benutzerrechte-Status
  DateTime? get lastDataExportRequest => throw _privateConstructorUsedError;
  DateTime? get lastDataDeletionRequest => throw _privateConstructorUsedError;
  DateTime? get consentGivenAt => throw _privateConstructorUsedError;
  DateTime? get consentWithdrawnAt =>
      throw _privateConstructorUsedError; // Kontaktpräferenzen
  bool get allowEmailContact => throw _privateConstructorUsedError;
  bool get allowPhoneContact => throw _privateConstructorUsedError;
  ContactReason get preferredContactReason =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PrivacySettingsCopyWith<PrivacySettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivacySettingsCopyWith<$Res> {
  factory $PrivacySettingsCopyWith(
          PrivacySettings value, $Res Function(PrivacySettings) then) =
      _$PrivacySettingsCopyWithImpl<$Res, PrivacySettings>;
  @useResult
  $Res call(
      {bool consentToLocationProcessing,
      bool consentToPhotoProcessing,
      bool consentToAnalytics,
      bool consentToMarketing,
      bool consentToDataSharing,
      bool allowReportSubmission,
      bool allowLocationTracking,
      bool allowUsageAnalytics,
      bool allowPersonalization,
      DataRetentionPeriod dataRetentionPeriod,
      bool autoDeleteOldReports,
      bool anonymizeOldData,
      DateTime? lastDataExportRequest,
      DateTime? lastDataDeletionRequest,
      DateTime? consentGivenAt,
      DateTime? consentWithdrawnAt,
      bool allowEmailContact,
      bool allowPhoneContact,
      ContactReason preferredContactReason});
}

/// @nodoc
class _$PrivacySettingsCopyWithImpl<$Res, $Val extends PrivacySettings>
    implements $PrivacySettingsCopyWith<$Res> {
  _$PrivacySettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consentToLocationProcessing = null,
    Object? consentToPhotoProcessing = null,
    Object? consentToAnalytics = null,
    Object? consentToMarketing = null,
    Object? consentToDataSharing = null,
    Object? allowReportSubmission = null,
    Object? allowLocationTracking = null,
    Object? allowUsageAnalytics = null,
    Object? allowPersonalization = null,
    Object? dataRetentionPeriod = null,
    Object? autoDeleteOldReports = null,
    Object? anonymizeOldData = null,
    Object? lastDataExportRequest = freezed,
    Object? lastDataDeletionRequest = freezed,
    Object? consentGivenAt = freezed,
    Object? consentWithdrawnAt = freezed,
    Object? allowEmailContact = null,
    Object? allowPhoneContact = null,
    Object? preferredContactReason = null,
  }) {
    return _then(_value.copyWith(
      consentToLocationProcessing: null == consentToLocationProcessing
          ? _value.consentToLocationProcessing
          : consentToLocationProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      consentToPhotoProcessing: null == consentToPhotoProcessing
          ? _value.consentToPhotoProcessing
          : consentToPhotoProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      consentToAnalytics: null == consentToAnalytics
          ? _value.consentToAnalytics
          : consentToAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
      consentToMarketing: null == consentToMarketing
          ? _value.consentToMarketing
          : consentToMarketing // ignore: cast_nullable_to_non_nullable
              as bool,
      consentToDataSharing: null == consentToDataSharing
          ? _value.consentToDataSharing
          : consentToDataSharing // ignore: cast_nullable_to_non_nullable
              as bool,
      allowReportSubmission: null == allowReportSubmission
          ? _value.allowReportSubmission
          : allowReportSubmission // ignore: cast_nullable_to_non_nullable
              as bool,
      allowLocationTracking: null == allowLocationTracking
          ? _value.allowLocationTracking
          : allowLocationTracking // ignore: cast_nullable_to_non_nullable
              as bool,
      allowUsageAnalytics: null == allowUsageAnalytics
          ? _value.allowUsageAnalytics
          : allowUsageAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
      allowPersonalization: null == allowPersonalization
          ? _value.allowPersonalization
          : allowPersonalization // ignore: cast_nullable_to_non_nullable
              as bool,
      dataRetentionPeriod: null == dataRetentionPeriod
          ? _value.dataRetentionPeriod
          : dataRetentionPeriod // ignore: cast_nullable_to_non_nullable
              as DataRetentionPeriod,
      autoDeleteOldReports: null == autoDeleteOldReports
          ? _value.autoDeleteOldReports
          : autoDeleteOldReports // ignore: cast_nullable_to_non_nullable
              as bool,
      anonymizeOldData: null == anonymizeOldData
          ? _value.anonymizeOldData
          : anonymizeOldData // ignore: cast_nullable_to_non_nullable
              as bool,
      lastDataExportRequest: freezed == lastDataExportRequest
          ? _value.lastDataExportRequest
          : lastDataExportRequest // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastDataDeletionRequest: freezed == lastDataDeletionRequest
          ? _value.lastDataDeletionRequest
          : lastDataDeletionRequest // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      consentGivenAt: freezed == consentGivenAt
          ? _value.consentGivenAt
          : consentGivenAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      consentWithdrawnAt: freezed == consentWithdrawnAt
          ? _value.consentWithdrawnAt
          : consentWithdrawnAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      allowEmailContact: null == allowEmailContact
          ? _value.allowEmailContact
          : allowEmailContact // ignore: cast_nullable_to_non_nullable
              as bool,
      allowPhoneContact: null == allowPhoneContact
          ? _value.allowPhoneContact
          : allowPhoneContact // ignore: cast_nullable_to_non_nullable
              as bool,
      preferredContactReason: null == preferredContactReason
          ? _value.preferredContactReason
          : preferredContactReason // ignore: cast_nullable_to_non_nullable
              as ContactReason,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrivacySettingsImplCopyWith<$Res>
    implements $PrivacySettingsCopyWith<$Res> {
  factory _$$PrivacySettingsImplCopyWith(_$PrivacySettingsImpl value,
          $Res Function(_$PrivacySettingsImpl) then) =
      __$$PrivacySettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool consentToLocationProcessing,
      bool consentToPhotoProcessing,
      bool consentToAnalytics,
      bool consentToMarketing,
      bool consentToDataSharing,
      bool allowReportSubmission,
      bool allowLocationTracking,
      bool allowUsageAnalytics,
      bool allowPersonalization,
      DataRetentionPeriod dataRetentionPeriod,
      bool autoDeleteOldReports,
      bool anonymizeOldData,
      DateTime? lastDataExportRequest,
      DateTime? lastDataDeletionRequest,
      DateTime? consentGivenAt,
      DateTime? consentWithdrawnAt,
      bool allowEmailContact,
      bool allowPhoneContact,
      ContactReason preferredContactReason});
}

/// @nodoc
class __$$PrivacySettingsImplCopyWithImpl<$Res>
    extends _$PrivacySettingsCopyWithImpl<$Res, _$PrivacySettingsImpl>
    implements _$$PrivacySettingsImplCopyWith<$Res> {
  __$$PrivacySettingsImplCopyWithImpl(
      _$PrivacySettingsImpl _value, $Res Function(_$PrivacySettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consentToLocationProcessing = null,
    Object? consentToPhotoProcessing = null,
    Object? consentToAnalytics = null,
    Object? consentToMarketing = null,
    Object? consentToDataSharing = null,
    Object? allowReportSubmission = null,
    Object? allowLocationTracking = null,
    Object? allowUsageAnalytics = null,
    Object? allowPersonalization = null,
    Object? dataRetentionPeriod = null,
    Object? autoDeleteOldReports = null,
    Object? anonymizeOldData = null,
    Object? lastDataExportRequest = freezed,
    Object? lastDataDeletionRequest = freezed,
    Object? consentGivenAt = freezed,
    Object? consentWithdrawnAt = freezed,
    Object? allowEmailContact = null,
    Object? allowPhoneContact = null,
    Object? preferredContactReason = null,
  }) {
    return _then(_$PrivacySettingsImpl(
      consentToLocationProcessing: null == consentToLocationProcessing
          ? _value.consentToLocationProcessing
          : consentToLocationProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      consentToPhotoProcessing: null == consentToPhotoProcessing
          ? _value.consentToPhotoProcessing
          : consentToPhotoProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      consentToAnalytics: null == consentToAnalytics
          ? _value.consentToAnalytics
          : consentToAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
      consentToMarketing: null == consentToMarketing
          ? _value.consentToMarketing
          : consentToMarketing // ignore: cast_nullable_to_non_nullable
              as bool,
      consentToDataSharing: null == consentToDataSharing
          ? _value.consentToDataSharing
          : consentToDataSharing // ignore: cast_nullable_to_non_nullable
              as bool,
      allowReportSubmission: null == allowReportSubmission
          ? _value.allowReportSubmission
          : allowReportSubmission // ignore: cast_nullable_to_non_nullable
              as bool,
      allowLocationTracking: null == allowLocationTracking
          ? _value.allowLocationTracking
          : allowLocationTracking // ignore: cast_nullable_to_non_nullable
              as bool,
      allowUsageAnalytics: null == allowUsageAnalytics
          ? _value.allowUsageAnalytics
          : allowUsageAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
      allowPersonalization: null == allowPersonalization
          ? _value.allowPersonalization
          : allowPersonalization // ignore: cast_nullable_to_non_nullable
              as bool,
      dataRetentionPeriod: null == dataRetentionPeriod
          ? _value.dataRetentionPeriod
          : dataRetentionPeriod // ignore: cast_nullable_to_non_nullable
              as DataRetentionPeriod,
      autoDeleteOldReports: null == autoDeleteOldReports
          ? _value.autoDeleteOldReports
          : autoDeleteOldReports // ignore: cast_nullable_to_non_nullable
              as bool,
      anonymizeOldData: null == anonymizeOldData
          ? _value.anonymizeOldData
          : anonymizeOldData // ignore: cast_nullable_to_non_nullable
              as bool,
      lastDataExportRequest: freezed == lastDataExportRequest
          ? _value.lastDataExportRequest
          : lastDataExportRequest // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastDataDeletionRequest: freezed == lastDataDeletionRequest
          ? _value.lastDataDeletionRequest
          : lastDataDeletionRequest // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      consentGivenAt: freezed == consentGivenAt
          ? _value.consentGivenAt
          : consentGivenAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      consentWithdrawnAt: freezed == consentWithdrawnAt
          ? _value.consentWithdrawnAt
          : consentWithdrawnAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      allowEmailContact: null == allowEmailContact
          ? _value.allowEmailContact
          : allowEmailContact // ignore: cast_nullable_to_non_nullable
              as bool,
      allowPhoneContact: null == allowPhoneContact
          ? _value.allowPhoneContact
          : allowPhoneContact // ignore: cast_nullable_to_non_nullable
              as bool,
      preferredContactReason: null == preferredContactReason
          ? _value.preferredContactReason
          : preferredContactReason // ignore: cast_nullable_to_non_nullable
              as ContactReason,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrivacySettingsImpl implements _PrivacySettings {
  const _$PrivacySettingsImpl(
      {this.consentToLocationProcessing = false,
      this.consentToPhotoProcessing = false,
      this.consentToAnalytics = false,
      this.consentToMarketing = false,
      this.consentToDataSharing = false,
      this.allowReportSubmission = true,
      this.allowLocationTracking = false,
      this.allowUsageAnalytics = false,
      this.allowPersonalization = false,
      this.dataRetentionPeriod = DataRetentionPeriod.oneYear,
      this.autoDeleteOldReports = false,
      this.anonymizeOldData = false,
      this.lastDataExportRequest,
      this.lastDataDeletionRequest,
      this.consentGivenAt,
      this.consentWithdrawnAt,
      this.allowEmailContact = false,
      this.allowPhoneContact = false,
      this.preferredContactReason = ContactReason.essential});

  factory _$PrivacySettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivacySettingsImplFromJson(json);

// Einwilligungen (explizite Opt-ins)
  @override
  @JsonKey()
  final bool consentToLocationProcessing;
  @override
  @JsonKey()
  final bool consentToPhotoProcessing;
  @override
  @JsonKey()
  final bool consentToAnalytics;
  @override
  @JsonKey()
  final bool consentToMarketing;
  @override
  @JsonKey()
  final bool consentToDataSharing;
// Datenverarbeitungszwecke
  @override
  @JsonKey()
  final bool allowReportSubmission;
// Essential für App-Funktionalität
  @override
  @JsonKey()
  final bool allowLocationTracking;
  @override
  @JsonKey()
  final bool allowUsageAnalytics;
  @override
  @JsonKey()
  final bool allowPersonalization;
// Datenspeicherung und -aufbewahrung
  @override
  @JsonKey()
  final DataRetentionPeriod dataRetentionPeriod;
  @override
  @JsonKey()
  final bool autoDeleteOldReports;
  @override
  @JsonKey()
  final bool anonymizeOldData;
// Benutzerrechte-Status
  @override
  final DateTime? lastDataExportRequest;
  @override
  final DateTime? lastDataDeletionRequest;
  @override
  final DateTime? consentGivenAt;
  @override
  final DateTime? consentWithdrawnAt;
// Kontaktpräferenzen
  @override
  @JsonKey()
  final bool allowEmailContact;
  @override
  @JsonKey()
  final bool allowPhoneContact;
  @override
  @JsonKey()
  final ContactReason preferredContactReason;

  @override
  String toString() {
    return 'PrivacySettings(consentToLocationProcessing: $consentToLocationProcessing, consentToPhotoProcessing: $consentToPhotoProcessing, consentToAnalytics: $consentToAnalytics, consentToMarketing: $consentToMarketing, consentToDataSharing: $consentToDataSharing, allowReportSubmission: $allowReportSubmission, allowLocationTracking: $allowLocationTracking, allowUsageAnalytics: $allowUsageAnalytics, allowPersonalization: $allowPersonalization, dataRetentionPeriod: $dataRetentionPeriod, autoDeleteOldReports: $autoDeleteOldReports, anonymizeOldData: $anonymizeOldData, lastDataExportRequest: $lastDataExportRequest, lastDataDeletionRequest: $lastDataDeletionRequest, consentGivenAt: $consentGivenAt, consentWithdrawnAt: $consentWithdrawnAt, allowEmailContact: $allowEmailContact, allowPhoneContact: $allowPhoneContact, preferredContactReason: $preferredContactReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivacySettingsImpl &&
            (identical(other.consentToLocationProcessing,
                    consentToLocationProcessing) ||
                other.consentToLocationProcessing ==
                    consentToLocationProcessing) &&
            (identical(
                    other.consentToPhotoProcessing, consentToPhotoProcessing) ||
                other.consentToPhotoProcessing == consentToPhotoProcessing) &&
            (identical(other.consentToAnalytics, consentToAnalytics) ||
                other.consentToAnalytics == consentToAnalytics) &&
            (identical(other.consentToMarketing, consentToMarketing) ||
                other.consentToMarketing == consentToMarketing) &&
            (identical(other.consentToDataSharing, consentToDataSharing) ||
                other.consentToDataSharing == consentToDataSharing) &&
            (identical(other.allowReportSubmission, allowReportSubmission) ||
                other.allowReportSubmission == allowReportSubmission) &&
            (identical(other.allowLocationTracking, allowLocationTracking) ||
                other.allowLocationTracking == allowLocationTracking) &&
            (identical(other.allowUsageAnalytics, allowUsageAnalytics) ||
                other.allowUsageAnalytics == allowUsageAnalytics) &&
            (identical(other.allowPersonalization, allowPersonalization) ||
                other.allowPersonalization == allowPersonalization) &&
            (identical(other.dataRetentionPeriod, dataRetentionPeriod) ||
                other.dataRetentionPeriod == dataRetentionPeriod) &&
            (identical(other.autoDeleteOldReports, autoDeleteOldReports) ||
                other.autoDeleteOldReports == autoDeleteOldReports) &&
            (identical(other.anonymizeOldData, anonymizeOldData) ||
                other.anonymizeOldData == anonymizeOldData) &&
            (identical(other.lastDataExportRequest, lastDataExportRequest) ||
                other.lastDataExportRequest == lastDataExportRequest) &&
            (identical(
                    other.lastDataDeletionRequest, lastDataDeletionRequest) ||
                other.lastDataDeletionRequest == lastDataDeletionRequest) &&
            (identical(other.consentGivenAt, consentGivenAt) ||
                other.consentGivenAt == consentGivenAt) &&
            (identical(other.consentWithdrawnAt, consentWithdrawnAt) ||
                other.consentWithdrawnAt == consentWithdrawnAt) &&
            (identical(other.allowEmailContact, allowEmailContact) ||
                other.allowEmailContact == allowEmailContact) &&
            (identical(other.allowPhoneContact, allowPhoneContact) ||
                other.allowPhoneContact == allowPhoneContact) &&
            (identical(other.preferredContactReason, preferredContactReason) ||
                other.preferredContactReason == preferredContactReason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        consentToLocationProcessing,
        consentToPhotoProcessing,
        consentToAnalytics,
        consentToMarketing,
        consentToDataSharing,
        allowReportSubmission,
        allowLocationTracking,
        allowUsageAnalytics,
        allowPersonalization,
        dataRetentionPeriod,
        autoDeleteOldReports,
        anonymizeOldData,
        lastDataExportRequest,
        lastDataDeletionRequest,
        consentGivenAt,
        consentWithdrawnAt,
        allowEmailContact,
        allowPhoneContact,
        preferredContactReason
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivacySettingsImplCopyWith<_$PrivacySettingsImpl> get copyWith =>
      __$$PrivacySettingsImplCopyWithImpl<_$PrivacySettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrivacySettingsImplToJson(
      this,
    );
  }
}

abstract class _PrivacySettings implements PrivacySettings {
  const factory _PrivacySettings(
      {final bool consentToLocationProcessing,
      final bool consentToPhotoProcessing,
      final bool consentToAnalytics,
      final bool consentToMarketing,
      final bool consentToDataSharing,
      final bool allowReportSubmission,
      final bool allowLocationTracking,
      final bool allowUsageAnalytics,
      final bool allowPersonalization,
      final DataRetentionPeriod dataRetentionPeriod,
      final bool autoDeleteOldReports,
      final bool anonymizeOldData,
      final DateTime? lastDataExportRequest,
      final DateTime? lastDataDeletionRequest,
      final DateTime? consentGivenAt,
      final DateTime? consentWithdrawnAt,
      final bool allowEmailContact,
      final bool allowPhoneContact,
      final ContactReason preferredContactReason}) = _$PrivacySettingsImpl;

  factory _PrivacySettings.fromJson(Map<String, dynamic> json) =
      _$PrivacySettingsImpl.fromJson;

  @override // Einwilligungen (explizite Opt-ins)
  bool get consentToLocationProcessing;
  @override
  bool get consentToPhotoProcessing;
  @override
  bool get consentToAnalytics;
  @override
  bool get consentToMarketing;
  @override
  bool get consentToDataSharing;
  @override // Datenverarbeitungszwecke
  bool get allowReportSubmission;
  @override // Essential für App-Funktionalität
  bool get allowLocationTracking;
  @override
  bool get allowUsageAnalytics;
  @override
  bool get allowPersonalization;
  @override // Datenspeicherung und -aufbewahrung
  DataRetentionPeriod get dataRetentionPeriod;
  @override
  bool get autoDeleteOldReports;
  @override
  bool get anonymizeOldData;
  @override // Benutzerrechte-Status
  DateTime? get lastDataExportRequest;
  @override
  DateTime? get lastDataDeletionRequest;
  @override
  DateTime? get consentGivenAt;
  @override
  DateTime? get consentWithdrawnAt;
  @override // Kontaktpräferenzen
  bool get allowEmailContact;
  @override
  bool get allowPhoneContact;
  @override
  ContactReason get preferredContactReason;
  @override
  @JsonKey(ignore: true)
  _$$PrivacySettingsImplCopyWith<_$PrivacySettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserSession _$UserSessionFromJson(Map<String, dynamic> json) {
  return _UserSession.fromJson(json);
}

/// @nodoc
mixin _$UserSession {
  String get sessionId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  DateTime? get lastActivityAt => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  String? get deviceInfo => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserSessionCopyWith<UserSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSessionCopyWith<$Res> {
  factory $UserSessionCopyWith(
          UserSession value, $Res Function(UserSession) then) =
      _$UserSessionCopyWithImpl<$Res, UserSession>;
  @useResult
  $Res call(
      {String sessionId,
      String userId,
      DateTime createdAt,
      DateTime expiresAt,
      DateTime? lastActivityAt,
      String? deviceId,
      String? deviceInfo,
      bool isActive});
}

/// @nodoc
class _$UserSessionCopyWithImpl<$Res, $Val extends UserSession>
    implements $UserSessionCopyWith<$Res> {
  _$UserSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? lastActivityAt = freezed,
    Object? deviceId = freezed,
    Object? deviceInfo = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActivityAt: freezed == lastActivityAt
          ? _value.lastActivityAt
          : lastActivityAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceInfo: freezed == deviceInfo
          ? _value.deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSessionImplCopyWith<$Res>
    implements $UserSessionCopyWith<$Res> {
  factory _$$UserSessionImplCopyWith(
          _$UserSessionImpl value, $Res Function(_$UserSessionImpl) then) =
      __$$UserSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      String userId,
      DateTime createdAt,
      DateTime expiresAt,
      DateTime? lastActivityAt,
      String? deviceId,
      String? deviceInfo,
      bool isActive});
}

/// @nodoc
class __$$UserSessionImplCopyWithImpl<$Res>
    extends _$UserSessionCopyWithImpl<$Res, _$UserSessionImpl>
    implements _$$UserSessionImplCopyWith<$Res> {
  __$$UserSessionImplCopyWithImpl(
      _$UserSessionImpl _value, $Res Function(_$UserSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? lastActivityAt = freezed,
    Object? deviceId = freezed,
    Object? deviceInfo = freezed,
    Object? isActive = null,
  }) {
    return _then(_$UserSessionImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActivityAt: freezed == lastActivityAt
          ? _value.lastActivityAt
          : lastActivityAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceInfo: freezed == deviceInfo
          ? _value.deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSessionImpl implements _UserSession {
  const _$UserSessionImpl(
      {required this.sessionId,
      required this.userId,
      required this.createdAt,
      required this.expiresAt,
      this.lastActivityAt,
      this.deviceId,
      this.deviceInfo,
      this.isActive = false});

  factory _$UserSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSessionImplFromJson(json);

  @override
  final String sessionId;
  @override
  final String userId;
  @override
  final DateTime createdAt;
  @override
  final DateTime expiresAt;
  @override
  final DateTime? lastActivityAt;
  @override
  final String? deviceId;
  @override
  final String? deviceInfo;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'UserSession(sessionId: $sessionId, userId: $userId, createdAt: $createdAt, expiresAt: $expiresAt, lastActivityAt: $lastActivityAt, deviceId: $deviceId, deviceInfo: $deviceInfo, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSessionImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.lastActivityAt, lastActivityAt) ||
                other.lastActivityAt == lastActivityAt) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.deviceInfo, deviceInfo) ||
                other.deviceInfo == deviceInfo) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sessionId, userId, createdAt,
      expiresAt, lastActivityAt, deviceId, deviceInfo, isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSessionImplCopyWith<_$UserSessionImpl> get copyWith =>
      __$$UserSessionImplCopyWithImpl<_$UserSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSessionImplToJson(
      this,
    );
  }
}

abstract class _UserSession implements UserSession {
  const factory _UserSession(
      {required final String sessionId,
      required final String userId,
      required final DateTime createdAt,
      required final DateTime expiresAt,
      final DateTime? lastActivityAt,
      final String? deviceId,
      final String? deviceInfo,
      final bool isActive}) = _$UserSessionImpl;

  factory _UserSession.fromJson(Map<String, dynamic> json) =
      _$UserSessionImpl.fromJson;

  @override
  String get sessionId;
  @override
  String get userId;
  @override
  DateTime get createdAt;
  @override
  DateTime get expiresAt;
  @override
  DateTime? get lastActivityAt;
  @override
  String? get deviceId;
  @override
  String? get deviceInfo;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$UserSessionImplCopyWith<_$UserSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserDataExport _$UserDataExportFromJson(Map<String, dynamic> json) {
  return _UserDataExport.fromJson(json);
}

/// @nodoc
mixin _$UserDataExport {
  String get userId => throw _privateConstructorUsedError;
  DateTime get exportedAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get userData => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get reports => throw _privateConstructorUsedError;
  Map<String, dynamic> get preferences => throw _privateConstructorUsedError;
  Map<String, dynamic> get privacySettings =>
      throw _privateConstructorUsedError;
  String? get exportFormat => throw _privateConstructorUsedError;
  int? get fileSizeBytes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserDataExportCopyWith<UserDataExport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDataExportCopyWith<$Res> {
  factory $UserDataExportCopyWith(
          UserDataExport value, $Res Function(UserDataExport) then) =
      _$UserDataExportCopyWithImpl<$Res, UserDataExport>;
  @useResult
  $Res call(
      {String userId,
      DateTime exportedAt,
      Map<String, dynamic> userData,
      List<Map<String, dynamic>> reports,
      Map<String, dynamic> preferences,
      Map<String, dynamic> privacySettings,
      String? exportFormat,
      int? fileSizeBytes});
}

/// @nodoc
class _$UserDataExportCopyWithImpl<$Res, $Val extends UserDataExport>
    implements $UserDataExportCopyWith<$Res> {
  _$UserDataExportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? exportedAt = null,
    Object? userData = null,
    Object? reports = null,
    Object? preferences = null,
    Object? privacySettings = null,
    Object? exportFormat = freezed,
    Object? fileSizeBytes = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      exportedAt: null == exportedAt
          ? _value.exportedAt
          : exportedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userData: null == userData
          ? _value.userData
          : userData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      reports: null == reports
          ? _value.reports
          : reports // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      preferences: null == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      privacySettings: null == privacySettings
          ? _value.privacySettings
          : privacySettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      exportFormat: freezed == exportFormat
          ? _value.exportFormat
          : exportFormat // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSizeBytes: freezed == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserDataExportImplCopyWith<$Res>
    implements $UserDataExportCopyWith<$Res> {
  factory _$$UserDataExportImplCopyWith(_$UserDataExportImpl value,
          $Res Function(_$UserDataExportImpl) then) =
      __$$UserDataExportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      DateTime exportedAt,
      Map<String, dynamic> userData,
      List<Map<String, dynamic>> reports,
      Map<String, dynamic> preferences,
      Map<String, dynamic> privacySettings,
      String? exportFormat,
      int? fileSizeBytes});
}

/// @nodoc
class __$$UserDataExportImplCopyWithImpl<$Res>
    extends _$UserDataExportCopyWithImpl<$Res, _$UserDataExportImpl>
    implements _$$UserDataExportImplCopyWith<$Res> {
  __$$UserDataExportImplCopyWithImpl(
      _$UserDataExportImpl _value, $Res Function(_$UserDataExportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? exportedAt = null,
    Object? userData = null,
    Object? reports = null,
    Object? preferences = null,
    Object? privacySettings = null,
    Object? exportFormat = freezed,
    Object? fileSizeBytes = freezed,
  }) {
    return _then(_$UserDataExportImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      exportedAt: null == exportedAt
          ? _value.exportedAt
          : exportedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userData: null == userData
          ? _value._userData
          : userData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      reports: null == reports
          ? _value._reports
          : reports // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      preferences: null == preferences
          ? _value._preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      privacySettings: null == privacySettings
          ? _value._privacySettings
          : privacySettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      exportFormat: freezed == exportFormat
          ? _value.exportFormat
          : exportFormat // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSizeBytes: freezed == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDataExportImpl implements _UserDataExport {
  const _$UserDataExportImpl(
      {required this.userId,
      required this.exportedAt,
      required final Map<String, dynamic> userData,
      required final List<Map<String, dynamic>> reports,
      required final Map<String, dynamic> preferences,
      required final Map<String, dynamic> privacySettings,
      this.exportFormat,
      this.fileSizeBytes})
      : _userData = userData,
        _reports = reports,
        _preferences = preferences,
        _privacySettings = privacySettings;

  factory _$UserDataExportImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDataExportImplFromJson(json);

  @override
  final String userId;
  @override
  final DateTime exportedAt;
  final Map<String, dynamic> _userData;
  @override
  Map<String, dynamic> get userData {
    if (_userData is EqualUnmodifiableMapView) return _userData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_userData);
  }

  final List<Map<String, dynamic>> _reports;
  @override
  List<Map<String, dynamic>> get reports {
    if (_reports is EqualUnmodifiableListView) return _reports;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reports);
  }

  final Map<String, dynamic> _preferences;
  @override
  Map<String, dynamic> get preferences {
    if (_preferences is EqualUnmodifiableMapView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_preferences);
  }

  final Map<String, dynamic> _privacySettings;
  @override
  Map<String, dynamic> get privacySettings {
    if (_privacySettings is EqualUnmodifiableMapView) return _privacySettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_privacySettings);
  }

  @override
  final String? exportFormat;
  @override
  final int? fileSizeBytes;

  @override
  String toString() {
    return 'UserDataExport(userId: $userId, exportedAt: $exportedAt, userData: $userData, reports: $reports, preferences: $preferences, privacySettings: $privacySettings, exportFormat: $exportFormat, fileSizeBytes: $fileSizeBytes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDataExportImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.exportedAt, exportedAt) ||
                other.exportedAt == exportedAt) &&
            const DeepCollectionEquality().equals(other._userData, _userData) &&
            const DeepCollectionEquality().equals(other._reports, _reports) &&
            const DeepCollectionEquality()
                .equals(other._preferences, _preferences) &&
            const DeepCollectionEquality()
                .equals(other._privacySettings, _privacySettings) &&
            (identical(other.exportFormat, exportFormat) ||
                other.exportFormat == exportFormat) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      exportedAt,
      const DeepCollectionEquality().hash(_userData),
      const DeepCollectionEquality().hash(_reports),
      const DeepCollectionEquality().hash(_preferences),
      const DeepCollectionEquality().hash(_privacySettings),
      exportFormat,
      fileSizeBytes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDataExportImplCopyWith<_$UserDataExportImpl> get copyWith =>
      __$$UserDataExportImplCopyWithImpl<_$UserDataExportImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDataExportImplToJson(
      this,
    );
  }
}

abstract class _UserDataExport implements UserDataExport {
  const factory _UserDataExport(
      {required final String userId,
      required final DateTime exportedAt,
      required final Map<String, dynamic> userData,
      required final List<Map<String, dynamic>> reports,
      required final Map<String, dynamic> preferences,
      required final Map<String, dynamic> privacySettings,
      final String? exportFormat,
      final int? fileSizeBytes}) = _$UserDataExportImpl;

  factory _UserDataExport.fromJson(Map<String, dynamic> json) =
      _$UserDataExportImpl.fromJson;

  @override
  String get userId;
  @override
  DateTime get exportedAt;
  @override
  Map<String, dynamic> get userData;
  @override
  List<Map<String, dynamic>> get reports;
  @override
  Map<String, dynamic> get preferences;
  @override
  Map<String, dynamic> get privacySettings;
  @override
  String? get exportFormat;
  @override
  int? get fileSizeBytes;
  @override
  @JsonKey(ignore: true)
  _$$UserDataExportImplCopyWith<_$UserDataExportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
