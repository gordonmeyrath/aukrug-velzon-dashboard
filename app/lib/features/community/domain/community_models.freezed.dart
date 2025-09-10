// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CommunityUser _$CommunityUserFromJson(Map<String, dynamic> json) {
  return _CommunityUser.fromJson(json);
}

/// @nodoc
mixin _$CommunityUser {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get verificationStatus => throw _privateConstructorUsedError;
  DateTime get registeredAt => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  List<String>? get interests => throw _privateConstructorUsedError;
  Map<String, dynamic>? get preferences => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isPremium => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommunityUserCopyWith<CommunityUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityUserCopyWith<$Res> {
  factory $CommunityUserCopyWith(
          CommunityUser value, $Res Function(CommunityUser) then) =
      _$CommunityUserCopyWithImpl<$Res, CommunityUser>;
  @useResult
  $Res call(
      {String id,
      String email,
      String displayName,
      String verificationStatus,
      DateTime registeredAt,
      String? profileImageUrl,
      String? bio,
      String? phoneNumber,
      List<String>? interests,
      Map<String, dynamic>? preferences,
      bool isActive,
      bool isPremium});
}

/// @nodoc
class _$CommunityUserCopyWithImpl<$Res, $Val extends CommunityUser>
    implements $CommunityUserCopyWith<$Res> {
  _$CommunityUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = null,
    Object? verificationStatus = null,
    Object? registeredAt = null,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? phoneNumber = freezed,
    Object? interests = freezed,
    Object? preferences = freezed,
    Object? isActive = null,
    Object? isPremium = null,
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
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      registeredAt: null == registeredAt
          ? _value.registeredAt
          : registeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      interests: freezed == interests
          ? _value.interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      preferences: freezed == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommunityUserImplCopyWith<$Res>
    implements $CommunityUserCopyWith<$Res> {
  factory _$$CommunityUserImplCopyWith(
          _$CommunityUserImpl value, $Res Function(_$CommunityUserImpl) then) =
      __$$CommunityUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String displayName,
      String verificationStatus,
      DateTime registeredAt,
      String? profileImageUrl,
      String? bio,
      String? phoneNumber,
      List<String>? interests,
      Map<String, dynamic>? preferences,
      bool isActive,
      bool isPremium});
}

