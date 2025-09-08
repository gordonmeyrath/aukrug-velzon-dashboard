// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Report _$ReportFromJson(Map<String, dynamic> json) {
  return _Report.fromJson(json);
}

/// @nodoc
mixin _$Report {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  ReportCategory get category => throw _privateConstructorUsedError;
  ReportPriority get priority => throw _privateConstructorUsedError;
  ReportStatus get status => throw _privateConstructorUsedError;
  ReportLocation get location => throw _privateConstructorUsedError;
  List<String>? get imageUrls => throw _privateConstructorUsedError;
  String? get contactName => throw _privateConstructorUsedError;
  String? get contactEmail => throw _privateConstructorUsedError;
  String? get contactPhone => throw _privateConstructorUsedError;
  bool get isAnonymous => throw _privateConstructorUsedError;
  DateTime? get submittedAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get municipalityResponse => throw _privateConstructorUsedError;
  DateTime? get responseAt => throw _privateConstructorUsedError;
  String? get referenceNumber => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReportCopyWith<Report> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportCopyWith<$Res> {
  factory $ReportCopyWith(Report value, $Res Function(Report) then) =
      _$ReportCopyWithImpl<$Res, Report>;
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      ReportCategory category,
      ReportPriority priority,
      ReportStatus status,
      ReportLocation location,
      List<String>? imageUrls,
      String? contactName,
      String? contactEmail,
      String? contactPhone,
      bool isAnonymous,
      DateTime? submittedAt,
      DateTime? updatedAt,
      String? municipalityResponse,
      DateTime? responseAt,
      String? referenceNumber,
      int version});

  $ReportLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$ReportCopyWithImpl<$Res, $Val extends Report>
    implements $ReportCopyWith<$Res> {
  _$ReportCopyWithImpl(this._value, this._then);

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
    Object? category = null,
    Object? priority = null,
    Object? status = null,
    Object? location = null,
    Object? imageUrls = freezed,
    Object? contactName = freezed,
    Object? contactEmail = freezed,
    Object? contactPhone = freezed,
    Object? isAnonymous = null,
    Object? submittedAt = freezed,
    Object? updatedAt = freezed,
    Object? municipalityResponse = freezed,
    Object? responseAt = freezed,
    Object? referenceNumber = freezed,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ReportCategory,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as ReportPriority,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReportStatus,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as ReportLocation,
      imageUrls: freezed == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      contactName: freezed == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      submittedAt: freezed == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      municipalityResponse: freezed == municipalityResponse
          ? _value.municipalityResponse
          : municipalityResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      responseAt: freezed == responseAt
          ? _value.responseAt
          : responseAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      referenceNumber: freezed == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ReportLocationCopyWith<$Res> get location {
    return $ReportLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReportImplCopyWith<$Res> implements $ReportCopyWith<$Res> {
  factory _$$ReportImplCopyWith(
          _$ReportImpl value, $Res Function(_$ReportImpl) then) =
      __$$ReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      ReportCategory category,
      ReportPriority priority,
      ReportStatus status,
      ReportLocation location,
      List<String>? imageUrls,
      String? contactName,
      String? contactEmail,
      String? contactPhone,
      bool isAnonymous,
      DateTime? submittedAt,
      DateTime? updatedAt,
      String? municipalityResponse,
      DateTime? responseAt,
      String? referenceNumber,
      int version});

  @override
  $ReportLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$ReportImplCopyWithImpl<$Res>
    extends _$ReportCopyWithImpl<$Res, _$ReportImpl>
    implements _$$ReportImplCopyWith<$Res> {
  __$$ReportImplCopyWithImpl(
      _$ReportImpl _value, $Res Function(_$ReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? priority = null,
    Object? status = null,
    Object? location = null,
    Object? imageUrls = freezed,
    Object? contactName = freezed,
    Object? contactEmail = freezed,
    Object? contactPhone = freezed,
    Object? isAnonymous = null,
    Object? submittedAt = freezed,
    Object? updatedAt = freezed,
    Object? municipalityResponse = freezed,
    Object? responseAt = freezed,
    Object? referenceNumber = freezed,
    Object? version = null,
  }) {
    return _then(_$ReportImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ReportCategory,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as ReportPriority,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReportStatus,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as ReportLocation,
      imageUrls: freezed == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      contactName: freezed == contactName
          ? _value.contactName
          : contactName // ignore: cast_nullable_to_non_nullable
              as String?,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      submittedAt: freezed == submittedAt
          ? _value.submittedAt
          : submittedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      municipalityResponse: freezed == municipalityResponse
          ? _value.municipalityResponse
          : municipalityResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      responseAt: freezed == responseAt
          ? _value.responseAt
          : responseAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      referenceNumber: freezed == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportImpl implements _Report {
  const _$ReportImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.category,
      required this.priority,
      required this.status,
      required this.location,
      final List<String>? imageUrls,
      this.contactName,
      this.contactEmail,
      this.contactPhone,
      this.isAnonymous = false,
      this.submittedAt,
      this.updatedAt,
      this.municipalityResponse,
      this.responseAt,
      this.referenceNumber,
      this.version = 1})
      : _imageUrls = imageUrls;

  factory _$ReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  final ReportCategory category;
  @override
  final ReportPriority priority;
  @override
  final ReportStatus status;
  @override
  final ReportLocation location;
  final List<String>? _imageUrls;
  @override
  List<String>? get imageUrls {
    final value = _imageUrls;
    if (value == null) return null;
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? contactName;
  @override
  final String? contactEmail;
  @override
  final String? contactPhone;
  @override
  @JsonKey()
  final bool isAnonymous;
  @override
  final DateTime? submittedAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? municipalityResponse;
  @override
  final DateTime? responseAt;
  @override
  final String? referenceNumber;
  @override
  @JsonKey()
  final int version;

  @override
  String toString() {
    return 'Report(id: $id, title: $title, description: $description, category: $category, priority: $priority, status: $status, location: $location, imageUrls: $imageUrls, contactName: $contactName, contactEmail: $contactEmail, contactPhone: $contactPhone, isAnonymous: $isAnonymous, submittedAt: $submittedAt, updatedAt: $updatedAt, municipalityResponse: $municipalityResponse, responseAt: $responseAt, referenceNumber: $referenceNumber, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.contactName, contactName) ||
                other.contactName == contactName) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.municipalityResponse, municipalityResponse) ||
                other.municipalityResponse == municipalityResponse) &&
            (identical(other.responseAt, responseAt) ||
                other.responseAt == responseAt) &&
            (identical(other.referenceNumber, referenceNumber) ||
                other.referenceNumber == referenceNumber) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      category,
      priority,
      status,
      location,
      const DeepCollectionEquality().hash(_imageUrls),
      contactName,
      contactEmail,
      contactPhone,
      isAnonymous,
      submittedAt,
      updatedAt,
      municipalityResponse,
      responseAt,
      referenceNumber,
      version);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportImplCopyWith<_$ReportImpl> get copyWith =>
      __$$ReportImplCopyWithImpl<_$ReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportImplToJson(
      this,
    );
  }
}

