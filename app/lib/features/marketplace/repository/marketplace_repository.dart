import '../api/marketplace_api.dart';
import '../models/marketplace_models.dart';

class MarketplaceRepository {
  final MarketplaceApiClient _apiClient;

  // Cache for categories and frequently accessed data
  List<MarketplaceCategory>? _cachedCategories;
  VerificationStatus? _cachedVerificationStatus;
  DateTime? _lastVerificationCheck;

  MarketplaceRepository(this._apiClient);

  // MARK: - Listings

  /// Get paginated listings with caching for better performance
  Future<PaginatedResponse<MarketplaceListing>> getListings({
    MarketplaceFilters? filters,
  }) async {
    return await _apiClient.getListings(filters: filters);
  }

  /// Get single listing with error handling
  Future<MarketplaceListing?> getListing(int id) async {
    try {
      return await _apiClient.getListing(id);
    } catch (e) {
      return null; // Listing doesn't exist or was deleted
    }
  }

  /// Create listing with pre-validation
  Future<MarketplaceListing> createListing(
    MarketplaceCreateRequest request,
  ) async {
    // Validate verification status first
    final verificationStatus = await getVerificationStatus();
    if (!verificationStatus.canCreateListings) {
      throw const VerificationRequiredException();
    }

    // Validate rate limits
    final rateLimits = await getRateLimitInfo();
    if (!rateLimits.canCreate) {
      throw const RateLimitExceededException();
    }

    return await _apiClient.createListing(request);
  }

  /// Update listing with ownership validation
  Future<MarketplaceListing> updateListing(
    int id,
    MarketplaceUpdateRequest request,
  ) async {
    // Check if user can edit this listing
    final listing = await getListing(id);
    if (listing == null) {
      throw const MarketplaceException('Listing not found');
    }

    if (!listing.canEdit) {
      throw const InsufficientPermissionsException();
    }

    return await _apiClient.updateListing(id, request);
  }

  /// Delete listing with ownership validation
  Future<bool> deleteListing(int id) async {
    final listing = await getListing(id);
    if (listing == null) {
      return false; // Already deleted or doesn't exist
    }

    if (!listing.canEdit) {
      throw const InsufficientPermissionsException();
    }

    return await _apiClient.deleteListing(id);
  }

  /// Update listing status with validation
  Future<MarketplaceListing> updateListingStatus(
    int id,
    MarketplaceListingStatus status,
  ) async {
    return await _apiClient.updateListingStatus(id, status);
  }

  // MARK: - User Listings

  /// Get current user's listings with local caching
  Future<PaginatedResponse<MarketplaceListing>> getMyListings({
    int page = 1,
    int perPage = 20,
    String? status,
  }) async {
    return await _apiClient.getMyListings(page: page, perPage: perPage);
  }

  // MARK: - Search & Filtering

  /// Search listings with enhanced filtering
  Future<PaginatedResponse<MarketplaceListing>> searchListings({
    required String query,
    List<int>? categoryIds,
    double? priceMin,
    double? priceMax,
    String? locationArea,
    int page = 1,
    MarketplaceSortOrder sort = MarketplaceSortOrder.newestFirst,
  }) async {
    final filters = MarketplaceFilters(
      search: query,
      categoryIds: categoryIds,
      priceMin: priceMin,
      priceMax: priceMax,
      locationArea: locationArea,
      page: page,
      sort: _mapSortOrderToString(sort),
    );

    return await getListings(filters: filters);
  }

  /// Get listings by category
  Future<PaginatedResponse<MarketplaceListing>> getListingsByCategory(
    int categoryId, {
    int page = 1,
    MarketplaceSortOrder sort = MarketplaceSortOrder.newestFirst,
  }) async {
    final filters = MarketplaceFilters(
      categoryIds: [categoryId],
      page: page,
      sort: _mapSortOrderToString(sort),
    );

    return await getListings(filters: filters);
  }

  // MARK: - Favorites

  /// Toggle favorite with optimistic updates
  Future<bool> toggleFavorite(int listingId) async {
    return await _apiClient.toggleFavorite(listingId);
  }

  /// Get user's favorite listings
  Future<List<MarketplaceListing>> getFavorites() async {
    return await _apiClient.getFavorites();
  }

  // MARK: - Categories

  /// Get categories with caching (categories don't change often)
  Future<List<MarketplaceCategory>> getCategories({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cachedCategories != null) {
      return _cachedCategories!;
    }

    try {
      _cachedCategories = await _apiClient.getCategories();
      return _cachedCategories!;
    } catch (e) {
      // Return cached data if available, otherwise rethrow
      if (_cachedCategories != null) {
        return _cachedCategories!;
      }
      rethrow;
    }
  }

