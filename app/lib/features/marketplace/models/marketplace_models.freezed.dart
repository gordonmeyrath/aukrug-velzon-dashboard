// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marketplace_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MarketplaceListing _$MarketplaceListingFromJson(Map<String, dynamic> json) {
  return _MarketplaceListing.fromJson(json);
}

/// @nodoc
mixin _$MarketplaceListing {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get locationArea => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get contactViaMessenger => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  int get authorId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  List<String>? get categories => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  bool get isOwner => throw _privateConstructorUsedError;
  bool get canEdit => throw _privateConstructorUsedError;
  int get viewCount => throw _privateConstructorUsedError;

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
      {int id,
      String title,
      String description,
      double price,
      String currency,
      String locationArea,
      List<String> images,
      String status,
      bool contactViaMessenger,
      String authorName,
      int authorId,
      DateTime createdAt,
      DateTime? updatedAt,
      List<String>? categories,
      bool isFavorite,
      bool isOwner,
      bool canEdit,
      int viewCount});
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
    Object? price = null,
    Object? currency = null,
    Object? locationArea = null,
    Object? images = null,
    Object? status = null,
    Object? contactViaMessenger = null,
    Object? authorName = null,
    Object? authorId = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? categories = freezed,
    Object? isFavorite = null,
    Object? isOwner = null,
    Object? canEdit = null,
    Object? viewCount = null,
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
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      locationArea: null == locationArea
          ? _value.locationArea
          : locationArea // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      contactViaMessenger: null == contactViaMessenger
          ? _value.contactViaMessenger
          : contactViaMessenger // ignore: cast_nullable_to_non_nullable
              as bool,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      categories: freezed == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isOwner: null == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
      canEdit: null == canEdit
          ? _value.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
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
      {int id,
      String title,
      String description,
      double price,
      String currency,
      String locationArea,
      List<String> images,
      String status,
      bool contactViaMessenger,
      String authorName,
      int authorId,
      DateTime createdAt,
      DateTime? updatedAt,
      List<String>? categories,
      bool isFavorite,
      bool isOwner,
      bool canEdit,
      int viewCount});
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
    Object? price = null,
    Object? currency = null,
    Object? locationArea = null,
    Object? images = null,
    Object? status = null,
    Object? contactViaMessenger = null,
    Object? authorName = null,
    Object? authorId = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? categories = freezed,
    Object? isFavorite = null,
    Object? isOwner = null,
    Object? canEdit = null,
    Object? viewCount = null,
  }) {
    return _then(_$MarketplaceListingImpl(
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
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      locationArea: null == locationArea
          ? _value.locationArea
          : locationArea // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      contactViaMessenger: null == contactViaMessenger
          ? _value.contactViaMessenger
          : contactViaMessenger // ignore: cast_nullable_to_non_nullable
              as bool,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      categories: freezed == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isOwner: null == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
      canEdit: null == canEdit
          ? _value.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
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
      required this.price,
      this.currency = 'EUR',
      required this.locationArea,
      required final List<String> images,
      this.status = 'active',
      this.contactViaMessenger = false,
      required this.authorName,
      required this.authorId,
      required this.createdAt,
      this.updatedAt,
      final List<String>? categories,
      this.isFavorite = false,
      this.isOwner = false,
      this.canEdit = false,
      this.viewCount = 0})
      : _images = images,
        _categories = categories;

  factory _$MarketplaceListingImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketplaceListingImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  final double price;
  @override
  @JsonKey()
  final String currency;
  @override
  final String locationArea;
  final List<String> _images;
  @override
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final bool contactViaMessenger;
  @override
  final String authorName;
  @override
  final int authorId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  final List<String>? _categories;
  @override
  List<String>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool isFavorite;
  @override
  @JsonKey()
  final bool isOwner;
  @override
  @JsonKey()
  final bool canEdit;
  @override
  @JsonKey()
  final int viewCount;

  @override
  String toString() {
    return 'MarketplaceListing(id: $id, title: $title, description: $description, price: $price, currency: $currency, locationArea: $locationArea, images: $images, status: $status, contactViaMessenger: $contactViaMessenger, authorName: $authorName, authorId: $authorId, createdAt: $createdAt, updatedAt: $updatedAt, categories: $categories, isFavorite: $isFavorite, isOwner: $isOwner, canEdit: $canEdit, viewCount: $viewCount)';
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
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.locationArea, locationArea) ||
                other.locationArea == locationArea) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.contactViaMessenger, contactViaMessenger) ||
                other.contactViaMessenger == contactViaMessenger) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.isOwner, isOwner) || other.isOwner == isOwner) &&
            (identical(other.canEdit, canEdit) || other.canEdit == canEdit) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      price,
      currency,
      locationArea,
      const DeepCollectionEquality().hash(_images),
      status,
      contactViaMessenger,
      authorName,
      authorId,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_categories),
      isFavorite,
      isOwner,
      canEdit,
      viewCount);

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
      {required final int id,
      required final String title,
      required final String description,
      required final double price,
      final String currency,
      required final String locationArea,
      required final List<String> images,
      final String status,
      final bool contactViaMessenger,
      required final String authorName,
      required final int authorId,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final List<String>? categories,
      final bool isFavorite,
      final bool isOwner,
      final bool canEdit,
      final int viewCount}) = _$MarketplaceListingImpl;

  factory _MarketplaceListing.fromJson(Map<String, dynamic> json) =
      _$MarketplaceListingImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get description;
  @override
  double get price;
  @override
  String get currency;
  @override
  String get locationArea;
  @override
  List<String> get images;
  @override
  String get status;
  @override
  bool get contactViaMessenger;
  @override
  String get authorName;
  @override
  int get authorId;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  List<String>? get categories;
  @override
  bool get isFavorite;
  @override
  bool get isOwner;
  @override
  bool get canEdit;
  @override
  int get viewCount;
  @override
  @JsonKey(ignore: true)
  _$$MarketplaceListingImplCopyWith<_$MarketplaceListingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MarketplaceCategory _$MarketplaceCategoryFromJson(Map<String, dynamic> json) {
  return _MarketplaceCategory.fromJson(json);
}

/// @nodoc
mixin _$MarketplaceCategory {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get iconName => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  int? get parentId => throw _privateConstructorUsedError;
  List<MarketplaceCategory>? get children => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MarketplaceCategoryCopyWith<MarketplaceCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketplaceCategoryCopyWith<$Res> {
  factory $MarketplaceCategoryCopyWith(
          MarketplaceCategory value, $Res Function(MarketplaceCategory) then) =
      _$MarketplaceCategoryCopyWithImpl<$Res, MarketplaceCategory>;
  @useResult
  $Res call(
      {int id,
      String name,
      String slug,
      String? description,
      String? iconName,
      int count,
      int? parentId,
      List<MarketplaceCategory>? children});
}

/// @nodoc
class _$MarketplaceCategoryCopyWithImpl<$Res, $Val extends MarketplaceCategory>
    implements $MarketplaceCategoryCopyWith<$Res> {
  _$MarketplaceCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? iconName = freezed,
    Object? count = null,
    Object? parentId = freezed,
    Object? children = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int?,
      children: freezed == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<MarketplaceCategory>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarketplaceCategoryImplCopyWith<$Res>
    implements $MarketplaceCategoryCopyWith<$Res> {
  factory _$$MarketplaceCategoryImplCopyWith(_$MarketplaceCategoryImpl value,
          $Res Function(_$MarketplaceCategoryImpl) then) =
      __$$MarketplaceCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String slug,
      String? description,
      String? iconName,
      int count,
      int? parentId,
      List<MarketplaceCategory>? children});
}