abstract class _Report implements Report {
  const factory _Report(
      {required final int id,
      required final String title,
      required final String description,
      required final ReportCategory category,
      required final ReportPriority priority,
      required final ReportStatus status,
      required final ReportLocation location,
      final List<String>? imageUrls,
      final String? contactName,
      final String? contactEmail,
      final String? contactPhone,
      final bool isAnonymous,
      final DateTime? submittedAt,
      final DateTime? updatedAt,
      final String? municipalityResponse,
      final DateTime? responseAt,
      final String? referenceNumber,
      final int version}) = _$ReportImpl;

  factory _Report.fromJson(Map<String, dynamic> json) = _$ReportImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get description;
  @override
  ReportCategory get category;
  @override
  ReportPriority get priority;
  @override
  ReportStatus get status;
  @override
  ReportLocation get location;
  @override
  List<String>? get imageUrls;
  @override
  String? get contactName;
  @override
  String? get contactEmail;
  @override
  String? get contactPhone;
  @override
  bool get isAnonymous;
  @override
  DateTime? get submittedAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get municipalityResponse;
  @override
  DateTime? get responseAt;
  @override
  String? get referenceNumber;
  @override
  int get version;
  @override
  @JsonKey(ignore: true)
  _$$ReportImplCopyWith<_$ReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportLocation _$ReportLocationFromJson(Map<String, dynamic> json) {
  return _ReportLocation.fromJson(json);
}

/// @nodoc
mixin _$ReportLocation {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get landmark => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReportLocationCopyWith<ReportLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportLocationCopyWith<$Res> {
  factory $ReportLocationCopyWith(
          ReportLocation value, $Res Function(ReportLocation) then) =
      _$ReportLocationCopyWithImpl<$Res, ReportLocation>;
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      String? address,
      String? description,
      String? landmark});
}

/// @nodoc
class _$ReportLocationCopyWithImpl<$Res, $Val extends ReportLocation>
    implements $ReportLocationCopyWith<$Res> {
  _$ReportLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? address = freezed,
    Object? description = freezed,
    Object? landmark = freezed,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      landmark: freezed == landmark
          ? _value.landmark
          : landmark // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportLocationImplCopyWith<$Res>
    implements $ReportLocationCopyWith<$Res> {
  factory _$$ReportLocationImplCopyWith(_$ReportLocationImpl value,
          $Res Function(_$ReportLocationImpl) then) =
      __$$ReportLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      String? address,
      String? description,
      String? landmark});
}

/// @nodoc
class __$$ReportLocationImplCopyWithImpl<$Res>
    extends _$ReportLocationCopyWithImpl<$Res, _$ReportLocationImpl>
    implements _$$ReportLocationImplCopyWith<$Res> {
  __$$ReportLocationImplCopyWithImpl(
      _$ReportLocationImpl _value, $Res Function(_$ReportLocationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? address = freezed,
    Object? description = freezed,
    Object? landmark = freezed,
  }) {
    return _then(_$ReportLocationImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      landmark: freezed == landmark
          ? _value.landmark
          : landmark // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportLocationImpl implements _ReportLocation {
  const _$ReportLocationImpl(
      {required this.latitude,
      required this.longitude,
      this.address,
      this.description,
      this.landmark});

  factory _$ReportLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportLocationImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? address;
  @override
  final String? description;
  @override
  final String? landmark;

  @override
  String toString() {
    return 'ReportLocation(latitude: $latitude, longitude: $longitude, address: $address, description: $description, landmark: $landmark)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportLocationImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.landmark, landmark) ||
                other.landmark == landmark));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, latitude, longitude, address, description, landmark);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportLocationImplCopyWith<_$ReportLocationImpl> get copyWith =>
      __$$ReportLocationImplCopyWithImpl<_$ReportLocationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportLocationImplToJson(
      this,
    );
  }
}

abstract class _ReportLocation implements ReportLocation {
  const factory _ReportLocation(
      {required final double latitude,
      required final double longitude,
      final String? address,
      final String? description,
      final String? landmark}) = _$ReportLocationImpl;

  factory _ReportLocation.fromJson(Map<String, dynamic> json) =
      _$ReportLocationImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get address;
  @override
  String? get description;
  @override
  String? get landmark;
  @override
  @JsonKey(ignore: true)
  _$$ReportLocationImplCopyWith<_$ReportLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