/// @nodoc
class __$$CommunityUserImplCopyWithImpl<$Res>
    extends _$CommunityUserCopyWithImpl<$Res, _$CommunityUserImpl>
    implements _$$CommunityUserImplCopyWith<$Res> {
  __$$CommunityUserImplCopyWithImpl(
      _$CommunityUserImpl _value, $Res Function(_$CommunityUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = null,
    Object? verificationStatus = null,
    Object? registeredAt = null,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? phoneNumber = freezed,
    Object? interests = freezed,
    Object? preferences = freezed,
    Object? isActive = null,
    Object? isPremium = null,
  }) {
    return _then(_$CommunityUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String,
      registeredAt: null == registeredAt
          ? _value.registeredAt
          : registeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      interests: freezed == interests
          ? _value._interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      preferences: freezed == preferences
          ? _value._preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityUserImpl implements _CommunityUser {
  const _$CommunityUserImpl(
      {required this.id,
      required this.email,
      required this.displayName,
      required this.verificationStatus,
      required this.registeredAt,
      this.profileImageUrl,
      this.bio,
      this.phoneNumber,
      final List<String>? interests,
      final Map<String, dynamic>? preferences,
      this.isActive = true,
      this.isPremium = false})
      : _interests = interests,
        _preferences = preferences;

  factory _$CommunityUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityUserImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String displayName;
  @override
  final String verificationStatus;
  @override
  final DateTime registeredAt;
  @override
  final String? profileImageUrl;
  @override
  final String? bio;
  @override
  final String? phoneNumber;
  final List<String>? _interests;
  @override
  List<String>? get interests {
    final value = _interests;
    if (value == null) return null;
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _preferences;
  @override
  Map<String, dynamic>? get preferences {
    final value = _preferences;
    if (value == null) return null;
    if (_preferences is EqualUnmodifiableMapView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isPremium;

  @override
  String toString() {
    return 'CommunityUser(id: $id, email: $email, displayName: $displayName, verificationStatus: $verificationStatus, registeredAt: $registeredAt, profileImageUrl: $profileImageUrl, bio: $bio, phoneNumber: $phoneNumber, interests: $interests, preferences: $preferences, isActive: $isActive, isPremium: $isPremium)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.registeredAt, registeredAt) ||
                other.registeredAt == registeredAt) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            const DeepCollectionEquality()
                .equals(other._interests, _interests) &&
            const DeepCollectionEquality()
                .equals(other._preferences, _preferences) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      displayName,
      verificationStatus,
      registeredAt,
      profileImageUrl,
      bio,
      phoneNumber,
      const DeepCollectionEquality().hash(_interests),
      const DeepCollectionEquality().hash(_preferences),
      isActive,
      isPremium);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityUserImplCopyWith<_$CommunityUserImpl> get copyWith =>
      __$$CommunityUserImplCopyWithImpl<_$CommunityUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityUserImplToJson(
      this,
    );
  }
}

abstract class _CommunityUser implements CommunityUser {
  const factory _CommunityUser(
      {required final String id,
      required final String email,
      required final String displayName,
      required final String verificationStatus,
      required final DateTime registeredAt,
      final String? profileImageUrl,
      final String? bio,
      final String? phoneNumber,
      final List<String>? interests,
      final Map<String, dynamic>? preferences,
      final bool isActive,
      final bool isPremium}) = _$CommunityUserImpl;

  factory _CommunityUser.fromJson(Map<String, dynamic> json) =
      _$CommunityUserImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get displayName;
  @override
  String get verificationStatus;
  @override
  DateTime get registeredAt;
  @override
  String? get profileImageUrl;
  @override
  String? get bio;
  @override
  String? get phoneNumber;
  @override
  List<String>? get interests;
  @override
  Map<String, dynamic>? get preferences;
  @override
  bool get isActive;
  @override
  bool get isPremium;
  @override
  @JsonKey(ignore: true)
  _$$CommunityUserImplCopyWith<_$CommunityUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommunityGroup _$CommunityGroupFromJson(Map<String, dynamic> json) {
  return _CommunityGroup.fromJson(json);
}

/// @nodoc
mixin _$CommunityGroup {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  List<String>? get members => throw _privateConstructorUsedError;
  Map<String, dynamic>? get settings => throw _privateConstructorUsedError;
  int get memberCount => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommunityGroupCopyWith<CommunityGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityGroupCopyWith<$Res> {
  factory $CommunityGroupCopyWith(
          CommunityGroup value, $Res Function(CommunityGroup) then) =
      _$CommunityGroupCopyWithImpl<$Res, CommunityGroup>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String category,
      String createdBy,
      DateTime createdAt,
      String? imageUrl,
      List<String>? tags,
      List<String>? members,
      Map<String, dynamic>? settings,
      int memberCount,
      bool isPublic,
      bool isActive});
}

/// @nodoc
class _$CommunityGroupCopyWithImpl<$Res, $Val extends CommunityGroup>
    implements $CommunityGroupCopyWith<$Res> {
  _$CommunityGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? category = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? imageUrl = freezed,
    Object? tags = freezed,
    Object? members = freezed,
    Object? settings = freezed,
    Object? memberCount = null,
    Object? isPublic = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      members: freezed == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommunityGroupImplCopyWith<$Res>
    implements $CommunityGroupCopyWith<$Res> {
  factory _$$CommunityGroupImplCopyWith(_$CommunityGroupImpl value,
          $Res Function(_$CommunityGroupImpl) then) =
      __$$CommunityGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String category,
      String createdBy,
      DateTime createdAt,
      String? imageUrl,
      List<String>? tags,
      List<String>? members,
      Map<String, dynamic>? settings,
      int memberCount,
      bool isPublic,
      bool isActive});
}

/// @nodoc
class __$$CommunityGroupImplCopyWithImpl<$Res>
    extends _$CommunityGroupCopyWithImpl<$Res, _$CommunityGroupImpl>
    implements _$$CommunityGroupImplCopyWith<$Res> {
  __$$CommunityGroupImplCopyWithImpl(
      _$CommunityGroupImpl _value, $Res Function(_$CommunityGroupImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? category = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? imageUrl = freezed,
    Object? tags = freezed,
    Object? members = freezed,
    Object? settings = freezed,
    Object? memberCount = null,
    Object? isPublic = null,
    Object? isActive = null,
  }) {
    return _then(_$CommunityGroupImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      members: freezed == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      settings: freezed == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityGroupImpl implements _CommunityGroup {
  const _$CommunityGroupImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.category,
      required this.createdBy,
      required this.createdAt,
      this.imageUrl,
      final List<String>? tags,
      final List<String>? members,
      final Map<String, dynamic>? settings,
      this.memberCount = 0,
      this.isPublic = true,
      this.isActive = true})
      : _tags = tags,
        _members = members,
        _settings = settings;

  factory _$CommunityGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityGroupImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String category;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  @override
  final String? imageUrl;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _members;
  @override
  List<String>? get members {
    final value = _members;
    if (value == null) return null;
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _settings;
  @override
  Map<String, dynamic>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final int memberCount;
  @override
  @JsonKey()
  final bool isPublic;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'CommunityGroup(id: $id, name: $name, description: $description, category: $category, createdBy: $createdBy, createdAt: $createdAt, imageUrl: $imageUrl, tags: $tags, members: $members, settings: $settings, memberCount: $memberCount, isPublic: $isPublic, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      category,
      createdBy,
      createdAt,
      imageUrl,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_members),
      const DeepCollectionEquality().hash(_settings),
      memberCount,
      isPublic,
      isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityGroupImplCopyWith<_$CommunityGroupImpl> get copyWith =>
      __$$CommunityGroupImplCopyWithImpl<_$CommunityGroupImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityGroupImplToJson(
      this,
    );
  }
}

abstract class _CommunityGroup implements CommunityGroup {
  const factory _CommunityGroup(
      {required final String id,
      required final String name,
      required final String description,
      required final String category,
      required final String createdBy,
      required final DateTime createdAt,
      final String? imageUrl,
      final List<String>? tags,
      final List<String>? members,
      final Map<String, dynamic>? settings,
      final int memberCount,
      final bool isPublic,
      final bool isActive}) = _$CommunityGroupImpl;

  factory _CommunityGroup.fromJson(Map<String, dynamic> json) =
      _$CommunityGroupImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get category;
  @override
  String get createdBy;
  @override
  DateTime get createdAt;
  @override
  String? get imageUrl;
  @override
  List<String>? get tags;
  @override
  List<String>? get members;
  @override
  Map<String, dynamic>? get settings;
  @override
  int get memberCount;
  @override
  bool get isPublic;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$CommunityGroupImplCopyWith<_$CommunityGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommunityPost _$CommunityPostFromJson(Map<String, dynamic> json) {
  return _CommunityPost.fromJson(json);
}

/// @nodoc
mixin _$CommunityPost {
  String get id => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  List<String>? get attachments => throw _privateConstructorUsedError;
  Map<String, dynamic>? get location => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  int get shareCount => throw _privateConstructorUsedError;
  bool get isEdited => throw _privateConstructorUsedError;
  bool get isPinned => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommunityPostCopyWith<CommunityPost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityPostCopyWith<$Res> {
  factory $CommunityPostCopyWith(
          CommunityPost value, $Res Function(CommunityPost) then) =
      _$CommunityPostCopyWithImpl<$Res, CommunityPost>;
  @useResult
  $Res call(
      {String id,
      String authorId,
      String authorName,
      String content,
      String category,
      DateTime createdAt,
      String? groupId,
      String? imageUrl,
      List<String>? tags,
      List<String>? attachments,
      Map<String, dynamic>? location,
      int likeCount,
      int commentCount,
      int shareCount,
      bool isEdited,
      bool isPinned,
      bool isActive});
}

/// @nodoc
class _$CommunityPostCopyWithImpl<$Res, $Val extends CommunityPost>
    implements $CommunityPostCopyWith<$Res> {
  _$CommunityPostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? content = null,
    Object? category = null,
    Object? createdAt = null,
    Object? groupId = freezed,
    Object? imageUrl = freezed,
    Object? tags = freezed,
    Object? attachments = freezed,
    Object? location = freezed,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? shareCount = null,
    Object? isEdited = null,
    Object? isPinned = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      attachments: freezed == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      shareCount: null == shareCount
          ? _value.shareCount
          : shareCount // ignore: cast_nullable_to_non_nullable
              as int,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommunityPostImplCopyWith<$Res>
    implements $CommunityPostCopyWith<$Res> {
  factory _$$CommunityPostImplCopyWith(
          _$CommunityPostImpl value, $Res Function(_$CommunityPostImpl) then) =
      __$$CommunityPostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String authorId,
      String authorName,
      String content,
      String category,
      DateTime createdAt,
      String? groupId,
      String? imageUrl,
      List<String>? tags,
      List<String>? attachments,
      Map<String, dynamic>? location,
      int likeCount,
      int commentCount,
      int shareCount,
      bool isEdited,
      bool isPinned,
      bool isActive});
}

/// @nodoc
class __$$CommunityPostImplCopyWithImpl<$Res>
    extends _$CommunityPostCopyWithImpl<$Res, _$CommunityPostImpl>
    implements _$$CommunityPostImplCopyWith<$Res> {
  __$$CommunityPostImplCopyWithImpl(
      _$CommunityPostImpl _value, $Res Function(_$CommunityPostImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? content = null,
    Object? category = null,
    Object? createdAt = null,
    Object? groupId = freezed,
    Object? imageUrl = freezed,
    Object? tags = freezed,
    Object? attachments = freezed,
    Object? location = freezed,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? shareCount = null,
    Object? isEdited = null,
    Object? isPinned = null,
    Object? isActive = null,
  }) {
    return _then(_$CommunityPostImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      attachments: freezed == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      location: freezed == location
          ? _value._location
          : location // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      shareCount: null == shareCount
          ? _value.shareCount
          : shareCount // ignore: cast_nullable_to_non_nullable
              as int,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityPostImpl implements _CommunityPost {
  const _$CommunityPostImpl(
      {required this.id,
      required this.authorId,
      required this.authorName,
      required this.content,
      required this.category,
      required this.createdAt,
      this.groupId,
      this.imageUrl,
      final List<String>? tags,
      final List<String>? attachments,
      final Map<String, dynamic>? location,
      this.likeCount = 0,
      this.commentCount = 0,
      this.shareCount = 0,
      this.isEdited = false,
      this.isPinned = false,
      this.isActive = true})
      : _tags = tags,
        _attachments = attachments,
        _location = location;

  factory _$CommunityPostImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityPostImplFromJson(json);

  @override
  final String id;
  @override
  final String authorId;
  @override
  final String authorName;
  @override
  final String content;
  @override
  final String category;
  @override
  final DateTime createdAt;
  @override
  final String? groupId;
  @override
  final String? imageUrl;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _attachments;
  @override
  List<String>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _location;
  @override
  Map<String, dynamic>? get location {
    final value = _location;
    if (value == null) return null;
    if (_location is EqualUnmodifiableMapView) return _location;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final int likeCount;
  @override
  @JsonKey()
  final int commentCount;
  @override
  @JsonKey()
  final int shareCount;
  @override
  @JsonKey()
  final bool isEdited;
  @override
  @JsonKey()
  final bool isPinned;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'CommunityPost(id: $id, authorId: $authorId, authorName: $authorName, content: $content, category: $category, createdAt: $createdAt, groupId: $groupId, imageUrl: $imageUrl, tags: $tags, attachments: $attachments, location: $location, likeCount: $likeCount, commentCount: $commentCount, shareCount: $shareCount, isEdited: $isEdited, isPinned: $isPinned, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityPostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            const DeepCollectionEquality().equals(other._location, _location) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.shareCount, shareCount) ||
                other.shareCount == shareCount) &&
            (identical(other.isEdited, isEdited) ||
                other.isEdited == isEdited) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      authorId,
      authorName,
      content,
      category,
      createdAt,
      groupId,
      imageUrl,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_attachments),
      const DeepCollectionEquality().hash(_location),
      likeCount,
      commentCount,
      shareCount,
      isEdited,
      isPinned,
      isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityPostImplCopyWith<_$CommunityPostImpl> get copyWith =>
      __$$CommunityPostImplCopyWithImpl<_$CommunityPostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityPostImplToJson(
      this,
    );
  }
}

abstract class _CommunityPost implements CommunityPost {
  const factory _CommunityPost(
      {required final String id,
      required final String authorId,
      required final String authorName,
      required final String content,
      required final String category,
      required final DateTime createdAt,
      final String? groupId,
      final String? imageUrl,
      final List<String>? tags,
      final List<String>? attachments,
      final Map<String, dynamic>? location,
      final int likeCount,
      final int commentCount,
      final int shareCount,
      final bool isEdited,
      final bool isPinned,
      final bool isActive}) = _$CommunityPostImpl;

  factory _CommunityPost.fromJson(Map<String, dynamic> json) =
      _$CommunityPostImpl.fromJson;

  @override
  String get id;
  @override
  String get authorId;
  @override
  String get authorName;
  @override
  String get content;
  @override
  String get category;
  @override
  DateTime get createdAt;
  @override
  String? get groupId;
  @override
  String? get imageUrl;
  @override
  List<String>? get tags;
  @override
  List<String>? get attachments;
  @override
  Map<String, dynamic>? get location;
  @override
  int get likeCount;
  @override
  int get commentCount;
  @override
  int get shareCount;
  @override
  bool get isEdited;
  @override
  bool get isPinned;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$CommunityPostImplCopyWith<_$CommunityPostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommunityMessage _$CommunityMessageFromJson(Map<String, dynamic> json) {
  return _CommunityMessage.fromJson(json);
}

/// @nodoc
mixin _$CommunityMessage {
  String get id => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get sentAt => throw _privateConstructorUsedError;
  String? get recipientId => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;
  String? get replyToId => throw _privateConstructorUsedError;
  List<String>? get attachments => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  String get messageType => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  bool get isDelivered => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommunityMessageCopyWith<CommunityMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityMessageCopyWith<$Res> {
  factory $CommunityMessageCopyWith(
          CommunityMessage value, $Res Function(CommunityMessage) then) =
      _$CommunityMessageCopyWithImpl<$Res, CommunityMessage>;
  @useResult
  $Res call(
      {String id,
      String senderId,
      String senderName,
      String content,
      DateTime sentAt,
      String? recipientId,
      String? groupId,
      String? replyToId,
      List<String>? attachments,
      Map<String, dynamic>? metadata,
      String messageType,
      bool isRead,
      bool isDelivered,
      bool isActive});
}

/// @nodoc
class _$CommunityMessageCopyWithImpl<$Res, $Val extends CommunityMessage>
    implements $CommunityMessageCopyWith<$Res> {
  _$CommunityMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? content = null,
    Object? sentAt = null,
    Object? recipientId = freezed,
    Object? groupId = freezed,
    Object? replyToId = freezed,
    Object? attachments = freezed,
    Object? metadata = freezed,
    Object? messageType = null,
    Object? isRead = null,
    Object? isDelivered = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      recipientId: freezed == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String?,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      replyToId: freezed == replyToId
          ? _value.replyToId
          : replyToId // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: freezed == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isDelivered: null == isDelivered
          ? _value.isDelivered
          : isDelivered // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommunityMessageImplCopyWith<$Res>
    implements $CommunityMessageCopyWith<$Res> {
  factory _$$CommunityMessageImplCopyWith(_$CommunityMessageImpl value,
          $Res Function(_$CommunityMessageImpl) then) =
      __$$CommunityMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String senderId,
      String senderName,
      String content,
      DateTime sentAt,
      String? recipientId,
      String? groupId,
      String? replyToId,
      List<String>? attachments,
      Map<String, dynamic>? metadata,
      String messageType,
      bool isRead,
      bool isDelivered,
      bool isActive});
}

/// @nodoc
class __$$CommunityMessageImplCopyWithImpl<$Res>
    extends _$CommunityMessageCopyWithImpl<$Res, _$CommunityMessageImpl>
    implements _$$CommunityMessageImplCopyWith<$Res> {
  __$$CommunityMessageImplCopyWithImpl(_$CommunityMessageImpl _value,
      $Res Function(_$CommunityMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? content = null,
    Object? sentAt = null,
    Object? recipientId = freezed,
    Object? groupId = freezed,
    Object? replyToId = freezed,
    Object? attachments = freezed,
    Object? metadata = freezed,
    Object? messageType = null,
    Object? isRead = null,
    Object? isDelivered = null,
    Object? isActive = null,
  }) {
    return _then(_$CommunityMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      recipientId: freezed == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String?,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      replyToId: freezed == replyToId
          ? _value.replyToId
          : replyToId // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: freezed == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isDelivered: null == isDelivered
          ? _value.isDelivered
          : isDelivered // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityMessageImpl implements _CommunityMessage {
  const _$CommunityMessageImpl(
      {required this.id,
      required this.senderId,
      required this.senderName,
      required this.content,
      required this.sentAt,
      this.recipientId,
      this.groupId,
      this.replyToId,
      final List<String>? attachments,
      final Map<String, dynamic>? metadata,
      this.messageType = 'text',
      this.isRead = false,
      this.isDelivered = false,
      this.isActive = true})
      : _attachments = attachments,
        _metadata = metadata;

  factory _$CommunityMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String senderId;
  @override
  final String senderName;
  @override
  final String content;
  @override
  final DateTime sentAt;
  @override
  final String? recipientId;
  @override
  final String? groupId;
  @override
  final String? replyToId;
  final List<String>? _attachments;
  @override
  List<String>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final String messageType;
  @override
  @JsonKey()
  final bool isRead;
  @override
  @JsonKey()
  final bool isDelivered;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'CommunityMessage(id: $id, senderId: $senderId, senderName: $senderName, content: $content, sentAt: $sentAt, recipientId: $recipientId, groupId: $groupId, replyToId: $replyToId, attachments: $attachments, metadata: $metadata, messageType: $messageType, isRead: $isRead, isDelivered: $isDelivered, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.replyToId, replyToId) ||
                other.replyToId == replyToId) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isDelivered, isDelivered) ||
                other.isDelivered == isDelivered) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      senderId,
      senderName,
      content,
      sentAt,
      recipientId,
      groupId,
      replyToId,
      const DeepCollectionEquality().hash(_attachments),
      const DeepCollectionEquality().hash(_metadata),
      messageType,
      isRead,
      isDelivered,
      isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityMessageImplCopyWith<_$CommunityMessageImpl> get copyWith =>
      __$$CommunityMessageImplCopyWithImpl<_$CommunityMessageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityMessageImplToJson(
      this,
    );
  }
}

abstract class _CommunityMessage implements CommunityMessage {
  const factory _CommunityMessage(
      {required final String id,
      required final String senderId,
      required final String senderName,
      required final String content,
      required final DateTime sentAt,
      final String? recipientId,
      final String? groupId,
      final String? replyToId,
      final List<String>? attachments,
      final Map<String, dynamic>? metadata,
      final String messageType,
      final bool isRead,
      final bool isDelivered,
      final bool isActive}) = _$CommunityMessageImpl;

  factory _CommunityMessage.fromJson(Map<String, dynamic> json) =
      _$CommunityMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get senderId;
  @override
  String get senderName;
  @override
  String get content;
  @override
  DateTime get sentAt;
  @override
  String? get recipientId;
  @override
  String? get groupId;
  @override
  String? get replyToId;
  @override
  List<String>? get attachments;
  @override
  Map<String, dynamic>? get metadata;
  @override
  String get messageType;
  @override
  bool get isRead;
  @override
  bool get isDelivered;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$CommunityMessageImplCopyWith<_$CommunityMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommunityEvent _$CommunityEventFromJson(Map<String, dynamic> json) {
  return _CommunityEvent.fromJson(json);
}

/// @nodoc
mixin _$CommunityEvent {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get organizerId => throw _privateConstructorUsedError;
  String get organizerName => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  List<String>? get attendees => throw _privateConstructorUsedError;
  Map<String, dynamic>? get details => throw _privateConstructorUsedError;
  String get visibility => throw _privateConstructorUsedError;
  int get maxAttendees => throw _privateConstructorUsedError;
  int get currentAttendees => throw _privateConstructorUsedError;
  bool get requiresApproval => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommunityEventCopyWith<CommunityEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityEventCopyWith<$Res> {
  factory $CommunityEventCopyWith(
          CommunityEvent value, $Res Function(CommunityEvent) then) =
      _$CommunityEventCopyWithImpl<$Res, CommunityEvent>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String organizerId,
      String organizerName,
      DateTime startDate,
      DateTime endDate,
      String location,
      String? imageUrl,
      List<String>? tags,
      List<String>? attendees,
      Map<String, dynamic>? details,
      String visibility,
      int maxAttendees,
      int currentAttendees,
      bool requiresApproval,
      bool isActive});
}

/// @nodoc
class _$CommunityEventCopyWithImpl<$Res, $Val extends CommunityEvent>
    implements $CommunityEventCopyWith<$Res> {
  _$CommunityEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? organizerId = null,
    Object? organizerName = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? location = null,
    Object? imageUrl = freezed,
    Object? tags = freezed,
    Object? attendees = freezed,
    Object? details = freezed,
    Object? visibility = null,
    Object? maxAttendees = null,
    Object? currentAttendees = null,
    Object? requiresApproval = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      organizerId: null == organizerId
          ? _value.organizerId
          : organizerId // ignore: cast_nullable_to_non_nullable
              as String,
      organizerName: null == organizerName
          ? _value.organizerName
          : organizerName // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      attendees: freezed == attendees
          ? _value.attendees
          : attendees // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String,
      maxAttendees: null == maxAttendees
          ? _value.maxAttendees
          : maxAttendees // ignore: cast_nullable_to_non_nullable
              as int,
      currentAttendees: null == currentAttendees
          ? _value.currentAttendees
          : currentAttendees // ignore: cast_nullable_to_non_nullable
              as int,
      requiresApproval: null == requiresApproval
          ? _value.requiresApproval
          : requiresApproval // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommunityEventImplCopyWith<$Res>
    implements $CommunityEventCopyWith<$Res> {
  factory _$$CommunityEventImplCopyWith(_$CommunityEventImpl value,
          $Res Function(_$CommunityEventImpl) then) =
      __$$CommunityEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String organizerId,
      String organizerName,
      DateTime startDate,
      DateTime endDate,
      String location,
      String? imageUrl,
      List<String>? tags,
      List<String>? attendees,
      Map<String, dynamic>? details,
      String visibility,
      int maxAttendees,
      int currentAttendees,
      bool requiresApproval,
      bool isActive});
}

/// @nodoc
class __$$CommunityEventImplCopyWithImpl<$Res>
    extends _$CommunityEventCopyWithImpl<$Res, _$CommunityEventImpl>
    implements _$$CommunityEventImplCopyWith<$Res> {
  __$$CommunityEventImplCopyWithImpl(
      _$CommunityEventImpl _value, $Res Function(_$CommunityEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? organizerId = null,
    Object? organizerName = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? location = null,
    Object? imageUrl = freezed,
    Object? tags = freezed,
    Object? attendees = freezed,
    Object? details = freezed,
    Object? visibility = null,
    Object? maxAttendees = null,
    Object? currentAttendees = null,
    Object? requiresApproval = null,
    Object? isActive = null,
  }) {
    return _then(_$CommunityEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      organizerId: null == organizerId
          ? _value.organizerId
          : organizerId // ignore: cast_nullable_to_non_nullable
              as String,
      organizerName: null == organizerName
          ? _value.organizerName
          : organizerName // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      attendees: freezed == attendees
          ? _value._attendees
          : attendees // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      details: freezed == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String,
      maxAttendees: null == maxAttendees
          ? _value.maxAttendees
          : maxAttendees // ignore: cast_nullable_to_non_nullable
              as int,
      currentAttendees: null == currentAttendees
          ? _value.currentAttendees
          : currentAttendees // ignore: cast_nullable_to_non_nullable
              as int,
      requiresApproval: null == requiresApproval
          ? _value.requiresApproval
          : requiresApproval // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityEventImpl implements _CommunityEvent {
  const _$CommunityEventImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.organizerId,
      required this.organizerName,
      required this.startDate,
      required this.endDate,
      required this.location,
      this.imageUrl,
      final List<String>? tags,
      final List<String>? attendees,
      final Map<String, dynamic>? details,
      this.visibility = 'public',
      this.maxAttendees = 0,
      this.currentAttendees = 0,
      this.requiresApproval = false,
      this.isActive = true})
      : _tags = tags,
        _attendees = attendees,
        _details = details;

  factory _$CommunityEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityEventImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String organizerId;
  @override
  final String organizerName;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final String location;
  @override
  final String? imageUrl;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _attendees;
  @override
  List<String>? get attendees {
    final value = _attendees;
    if (value == null) return null;
    if (_attendees is EqualUnmodifiableListView) return _attendees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _details;
  @override
  Map<String, dynamic>? get details {
    final value = _details;
    if (value == null) return null;
    if (_details is EqualUnmodifiableMapView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final String visibility;
  @override
  @JsonKey()
  final int maxAttendees;
  @override
  @JsonKey()
  final int currentAttendees;
  @override
  @JsonKey()
  final bool requiresApproval;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'CommunityEvent(id: $id, title: $title, description: $description, organizerId: $organizerId, organizerName: $organizerName, startDate: $startDate, endDate: $endDate, location: $location, imageUrl: $imageUrl, tags: $tags, attendees: $attendees, details: $details, visibility: $visibility, maxAttendees: $maxAttendees, currentAttendees: $currentAttendees, requiresApproval: $requiresApproval, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.organizerId, organizerId) ||
                other.organizerId == organizerId) &&
            (identical(other.organizerName, organizerName) ||
                other.organizerName == organizerName) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._attendees, _attendees) &&
            const DeepCollectionEquality().equals(other._details, _details) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.maxAttendees, maxAttendees) ||
                other.maxAttendees == maxAttendees) &&
            (identical(other.currentAttendees, currentAttendees) ||
                other.currentAttendees == currentAttendees) &&
            (identical(other.requiresApproval, requiresApproval) ||
                other.requiresApproval == requiresApproval) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      organizerId,
      organizerName,
      startDate,
      endDate,
      location,
      imageUrl,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_attendees),
      const DeepCollectionEquality().hash(_details),
      visibility,
      maxAttendees,
      currentAttendees,
      requiresApproval,
      isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityEventImplCopyWith<_$CommunityEventImpl> get copyWith =>
      __$$CommunityEventImplCopyWithImpl<_$CommunityEventImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityEventImplToJson(
      this,
    );
  }
}

