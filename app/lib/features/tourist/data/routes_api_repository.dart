import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/api_config.dart';
import '../../../core/services/api_service.dart';
import '../domain/route_item.dart';

part 'routes_api_repository.g.dart';

@riverpod
class RoutesApiRepository extends _$RoutesApiRepository {
  late final ApiService _apiService;

  @override
  Future<List<RouteItem>> build() async {
    _apiService = ApiService();
    return getRoutes();
  }

  Future<List<RouteItem>> getRoutes({
    RouteType? type,
    RouteDifficulty? difficulty,
    String? searchQuery,
  }) async {
    try {
      final queryParams = <String, String>{};

      if (type != null) {
        queryParams['type'] = _typeToApiString(type);
      }

      if (difficulty != null) {
        queryParams['difficulty'] = _difficultyToApiString(difficulty);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }

      final response = await _apiService.get(
        ApiConfig.routesEndpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response['data'] != null && response['data'] is List) {
        final List<dynamic> items = response['data'];
        return items
            .map((json) => RouteItem.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      print('Error loading routes: $e');
      return [];
    }
  }

  String _typeToApiString(RouteType type) {
    switch (type) {
      case RouteType.wandern:
        return 'wandern';
      case RouteType.radfahren:
        return 'radfahren';
      case RouteType.laufen:
        return 'laufen';
      case RouteType.nordic_walking:
        return 'nordic_walking';
    }
  }

  String _difficultyToApiString(RouteDifficulty difficulty) {
    switch (difficulty) {
      case RouteDifficulty.leicht:
        return 'leicht';
      case RouteDifficulty.mittel:
        return 'mittel';
      case RouteDifficulty.schwer:
        return 'schwer';
    }
  }
}
