import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../api/marketplace_api.dart';
import '../models/marketplace_models.dart';
import '../repository/marketplace_repository.dart';

// API Client Provider
final marketplaceApiClientProvider = Provider<MarketplaceApiClient>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return MarketplaceApiClient(apiClient, ref);
});

// Repository Provider
final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  final apiClient = ref.read(marketplaceApiClientProvider);
  return MarketplaceRepository(apiClient);
});

// Categories Provider
final marketplaceCategoriesProvider = FutureProvider<List<MarketplaceCategory>>(
  (ref) async {
    final repository = ref.read(marketplaceRepositoryProvider);
    return await repository.getCategories();
  },
);

// Filters State Provider
final marketplaceFiltersProvider = StateProvider<MarketplaceFilters>((ref) {
  return const MarketplaceFilters(
    categoryIds: [],
    priceMin: null,
    priceMax: null,
    locationArea: null,
    maxDistance: null,
    status: 'active',
    sort: 'date_desc',
    onlyFavorites: false,
  );
});

// Categories Simple Provider (for convenience)
final categoriesProvider = FutureProvider<List<MarketplaceCategory>>((
  ref,
) async {
  return ref.read(marketplaceCategoriesProvider.future);
});