abstract class _CommunityEvent implements CommunityEvent {
  const factory _CommunityEvent(
      {required final String id,
      required final String title,
      required final String description,
      required final String organizerId,
      required final String organizerName,
      required final DateTime startDate,
      required final DateTime endDate,
      required final String location,
      final String? imageUrl,
      final List<String>? tags,
      final List<String>? attendees,
      final Map<String, dynamic>? details,
      final String visibility,
      final int maxAttendees,
      final int currentAttendees,
      final bool requiresApproval,
      final bool isActive}) = _$CommunityEventImpl;

  factory _CommunityEvent.fromJson(Map<String, dynamic> json) =
      _$CommunityEventImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get organizerId;
  @override
  String get organizerName;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  String get location;
  @override
  String? get imageUrl;
  @override
  List<String>? get tags;
  @override
  List<String>? get attendees;
  @override
  Map<String, dynamic>? get details;
  @override
  String get visibility;
  @override
  int get maxAttendees;
  @override
  int get currentAttendees;
  @override
  bool get requiresApproval;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$CommunityEventImplCopyWith<_$CommunityEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MarketplaceListing _$MarketplaceListingFromJson(Map<String, dynamic> json) {
  return _MarketplaceListing.fromJson(json);
}

/// @nodoc
mixin _$MarketplaceListing {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get sellerId => throw _privateConstructorUsedError;
  String get sellerName => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get condition => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  Map<String, dynamic>? get specifications =>
      throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get contactMethod => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get isNegotiable => throw _privateConstructorUsedError;
  bool get isHighlighted => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MarketplaceListingCopyWith<MarketplaceListing> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketplaceListingCopyWith<$Res> {
  factory $MarketplaceListingCopyWith(
          MarketplaceListing value, $Res Function(MarketplaceListing) then) =
      _$MarketplaceListingCopyWithImpl<$Res, MarketplaceListing>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String sellerId,
      String sellerName,
      double price,
      String category,
      String condition,
      DateTime createdAt,
      List<String>? images,
      List<String>? tags,
      Map<String, dynamic>? specifications,
      String? location,
      String? contactMethod,
      String currency,
      String status,
      bool isNegotiable,
      bool isHighlighted,
      bool isActive});
}

