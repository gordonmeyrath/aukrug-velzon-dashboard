import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'marketplace_models.freezed.dart';
part 'marketplace_models.g.dart';

@freezed
class MarketplaceListing with _$MarketplaceListing {
  const factory MarketplaceListing({
    required int id,
    required String title,
    required String description,
    required double price,
    @Default('EUR') String currency,
    required String locationArea,
    required List<String> images,
    @Default('active') String status,
    @Default(false) bool contactViaMessenger,
    required String authorName,
    required int authorId,
    required DateTime createdAt,
    DateTime? updatedAt,
    List<String>? categories,
    @Default(false) bool isFavorite,
    @Default(false) bool isOwner,
    @Default(false) bool canEdit,
    @Default(0) int viewCount,
  }) = _MarketplaceListing;

  factory MarketplaceListing.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceListingFromJson(json);
}

@freezed
class MarketplaceCategory with _$MarketplaceCategory {
  const factory MarketplaceCategory({
    required int id,
    required String name,
    required String slug,
    String? description,
    String? iconName,
    @Default(0) int count,
    int? parentId,
    List<MarketplaceCategory>? children,
  }) = _MarketplaceCategory;

  factory MarketplaceCategory.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceCategoryFromJson(json);
}

@freezed
class MarketplaceFilters with _$MarketplaceFilters {
  const factory MarketplaceFilters({
    @Default('') String search,
    List<int>? categoryIds,
    double? priceMin,
    double? priceMax,
    String? locationArea,
    @Default('active') String status,
    @Default(1) int page,
    @Default(20) int perPage,
    @Default('date_desc') String sort,
    @Default(false) bool onlyFavorites,
    double? maxDistance,
  }) = _MarketplaceFilters;

  factory MarketplaceFilters.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceFiltersFromJson(json);
}

@freezed
class MarketplaceCreateRequest with _$MarketplaceCreateRequest {
  const factory MarketplaceCreateRequest({
    required String title,
    required String description,
    required double price,
    @Default('EUR') String currency,
    required String locationArea,
    @Default(<String>[]) List<String> imageBase64List,
    @Default(true) bool contactViaMessenger,
    List<int>? categoryIds,
  }) = _MarketplaceCreateRequest;

  factory MarketplaceCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceCreateRequestFromJson(json);
}

@freezed
class MarketplaceUpdateRequest with _$MarketplaceUpdateRequest {
  const factory MarketplaceUpdateRequest({
    String? title,
    String? description,
    double? price,
    String? currency,
    String? locationArea,
    List<String>? imageBase64List,
    bool? contactViaMessenger,
    List<int>? categoryIds,
  }) = _MarketplaceUpdateRequest;

  factory MarketplaceUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceUpdateRequestFromJson(json);
}

@freezed
class VerificationRequest with _$VerificationRequest {
  const factory VerificationRequest({
    required VerificationType type,
    required String fullName,
    required String address,
    String? businessName,
    String? businessRegNumber,
    String? additionalInfo,
  }) = _VerificationRequest;

  factory VerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$VerificationRequestFromJson(json);
}

@freezed
class VerificationStatus with _$VerificationStatus {
  const factory VerificationStatus({
    @Default(false) bool isVerifiedResident,
    @Default(false) bool isVerifiedBusiness,
    @Default(false) bool hasPendingRequest,
    String? pendingType,
    String? adminNote,
    DateTime? requestedAt,
    DateTime? verifiedAt,
  }) = _VerificationStatus;

  factory VerificationStatus.fromJson(Map<String, dynamic> json) =>
      _$VerificationStatusFromJson(json);
}

@freezed
class MarketplaceReport with _$MarketplaceReport {
  const factory MarketplaceReport({
    required int listingId,
    required ReportReason reason,
    required String description,
  }) = _MarketplaceReport;

  factory MarketplaceReport.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceReportFromJson(json);
}

@freezed
class RateLimitInfo with _$RateLimitInfo {
  const factory RateLimitInfo({
    required int dailyCreateLimit,
    required int dailyEditLimit,
    required int createdToday,
    required int editedToday,
    required bool canCreate,
    required bool canEdit,
  }) = _RateLimitInfo;

  factory RateLimitInfo.fromJson(Map<String, dynamic> json) =>
      _$RateLimitInfoFromJson(json);
}

enum MarketplaceListingStatus {
  @JsonValue('active')
  active,
  @JsonValue('paused')
  paused,
  @JsonValue('sold')
  sold,
}

enum VerificationType {
  @JsonValue('resident')
  resident,
  @JsonValue('business')
  business,
}