/// @nodoc
class __$$MarketplaceCategoryImplCopyWithImpl<$Res>
    extends _$MarketplaceCategoryCopyWithImpl<$Res, _$MarketplaceCategoryImpl>
    implements _$$MarketplaceCategoryImplCopyWith<$Res> {
  __$$MarketplaceCategoryImplCopyWithImpl(_$MarketplaceCategoryImpl _value,
      $Res Function(_$MarketplaceCategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? iconName = freezed,
    Object? count = null,
    Object? parentId = freezed,
    Object? children = freezed,
  }) {
    return _then(_$MarketplaceCategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int?,
      children: freezed == children
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<MarketplaceCategory>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketplaceCategoryImpl implements _MarketplaceCategory {
  const _$MarketplaceCategoryImpl(
      {required this.id,
      required this.name,
      required this.slug,
      this.description,
      this.iconName,
      this.count = 0,
      this.parentId,
      final List<MarketplaceCategory>? children})
      : _children = children;

  factory _$MarketplaceCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketplaceCategoryImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final String? description;
  @override
  final String? iconName;
  @override
  @JsonKey()
  final int count;
  @override
  final int? parentId;
  final List<MarketplaceCategory>? _children;
  @override
  List<MarketplaceCategory>? get children {
    final value = _children;
    if (value == null) return null;
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'MarketplaceCategory(id: $id, name: $name, slug: $slug, description: $description, iconName: $iconName, count: $count, parentId: $parentId, children: $children)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketplaceCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      slug,
      description,
      iconName,
      count,
      parentId,
      const DeepCollectionEquality().hash(_children));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketplaceCategoryImplCopyWith<_$MarketplaceCategoryImpl> get copyWith =>
      __$$MarketplaceCategoryImplCopyWithImpl<_$MarketplaceCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketplaceCategoryImplToJson(
      this,
    );
  }
}

abstract class _MarketplaceCategory implements MarketplaceCategory {
  const factory _MarketplaceCategory(
      {required final int id,
      required final String name,
      required final String slug,
      final String? description,
      final String? iconName,
      final int count,
      final int? parentId,
      final List<MarketplaceCategory>? children}) = _$MarketplaceCategoryImpl;

  factory _MarketplaceCategory.fromJson(Map<String, dynamic> json) =
      _$MarketplaceCategoryImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  String? get description;
  @override
  String? get iconName;
  @override
  int get count;
  @override
  int? get parentId;
  @override
  List<MarketplaceCategory>? get children;
  @override
  @JsonKey(ignore: true)
  _$$MarketplaceCategoryImplCopyWith<_$MarketplaceCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MarketplaceFilters _$MarketplaceFiltersFromJson(Map<String, dynamic> json) {
  return _MarketplaceFilters.fromJson(json);
}

/// @nodoc
mixin _$MarketplaceFilters {
  String get search => throw _privateConstructorUsedError;
  List<int>? get categoryIds => throw _privateConstructorUsedError;
  double? get priceMin => throw _privateConstructorUsedError;
  double? get priceMax => throw _privateConstructorUsedError;
  String? get locationArea => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get perPage => throw _privateConstructorUsedError;
  String get sort => throw _privateConstructorUsedError;
  bool get onlyFavorites => throw _privateConstructorUsedError;
  double? get maxDistance => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MarketplaceFiltersCopyWith<MarketplaceFilters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketplaceFiltersCopyWith<$Res> {
  factory $MarketplaceFiltersCopyWith(
          MarketplaceFilters value, $Res Function(MarketplaceFilters) then) =
      _$MarketplaceFiltersCopyWithImpl<$Res, MarketplaceFilters>;
  @useResult
  $Res call(
      {String search,
      List<int>? categoryIds,
      double? priceMin,
      double? priceMax,
      String? locationArea,
      String status,
      int page,
      int perPage,
      String sort,
      bool onlyFavorites,
      double? maxDistance});
}

/// @nodoc
class _$MarketplaceFiltersCopyWithImpl<$Res, $Val extends MarketplaceFilters>
    implements $MarketplaceFiltersCopyWith<$Res> {
  _$MarketplaceFiltersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? search = null,
    Object? categoryIds = freezed,
    Object? priceMin = freezed,
    Object? priceMax = freezed,
    Object? locationArea = freezed,
    Object? status = null,
    Object? page = null,
    Object? perPage = null,
    Object? sort = null,
    Object? onlyFavorites = null,
    Object? maxDistance = freezed,
  }) {
    return _then(_value.copyWith(
      search: null == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String,
      categoryIds: freezed == categoryIds
          ? _value.categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      priceMin: freezed == priceMin
          ? _value.priceMin
          : priceMin // ignore: cast_nullable_to_non_nullable
              as double?,
      priceMax: freezed == priceMax
          ? _value.priceMax
          : priceMax // ignore: cast_nullable_to_non_nullable
              as double?,
      locationArea: freezed == locationArea
          ? _value.locationArea
          : locationArea // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      sort: null == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as String,
      onlyFavorites: null == onlyFavorites
          ? _value.onlyFavorites
          : onlyFavorites // ignore: cast_nullable_to_non_nullable
              as bool,
      maxDistance: freezed == maxDistance
          ? _value.maxDistance
          : maxDistance // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarketplaceFiltersImplCopyWith<$Res>
    implements $MarketplaceFiltersCopyWith<$Res> {
  factory _$$MarketplaceFiltersImplCopyWith(_$MarketplaceFiltersImpl value,
          $Res Function(_$MarketplaceFiltersImpl) then) =
      __$$MarketplaceFiltersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String search,
      List<int>? categoryIds,
      double? priceMin,
      double? priceMax,
      String? locationArea,
      String status,
      int page,
      int perPage,
      String sort,
      bool onlyFavorites,
      double? maxDistance});
}

/// @nodoc
class __$$MarketplaceFiltersImplCopyWithImpl<$Res>
    extends _$MarketplaceFiltersCopyWithImpl<$Res, _$MarketplaceFiltersImpl>
    implements _$$MarketplaceFiltersImplCopyWith<$Res> {
  __$$MarketplaceFiltersImplCopyWithImpl(_$MarketplaceFiltersImpl _value,
      $Res Function(_$MarketplaceFiltersImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? search = null,
    Object? categoryIds = freezed,
    Object? priceMin = freezed,
    Object? priceMax = freezed,
    Object? locationArea = freezed,
    Object? status = null,
    Object? page = null,
    Object? perPage = null,
    Object? sort = null,
    Object? onlyFavorites = null,
    Object? maxDistance = freezed,
  }) {
    return _then(_$MarketplaceFiltersImpl(
      search: null == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String,
      categoryIds: freezed == categoryIds
          ? _value._categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      priceMin: freezed == priceMin
          ? _value.priceMin
          : priceMin // ignore: cast_nullable_to_non_nullable
              as double?,
      priceMax: freezed == priceMax
          ? _value.priceMax
          : priceMax // ignore: cast_nullable_to_non_nullable
              as double?,
      locationArea: freezed == locationArea
          ? _value.locationArea
          : locationArea // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      sort: null == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as String,
      onlyFavorites: null == onlyFavorites
          ? _value.onlyFavorites
          : onlyFavorites // ignore: cast_nullable_to_non_nullable
              as bool,
      maxDistance: freezed == maxDistance
          ? _value.maxDistance
          : maxDistance // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketplaceFiltersImpl implements _MarketplaceFilters {
  const _$MarketplaceFiltersImpl(
      {this.search = '',
      final List<int>? categoryIds,
      this.priceMin,
      this.priceMax,
      this.locationArea,
      this.status = 'active',
      this.page = 1,
      this.perPage = 20,
      this.sort = 'date_desc',
      this.onlyFavorites = false,
      this.maxDistance})
      : _categoryIds = categoryIds;

  factory _$MarketplaceFiltersImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketplaceFiltersImplFromJson(json);

  @override
  @JsonKey()
  final String search;
  final List<int>? _categoryIds;
  @override
  List<int>? get categoryIds {
    final value = _categoryIds;
    if (value == null) return null;
    if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final double? priceMin;
  @override
  final double? priceMax;
  @override
  final String? locationArea;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int perPage;
  @override
  @JsonKey()
  final String sort;
  @override
  @JsonKey()
  final bool onlyFavorites;
  @override
  final double? maxDistance;

  @override
  String toString() {
    return 'MarketplaceFilters(search: $search, categoryIds: $categoryIds, priceMin: $priceMin, priceMax: $priceMax, locationArea: $locationArea, status: $status, page: $page, perPage: $perPage, sort: $sort, onlyFavorites: $onlyFavorites, maxDistance: $maxDistance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketplaceFiltersImpl &&
            (identical(other.search, search) || other.search == search) &&
            const DeepCollectionEquality()
                .equals(other._categoryIds, _categoryIds) &&
            (identical(other.priceMin, priceMin) ||
                other.priceMin == priceMin) &&
            (identical(other.priceMax, priceMax) ||
                other.priceMax == priceMax) &&
            (identical(other.locationArea, locationArea) ||
                other.locationArea == locationArea) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.onlyFavorites, onlyFavorites) ||
                other.onlyFavorites == onlyFavorites) &&
            (identical(other.maxDistance, maxDistance) ||
                other.maxDistance == maxDistance));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      search,
      const DeepCollectionEquality().hash(_categoryIds),
      priceMin,
      priceMax,
      locationArea,
      status,
      page,
      perPage,
      sort,
      onlyFavorites,
      maxDistance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketplaceFiltersImplCopyWith<_$MarketplaceFiltersImpl> get copyWith =>
      __$$MarketplaceFiltersImplCopyWithImpl<_$MarketplaceFiltersImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketplaceFiltersImplToJson(
      this,
    );
  }
}

abstract class _MarketplaceFilters implements MarketplaceFilters {
  const factory _MarketplaceFilters(
      {final String search,
      final List<int>? categoryIds,
      final double? priceMin,
      final double? priceMax,
      final String? locationArea,
      final String status,
      final int page,
      final int perPage,
      final String sort,
      final bool onlyFavorites,
      final double? maxDistance}) = _$MarketplaceFiltersImpl;

  factory _MarketplaceFilters.fromJson(Map<String, dynamic> json) =
      _$MarketplaceFiltersImpl.fromJson;

  @override
  String get search;
  @override
  List<int>? get categoryIds;
  @override
  double? get priceMin;
  @override
  double? get priceMax;
  @override
  String? get locationArea;
  @override
  String get status;
  @override
  int get page;
  @override
  int get perPage;
  @override
  String get sort;
  @override
  bool get onlyFavorites;
  @override
  double? get maxDistance;
  @override
  @JsonKey(ignore: true)
  _$$MarketplaceFiltersImplCopyWith<_$MarketplaceFiltersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MarketplaceCreateRequest _$MarketplaceCreateRequestFromJson(
    Map<String, dynamic> json) {
  return _MarketplaceCreateRequest.fromJson(json);
}

/// @nodoc
mixin _$MarketplaceCreateRequest {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get locationArea => throw _privateConstructorUsedError;
  List<String> get imageBase64List => throw _privateConstructorUsedError;
  bool get contactViaMessenger => throw _privateConstructorUsedError;
  List<int>? get categoryIds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MarketplaceCreateRequestCopyWith<MarketplaceCreateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketplaceCreateRequestCopyWith<$Res> {
  factory $MarketplaceCreateRequestCopyWith(MarketplaceCreateRequest value,
          $Res Function(MarketplaceCreateRequest) then) =
      _$MarketplaceCreateRequestCopyWithImpl<$Res, MarketplaceCreateRequest>;
  @useResult
  $Res call(
      {String title,
      String description,
      double price,
      String currency,
      String locationArea,
      List<String> imageBase64List,
      bool contactViaMessenger,
      List<int>? categoryIds});
}

/// @nodoc
class _$MarketplaceCreateRequestCopyWithImpl<$Res,
        $Val extends MarketplaceCreateRequest>
    implements $MarketplaceCreateRequestCopyWith<$Res> {
  _$MarketplaceCreateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? currency = null,
    Object? locationArea = null,
    Object? imageBase64List = null,
    Object? contactViaMessenger = null,
    Object? categoryIds = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      locationArea: null == locationArea
          ? _value.locationArea
          : locationArea // ignore: cast_nullable_to_non_nullable
              as String,
      imageBase64List: null == imageBase64List
          ? _value.imageBase64List
          : imageBase64List // ignore: cast_nullable_to_non_nullable
              as List<String>,
      contactViaMessenger: null == contactViaMessenger
          ? _value.contactViaMessenger
          : contactViaMessenger // ignore: cast_nullable_to_non_nullable
              as bool,
      categoryIds: freezed == categoryIds
          ? _value.categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarketplaceCreateRequestImplCopyWith<$Res>
    implements $MarketplaceCreateRequestCopyWith<$Res> {
  factory _$$MarketplaceCreateRequestImplCopyWith(
          _$MarketplaceCreateRequestImpl value,
          $Res Function(_$MarketplaceCreateRequestImpl) then) =
      __$$MarketplaceCreateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String description,
      double price,
      String currency,
      String locationArea,
      List<String> imageBase64List,
      bool contactViaMessenger,
      List<int>? categoryIds});
}

/// @nodoc
class __$$MarketplaceCreateRequestImplCopyWithImpl<$Res>
    extends _$MarketplaceCreateRequestCopyWithImpl<$Res,
        _$MarketplaceCreateRequestImpl>
    implements _$$MarketplaceCreateRequestImplCopyWith<$Res> {
  __$$MarketplaceCreateRequestImplCopyWithImpl(
      _$MarketplaceCreateRequestImpl _value,
      $Res Function(_$MarketplaceCreateRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? currency = null,
    Object? locationArea = null,
    Object? imageBase64List = null,
    Object? contactViaMessenger = null,
    Object? categoryIds = freezed,
  }) {
    return _then(_$MarketplaceCreateRequestImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      locationArea: null == locationArea
          ? _value.locationArea
          : locationArea // ignore: cast_nullable_to_non_nullable
              as String,
      imageBase64List: null == imageBase64List
          ? _value._imageBase64List
          : imageBase64List // ignore: cast_nullable_to_non_nullable
              as List<String>,
      contactViaMessenger: null == contactViaMessenger
          ? _value.contactViaMessenger
          : contactViaMessenger // ignore: cast_nullable_to_non_nullable
              as bool,
      categoryIds: freezed == categoryIds
          ? _value._categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketplaceCreateRequestImpl implements _MarketplaceCreateRequest {
  const _$MarketplaceCreateRequestImpl(
      {required this.title,
      required this.description,
      required this.price,
      this.currency = 'EUR',
      required this.locationArea,
      final List<String> imageBase64List = const <String>[],
      this.contactViaMessenger = true,
      final List<int>? categoryIds})
      : _imageBase64List = imageBase64List,
        _categoryIds = categoryIds;

  factory _$MarketplaceCreateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketplaceCreateRequestImplFromJson(json);

  @override
  final String title;
  @override
  final String description;
  @override
  final double price;
  @override
  @JsonKey()
  final String currency;
  @override
  final String locationArea;
  final List<String> _imageBase64List;
  @override
  @JsonKey()
  List<String> get imageBase64List {
    if (_imageBase64List is EqualUnmodifiableListView) return _imageBase64List;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageBase64List);
  }

  @override
  @JsonKey()
  final bool contactViaMessenger;
  final List<int>? _categoryIds;
  @override
  List<int>? get categoryIds {
    final value = _categoryIds;
    if (value == null) return null;
    if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'MarketplaceCreateRequest(title: $title, description: $description, price: $price, currency: $currency, locationArea: $locationArea, imageBase64List: $imageBase64List, contactViaMessenger: $contactViaMessenger, categoryIds: $categoryIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketplaceCreateRequestImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.locationArea, locationArea) ||
                other.locationArea == locationArea) &&
            const DeepCollectionEquality()
                .equals(other._imageBase64List, _imageBase64List) &&
            (identical(other.contactViaMessenger, contactViaMessenger) ||
                other.contactViaMessenger == contactViaMessenger) &&
            const DeepCollectionEquality()
                .equals(other._categoryIds, _categoryIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      description,
      price,
      currency,
      locationArea,
      const DeepCollectionEquality().hash(_imageBase64List),
      contactViaMessenger,
      const DeepCollectionEquality().hash(_categoryIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketplaceCreateRequestImplCopyWith<_$MarketplaceCreateRequestImpl>
      get copyWith => __$$MarketplaceCreateRequestImplCopyWithImpl<
          _$MarketplaceCreateRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketplaceCreateRequestImplToJson(
      this,
    );
  }
}

abstract class _MarketplaceCreateRequest implements MarketplaceCreateRequest {
  const factory _MarketplaceCreateRequest(
      {required final String title,
      required final String description,
      required final double price,
      final String currency,
      required final String locationArea,
      final List<String> imageBase64List,
      final bool contactViaMessenger,
      final List<int>? categoryIds}) = _$MarketplaceCreateRequestImpl;

  factory _MarketplaceCreateRequest.fromJson(Map<String, dynamic> json) =
      _$MarketplaceCreateRequestImpl.fromJson;

  @override
  String get title;
  @override
  String get description;
  @override
  double get price;
  @override
  String get currency;
  @override
  String get locationArea;
  @override
  List<String> get imageBase64List;
  @override
  bool get contactViaMessenger;
  @override
  List<int>? get categoryIds;
  @override
  @JsonKey(ignore: true)
  _$$MarketplaceCreateRequestImplCopyWith<_$MarketplaceCreateRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MarketplaceUpdateRequest _$MarketplaceUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return _MarketplaceUpdateRequest.fromJson(json);
}

/// @nodoc
mixin _$MarketplaceUpdateRequest {
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  String? get locationArea => throw _privateConstructorUsedError;
  List<String>? get imageBase64List => throw _privateConstructorUsedError;
  bool? get contactViaMessenger => throw _privateConstructorUsedError;
  List<int>? get categoryIds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MarketplaceUpdateRequestCopyWith<MarketplaceUpdateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketplaceUpdateRequestCopyWith<$Res> {
  factory $MarketplaceUpdateRequestCopyWith(MarketplaceUpdateRequest value,
          $Res Function(MarketplaceUpdateRequest) then) =
      _$MarketplaceUpdateRequestCopyWithImpl<$Res, MarketplaceUpdateRequest>;
  @useResult
  $Res call(
      {String? title,
      String? description,
      double? price,
      String? currency,
      String? locationArea,
      List<String>? imageBase64List,
      bool? contactViaMessenger,
      List<int>? categoryIds});
}

/// @nodoc
class _$MarketplaceUpdateRequestCopyWithImpl<$Res,
        $Val extends MarketplaceUpdateRequest>
    implements $MarketplaceUpdateRequestCopyWith<$Res> {
  _$MarketplaceUpdateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? price = freezed,
    Object? currency = freezed,
    Object? locationArea = freezed,
    Object? imageBase64List = freezed,
    Object? contactViaMessenger = freezed,
    Object? categoryIds = freezed,
  }) {
    return _then(_value.copyWith(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      locationArea: freezed == locationArea
          ? _value.locationArea
          : locationArea // ignore: cast_nullable_to_non_nullable
              as String?,
      imageBase64List: freezed == imageBase64List
          ? _value.imageBase64List
          : imageBase64List // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      contactViaMessenger: freezed == contactViaMessenger
          ? _value.contactViaMessenger
          : contactViaMessenger // ignore: cast_nullable_to_non_nullable
              as bool?,
      categoryIds: freezed == categoryIds
          ? _value.categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarketplaceUpdateRequestImplCopyWith<$Res>
    implements $MarketplaceUpdateRequestCopyWith<$Res> {
  factory _$$MarketplaceUpdateRequestImplCopyWith(
          _$MarketplaceUpdateRequestImpl value,
          $Res Function(_$MarketplaceUpdateRequestImpl) then) =
      __$$MarketplaceUpdateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? title,
      String? description,
      double? price,
      String? currency,
      String? locationArea,
      List<String>? imageBase64List,
      bool? contactViaMessenger,
      List<int>? categoryIds});
}

/// @nodoc
class __$$MarketplaceUpdateRequestImplCopyWithImpl<$Res>
    extends _$MarketplaceUpdateRequestCopyWithImpl<$Res,
        _$MarketplaceUpdateRequestImpl>
    implements _$$MarketplaceUpdateRequestImplCopyWith<$Res> {
  __$$MarketplaceUpdateRequestImplCopyWithImpl(
      _$MarketplaceUpdateRequestImpl _value,
      $Res Function(_$MarketplaceUpdateRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? price = freezed,
    Object? currency = freezed,
    Object? locationArea = freezed,
    Object? imageBase64List = freezed,
    Object? contactViaMessenger = freezed,
    Object? categoryIds = freezed,
  }) {
    return _then(_$MarketplaceUpdateRequestImpl(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      locationArea: freezed == locationArea
          ? _value.locationArea
          : locationArea // ignore: cast_nullable_to_non_nullable
              as String?,
      imageBase64List: freezed == imageBase64List
          ? _value._imageBase64List
          : imageBase64List // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      contactViaMessenger: freezed == contactViaMessenger
          ? _value.contactViaMessenger
          : contactViaMessenger // ignore: cast_nullable_to_non_nullable
              as bool?,
      categoryIds: freezed == categoryIds
          ? _value._categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketplaceUpdateRequestImpl implements _MarketplaceUpdateRequest {
  const _$MarketplaceUpdateRequestImpl(
      {this.title,
      this.description,
      this.price,
      this.currency,
      this.locationArea,
      final List<String>? imageBase64List,
      this.contactViaMessenger,
      final List<int>? categoryIds})
      : _imageBase64List = imageBase64List,
        _categoryIds = categoryIds;

  factory _$MarketplaceUpdateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketplaceUpdateRequestImplFromJson(json);

  @override
  final String? title;
  @override
  final String? description;
  @override
  final double? price;
  @override
  final String? currency;
  @override
  final String? locationArea;
  final List<String>? _imageBase64List;
  @override
  List<String>? get imageBase64List {
    final value = _imageBase64List;
    if (value == null) return null;
    if (_imageBase64List is EqualUnmodifiableListView) return _imageBase64List;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? contactViaMessenger;
  final List<int>? _categoryIds;
  @override
  List<int>? get categoryIds {
    final value = _categoryIds;
    if (value == null) return null;
    if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'MarketplaceUpdateRequest(title: $title, description: $description, price: $price, currency: $currency, locationArea: $locationArea, imageBase64List: $imageBase64List, contactViaMessenger: $contactViaMessenger, categoryIds: $categoryIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketplaceUpdateRequestImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.locationArea, locationArea) ||
                other.locationArea == locationArea) &&
            const DeepCollectionEquality()
                .equals(other._imageBase64List, _imageBase64List) &&
            (identical(other.contactViaMessenger, contactViaMessenger) ||
                other.contactViaMessenger == contactViaMessenger) &&
            const DeepCollectionEquality()
                .equals(other._categoryIds, _categoryIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      description,
      price,
      currency,
      locationArea,
      const DeepCollectionEquality().hash(_imageBase64List),
      contactViaMessenger,
      const DeepCollectionEquality().hash(_categoryIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketplaceUpdateRequestImplCopyWith<_$MarketplaceUpdateRequestImpl>
      get copyWith => __$$MarketplaceUpdateRequestImplCopyWithImpl<
          _$MarketplaceUpdateRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketplaceUpdateRequestImplToJson(
      this,
    );
  }
}

abstract class _MarketplaceUpdateRequest implements MarketplaceUpdateRequest {
  const factory _MarketplaceUpdateRequest(
      {final String? title,
      final String? description,
      final double? price,
      final String? currency,
      final String? locationArea,
      final List<String>? imageBase64List,
      final bool? contactViaMessenger,
      final List<int>? categoryIds}) = _$MarketplaceUpdateRequestImpl;

  factory _MarketplaceUpdateRequest.fromJson(Map<String, dynamic> json) =
      _$MarketplaceUpdateRequestImpl.fromJson;

  @override
  String? get title;
  @override
  String? get description;
  @override
  double? get price;
  @override
  String? get currency;
  @override
  String? get locationArea;
  @override
  List<String>? get imageBase64List;
  @override
  bool? get contactViaMessenger;
  @override
  List<int>? get categoryIds;
  @override
  @JsonKey(ignore: true)
  _$$MarketplaceUpdateRequestImplCopyWith<_$MarketplaceUpdateRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

VerificationRequest _$VerificationRequestFromJson(Map<String, dynamic> json) {
  return _VerificationRequest.fromJson(json);
}

/// @nodoc
mixin _$VerificationRequest {
  VerificationType get type => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String? get businessName => throw _privateConstructorUsedError;
  String? get businessRegNumber => throw _privateConstructorUsedError;
  String? get additionalInfo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VerificationRequestCopyWith<VerificationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationRequestCopyWith<$Res> {
  factory $VerificationRequestCopyWith(
          VerificationRequest value, $Res Function(VerificationRequest) then) =
      _$VerificationRequestCopyWithImpl<$Res, VerificationRequest>;
  @useResult
  $Res call(
      {VerificationType type,
      String fullName,
      String address,
      String? businessName,
      String? businessRegNumber,
      String? additionalInfo});
}

/// @nodoc
class _$VerificationRequestCopyWithImpl<$Res, $Val extends VerificationRequest>
    implements $VerificationRequestCopyWith<$Res> {
  _$VerificationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? fullName = null,
    Object? address = null,
    Object? businessName = freezed,
    Object? businessRegNumber = freezed,
    Object? additionalInfo = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as VerificationType,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessRegNumber: freezed == businessRegNumber
          ? _value.businessRegNumber
          : businessRegNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalInfo: freezed == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerificationRequestImplCopyWith<$Res>
    implements $VerificationRequestCopyWith<$Res> {
  factory _$$VerificationRequestImplCopyWith(_$VerificationRequestImpl value,
          $Res Function(_$VerificationRequestImpl) then) =
      __$$VerificationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {VerificationType type,
      String fullName,
      String address,
      String? businessName,
      String? businessRegNumber,
      String? additionalInfo});
}

/// @nodoc
class __$$VerificationRequestImplCopyWithImpl<$Res>
    extends _$VerificationRequestCopyWithImpl<$Res, _$VerificationRequestImpl>
    implements _$$VerificationRequestImplCopyWith<$Res> {
  __$$VerificationRequestImplCopyWithImpl(_$VerificationRequestImpl _value,
      $Res Function(_$VerificationRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? fullName = null,
    Object? address = null,
    Object? businessName = freezed,
    Object? businessRegNumber = freezed,
    Object? additionalInfo = freezed,
  }) {
    return _then(_$VerificationRequestImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as VerificationType,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessRegNumber: freezed == businessRegNumber
          ? _value.businessRegNumber
          : businessRegNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalInfo: freezed == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationRequestImpl implements _VerificationRequest {
  const _$VerificationRequestImpl(
      {required this.type,
      required this.fullName,
      required this.address,
      this.businessName,
      this.businessRegNumber,
      this.additionalInfo});

  factory _$VerificationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationRequestImplFromJson(json);

  @override
  final VerificationType type;
  @override
  final String fullName;
  @override
  final String address;
  @override
  final String? businessName;
  @override
  final String? businessRegNumber;
  @override
  final String? additionalInfo;

  @override
  String toString() {
    return 'VerificationRequest(type: $type, fullName: $fullName, address: $address, businessName: $businessName, businessRegNumber: $businessRegNumber, additionalInfo: $additionalInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationRequestImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.businessRegNumber, businessRegNumber) ||
                other.businessRegNumber == businessRegNumber) &&
            (identical(other.additionalInfo, additionalInfo) ||
                other.additionalInfo == additionalInfo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, fullName, address,
      businessName, businessRegNumber, additionalInfo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationRequestImplCopyWith<_$VerificationRequestImpl> get copyWith =>
      __$$VerificationRequestImplCopyWithImpl<_$VerificationRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationRequestImplToJson(
      this,
    );
  }
}

abstract class _VerificationRequest implements VerificationRequest {
  const factory _VerificationRequest(
      {required final VerificationType type,
      required final String fullName,
      required final String address,
      final String? businessName,
      final String? businessRegNumber,
      final String? additionalInfo}) = _$VerificationRequestImpl;

  factory _VerificationRequest.fromJson(Map<String, dynamic> json) =
      _$VerificationRequestImpl.fromJson;

  @override
  VerificationType get type;
  @override
  String get fullName;
  @override
  String get address;
  @override
  String? get businessName;
  @override
  String? get businessRegNumber;
  @override
  String? get additionalInfo;
  @override
  @JsonKey(ignore: true)
  _$$VerificationRequestImplCopyWith<_$VerificationRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VerificationStatus _$VerificationStatusFromJson(Map<String, dynamic> json) {
  return _VerificationStatus.fromJson(json);
}

/// @nodoc
mixin _$VerificationStatus {
  bool get isVerifiedResident => throw _privateConstructorUsedError;
  bool get isVerifiedBusiness => throw _privateConstructorUsedError;
  bool get hasPendingRequest => throw _privateConstructorUsedError;
  String? get pendingType => throw _privateConstructorUsedError;
  String? get adminNote => throw _privateConstructorUsedError;
  DateTime? get requestedAt => throw _privateConstructorUsedError;
  DateTime? get verifiedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VerificationStatusCopyWith<VerificationStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationStatusCopyWith<$Res> {
  factory $VerificationStatusCopyWith(
          VerificationStatus value, $Res Function(VerificationStatus) then) =
      _$VerificationStatusCopyWithImpl<$Res, VerificationStatus>;
  @useResult
  $Res call(
      {bool isVerifiedResident,
      bool isVerifiedBusiness,
      bool hasPendingRequest,
      String? pendingType,
      String? adminNote,
      DateTime? requestedAt,
      DateTime? verifiedAt});
}

/// @nodoc
class _$VerificationStatusCopyWithImpl<$Res, $Val extends VerificationStatus>
    implements $VerificationStatusCopyWith<$Res> {
  _$VerificationStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isVerifiedResident = null,
    Object? isVerifiedBusiness = null,
    Object? hasPendingRequest = null,
    Object? pendingType = freezed,
    Object? adminNote = freezed,
    Object? requestedAt = freezed,
    Object? verifiedAt = freezed,
  }) {
    return _then(_value.copyWith(
      isVerifiedResident: null == isVerifiedResident
          ? _value.isVerifiedResident
          : isVerifiedResident // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerifiedBusiness: null == isVerifiedBusiness
          ? _value.isVerifiedBusiness
          : isVerifiedBusiness // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPendingRequest: null == hasPendingRequest
          ? _value.hasPendingRequest
          : hasPendingRequest // ignore: cast_nullable_to_non_nullable
              as bool,
      pendingType: freezed == pendingType
          ? _value.pendingType
          : pendingType // ignore: cast_nullable_to_non_nullable
              as String?,
      adminNote: freezed == adminNote
          ? _value.adminNote
          : adminNote // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedAt: freezed == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerificationStatusImplCopyWith<$Res>
    implements $VerificationStatusCopyWith<$Res> {
  factory _$$VerificationStatusImplCopyWith(_$VerificationStatusImpl value,
          $Res Function(_$VerificationStatusImpl) then) =
      __$$VerificationStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isVerifiedResident,
      bool isVerifiedBusiness,
      bool hasPendingRequest,
      String? pendingType,
      String? adminNote,
      DateTime? requestedAt,
      DateTime? verifiedAt});
}

/// @nodoc
class __$$VerificationStatusImplCopyWithImpl<$Res>
    extends _$VerificationStatusCopyWithImpl<$Res, _$VerificationStatusImpl>
    implements _$$VerificationStatusImplCopyWith<$Res> {
  __$$VerificationStatusImplCopyWithImpl(_$VerificationStatusImpl _value,
      $Res Function(_$VerificationStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isVerifiedResident = null,
    Object? isVerifiedBusiness = null,
    Object? hasPendingRequest = null,
    Object? pendingType = freezed,
    Object? adminNote = freezed,
    Object? requestedAt = freezed,
    Object? verifiedAt = freezed,
  }) {
    return _then(_$VerificationStatusImpl(
      isVerifiedResident: null == isVerifiedResident
          ? _value.isVerifiedResident
          : isVerifiedResident // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerifiedBusiness: null == isVerifiedBusiness
          ? _value.isVerifiedBusiness
          : isVerifiedBusiness // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPendingRequest: null == hasPendingRequest
          ? _value.hasPendingRequest
          : hasPendingRequest // ignore: cast_nullable_to_non_nullable
              as bool,
      pendingType: freezed == pendingType
          ? _value.pendingType
          : pendingType // ignore: cast_nullable_to_non_nullable
              as String?,
      adminNote: freezed == adminNote
          ? _value.adminNote
          : adminNote // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedAt: freezed == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationStatusImpl implements _VerificationStatus {
  const _$VerificationStatusImpl(
      {this.isVerifiedResident = false,
      this.isVerifiedBusiness = false,
      this.hasPendingRequest = false,
      this.pendingType,
      this.adminNote,
      this.requestedAt,
      this.verifiedAt});

  factory _$VerificationStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationStatusImplFromJson(json);

  @override
  @JsonKey()
  final bool isVerifiedResident;
  @override
  @JsonKey()
  final bool isVerifiedBusiness;
  @override
  @JsonKey()
  final bool hasPendingRequest;
  @override
  final String? pendingType;
  @override
  final String? adminNote;
  @override
  final DateTime? requestedAt;
  @override
  final DateTime? verifiedAt;

  @override
  String toString() {
    return 'VerificationStatus(isVerifiedResident: $isVerifiedResident, isVerifiedBusiness: $isVerifiedBusiness, hasPendingRequest: $hasPendingRequest, pendingType: $pendingType, adminNote: $adminNote, requestedAt: $requestedAt, verifiedAt: $verifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationStatusImpl &&
            (identical(other.isVerifiedResident, isVerifiedResident) ||
                other.isVerifiedResident == isVerifiedResident) &&
            (identical(other.isVerifiedBusiness, isVerifiedBusiness) ||
                other.isVerifiedBusiness == isVerifiedBusiness) &&
            (identical(other.hasPendingRequest, hasPendingRequest) ||
                other.hasPendingRequest == hasPendingRequest) &&
            (identical(other.pendingType, pendingType) ||
                other.pendingType == pendingType) &&
            (identical(other.adminNote, adminNote) ||
                other.adminNote == adminNote) &&
            (identical(other.requestedAt, requestedAt) ||
                other.requestedAt == requestedAt) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isVerifiedResident,
      isVerifiedBusiness,
      hasPendingRequest,
      pendingType,
      adminNote,
      requestedAt,
      verifiedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationStatusImplCopyWith<_$VerificationStatusImpl> get copyWith =>
      __$$VerificationStatusImplCopyWithImpl<_$VerificationStatusImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationStatusImplToJson(
      this,
    );
  }
}

abstract class _VerificationStatus implements VerificationStatus {
  const factory _VerificationStatus(
      {final bool isVerifiedResident,
      final bool isVerifiedBusiness,
      final bool hasPendingRequest,
      final String? pendingType,
      final String? adminNote,
      final DateTime? requestedAt,
      final DateTime? verifiedAt}) = _$VerificationStatusImpl;

  factory _VerificationStatus.fromJson(Map<String, dynamic> json) =
      _$VerificationStatusImpl.fromJson;

  @override
  bool get isVerifiedResident;
  @override
  bool get isVerifiedBusiness;
  @override
  bool get hasPendingRequest;
  @override
  String? get pendingType;
  @override
  String? get adminNote;
  @override
  DateTime? get requestedAt;
  @override
  DateTime? get verifiedAt;
  @override
  @JsonKey(ignore: true)
  _$$VerificationStatusImplCopyWith<_$VerificationStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MarketplaceReport _$MarketplaceReportFromJson(Map<String, dynamic> json) {
  return _MarketplaceReport.fromJson(json);
}

/// @nodoc
mixin _$MarketplaceReport {
  int get listingId => throw _privateConstructorUsedError;
  ReportReason get reason => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MarketplaceReportCopyWith<MarketplaceReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketplaceReportCopyWith<$Res> {
  factory $MarketplaceReportCopyWith(
          MarketplaceReport value, $Res Function(MarketplaceReport) then) =
      _$MarketplaceReportCopyWithImpl<$Res, MarketplaceReport>;
  @useResult
  $Res call({int listingId, ReportReason reason, String description});
}

/// @nodoc
class _$MarketplaceReportCopyWithImpl<$Res, $Val extends MarketplaceReport>
    implements $MarketplaceReportCopyWith<$Res> {
  _$MarketplaceReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? listingId = null,
    Object? reason = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      listingId: null == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as ReportReason,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarketplaceReportImplCopyWith<$Res>
    implements $MarketplaceReportCopyWith<$Res> {
  factory _$$MarketplaceReportImplCopyWith(_$MarketplaceReportImpl value,
          $Res Function(_$MarketplaceReportImpl) then) =
      __$$MarketplaceReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int listingId, ReportReason reason, String description});
}

/// @nodoc
class __$$MarketplaceReportImplCopyWithImpl<$Res>
    extends _$MarketplaceReportCopyWithImpl<$Res, _$MarketplaceReportImpl>
    implements _$$MarketplaceReportImplCopyWith<$Res> {
  __$$MarketplaceReportImplCopyWithImpl(_$MarketplaceReportImpl _value,
      $Res Function(_$MarketplaceReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? listingId = null,
    Object? reason = null,
    Object? description = null,
  }) {
    return _then(_$MarketplaceReportImpl(
      listingId: null == listingId
          ? _value.listingId
          : listingId // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as ReportReason,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketplaceReportImpl implements _MarketplaceReport {
  const _$MarketplaceReportImpl(
      {required this.listingId,
      required this.reason,
      required this.description});

  factory _$MarketplaceReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketplaceReportImplFromJson(json);

  @override
  final int listingId;
  @override
  final ReportReason reason;
  @override
  final String description;

  @override
  String toString() {
    return 'MarketplaceReport(listingId: $listingId, reason: $reason, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketplaceReportImpl &&
            (identical(other.listingId, listingId) ||
                other.listingId == listingId) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, listingId, reason, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketplaceReportImplCopyWith<_$MarketplaceReportImpl> get copyWith =>
      __$$MarketplaceReportImplCopyWithImpl<_$MarketplaceReportImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketplaceReportImplToJson(
      this,
    );
  }
}

abstract class _MarketplaceReport implements MarketplaceReport {
  const factory _MarketplaceReport(
      {required final int listingId,
      required final ReportReason reason,
      required final String description}) = _$MarketplaceReportImpl;

  factory _MarketplaceReport.fromJson(Map<String, dynamic> json) =
      _$MarketplaceReportImpl.fromJson;

  @override
  int get listingId;
  @override
  ReportReason get reason;
  @override
  String get description;
  @override
  @JsonKey(ignore: true)
  _$$MarketplaceReportImplCopyWith<_$MarketplaceReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RateLimitInfo _$RateLimitInfoFromJson(Map<String, dynamic> json) {
  return _RateLimitInfo.fromJson(json);
}

/// @nodoc
mixin _$RateLimitInfo {
  int get dailyCreateLimit => throw _privateConstructorUsedError;
  int get dailyEditLimit => throw _privateConstructorUsedError;
  int get createdToday => throw _privateConstructorUsedError;
  int get editedToday => throw _privateConstructorUsedError;
  bool get canCreate => throw _privateConstructorUsedError;
  bool get canEdit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RateLimitInfoCopyWith<RateLimitInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RateLimitInfoCopyWith<$Res> {
  factory $RateLimitInfoCopyWith(
          RateLimitInfo value, $Res Function(RateLimitInfo) then) =
      _$RateLimitInfoCopyWithImpl<$Res, RateLimitInfo>;
  @useResult
  $Res call(
      {int dailyCreateLimit,
      int dailyEditLimit,
      int createdToday,
      int editedToday,
      bool canCreate,
      bool canEdit});
}

/// @nodoc
class _$RateLimitInfoCopyWithImpl<$Res, $Val extends RateLimitInfo>
    implements $RateLimitInfoCopyWith<$Res> {
  _$RateLimitInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dailyCreateLimit = null,
    Object? dailyEditLimit = null,
    Object? createdToday = null,
    Object? editedToday = null,
    Object? canCreate = null,
    Object? canEdit = null,
  }) {
    return _then(_value.copyWith(
      dailyCreateLimit: null == dailyCreateLimit
          ? _value.dailyCreateLimit
          : dailyCreateLimit // ignore: cast_nullable_to_non_nullable
              as int,
      dailyEditLimit: null == dailyEditLimit
          ? _value.dailyEditLimit
          : dailyEditLimit // ignore: cast_nullable_to_non_nullable
              as int,
      createdToday: null == createdToday
          ? _value.createdToday
          : createdToday // ignore: cast_nullable_to_non_nullable
              as int,
      editedToday: null == editedToday
          ? _value.editedToday
          : editedToday // ignore: cast_nullable_to_non_nullable
              as int,
      canCreate: null == canCreate
          ? _value.canCreate
          : canCreate // ignore: cast_nullable_to_non_nullable
              as bool,
      canEdit: null == canEdit
          ? _value.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RateLimitInfoImplCopyWith<$Res>
    implements $RateLimitInfoCopyWith<$Res> {
  factory _$$RateLimitInfoImplCopyWith(
          _$RateLimitInfoImpl value, $Res Function(_$RateLimitInfoImpl) then) =
      __$$RateLimitInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int dailyCreateLimit,
      int dailyEditLimit,
      int createdToday,
      int editedToday,
      bool canCreate,
      bool canEdit});
}

/// @nodoc
class __$$RateLimitInfoImplCopyWithImpl<$Res>
    extends _$RateLimitInfoCopyWithImpl<$Res, _$RateLimitInfoImpl>
    implements _$$RateLimitInfoImplCopyWith<$Res> {
  __$$RateLimitInfoImplCopyWithImpl(
      _$RateLimitInfoImpl _value, $Res Function(_$RateLimitInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dailyCreateLimit = null,
    Object? dailyEditLimit = null,
    Object? createdToday = null,
    Object? editedToday = null,
    Object? canCreate = null,
    Object? canEdit = null,
  }) {
    return _then(_$RateLimitInfoImpl(
      dailyCreateLimit: null == dailyCreateLimit
          ? _value.dailyCreateLimit
          : dailyCreateLimit // ignore: cast_nullable_to_non_nullable
              as int,
      dailyEditLimit: null == dailyEditLimit
          ? _value.dailyEditLimit
          : dailyEditLimit // ignore: cast_nullable_to_non_nullable
              as int,
      createdToday: null == createdToday
          ? _value.createdToday
          : createdToday // ignore: cast_nullable_to_non_nullable
              as int,
      editedToday: null == editedToday
          ? _value.editedToday
          : editedToday // ignore: cast_nullable_to_non_nullable
              as int,
      canCreate: null == canCreate
          ? _value.canCreate
          : canCreate // ignore: cast_nullable_to_non_nullable
              as bool,
      canEdit: null == canEdit
          ? _value.canEdit
          : canEdit // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RateLimitInfoImpl implements _RateLimitInfo {
  const _$RateLimitInfoImpl(
      {required this.dailyCreateLimit,
      required this.dailyEditLimit,
      required this.createdToday,
      required this.editedToday,
      required this.canCreate,
      required this.canEdit});

  factory _$RateLimitInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RateLimitInfoImplFromJson(json);

  @override
  final int dailyCreateLimit;
  @override
  final int dailyEditLimit;
  @override
  final int createdToday;
  @override
  final int editedToday;
  @override
  final bool canCreate;
  @override
  final bool canEdit;

  @override
  String toString() {
    return 'RateLimitInfo(dailyCreateLimit: $dailyCreateLimit, dailyEditLimit: $dailyEditLimit, createdToday: $createdToday, editedToday: $editedToday, canCreate: $canCreate, canEdit: $canEdit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RateLimitInfoImpl &&
            (identical(other.dailyCreateLimit, dailyCreateLimit) ||
                other.dailyCreateLimit == dailyCreateLimit) &&
            (identical(other.dailyEditLimit, dailyEditLimit) ||
                other.dailyEditLimit == dailyEditLimit) &&
            (identical(other.createdToday, createdToday) ||
                other.createdToday == createdToday) &&
            (identical(other.editedToday, editedToday) ||
                other.editedToday == editedToday) &&
            (identical(other.canCreate, canCreate) ||
                other.canCreate == canCreate) &&
            (identical(other.canEdit, canEdit) || other.canEdit == canEdit));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, dailyCreateLimit, dailyEditLimit,
      createdToday, editedToday, canCreate, canEdit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RateLimitInfoImplCopyWith<_$RateLimitInfoImpl> get copyWith =>
      __$$RateLimitInfoImplCopyWithImpl<_$RateLimitInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RateLimitInfoImplToJson(
      this,
    );
  }
}

abstract class _RateLimitInfo implements RateLimitInfo {
  const factory _RateLimitInfo(
      {required final int dailyCreateLimit,
      required final int dailyEditLimit,
      required final int createdToday,
      required final int editedToday,
      required final bool canCreate,
      required final bool canEdit}) = _$RateLimitInfoImpl;

  factory _RateLimitInfo.fromJson(Map<String, dynamic> json) =
      _$RateLimitInfoImpl.fromJson;

  @override
  int get dailyCreateLimit;
  @override
  int get dailyEditLimit;
  @override
  int get createdToday;
  @override
  int get editedToday;
  @override
  bool get canCreate;
  @override
  bool get canEdit;
  @override
  @JsonKey(ignore: true)
  _$$RateLimitInfoImplCopyWith<_$RateLimitInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MarketplaceListingPage _$MarketplaceListingPageFromJson(
    Map<String, dynamic> json) {
  return _MarketplaceListingPage.fromJson(json);
}

/// @nodoc
mixin _$MarketplaceListingPage {
  List<MarketplaceListing> get data => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get perPage => throw _privateConstructorUsedError;
  bool get hasNextPage => throw _privateConstructorUsedError;
  bool get hasPreviousPage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MarketplaceListingPageCopyWith<MarketplaceListingPage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketplaceListingPageCopyWith<$Res> {
  factory $MarketplaceListingPageCopyWith(MarketplaceListingPage value,
          $Res Function(MarketplaceListingPage) then) =
      _$MarketplaceListingPageCopyWithImpl<$Res, MarketplaceListingPage>;
  @useResult
  $Res call(
      {List<MarketplaceListing> data,
      int totalItems,
      int totalPages,
      int currentPage,
      int perPage,
      bool hasNextPage,
      bool hasPreviousPage});
}

/// @nodoc
class _$MarketplaceListingPageCopyWithImpl<$Res,
        $Val extends MarketplaceListingPage>
    implements $MarketplaceListingPageCopyWith<$Res> {
  _$MarketplaceListingPageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? totalItems = null,
    Object? totalPages = null,
    Object? currentPage = null,
    Object? perPage = null,
    Object? hasNextPage = null,
    Object? hasPreviousPage = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<MarketplaceListing>,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasNextPage: null == hasNextPage
          ? _value.hasNextPage
          : hasNextPage // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPreviousPage: null == hasPreviousPage
          ? _value.hasPreviousPage
          : hasPreviousPage // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarketplaceListingPageImplCopyWith<$Res>
    implements $MarketplaceListingPageCopyWith<$Res> {
  factory _$$MarketplaceListingPageImplCopyWith(
          _$MarketplaceListingPageImpl value,
          $Res Function(_$MarketplaceListingPageImpl) then) =
      __$$MarketplaceListingPageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<MarketplaceListing> data,
      int totalItems,
      int totalPages,
      int currentPage,
      int perPage,
      bool hasNextPage,
      bool hasPreviousPage});
}

/// @nodoc
class __$$MarketplaceListingPageImplCopyWithImpl<$Res>
    extends _$MarketplaceListingPageCopyWithImpl<$Res,
        _$MarketplaceListingPageImpl>
    implements _$$MarketplaceListingPageImplCopyWith<$Res> {
  __$$MarketplaceListingPageImplCopyWithImpl(
      _$MarketplaceListingPageImpl _value,
      $Res Function(_$MarketplaceListingPageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? totalItems = null,
    Object? totalPages = null,
    Object? currentPage = null,
    Object? perPage = null,
    Object? hasNextPage = null,
    Object? hasPreviousPage = null,
  }) {
    return _then(_$MarketplaceListingPageImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<MarketplaceListing>,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasNextPage: null == hasNextPage
          ? _value.hasNextPage
          : hasNextPage // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPreviousPage: null == hasPreviousPage
          ? _value.hasPreviousPage
          : hasPreviousPage // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketplaceListingPageImpl implements _MarketplaceListingPage {
  const _$MarketplaceListingPageImpl(
      {required final List<MarketplaceListing> data,
      required this.totalItems,
      required this.totalPages,
      required this.currentPage,
      required this.perPage,
      required this.hasNextPage,
      required this.hasPreviousPage})
      : _data = data;

  factory _$MarketplaceListingPageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketplaceListingPageImplFromJson(json);

  final List<MarketplaceListing> _data;
  @override
  List<MarketplaceListing> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final int totalItems;
  @override
  final int totalPages;
  @override
  final int currentPage;
  @override
  final int perPage;
  @override
  final bool hasNextPage;
  @override
  final bool hasPreviousPage;

  @override
  String toString() {
    return 'MarketplaceListingPage(data: $data, totalItems: $totalItems, totalPages: $totalPages, currentPage: $currentPage, perPage: $perPage, hasNextPage: $hasNextPage, hasPreviousPage: $hasPreviousPage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketplaceListingPageImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.hasNextPage, hasNextPage) ||
                other.hasNextPage == hasNextPage) &&
            (identical(other.hasPreviousPage, hasPreviousPage) ||
                other.hasPreviousPage == hasPreviousPage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_data),
      totalItems,
      totalPages,
      currentPage,
      perPage,
      hasNextPage,
      hasPreviousPage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketplaceListingPageImplCopyWith<_$MarketplaceListingPageImpl>
      get copyWith => __$$MarketplaceListingPageImplCopyWithImpl<
          _$MarketplaceListingPageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketplaceListingPageImplToJson(
      this,
    );
  }
}

abstract class _MarketplaceListingPage implements MarketplaceListingPage {
  const factory _MarketplaceListingPage(
      {required final List<MarketplaceListing> data,
      required final int totalItems,
      required final int totalPages,
      required final int currentPage,
      required final int perPage,
      required final bool hasNextPage,
      required final bool hasPreviousPage}) = _$MarketplaceListingPageImpl;

  factory _MarketplaceListingPage.fromJson(Map<String, dynamic> json) =
      _$MarketplaceListingPageImpl.fromJson;

  @override
  List<MarketplaceListing> get data;
  @override
  int get totalItems;
  @override
  int get totalPages;
  @override
  int get currentPage;
  @override
  int get perPage;
  @override
  bool get hasNextPage;
  @override
  bool get hasPreviousPage;
  @override
  @JsonKey(ignore: true)
  _$$MarketplaceListingPageImplCopyWith<_$MarketplaceListingPageImpl>
      get copyWith => throw _privateConstructorUsedError;
}