/// @nodoc
class _$MarketplaceListingCopyWithImpl<$Res, $Val extends MarketplaceListing>
    implements $MarketplaceListingCopyWith<$Res> {
  _$MarketplaceListingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? sellerId = null,
    Object? sellerName = null,
    Object? price = null,
    Object? category = null,
    Object? condition = null,
    Object? createdAt = null,
    Object? images = freezed,
    Object? tags = freezed,
    Object? specifications = freezed,
    Object? location = freezed,
    Object? contactMethod = freezed,
    Object? currency = null,
    Object? status = null,
    Object? isNegotiable = null,
    Object? isHighlighted = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      sellerName: null == sellerName
          ? _value.sellerName
          : sellerName // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      specifications: freezed == specifications
          ? _value.specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      contactMethod: freezed == contactMethod
          ? _value.contactMethod
          : contactMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isNegotiable: null == isNegotiable
          ? _value.isNegotiable
          : isNegotiable // ignore: cast_nullable_to_non_nullable
              as bool,
      isHighlighted: null == isHighlighted
          ? _value.isHighlighted
          : isHighlighted // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarketplaceListingImplCopyWith<$Res>
    implements $MarketplaceListingCopyWith<$Res> {
  factory _$$MarketplaceListingImplCopyWith(_$MarketplaceListingImpl value,
          $Res Function(_$MarketplaceListingImpl) then) =
      __$$MarketplaceListingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String sellerId,
      String sellerName,
      double price,
      String category,
      String condition,
      DateTime createdAt,
      List<String>? images,
      List<String>? tags,
      Map<String, dynamic>? specifications,
      String? location,
      String? contactMethod,
      String currency,
      String status,
      bool isNegotiable,
      bool isHighlighted,
      bool isActive});
}

