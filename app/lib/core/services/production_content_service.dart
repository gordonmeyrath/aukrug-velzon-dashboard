import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../network/dio_client.dart';
import '../config/app_config.dart';

/// Production Content Service - loads all content from server
/// Replaces demo content with real API calls
class ContentService {
  final Dio _dio;
  
  ContentService(this._dio);

  // Reports API
  Future<List<Map<String, dynamic>>> getReports({
    String? category,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/v1/reports',
        queryParameters: {
          if (category != null) 'category': category,
          if (status != null) 'status': status,
          'page': page,
          'limit': limit,
        },
      );
      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      throw Exception('Failed to load reports: $e');
    }
  }

  Future<Map<String, dynamic>> createReport(Map<String, dynamic> reportData) async {
    try {
      final response = await _dio.post(
        '/api/v1/reports',
        data: reportData,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create report: $e');
    }
  }

  // Events API
  Future<List<Map<String, dynamic>>> getEvents({
    String? category,
    DateTime? fromDate,
    DateTime? toDate,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/v1/events',
        queryParameters: {
          if (category != null) 'category': category,
          if (fromDate != null) 'from': fromDate.toIso8601String(),
          if (toDate != null) 'to': toDate.toIso8601String(),
          'page': page,
          'limit': limit,
        },
      );
      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }

  // Notices API  
  Future<List<Map<String, dynamic>>> getNotices({
    String? category,
    bool onlyActive = true,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/v1/notices',
        queryParameters: {
          if (category != null) 'category': category,
          'active': onlyActive,
          'page': page,
          'limit': limit,
        },
      );
      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      throw Exception('Failed to load notices: $e');
    }
  }

  // Places API
  Future<List<Map<String, dynamic>>> getPlaces({
    String? category,
    double? latitude,
    double? longitude,
    double? radius,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/v1/places',
        queryParameters: {
          if (category != null) 'category': category,
          if (latitude != null) 'lat': latitude,
          if (longitude != null) 'lng': longitude,
          if (radius != null) 'radius': radius,
          'page': page,
          'limit': limit,
        },
      );
      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      throw Exception('Failed to load places: $e');
    }
  }

  // Routes/Trails API
  Future<List<Map<String, dynamic>>> getRoutes({
    String? difficulty,
    double? minDistance,
    double? maxDistance,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/v1/routes',
        queryParameters: {
          if (difficulty != null) 'difficulty': difficulty,
          if (minDistance != null) 'min_distance': minDistance,
          if (maxDistance != null) 'max_distance': maxDistance,
          'page': page,
          'limit': limit,
        },
      );
      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      throw Exception('Failed to load routes: $e');
    }
  }

  // Documents/Downloads API
  Future<List<Map<String, dynamic>>> getDocuments({
    String? category,
    String? searchQuery,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/v1/documents',
        queryParameters: {
          if (category != null) 'category': category,
          if (searchQuery != null) 'search': searchQuery,
          'page': page,
          'limit': limit,
        },
      );
      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      throw Exception('Failed to load documents: $e');
    }
  }

  // Community/Marketplace API (nur für verifizierte Residents)
  Future<List<Map<String, dynamic>>> getCommunityPosts({
    String? category,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/v1/community/posts',
        queryParameters: {
          if (category != null) 'category': category,
          'page': page,
          'limit': limit,
        },
      );
      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      throw Exception('Failed to load community posts: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getMarketplaceItems({
    String? category,
    String? condition,
    double? maxPrice,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/v1/marketplace/items',
        queryParameters: {
          if (category != null) 'category': category,
          if (condition != null) 'condition': condition,
          if (maxPrice != null) 'max_price': maxPrice,
          'page': page,
          'limit': limit,
        },
      );
      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      throw Exception('Failed to load marketplace items: $e');
    }
  }

  // User Profile API
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dio.get('/api/v1/user/profile');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to load user profile: $e');
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _dio.put(
        '/api/v1/user/profile',
        data: profileData,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }
}

/// Production Content Service Provider
final contentServiceProvider = Provider<ContentService>((ref) {
  final dio = ref.watch(dioProvider);
  return ContentService(dio);
});

/// Content providers for specific sections
final reportsProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, Map<String, dynamic>>((ref, params) async {
  final contentService = ref.watch(contentServiceProvider);
  return contentService.getReports(
    category: params['category'],
    status: params['status'],
    page: params['page'] ?? 1,
    limit: params['limit'] ?? 20,
  );
});

final eventsProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, Map<String, dynamic>>((ref, params) async {
  final contentService = ref.watch(contentServiceProvider);
  return contentService.getEvents(
    category: params['category'],
    fromDate: params['fromDate'],
    toDate: params['toDate'],
    page: params['page'] ?? 1,
    limit: params['limit'] ?? 20,
  );
});

final noticesProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, Map<String, dynamic>>((ref, params) async {
  final contentService = ref.watch(contentServiceProvider);
  return contentService.getNotices(
    category: params['category'],
    onlyActive: params['onlyActive'] ?? true,
    page: params['page'] ?? 1,
    limit: params['limit'] ?? 20,
  );
});

final placesProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, Map<String, dynamic>>((ref, params) async {
  final contentService = ref.watch(contentServiceProvider);
  return contentService.getPlaces(
    category: params['category'],
    latitude: params['latitude'],
    longitude: params['longitude'],
    radius: params['radius'],
    page: params['page'] ?? 1,
    limit: params['limit'] ?? 20,
  );
});

final routesProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, Map<String, dynamic>>((ref, params) async {
  final contentService = ref.watch(contentServiceProvider);
  return contentService.getRoutes(
    difficulty: params['difficulty'],
    minDistance: params['minDistance'],
    maxDistance: params['maxDistance'],
    page: params['page'] ?? 1,
    limit: params['limit'] ?? 20,
  );
});

final documentsProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, Map<String, dynamic>>((ref, params) async {
  final contentService = ref.watch(contentServiceProvider);
  return contentService.getDocuments(
    category: params['category'],
    searchQuery: params['searchQuery'],
    page: params['page'] ?? 1,
    limit: params['limit'] ?? 20,
  );
});

final communityPostsProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, Map<String, dynamic>>((ref, params) async {
  final contentService = ref.watch(contentServiceProvider);
  return contentService.getCommunityPosts(
    category: params['category'],
    page: params['page'] ?? 1,
    limit: params['limit'] ?? 20,
  );
});

final marketplaceProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, Map<String, dynamic>>((ref, params) async {
  final contentService = ref.watch(contentServiceProvider);
  return contentService.getMarketplaceItems(
    category: params['category'],
    condition: params['condition'],
    maxPrice: params['maxPrice'],
    page: params['page'] ?? 1,
    limit: params['limit'] ?? 20,
  );
});

final currentUserProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final contentService = ref.watch(contentServiceProvider);
  return contentService.getCurrentUser();
});

/// Dio Provider für HTTP-Client
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.baseUrl = AppConfig.apiBaseUrl;
  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 10);
  
  // Interceptor für Authentication
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token if available
        final token = getStoredAuthToken(); // Implement this
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ),
  );
  
  return dio;
});

// Placeholder für Auth Token Storage
String? getStoredAuthToken() {
  // TODO: Implement secure token storage
  return null;
}
