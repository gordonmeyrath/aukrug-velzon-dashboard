// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketplaceListingImpl _$$MarketplaceListingImplFromJson(
        Map<String, dynamic> json) =>
    _$MarketplaceListingImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EUR',
      locationArea: json['locationArea'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      status: json['status'] as String? ?? 'active',
      contactViaMessenger: json['contactViaMessenger'] as bool? ?? false,
      authorName: json['authorName'] as String,
      authorId: (json['authorId'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      isOwner: json['isOwner'] as bool? ?? false,
      canEdit: json['canEdit'] as bool? ?? false,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MarketplaceListingImplToJson(
        _$MarketplaceListingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'currency': instance.currency,
      'locationArea': instance.locationArea,
      'images': instance.images,
      'status': instance.status,
      'contactViaMessenger': instance.contactViaMessenger,
      'authorName': instance.authorName,
      'authorId': instance.authorId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'categories': instance.categories,
      'isFavorite': instance.isFavorite,
      'isOwner': instance.isOwner,
      'canEdit': instance.canEdit,
      'viewCount': instance.viewCount,
    };

_$MarketplaceCategoryImpl _$$MarketplaceCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$MarketplaceCategoryImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      iconName: json['iconName'] as String?,
      count: (json['count'] as num?)?.toInt() ?? 0,
      parentId: (json['parentId'] as num?)?.toInt(),
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => MarketplaceCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$MarketplaceCategoryImplToJson(
        _$MarketplaceCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'iconName': instance.iconName,
      'count': instance.count,
      'parentId': instance.parentId,
      'children': instance.children,
    };

_$MarketplaceFiltersImpl _$$MarketplaceFiltersImplFromJson(
        Map<String, dynamic> json) =>
    _$MarketplaceFiltersImpl(
      search: json['search'] as String? ?? '',
      categoryIds: (json['categoryIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      priceMin: (json['priceMin'] as num?)?.toDouble(),
      priceMax: (json['priceMax'] as num?)?.toDouble(),
      locationArea: json['locationArea'] as String?,
      status: json['status'] as String? ?? 'active',
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['perPage'] as num?)?.toInt() ?? 20,
      sort: json['sort'] as String? ?? 'date_desc',
      onlyFavorites: json['onlyFavorites'] as bool? ?? false,
      maxDistance: (json['maxDistance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$MarketplaceFiltersImplToJson(
        _$MarketplaceFiltersImpl instance) =>
    <String, dynamic>{
      'search': instance.search,
      'categoryIds': instance.categoryIds,
      'priceMin': instance.priceMin,
      'priceMax': instance.priceMax,
      'locationArea': instance.locationArea,
      'status': instance.status,
      'page': instance.page,
      'perPage': instance.perPage,
      'sort': instance.sort,
      'onlyFavorites': instance.onlyFavorites,
      'maxDistance': instance.maxDistance,
    };

_$MarketplaceCreateRequestImpl _$$MarketplaceCreateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$MarketplaceCreateRequestImpl(
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EUR',
      locationArea: json['locationArea'] as String,
      imageBase64List: (json['imageBase64List'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      contactViaMessenger: json['contactViaMessenger'] as bool? ?? true,
      categoryIds: (json['categoryIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$$MarketplaceCreateRequestImplToJson(
        _$MarketplaceCreateRequestImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'currency': instance.currency,
      'locationArea': instance.locationArea,
      'imageBase64List': instance.imageBase64List,
      'contactViaMessenger': instance.contactViaMessenger,
      'categoryIds': instance.categoryIds,
    };

_$MarketplaceUpdateRequestImpl _$$MarketplaceUpdateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$MarketplaceUpdateRequestImpl(
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      locationArea: json['locationArea'] as String?,
      imageBase64List: (json['imageBase64List'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      contactViaMessenger: json['contactViaMessenger'] as bool?,
      categoryIds: (json['categoryIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$$MarketplaceUpdateRequestImplToJson(
        _$MarketplaceUpdateRequestImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'currency': instance.currency,
      'locationArea': instance.locationArea,
      'imageBase64List': instance.imageBase64List,
      'contactViaMessenger': instance.contactViaMessenger,
      'categoryIds': instance.categoryIds,
    };

_$VerificationRequestImpl _$$VerificationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationRequestImpl(
      type: $enumDecode(_$VerificationTypeEnumMap, json['type']),
      fullName: json['fullName'] as String,
      address: json['address'] as String,
      businessName: json['businessName'] as String?,
      businessRegNumber: json['businessRegNumber'] as String?,
      additionalInfo: json['additionalInfo'] as String?,
    );

Map<String, dynamic> _$$VerificationRequestImplToJson(
        _$VerificationRequestImpl instance) =>
    <String, dynamic>{
      'type': _$VerificationTypeEnumMap[instance.type]!,
      'fullName': instance.fullName,
      'address': instance.address,
      'businessName': instance.businessName,
      'businessRegNumber': instance.businessRegNumber,
      'additionalInfo': instance.additionalInfo,
    };

const _$VerificationTypeEnumMap = {
  VerificationType.resident: 'resident',
  VerificationType.business: 'business',
};

_$VerificationStatusImpl _$$VerificationStatusImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationStatusImpl(
      isVerifiedResident: json['isVerifiedResident'] as bool? ?? false,
      isVerifiedBusiness: json['isVerifiedBusiness'] as bool? ?? false,
      hasPendingRequest: json['hasPendingRequest'] as bool? ?? false,
      pendingType: json['pendingType'] as String?,
      adminNote: json['adminNote'] as String?,
      requestedAt: json['requestedAt'] == null
          ? null
          : DateTime.parse(json['requestedAt'] as String),
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
    );

Map<String, dynamic> _$$VerificationStatusImplToJson(
        _$VerificationStatusImpl instance) =>
    <String, dynamic>{
      'isVerifiedResident': instance.isVerifiedResident,
      'isVerifiedBusiness': instance.isVerifiedBusiness,
      'hasPendingRequest': instance.hasPendingRequest,
      'pendingType': instance.pendingType,
      'adminNote': instance.adminNote,
      'requestedAt': instance.requestedAt?.toIso8601String(),
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
    };

_$MarketplaceReportImpl _$$MarketplaceReportImplFromJson(
        Map<String, dynamic> json) =>
    _$MarketplaceReportImpl(
      listingId: (json['listingId'] as num).toInt(),
      reason: $enumDecode(_$ReportReasonEnumMap, json['reason']),
      description: json['description'] as String,
    );

Map<String, dynamic> _$$MarketplaceReportImplToJson(
        _$MarketplaceReportImpl instance) =>
    <String, dynamic>{
      'listingId': instance.listingId,
      'reason': _$ReportReasonEnumMap[instance.reason]!,
      'description': instance.description,
    };

const _$ReportReasonEnumMap = {
  ReportReason.inappropriate: 'inappropriate',
  ReportReason.spam: 'spam',
  ReportReason.fraud: 'fraud',
  ReportReason.duplicate: 'duplicate',
  ReportReason.other: 'other',
};

_$RateLimitInfoImpl _$$RateLimitInfoImplFromJson(Map<String, dynamic> json) =>
    _$RateLimitInfoImpl(
      dailyCreateLimit: (json['dailyCreateLimit'] as num).toInt(),
      dailyEditLimit: (json['dailyEditLimit'] as num).toInt(),
      createdToday: (json['createdToday'] as num).toInt(),
      editedToday: (json['editedToday'] as num).toInt(),
      canCreate: json['canCreate'] as bool,
      canEdit: json['canEdit'] as bool,
    );

Map<String, dynamic> _$$RateLimitInfoImplToJson(_$RateLimitInfoImpl instance) =>
    <String, dynamic>{
      'dailyCreateLimit': instance.dailyCreateLimit,
      'dailyEditLimit': instance.dailyEditLimit,
      'createdToday': instance.createdToday,
      'editedToday': instance.editedToday,
      'canCreate': instance.canCreate,
      'canEdit': instance.canEdit,
    };

_$MarketplaceListingPageImpl _$$MarketplaceListingPageImplFromJson(
        Map<String, dynamic> json) =>
    _$MarketplaceListingPageImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => MarketplaceListing.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalItems: (json['totalItems'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      currentPage: (json['currentPage'] as num).toInt(),
      perPage: (json['perPage'] as num).toInt(),
      hasNextPage: json['hasNextPage'] as bool,
      hasPreviousPage: json['hasPreviousPage'] as bool,
    );

Map<String, dynamic> _$$MarketplaceListingPageImplToJson(
        _$MarketplaceListingPageImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
      'currentPage': instance.currentPage,
      'perPage': instance.perPage,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
    };