/// @nodoc
class __$$MarketplaceListingImplCopyWithImpl<$Res>
    extends _$MarketplaceListingCopyWithImpl<$Res, _$MarketplaceListingImpl>
    implements _$$MarketplaceListingImplCopyWith<$Res> {
  __$$MarketplaceListingImplCopyWithImpl(_$MarketplaceListingImpl _value,
      $Res Function(_$MarketplaceListingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? sellerId = null,
    Object? sellerName = null,
    Object? price = null,
    Object? category = null,
    Object? condition = null,
    Object? createdAt = null,
    Object? images = freezed,
    Object? tags = freezed,
    Object? specifications = freezed,
    Object? location = freezed,
    Object? contactMethod = freezed,
    Object? currency = null,
    Object? status = null,
    Object? isNegotiable = null,
    Object? isHighlighted = null,
    Object? isActive = null,
  }) {
    return _then(_$MarketplaceListingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      sellerName: null == sellerName
          ? _value.sellerName
          : sellerName // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      specifications: freezed == specifications
          ? _value._specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      contactMethod: freezed == contactMethod
          ? _value.contactMethod
          : contactMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isNegotiable: null == isNegotiable
          ? _value.isNegotiable
          : isNegotiable // ignore: cast_nullable_to_non_nullable
              as bool,
      isHighlighted: null == isHighlighted
          ? _value.isHighlighted
          : isHighlighted // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketplaceListingImpl implements _MarketplaceListing {
  const _$MarketplaceListingImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.sellerId,
      required this.sellerName,
      required this.price,
      required this.category,
      required this.condition,
      required this.createdAt,
      final List<String>? images,
      final List<String>? tags,
      final Map<String, dynamic>? specifications,
      this.location,
      this.contactMethod,
      this.currency = 'EUR',
      this.status = 'available',
      this.isNegotiable = false,
      this.isHighlighted = false,
      this.isActive = true})
      : _images = images,
        _tags = tags,
        _specifications = specifications;

  factory _$MarketplaceListingImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketplaceListingImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String sellerId;
  @override
  final String sellerName;
  @override
  final double price;
  @override
  final String category;
  @override
  final String condition;
  @override
  final DateTime createdAt;
  final List<String>? _images;
  @override
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _specifications;
  @override
  Map<String, dynamic>? get specifications {
    final value = _specifications;
    if (value == null) return null;
    if (_specifications is EqualUnmodifiableMapView) return _specifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? location;
  @override
  final String? contactMethod;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final bool isNegotiable;
  @override
  @JsonKey()
  final bool isHighlighted;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'MarketplaceListing(id: $id, title: $title, description: $description, sellerId: $sellerId, sellerName: $sellerName, price: $price, category: $category, condition: $condition, createdAt: $createdAt, images: $images, tags: $tags, specifications: $specifications, location: $location, contactMethod: $contactMethod, currency: $currency, status: $status, isNegotiable: $isNegotiable, isHighlighted: $isHighlighted, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketplaceListingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.sellerName, sellerName) ||
                other.sellerName == sellerName) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._specifications, _specifications) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.contactMethod, contactMethod) ||
                other.contactMethod == contactMethod) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isNegotiable, isNegotiable) ||
                other.isNegotiable == isNegotiable) &&
            (identical(other.isHighlighted, isHighlighted) ||
                other.isHighlighted == isHighlighted) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        description,
        sellerId,
        sellerName,
        price,
        category,
        condition,
        createdAt,
        const DeepCollectionEquality().hash(_images),
        const DeepCollectionEquality().hash(_tags),
        const DeepCollectionEquality().hash(_specifications),
        location,
        contactMethod,
        currency,
        status,
        isNegotiable,
        isHighlighted,
        isActive
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketplaceListingImplCopyWith<_$MarketplaceListingImpl> get copyWith =>
      __$$MarketplaceListingImplCopyWithImpl<_$MarketplaceListingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketplaceListingImplToJson(
      this,
    );
  }
}

