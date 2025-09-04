// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Document _$DocumentFromJson(Map<String, dynamic> json) {
  return _Document.fromJson(json);
}

/// @nodoc
mixin _$Document {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DocumentCategory get category => throw _privateConstructorUsedError;
  String get fileUrl => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  int get fileSizeBytes => throw _privateConstructorUsedError;
  String? get fileType => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  bool get requiresAuthentication => throw _privateConstructorUsedError;
  bool get isPopular => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DocumentCopyWith<Document> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentCopyWith<$Res> {
  factory $DocumentCopyWith(Document value, $Res Function(Document) then) =
      _$DocumentCopyWithImpl<$Res, Document>;
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      DocumentCategory category,
      String fileUrl,
      String fileName,
      int fileSizeBytes,
      String? fileType,
      DateTime? lastUpdated,
      List<String>? tags,
      bool requiresAuthentication,
      bool isPopular,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$DocumentCopyWithImpl<$Res, $Val extends Document>
    implements $DocumentCopyWith<$Res> {
  _$DocumentCopyWithImpl(this._value, this._then);

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
    Object? fileUrl = null,
    Object? fileName = null,
    Object? fileSizeBytes = null,
    Object? fileType = freezed,
    Object? lastUpdated = freezed,
    Object? tags = freezed,
    Object? requiresAuthentication = null,
    Object? isPopular = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
              as DocumentCategory,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSizeBytes: null == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      fileType: freezed == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      requiresAuthentication: null == requiresAuthentication
          ? _value.requiresAuthentication
          : requiresAuthentication // ignore: cast_nullable_to_non_nullable
              as bool,
      isPopular: null == isPopular
          ? _value.isPopular
          : isPopular // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DocumentImplCopyWith<$Res>
    implements $DocumentCopyWith<$Res> {
  factory _$$DocumentImplCopyWith(
          _$DocumentImpl value, $Res Function(_$DocumentImpl) then) =
      __$$DocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      DocumentCategory category,
      String fileUrl,
      String fileName,
      int fileSizeBytes,
      String? fileType,
      DateTime? lastUpdated,
      List<String>? tags,
      bool requiresAuthentication,
      bool isPopular,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$DocumentImplCopyWithImpl<$Res>
    extends _$DocumentCopyWithImpl<$Res, _$DocumentImpl>
    implements _$$DocumentImplCopyWith<$Res> {
  __$$DocumentImplCopyWithImpl(
      _$DocumentImpl _value, $Res Function(_$DocumentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? fileUrl = null,
    Object? fileName = null,
    Object? fileSizeBytes = null,
    Object? fileType = freezed,
    Object? lastUpdated = freezed,
    Object? tags = freezed,
    Object? requiresAuthentication = null,
    Object? isPopular = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$DocumentImpl(
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
              as DocumentCategory,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSizeBytes: null == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      fileType: freezed == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      requiresAuthentication: null == requiresAuthentication
          ? _value.requiresAuthentication
          : requiresAuthentication // ignore: cast_nullable_to_non_nullable
              as bool,
      isPopular: null == isPopular
          ? _value.isPopular
          : isPopular // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DocumentImpl implements _Document {
  const _$DocumentImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.category,
      required this.fileUrl,
      required this.fileName,
      required this.fileSizeBytes,
      this.fileType,
      this.lastUpdated,
      final List<String>? tags,
      this.requiresAuthentication = false,
      this.isPopular = false,
      this.createdAt,
      this.updatedAt})
      : _tags = tags;

  factory _$DocumentImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  final DocumentCategory category;
  @override
  final String fileUrl;
  @override
  final String fileName;
  @override
  final int fileSizeBytes;
  @override
  final String? fileType;
  @override
  final DateTime? lastUpdated;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool requiresAuthentication;
  @override
  @JsonKey()
  final bool isPopular;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Document(id: $id, title: $title, description: $description, category: $category, fileUrl: $fileUrl, fileName: $fileName, fileSizeBytes: $fileSizeBytes, fileType: $fileType, lastUpdated: $lastUpdated, tags: $tags, requiresAuthentication: $requiresAuthentication, isPopular: $isPopular, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.requiresAuthentication, requiresAuthentication) ||
                other.requiresAuthentication == requiresAuthentication) &&
            (identical(other.isPopular, isPopular) ||
                other.isPopular == isPopular) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      category,
      fileUrl,
      fileName,
      fileSizeBytes,
      fileType,
      lastUpdated,
      const DeepCollectionEquality().hash(_tags),
      requiresAuthentication,
      isPopular,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentImplCopyWith<_$DocumentImpl> get copyWith =>
      __$$DocumentImplCopyWithImpl<_$DocumentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentImplToJson(
      this,
    );
  }
}

abstract class _Document implements Document {
  const factory _Document(
      {required final int id,
      required final String title,
      required final String description,
      required final DocumentCategory category,
      required final String fileUrl,
      required final String fileName,
      required final int fileSizeBytes,
      final String? fileType,
      final DateTime? lastUpdated,
      final List<String>? tags,
      final bool requiresAuthentication,
      final bool isPopular,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$DocumentImpl;

  factory _Document.fromJson(Map<String, dynamic> json) =
      _$DocumentImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get description;
  @override
  DocumentCategory get category;
  @override
  String get fileUrl;
  @override
  String get fileName;
  @override
  int get fileSizeBytes;
  @override
  String? get fileType;
  @override
  DateTime? get lastUpdated;
  @override
  List<String>? get tags;
  @override
  bool get requiresAuthentication;
  @override
  bool get isPopular;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$DocumentImplCopyWith<_$DocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