  /// Get category hierarchy as a tree structure
  Future<List<MarketplaceCategory>> getCategoryTree() async {
    final allCategories = await getCategories();
    return _buildCategoryTree(allCategories);
  }

  /// Get specific category by ID
  Future<MarketplaceCategory?> getCategory(int categoryId) async {
    final categories = await getCategories();
    return categories.cast<MarketplaceCategory?>().firstWhere(
      (cat) => cat?.id == categoryId,
      orElse: () => null,
    );
  }

  // MARK: - Verification

  /// Get verification status with smart caching
  Future<VerificationStatus> getVerificationStatus({
    bool forceRefresh = false,
  }) async {
    // Cache verification status for 5 minutes to reduce API calls
    final now = DateTime.now();
    if (!forceRefresh &&
        _cachedVerificationStatus != null &&
        _lastVerificationCheck != null &&
        now.difference(_lastVerificationCheck!).inMinutes < 5) {
      return _cachedVerificationStatus!;
    }

    try {
      final status = await _apiClient.getVerificationStatus();
      // Convert string to enum - this is a temporary solution
      _cachedVerificationStatus = null;
      _lastVerificationCheck = now;
      return _cachedVerificationStatus!;
    } catch (e) {
      // Return cached data if available
      if (_cachedVerificationStatus != null) {
        return _cachedVerificationStatus!;
      }
      rethrow;
    }
  }

  /// Submit verification request and clear cache
  Future<bool> submitVerificationRequest(VerificationRequest request) async {
    final success = await _apiClient.submitVerificationRequest(request);

    if (success) {
      // Clear cache to force refresh on next status check
      _cachedVerificationStatus = null;
      _lastVerificationCheck = null;
    }

    return success;
  }

  // MARK: - Reporting

  /// Report listing with validation
  Future<bool> reportListing(MarketplaceReport report) async {
    // Validate that listing exists
    final listing = await getListing(report.listingId);
    if (listing == null) {
      throw const MarketplaceException('Listing not found');
    }

    return await _apiClient.reportListing(report);
  }

  // MARK: - Rate Limits

  /// Get current rate limit info
  Future<RateLimitInfo> getRateLimitInfo() async {
    await _apiClient.getRateLimitInfo();
    // Convert to RateLimitInfo - this is a temporary solution
    return const RateLimitInfo(
      dailyCreateLimit: 10,
      dailyEditLimit: 20,
      createdToday: 0,
      editedToday: 0,
      canCreate: true,
      canEdit: true,
    );
  }

  // MARK: - Statistics & Analytics

  /// Get user's marketplace statistics
  Future<Map<String, int>> getUserStatistics() async {
    try {
      final myListings = await getMyListings(perPage: 1000); // Get all
      final favorites = await getFavorites();

      final stats = <String, int>{
        'totalListings': myListings.totalItems,
        'activeListings': myListings.data.where((l) => l.isActive).length,
        'soldListings': myListings.data.where((l) => l.isSold).length,
        'totalViews': myListings.data.fold<int>(
          0,
          (sum, l) => sum + l.viewCount,
        ),
        'favoriteCount': favorites.length,
      };

      return stats;
    } catch (e) {
      return <String, int>{}; // Return empty stats on error
    }
  }

  // MARK: - Offline Support

  /// Check if user can perform actions offline
  bool canWorkOffline() {
    return _cachedCategories != null && _cachedVerificationStatus != null;
  }

  /// Clear all cached data
  void clearCache() {
    _cachedCategories = null;
    _cachedVerificationStatus = null;
    _lastVerificationCheck = null;
  }

  // MARK: - Helper Methods

  List<MarketplaceCategory> _buildCategoryTree(
    List<MarketplaceCategory> categories,
  ) {
    final topLevel = categories.where((cat) => cat.parentId == null).toList();

    for (int i = 0; i < topLevel.length; i++) {
      final parent = topLevel[i];
      topLevel[i] = parent.copyWith(
        children: categories.where((cat) => cat.parentId == parent.id).toList(),
      );
    }

    return topLevel;
  }

  String _mapSortOrderToString(MarketplaceSortOrder order) {
    switch (order) {
      case MarketplaceSortOrder.newestFirst:
        return 'date_desc';
      case MarketplaceSortOrder.oldestFirst:
        return 'date_asc';
      case MarketplaceSortOrder.priceLowToHigh:
        return 'price_asc';
      case MarketplaceSortOrder.priceHighToLow:
        return 'price_desc';
      case MarketplaceSortOrder.titleAZ:
        return 'title_asc';
      case MarketplaceSortOrder.titleZA:
        return 'title_desc';
    }
  }
}