abstract class _MarketplaceListing implements MarketplaceListing {
  const factory _MarketplaceListing(
      {required final String id,
      required final String title,
      required final String description,
      required final String sellerId,
      required final String sellerName,
      required final double price,
      required final String category,
      required final String condition,
      required final DateTime createdAt,
      final List<String>? images,
      final List<String>? tags,
      final Map<String, dynamic>? specifications,
      final String? location,
      final String? contactMethod,
      final String currency,
      final String status,
      final bool isNegotiable,
      final bool isHighlighted,
      final bool isActive}) = _$MarketplaceListingImpl;

  factory _MarketplaceListing.fromJson(Map<String, dynamic> json) =
      _$MarketplaceListingImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get sellerId;
  @override
  String get sellerName;
  @override
  double get price;
  @override
  String get category;
  @override
  String get condition;
  @override
  DateTime get createdAt;
  @override
  List<String>? get images;
  @override
  List<String>? get tags;
  @override
  Map<String, dynamic>? get specifications;
  @override
  String? get location;
  @override
  String? get contactMethod;
  @override
  String get currency;
  @override
  String get status;
  @override
  bool get isNegotiable;
  @override
  bool get isHighlighted;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$MarketplaceListingImplCopyWith<_$MarketplaceListingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommunityComment _$CommunityCommentFromJson(Map<String, dynamic> json) {
  return _CommunityComment.fromJson(json);
}

/// @nodoc
mixin _$CommunityComment {
  String get id => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get parentCommentId => throw _privateConstructorUsedError;
  List<String>? get attachments => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  int get replyCount => throw _privateConstructorUsedError;
  bool get isEdited => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommunityCommentCopyWith<CommunityComment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityCommentCopyWith<$Res> {
  factory $CommunityCommentCopyWith(
          CommunityComment value, $Res Function(CommunityComment) then) =
      _$CommunityCommentCopyWithImpl<$Res, CommunityComment>;
  @useResult
  $Res call(
      {String id,
      String postId,
      String authorId,
      String authorName,
      String content,
      DateTime createdAt,
      String? parentCommentId,
      List<String>? attachments,
      int likeCount,
      int replyCount,
      bool isEdited,
      bool isActive});
}

/// @nodoc
class _$CommunityCommentCopyWithImpl<$Res, $Val extends CommunityComment>
    implements $CommunityCommentCopyWith<$Res> {
  _$CommunityCommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? content = null,
    Object? createdAt = null,
    Object? parentCommentId = freezed,
    Object? attachments = freezed,
    Object? likeCount = null,
    Object? replyCount = null,
    Object? isEdited = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: freezed == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      replyCount: null == replyCount
          ? _value.replyCount
          : replyCount // ignore: cast_nullable_to_non_nullable
              as int,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommunityCommentImplCopyWith<$Res>
    implements $CommunityCommentCopyWith<$Res> {
  factory _$$CommunityCommentImplCopyWith(_$CommunityCommentImpl value,
          $Res Function(_$CommunityCommentImpl) then) =
      __$$CommunityCommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String postId,
      String authorId,
      String authorName,
      String content,
      DateTime createdAt,
      String? parentCommentId,
      List<String>? attachments,
      int likeCount,
      int replyCount,
      bool isEdited,
      bool isActive});
}

/// @nodoc
class __$$CommunityCommentImplCopyWithImpl<$Res>
    extends _$CommunityCommentCopyWithImpl<$Res, _$CommunityCommentImpl>
    implements _$$CommunityCommentImplCopyWith<$Res> {
  __$$CommunityCommentImplCopyWithImpl(_$CommunityCommentImpl _value,
      $Res Function(_$CommunityCommentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? content = null,
    Object? createdAt = null,
    Object? parentCommentId = freezed,
    Object? attachments = freezed,
    Object? likeCount = null,
    Object? replyCount = null,
    Object? isEdited = null,
    Object? isActive = null,
  }) {
    return _then(_$CommunityCommentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: freezed == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      replyCount: null == replyCount
          ? _value.replyCount
          : replyCount // ignore: cast_nullable_to_non_nullable
              as int,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityCommentImpl implements _CommunityComment {
  const _$CommunityCommentImpl(
      {required this.id,
      required this.postId,
      required this.authorId,
      required this.authorName,
      required this.content,
      required this.createdAt,
      this.parentCommentId,
      final List<String>? attachments,
      this.likeCount = 0,
      this.replyCount = 0,
      this.isEdited = false,
      this.isActive = true})
      : _attachments = attachments;

  factory _$CommunityCommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityCommentImplFromJson(json);

  @override
  final String id;
  @override
  final String postId;
  @override
  final String authorId;
  @override
  final String authorName;
  @override
  final String content;
  @override
  final DateTime createdAt;
  @override
  final String? parentCommentId;
  final List<String>? _attachments;
  @override
  List<String>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final int likeCount;
  @override
  @JsonKey()
  final int replyCount;
  @override
  @JsonKey()
  final bool isEdited;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'CommunityComment(id: $id, postId: $postId, authorId: $authorId, authorName: $authorName, content: $content, createdAt: $createdAt, parentCommentId: $parentCommentId, attachments: $attachments, likeCount: $likeCount, replyCount: $replyCount, isEdited: $isEdited, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityCommentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.parentCommentId, parentCommentId) ||
                other.parentCommentId == parentCommentId) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.replyCount, replyCount) ||
                other.replyCount == replyCount) &&
            (identical(other.isEdited, isEdited) ||
                other.isEdited == isEdited) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      postId,
      authorId,
      authorName,
      content,
      createdAt,
      parentCommentId,
      const DeepCollectionEquality().hash(_attachments),
      likeCount,
      replyCount,
      isEdited,
      isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityCommentImplCopyWith<_$CommunityCommentImpl> get copyWith =>
      __$$CommunityCommentImplCopyWithImpl<_$CommunityCommentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityCommentImplToJson(
      this,
    );
  }
}

