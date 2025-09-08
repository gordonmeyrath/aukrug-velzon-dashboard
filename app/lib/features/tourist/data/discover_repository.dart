import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/api_config.dart';
import '../../../core/services/api_service.dart';
import '../domain/discover_item.dart';

part 'discover_repository.g.dart';

@riverpod
class DiscoverRepository extends _$DiscoverRepository {
  late final ApiService _apiService;

  @override
  Future<List<DiscoverItem>> build() async {
    _apiService = ApiService();
    return getDiscoverItems();
  }

  Future<List<DiscoverItem>> getDiscoverItems({
    DiscoverCategory? category,
    String? searchQuery,
  }) async {
    try {
      final queryParams = <String, String>{};

      if (category != null) {
        queryParams['category'] = _categoryToApiString(category);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }

      final response = await _apiService.get(
        ApiConfig.discoverEndpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
      );

      // Handle response wrapped in data object (WordPress REST API returns arrays)
      if (response['data'] != null && response['data'] is List) {
        final List<dynamic> itemsJson = response['data'];
        return itemsJson
            .map((json) => DiscoverItem.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      // Log error and return empty list for now
      print('Error loading discover items: $e');
      return [];
    }
  }

  Future<List<DiscoverItem>> getFeaturedItems() async {
    try {
      final response = await _apiService.get(
        ApiConfig.discoverEndpoint,
        queryParams: {'featured': 'true'},
      );

      // Handle response wrapped in data object (WordPress REST API returns arrays)
      if (response['data'] != null && response['data'] is List) {
        final List<dynamic> itemsJson = response['data'];
        return itemsJson
            .map((json) => DiscoverItem.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      print('Error loading featured items: $e');
      return [];
    }
  }

  String _categoryToApiString(DiscoverCategory category) {
    switch (category) {
      case DiscoverCategory.sehenswuerdigkeit:
        return 'sehenswuerdigkeit';
      case DiscoverCategory.gastronomie:
        return 'gastronomie';
      case DiscoverCategory.unterkunft:
        return 'unterkunft';
      case DiscoverCategory.aktivitaet:
        return 'aktivitaet';
      case DiscoverCategory.kultur:
        return 'kultur';
      case DiscoverCategory.natur:
        return 'natur';
      case DiscoverCategory.shopping:
        return 'shopping';
    }
  }
}
