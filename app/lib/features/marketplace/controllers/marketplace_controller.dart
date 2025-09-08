import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/marketplace_models.dart';
import '../providers/marketplace_providers.dart';
import '../repository/marketplace_repository.dart';

// Main Controller Provider
final marketplaceControllerProvider =
    StateNotifierProvider<MarketplaceController, MarketplaceState>((ref) {
      final repository = ref.read(marketplaceRepositoryProvider);
      return MarketplaceController(repository);
    });

class MarketplaceController extends StateNotifier<MarketplaceState> {
  final MarketplaceRepository _repository;

  MarketplaceController(this._repository)
    : super(const MarketplaceState.initial());

  Future<void> loadListings({MarketplaceFilters? filters}) async {
    state = const MarketplaceState.loading();

    try {
      final response = await _repository.getListings(filters: filters);
      state = MarketplaceState.loaded(response);
    } catch (e, stackTrace) {
      state = MarketplaceState.error(e.toString(), stackTrace);
    }
  }

  Future<MarketplaceListing?> getListing(int id) async {
    try {
      return await _repository.getListing(id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> toggleFavorite(int listingId) async {
    try {
      return await _repository.toggleFavorite(listingId);
    } catch (e) {
      return false;
    }
  }
}

// State class
sealed class MarketplaceState {
  const MarketplaceState();

  const factory MarketplaceState.initial() = MarketplaceInitial;
  const factory MarketplaceState.loading() = MarketplaceLoading;
  const factory MarketplaceState.loaded(
    PaginatedResponse<MarketplaceListing> listings,
  ) = MarketplaceLoaded;
  const factory MarketplaceState.error(String message, StackTrace? stackTrace) =
      MarketplaceError;
}

class MarketplaceInitial extends MarketplaceState {
  const MarketplaceInitial();
}

class MarketplaceLoading extends MarketplaceState {
  const MarketplaceLoading();
}

class MarketplaceLoaded extends MarketplaceState {
  final PaginatedResponse<MarketplaceListing> listings;
  const MarketplaceLoaded(this.listings);
}

class MarketplaceError extends MarketplaceState {
  final String message;
  final StackTrace? stackTrace;
  const MarketplaceError(this.message, this.stackTrace);
}