abstract class _CommunityComment implements CommunityComment {
  const factory _CommunityComment(
      {required final String id,
      required final String postId,
      required final String authorId,
      required final String authorName,
      required final String content,
      required final DateTime createdAt,
      final String? parentCommentId,
      final List<String>? attachments,
      final int likeCount,
      final int replyCount,
      final bool isEdited,
      final bool isActive}) = _$CommunityCommentImpl;

  factory _CommunityComment.fromJson(Map<String, dynamic> json) =
      _$CommunityCommentImpl.fromJson;

  @override
  String get id;
  @override
  String get postId;
  @override
  String get authorId;
  @override
  String get authorName;
  @override
  String get content;
  @override
  DateTime get createdAt;
  @override
  String? get parentCommentId;
  @override
  List<String>? get attachments;
  @override
  int get likeCount;
  @override
  int get replyCount;
  @override
  bool get isEdited;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$CommunityCommentImplCopyWith<_$CommunityCommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommunityNotification _$CommunityNotificationFromJson(
    Map<String, dynamic> json) {
  return _CommunityNotification.fromJson(json);
}

/// @nodoc
mixin _$CommunityNotification {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get actionUrl => throw _privateConstructorUsedError;
  String? get relatedId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommunityNotificationCopyWith<CommunityNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityNotificationCopyWith<$Res> {
  factory $CommunityNotificationCopyWith(CommunityNotification value,
          $Res Function(CommunityNotification) then) =
      _$CommunityNotificationCopyWithImpl<$Res, CommunityNotification>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String type,
      String title,
      String message,
      DateTime createdAt,
      String? actionUrl,
      String? relatedId,
      Map<String, dynamic>? data,
      String priority,
      bool isRead,
      bool isActive});
}