enum ReportReason {
  @JsonValue('inappropriate')
  inappropriate,
  @JsonValue('spam')
  spam,
  @JsonValue('fraud')
  fraud,
  @JsonValue('duplicate')
  duplicate,
  @JsonValue('other')
  other,
}

enum MarketplaceSortOrder {
  @JsonValue('date_desc')
  newestFirst,
  @JsonValue('date_asc')
  oldestFirst,
  @JsonValue('price_asc')
  priceLowToHigh,
  @JsonValue('price_desc')
  priceHighToLow,
  @JsonValue('title_asc')
  titleAZ,
  @JsonValue('title_desc')
  titleZA,
}

// Exception classes
class MarketplaceException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const MarketplaceException(this.message, {this.statusCode, this.errorCode});

  @override
  String toString() => 'MarketplaceException: $message';
}

class VerificationRequiredException extends MarketplaceException {
  const VerificationRequiredException()
    : super('Verification required to perform this action');
}

class RateLimitExceededException extends MarketplaceException {
  const RateLimitExceededException()
    : super('Rate limit exceeded. Please try again tomorrow.');
}

class InsufficientPermissionsException extends MarketplaceException {
  const InsufficientPermissionsException()
    : super('Insufficient permissions for this action');
}

// API Response wrapper (no JSON serialization for generics)
abstract class ApiResponse<T> {
  const ApiResponse();
}

class ApiSuccess<T> extends ApiResponse<T> {
  final T data;
  const ApiSuccess(this.data);
}

class ApiError<T> extends ApiResponse<T> {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const ApiError(this.message, {this.statusCode, this.errorCode});
}

@freezed
class MarketplaceListingPage with _$MarketplaceListingPage {
  const factory MarketplaceListingPage({
    required List<MarketplaceListing> data,
    required int totalItems,
    required int totalPages,
    required int currentPage,
    required int perPage,
    required bool hasNextPage,
    required bool hasPreviousPage,
  }) = _MarketplaceListingPage;

  factory MarketplaceListingPage.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceListingPageFromJson(json);
}

// Create the generic class without JSON serialization
class PaginatedResponse<T> {
  final List<T> data;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int perPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedResponse({
    required this.data,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.perPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  PaginatedResponse<T> copyWith({
    List<T>? data,
    int? totalItems,
    int? totalPages,
    int? currentPage,
    int? perPage,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) {
    return PaginatedResponse<T>(
      data: data ?? this.data,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      perPage: perPage ?? this.perPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }
}

// Extensions for better UX
extension MarketplaceListingExtensions on MarketplaceListing {
  String get formattedPrice => '$price ${currency.toUpperCase()}';

  String get primaryImageUrl => images.isNotEmpty ? images.first : '';

  bool get hasMultipleImages => images.length > 1;

  bool get isActive => status == 'active';

  bool get isPaused => status == 'paused';

  bool get isSold => status == 'sold';

  Color get statusColor {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'paused':
        return Colors.orange;
      case 'sold':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String get statusDisplayText {
    switch (status) {
      case 'active':
        return 'Aktiv';
      case 'paused':
        return 'Pausiert';
      case 'sold':
        return 'Verkauft';
      default:
        return 'Unbekannt';
    }
  }

  String get relativeTimeString {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return 'vor ${difference.inDays} Tagen';
    } else if (difference.inDays > 0) {
      return 'vor ${difference.inDays} Tag${difference.inDays > 1 ? 'en' : ''}';
    } else if (difference.inHours > 0) {
      return 'vor ${difference.inHours} Stunde${difference.inHours > 1 ? 'n' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'vor ${difference.inMinutes} Minute${difference.inMinutes > 1 ? 'n' : ''}';
    } else {
      return 'gerade eben';
    }
  }
}

extension VerificationStatusExtensions on VerificationStatus {
  bool get isVerified => isVerifiedResident || isVerifiedBusiness;

  bool get canCreateListings => isVerified;

  String get displayStatus {
    if (hasPendingRequest) {
      return 'Verifikation ausstehend';
    } else if (isVerifiedBusiness) {
      return 'Verifiziertes Unternehmen';
    } else if (isVerifiedResident) {
      return 'Verifizierter Einwohner';
    } else {
      return 'Nicht verifiziert';
    }
  }

  IconData get statusIcon {
    if (hasPendingRequest) {
      return Icons.schedule;
    } else if (isVerifiedBusiness) {
      return Icons.business_center;
    } else if (isVerifiedResident) {
      return Icons.verified_user;
    } else {
      return Icons.warning;
    }
  }

  Color get statusColor {
    if (hasPendingRequest) {
      return Colors.orange;
    } else if (isVerified) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}
