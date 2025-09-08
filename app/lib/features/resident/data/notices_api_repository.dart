import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/api_config.dart';
import '../../../core/services/api_service.dart';
import '../domain/notice.dart';

part 'notices_api_repository.g.dart';

@riverpod
class NoticesApiRepository extends _$NoticesApiRepository {
  late final ApiService _apiService;

  @override
  Future<List<Notice>> build() async {
    _apiService = ApiService();
    return getNotices();
  }

  Future<List<Notice>> getNotices({
    NoticeCategory? category,
    String? searchQuery,
    bool pinnedOnly = false,
  }) async {
    try {
      final queryParams = <String, String>{};

      if (category != null) {
        queryParams['category'] = _categoryToApiString(category);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }

      if (pinnedOnly) {
        queryParams['pinned'] = 'true';
      }

      final response = await _apiService.get(
        ApiConfig.noticesEndpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response['data'] != null && response['data'] is List) {
        final List<dynamic> items = response['data'];
        return items
            .map((json) => Notice.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      print('Error loading notices: $e');
      return [];
    }
  }

  Future<List<Notice>> getPinnedNotices() async {
    return getNotices(pinnedOnly: true);
  }

  String _categoryToApiString(NoticeCategory category) {
    switch (category) {
      case NoticeCategory.allgemein:
        return 'allgemein';
      case NoticeCategory.bauen:
        return 'baustelle';
      case NoticeCategory.verkehr:
        return 'verkehr';
      case NoticeCategory.umwelt:
        return 'umwelt';
      case NoticeCategory.kultur:
        return 'kultur';
      case NoticeCategory.sport:
        return 'veranstaltung';
      case NoticeCategory.verwaltung:
        return 'sitzung';
      case NoticeCategory.termine:
        return 'sonstiges';
    }
  }
}
