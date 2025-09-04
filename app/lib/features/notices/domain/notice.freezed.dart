// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Notice _$NoticeFromJson(Map<String, dynamic> json) {
  return _Notice.fromJson(json);
}

/// @nodoc
mixin _$Notice {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get publishedDate => throw _privateConstructorUsedError;
  DateTime? get validUntil => throw _privateConstructorUsedError;
  NoticePriority get priority => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<NoticeAttachment>? get attachments => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NoticeCopyWith<Notice> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoticeCopyWith<$Res> {
  factory $NoticeCopyWith(Notice value, $Res Function(Notice) then) =
      _$NoticeCopyWithImpl<$Res, Notice>;
  @useResult
  $Res call(
      {int id,
      String title,
      String content,
      DateTime publishedDate,
      DateTime? validUntil,
      NoticePriority priority,
      String category,
      String? imageUrl,
      List<NoticeAttachment>? attachments,
      List<String> tags,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$NoticeCopyWithImpl<$Res, $Val extends Notice>
    implements $NoticeCopyWith<$Res> {
  _$NoticeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? publishedDate = null,
    Object? validUntil = freezed,
    Object? priority = null,
    Object? category = null,
    Object? imageUrl = freezed,
    Object? attachments = freezed,
    Object? tags = null,
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
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      publishedDate: null == publishedDate
          ? _value.publishedDate
          : publishedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      validUntil: freezed == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NoticePriority,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: freezed == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<NoticeAttachment>?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
abstract class _$$NoticeImplCopyWith<$Res> implements $NoticeCopyWith<$Res> {
  factory _$$NoticeImplCopyWith(
          _$NoticeImpl value, $Res Function(_$NoticeImpl) then) =
      __$$NoticeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String content,
      DateTime publishedDate,
      DateTime? validUntil,
      NoticePriority priority,
      String category,
      String? imageUrl,
      List<NoticeAttachment>? attachments,
      List<String> tags,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$NoticeImplCopyWithImpl<$Res>
    extends _$NoticeCopyWithImpl<$Res, _$NoticeImpl>
    implements _$$NoticeImplCopyWith<$Res> {
  __$$NoticeImplCopyWithImpl(
      _$NoticeImpl _value, $Res Function(_$NoticeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? publishedDate = null,
    Object? validUntil = freezed,
    Object? priority = null,
    Object? category = null,
    Object? imageUrl = freezed,
    Object? attachments = freezed,
    Object? tags = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$NoticeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      publishedDate: null == publishedDate
          ? _value.publishedDate
          : publishedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      validUntil: freezed == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NoticePriority,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: freezed == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<NoticeAttachment>?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
class _$NoticeImpl implements _Notice {
  const _$NoticeImpl(
      {required this.id,
      required this.title,
      required this.content,
      required this.publishedDate,
      this.validUntil,
      required this.priority,
      required this.category,
      this.imageUrl,
      final List<NoticeAttachment>? attachments,
      final List<String> tags = const [],
      this.createdAt,
      this.updatedAt})
      : _attachments = attachments,
        _tags = tags;

  factory _$NoticeImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoticeImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String content;
  @override
  final DateTime publishedDate;
  @override
  final DateTime? validUntil;
  @override
  final NoticePriority priority;
  @override
  final String category;
  @override
  final String? imageUrl;
  final List<NoticeAttachment>? _attachments;
  @override
  List<NoticeAttachment>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Notice(id: $id, title: $title, content: $content, publishedDate: $publishedDate, validUntil: $validUntil, priority: $priority, category: $category, imageUrl: $imageUrl, attachments: $attachments, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoticeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.publishedDate, publishedDate) ||
                other.publishedDate == publishedDate) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
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
      content,
      publishedDate,
      validUntil,
      priority,
      category,
      imageUrl,
      const DeepCollectionEquality().hash(_attachments),
      const DeepCollectionEquality().hash(_tags),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NoticeImplCopyWith<_$NoticeImpl> get copyWith =>
      __$$NoticeImplCopyWithImpl<_$NoticeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoticeImplToJson(
      this,
    );
  }
}

abstract class _Notice implements Notice {
  const factory _Notice(
      {required final int id,
      required final String title,
      required final String content,
      required final DateTime publishedDate,
      final DateTime? validUntil,
      required final NoticePriority priority,
      required final String category,
      final String? imageUrl,
      final List<NoticeAttachment>? attachments,
      final List<String> tags,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$NoticeImpl;

  factory _Notice.fromJson(Map<String, dynamic> json) = _$NoticeImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get content;
  @override
  DateTime get publishedDate;
  @override
  DateTime? get validUntil;
  @override
  NoticePriority get priority;
  @override
  String get category;
  @override
  String? get imageUrl;
  @override
  List<NoticeAttachment>? get attachments;
  @override
  List<String> get tags;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$NoticeImplCopyWith<_$NoticeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NoticeAttachment _$NoticeAttachmentFromJson(Map<String, dynamic> json) {
  return _NoticeAttachment.fromJson(json);
}

/// @nodoc
mixin _$NoticeAttachment {
  String get name => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NoticeAttachmentCopyWith<NoticeAttachment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoticeAttachmentCopyWith<$Res> {
  factory $NoticeAttachmentCopyWith(
          NoticeAttachment value, $Res Function(NoticeAttachment) then) =
      _$NoticeAttachmentCopyWithImpl<$Res, NoticeAttachment>;
  @useResult
  $Res call({String name, String url, String type, int size});
}

/// @nodoc
class _$NoticeAttachmentCopyWithImpl<$Res, $Val extends NoticeAttachment>
    implements $NoticeAttachmentCopyWith<$Res> {
  _$NoticeAttachmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? url = null,
    Object? type = null,
    Object? size = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoticeAttachmentImplCopyWith<$Res>
    implements $NoticeAttachmentCopyWith<$Res> {
  factory _$$NoticeAttachmentImplCopyWith(_$NoticeAttachmentImpl value,
          $Res Function(_$NoticeAttachmentImpl) then) =
      __$$NoticeAttachmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String url, String type, int size});
}

/// @nodoc
class __$$NoticeAttachmentImplCopyWithImpl<$Res>
    extends _$NoticeAttachmentCopyWithImpl<$Res, _$NoticeAttachmentImpl>
    implements _$$NoticeAttachmentImplCopyWith<$Res> {
  __$$NoticeAttachmentImplCopyWithImpl(_$NoticeAttachmentImpl _value,
      $Res Function(_$NoticeAttachmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? url = null,
    Object? type = null,
    Object? size = null,
  }) {
    return _then(_$NoticeAttachmentImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NoticeAttachmentImpl implements _NoticeAttachment {
  const _$NoticeAttachmentImpl(
      {required this.name,
      required this.url,
      required this.type,
      required this.size});

  factory _$NoticeAttachmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoticeAttachmentImplFromJson(json);

  @override
  final String name;
  @override
  final String url;
  @override
  final String type;
  @override
  final int size;

  @override
  String toString() {
    return 'NoticeAttachment(name: $name, url: $url, type: $type, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoticeAttachmentImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.size, size) || other.size == size));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, url, type, size);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NoticeAttachmentImplCopyWith<_$NoticeAttachmentImpl> get copyWith =>
      __$$NoticeAttachmentImplCopyWithImpl<_$NoticeAttachmentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoticeAttachmentImplToJson(
      this,
    );
  }
}

abstract class _NoticeAttachment implements NoticeAttachment {
  const factory _NoticeAttachment(
      {required final String name,
      required final String url,
      required final String type,
      required final int size}) = _$NoticeAttachmentImpl;

  factory _NoticeAttachment.fromJson(Map<String, dynamic> json) =
      _$NoticeAttachmentImpl.fromJson;

  @override
  String get name;
  @override
  String get url;
  @override
  String get type;
  @override
  int get size;
  @override
  @JsonKey(ignore: true)
  _$$NoticeAttachmentImplCopyWith<_$NoticeAttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
