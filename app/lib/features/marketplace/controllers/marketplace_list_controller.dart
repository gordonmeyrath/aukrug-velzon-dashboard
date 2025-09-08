import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/marketplace_models.dart';
import '../providers/marketplace_providers.dart';
import '../repository/marketplace_repository.dart';

class MarketplaceListController
    extends StateNotifier<AsyncValue<PaginatedResponse<MarketplaceListing>>> {
  final MarketplaceRepository _repository;
  final Ref _ref;

  MarketplaceFilters _currentFilters = const MarketplaceFilters();
  bool _isLoadingMore = false;
  List<MarketplaceListing> _allListings = [];

  MarketplaceListController(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    _loadInitialListings();
  }

  // MARK: - Public Methods

  /// Load initial listings
  Future<void> _loadInitialListings() async {
    state = const AsyncValue.loading();

    try {
      final response = await _repository.getListings(filters: _currentFilters);
      _allListings = response.data;
      state = AsyncValue.data(response);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh listings (pull to refresh)
  Future<void> refresh() async {
    _currentFilters = _currentFilters.copyWith(page: 1);
    await _loadInitialListings();
  }

  /// Load more listings (pagination)
  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null || !currentState.hasNextPage || _isLoadingMore) {
      return;
    }

    _isLoadingMore = true;

    try {
      final nextPage = currentState.currentPage + 1;
      final nextFilters = _currentFilters.copyWith(page: nextPage);

      final response = await _repository.getListings(filters: nextFilters);

      // Combine existing and new listings
      final allListings = [..._allListings, ...response.data];
      _allListings = allListings;

      // Update state with combined data
      final updatedResponse = response.copyWith(
        data: allListings,
        currentPage: nextPage,
      );

      state = AsyncValue.data(updatedResponse);
      _currentFilters = nextFilters;
    } catch (error, stackTrace) {
      // Don't change state on load more error, just show a message
      _showError('Fehler beim Laden weiterer Anzeigen');
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Search listings
  Future<void> search(String query) async {
    final newFilters = _currentFilters.copyWith(
      search: query,
      page: 1, // Reset to first page
    );

    await _applyFilters(newFilters);
  }

  /// Apply category filter
  Future<void> filterByCategory(int? categoryId) async {
    final newFilters = _currentFilters.copyWith(
      categoryIds: categoryId != null ? [categoryId] : null,
      page: 1,
    );

    await _applyFilters(newFilters);
  }

  /// Apply multiple filters
  Future<void> applyFilters(MarketplaceFilters filters) async {
    final newFilters = filters.copyWith(page: 1); // Always reset to first page
    await _applyFilters(newFilters);
  }

  /// Set sort order
  Future<void> setSortOrder(MarketplaceSortOrder sortOrder) async {
    final sortString = _mapSortOrderToString(sortOrder);
    final newFilters = _currentFilters.copyWith(sort: sortString, page: 1);

    await _applyFilters(newFilters);
  }

  /// Toggle favorites only filter
  Future<void> toggleFavoritesOnly() async {
    final newFilters = _currentFilters.copyWith(
      onlyFavorites: !_currentFilters.onlyFavorites,
      page: 1,
    );

    await _applyFilters(newFilters);
  }

  /// Update favorite status of a specific listing
  void updateListingFavoriteStatus(int listingId, bool isFavorite) {
    final currentState = state.value;
    if (currentState == null) return;

    final updatedListings = _allListings.map((listing) {
      if (listing.id == listingId) {
        return listing.copyWith(isFavorite: isFavorite);
      }
      return listing;
    }).toList();

    _allListings = updatedListings;

    final updatedResponse = currentState.copyWith(data: updatedListings);
    state = AsyncValue.data(updatedResponse);
  }

  /// Remove listing from list (when deleted)
  void removeListing(int listingId) {
    final currentState = state.value;
    if (currentState == null) return;

    _allListings.removeWhere((listing) => listing.id == listingId);

    final updatedResponse = currentState.copyWith(
      data: _allListings,
      totalItems: currentState.totalItems - 1,
    );

    state = AsyncValue.data(updatedResponse);
  }

  /// Update listing in list (when edited)
  void updateListing(MarketplaceListing updatedListing) {
    final currentState = state.value;
    if (currentState == null) return;

    final updatedListings = _allListings.map((listing) {
      if (listing.id == updatedListing.id) {
        return updatedListing;
      }
      return listing;
    }).toList();

    _allListings = updatedListings;

    final updatedResponse = currentState.copyWith(data: updatedListings);
    state = AsyncValue.data(updatedResponse);
  }

  /// Add new listing to the beginning of the list
  void addListing(MarketplaceListing newListing) {
    final currentState = state.value;
    if (currentState == null) return;

    _allListings.insert(0, newListing);

    final updatedResponse = currentState.copyWith(
      data: _allListings,
      totalItems: currentState.totalItems + 1,
    );

    state = AsyncValue.data(updatedResponse);
  }

  // MARK: - Private Methods

  Future<void> _applyFilters(MarketplaceFilters filters) async {
    _currentFilters = filters;
    state = const AsyncValue.loading();

    try {
      final response = await _repository.getListings(filters: filters);
      _allListings = response.data;
      state = AsyncValue.data(response);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
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

  void _showError(String message) {
    // This could be implemented with a toast/snackbar service
    // For now, we just print the error
    print('MarketplaceListController Error: $message');
  }

  // MARK: - Getters

  MarketplaceFilters get currentFilters => _currentFilters;
  bool get isLoadingMore => _isLoadingMore;
  List<MarketplaceListing> get allListings => List.unmodifiable(_allListings);
}

// Provider
final marketplaceListControllerProvider =
    StateNotifierProvider<
      MarketplaceListController,
      AsyncValue<PaginatedResponse<MarketplaceListing>>
    >((ref) {
      final repository = ref.watch(marketplaceRepositoryProvider);
      return MarketplaceListController(repository, ref);
    });

// Additional providers for specific use cases
final marketplaceSearchControllerProvider =
    StateNotifierProvider.family<
      MarketplaceListController,
      AsyncValue<PaginatedResponse<MarketplaceListing>>,
      String
    >((ref, searchQuery) {
      final repository = ref.watch(marketplaceRepositoryProvider);
      final controller = MarketplaceListController(repository, ref);
      if (searchQuery.isNotEmpty) {
        controller.search(searchQuery);
      }
      return controller;
    });

final marketplaceCategoryControllerProvider =
    StateNotifierProvider.family<
      MarketplaceListController,
      AsyncValue<PaginatedResponse<MarketplaceListing>>,
      int?
    >((ref, categoryId) {
      final repository = ref.watch(marketplaceRepositoryProvider);
      final controller = MarketplaceListController(repository, ref);
      if (categoryId != null) {
        controller.filterByCategory(categoryId);
      }
      return controller;
    });

final marketplaceFavoritesControllerProvider =
    StateNotifierProvider<
      MarketplaceListController,
      AsyncValue<PaginatedResponse<MarketplaceListing>>
    >((ref) {
      final repository = ref.watch(marketplaceRepositoryProvider);
      final controller = MarketplaceListController(repository, ref);
      controller.toggleFavoritesOnly();
      return controller;
    });
