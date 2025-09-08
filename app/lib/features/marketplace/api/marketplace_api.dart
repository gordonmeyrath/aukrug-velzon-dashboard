import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../models/marketplace_models.dart';

class MarketplaceApiClient {
  final ApiClient _apiClient;
  final Ref _ref;

  MarketplaceApiClient(this._apiClient, this._ref);

  /// Get listings with filters and pagination
  Future<PaginatedResponse<MarketplaceListing>> getListings({
    MarketplaceFilters? filters,
  }) async {
    try {
      final queryParams = _buildQueryParams(filters);

      final response = await _apiClient.get(
        '/aukrug/v1/market/listings',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final List<MarketplaceListing> listings = [];
        if (data['data'] != null) {
          for (var item in data['data']) {
            listings.add(MarketplaceListing.fromJson(item));
          }
        }

        return PaginatedResponse<MarketplaceListing>(
          data: listings,
          currentPage: data['current_page'] ?? 1,
          totalPages: data['last_page'] ?? 1,
          perPage: data['per_page'] ?? 20,
          totalItems: data['total'] ?? 0,
          hasNextPage: (data['current_page'] ?? 1) < (data['last_page'] ?? 1),
          hasPreviousPage: (data['current_page'] ?? 1) > 1,
        );
      } else {
        throw ApiException(
          'Failed to load listings: ${response.statusMessage}',
        );
      }
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  /// Get a single listing by ID
  Future<MarketplaceListing?> getListing(dynamic id) async {
    try {
      final response = await _apiClient.get('/aukrug/v1/market/listings/$id');
      if (response.statusCode == 200) {
        return MarketplaceListing.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Create a new listing
  Future<MarketplaceListing> createListing(
    MarketplaceCreateRequest request,
  ) async {
    try {
      final response = await _apiClient.post(
        '/aukrug/v1/market/listings',
        data: request.toJson(),
      );
      if (response.statusCode == 201) {
        return MarketplaceListing.fromJson(response.data['data']);
      }
      throw ApiException('Failed to create listing');
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  /// Update listing
  Future<MarketplaceListing> updateListing(
    dynamic id,
    MarketplaceUpdateRequest request,
  ) async {
    try {
      final response = await _apiClient.put(
        '/aukrug/v1/market/listings/$id',
        data: request.toJson(),
      );
      if (response.statusCode == 200) {
        return MarketplaceListing.fromJson(response.data['data']);
      }
      throw ApiException('Failed to update listing');
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  /// Delete listing
  Future<bool> deleteListing(dynamic id) async {
    try {
      final response = await _apiClient.delete(
        '/aukrug/v1/market/listings/$id',
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Update listing status
  Future<MarketplaceListing> updateListingStatus(
    dynamic id,
    dynamic status,
  ) async {
    try {
      final statusStr = status.toString().split('.').last;
      final response = await _apiClient.put(
        '/aukrug/v1/market/listings/$id/status',
        data: {'status': statusStr},
      );
      if (response.statusCode == 200) {
        return MarketplaceListing.fromJson(response.data['data']);
      }
      throw ApiException('Failed to update listing status');
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  /// Get my listings
  Future<PaginatedResponse<MarketplaceListing>> getMyListings({
    int page = 1,
    int perPage = 20,
  }) async {
    return getListings(
      filters: MarketplaceFilters(page: page, perPage: perPage),
    );
  }

  /// Toggle favorite
  Future<bool> toggleFavorite(dynamic listingId) async {
    try {
      final response = await _apiClient.post(
        '/aukrug/v1/market/listings/$listingId/toggle-favorite',
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Get favorites
  Future<List<MarketplaceListing>> getFavorites({
    int page = 1,
    int perPage = 20,
  }) async {
    final result = await getListings(
      filters: MarketplaceFilters(
        page: page,
        perPage: perPage,
        onlyFavorites: true,
      ),
    );
    return result.data;
  }

  /// Get categories
  Future<List<MarketplaceCategory>> getCategories() async {
    try {
      final response = await _apiClient.get('/aukrug/v1/market/categories');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((item) => MarketplaceCategory.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get verification status
  Future<String> getVerificationStatus() async {
    try {
      final response = await _apiClient.get(
        '/aukrug/v1/auth/verification-status',
      );
      if (response.statusCode == 200) {
        return response.data['status'] ?? 'guest';
      }
      return 'guest';
    } catch (e) {
      return 'guest';
    }
  }

  /// Submit verification request (stub)
  Future<bool> submitVerificationRequest(dynamic request) async {
    try {
      final response = await _apiClient.post(
        '/aukrug/v1/auth/verification-request',
        data: request is Map ? request : request?.toJson() ?? {},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Report listing (stub)
  Future<bool> reportListing(dynamic report) async {
    try {
      final response = await _apiClient.post(
        '/aukrug/v1/market/reports',
        data: report is Map ? report : report?.toJson() ?? {},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Get rate limit info (stub)
  Future<Map<String, dynamic>> getRateLimitInfo() async {
    try {
      final response = await _apiClient.get('/aukrug/v1/auth/rate-limit');
      if (response.statusCode == 200) {
        return response.data ?? {};
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  /// Build query parameters for API requests
  Map<String, String> _buildQueryParams(MarketplaceFilters? filters) {
    final Map<String, String> params = {};

    if (filters != null) {
      params['page'] = filters.page.toString();
      params['per_page'] = filters.perPage.toString();

      if (filters.search.isNotEmpty) params['search'] = filters.search;
      if (filters.categoryIds != null && filters.categoryIds!.isNotEmpty) {
        params['category_ids'] = filters.categoryIds!.join(',');
      }
      if (filters.priceMin != null)
        params['price_min'] = filters.priceMin.toString();
      if (filters.priceMax != null)
        params['price_max'] = filters.priceMax.toString();
      if (filters.locationArea != null)
        params['location'] = filters.locationArea!;
      params['sort'] = filters.sort;
      if (filters.onlyFavorites) params['only_favorites'] = 'true';
      if (filters.maxDistance != null)
        params['max_distance'] = filters.maxDistance.toString();
    }

    return params;
  }

  /// Handle API errors
  Exception _handleApiError(dynamic error) {
    if (error is ApiException) {
      return error;
    } else {
      return ApiException('An unexpected error occurred: $error');
    }
  }
}

/// API Exception class
class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