/// @nodoc
class _$CommunityNotificationCopyWithImpl<$Res,
        $Val extends CommunityNotification>
    implements $CommunityNotificationCopyWith<$Res> {
  _$CommunityNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? message = null,
    Object? createdAt = null,
    Object? actionUrl = freezed,
    Object? relatedId = freezed,
    Object? data = freezed,
    Object? priority = null,
    Object? isRead = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedId: freezed == relatedId
          ? _value.relatedId
          : relatedId // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommunityNotificationImplCopyWith<$Res>
    implements $CommunityNotificationCopyWith<$Res> {
  factory _$$CommunityNotificationImplCopyWith(
          _$CommunityNotificationImpl value,
          $Res Function(_$CommunityNotificationImpl) then) =
      __$$CommunityNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String type,
      String title,
      String message,
      DateTime createdAt,
      String? actionUrl,
      String? relatedId,
      Map<String, dynamic>? data,
      String priority,
      bool isRead,
      bool isActive});
}

/// @nodoc
class __$$CommunityNotificationImplCopyWithImpl<$Res>
    extends _$CommunityNotificationCopyWithImpl<$Res,
        _$CommunityNotificationImpl>
    implements _$$CommunityNotificationImplCopyWith<$Res> {
  __$$CommunityNotificationImplCopyWithImpl(_$CommunityNotificationImpl _value,
      $Res Function(_$CommunityNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? message = null,
    Object? createdAt = null,
    Object? actionUrl = freezed,
    Object? relatedId = freezed,
    Object? data = freezed,
    Object? priority = null,
    Object? isRead = null,
    Object? isActive = null,
  }) {
    return _then(_$CommunityNotificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedId: freezed == relatedId
          ? _value.relatedId
          : relatedId // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityNotificationImpl implements _CommunityNotification {
  const _$CommunityNotificationImpl(
      {required this.id,
      required this.userId,
      required this.type,
      required this.title,
      required this.message,
      required this.createdAt,
      this.actionUrl,
      this.relatedId,
      final Map<String, dynamic>? data,
      this.priority = 'info',
      this.isRead = false,
      this.isActive = true})
      : _data = data;

  factory _$CommunityNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityNotificationImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String type;
  @override
  final String title;
  @override
  final String message;
  @override
  final DateTime createdAt;
  @override
  final String? actionUrl;
  @override
  final String? relatedId;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final String priority;
  @override
  @JsonKey()
  final bool isRead;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'CommunityNotification(id: $id, userId: $userId, type: $type, title: $title, message: $message, createdAt: $createdAt, actionUrl: $actionUrl, relatedId: $relatedId, data: $data, priority: $priority, isRead: $isRead, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            (identical(other.relatedId, relatedId) ||
                other.relatedId == relatedId) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      type,
      title,
      message,
      createdAt,
      actionUrl,
      relatedId,
      const DeepCollectionEquality().hash(_data),
      priority,
      isRead,
      isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityNotificationImplCopyWith<_$CommunityNotificationImpl>
      get copyWith => __$$CommunityNotificationImplCopyWithImpl<
          _$CommunityNotificationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityNotificationImplToJson(
      this,
    );
  }
}

abstract class _CommunityNotification implements CommunityNotification {
  const factory _CommunityNotification(
      {required final String id,
      required final String userId,
      required final String type,
      required final String title,
      required final String message,
      required final DateTime createdAt,
      final String? actionUrl,
      final String? relatedId,
      final Map<String, dynamic>? data,
      final String priority,
      final bool isRead,
      final bool isActive}) = _$CommunityNotificationImpl;

  factory _CommunityNotification.fromJson(Map<String, dynamic> json) =
      _$CommunityNotificationImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get type;
  @override
  String get title;
  @override
  String get message;
  @override
  DateTime get createdAt;
  @override
  String? get actionUrl;
  @override
  String? get relatedId;
  @override
  Map<String, dynamic>? get data;
  @override
  String get priority;
  @override
  bool get isRead;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$CommunityNotificationImplCopyWith<_$CommunityNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
