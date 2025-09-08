import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/api_config.dart';
import '../../../core/services/api_service.dart';

part 'info_api_repository.g.dart';

@riverpod
class InfoApiRepository extends _$InfoApiRepository {
  late final ApiService _apiService;

  @override
  Future<Map<String, dynamic>?> build() async {
    _apiService = ApiService();
    return getAppInfo();
  }

  Future<Map<String, dynamic>?> getAppInfo() async {
    try {
      final response = await _apiService.get(ApiConfig.infoEndpoint);

      if (response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      } else if (response.isNotEmpty) {
        return response;
      }

      return null;
    } catch (e) {
      print('Error loading app info: $e');
      return null;
    }
  }
}
