import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'etag_interceptor.g.dart';

/// Interceptor for handling ETag-based caching
@riverpod
EtagInterceptor etagInterceptor(EtagInterceptorRef ref) {
  return EtagInterceptor();
}

class EtagInterceptor extends Interceptor {
  static const String _etagPrefix = 'etag_';
  static const String _lastModifiedPrefix = 'last_modified_';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Only apply to GET requests
    if (options.method.toUpperCase() != 'GET') {
      handler.next(options);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final cacheKey = _getCacheKey(options.uri.toString());

    // Add If-None-Match header for ETag
    final etag = prefs.getString('$_etagPrefix$cacheKey');
    if (etag != null) {
      options.headers['If-None-Match'] = etag;
    }

    // Add If-Modified-Since header
    final lastModified = prefs.getString('$_lastModifiedPrefix$cacheKey');
    if (lastModified != null) {
      options.headers['If-Modified-Since'] = lastModified;
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Store ETag and Last-Modified headers for caching
    if (response.requestOptions.method.toUpperCase() == 'GET') {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = _getCacheKey(response.requestOptions.uri.toString());

      final etag = response.headers.value('etag');
      if (etag != null) {
        await prefs.setString('$_etagPrefix$cacheKey', etag);
      }

      final lastModified = response.headers.value('last-modified');
      if (lastModified != null) {
        await prefs.setString('$_lastModifiedPrefix$cacheKey', lastModified);
      }
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 304 Not Modified responses
    if (err.response?.statusCode == 304) {
      // Return cached data or handle appropriately
      // For now, we'll let the repository layer handle this
    }
    handler.next(err);
  }

  String _getCacheKey(String url) {
    // Create a simple cache key from URL
    return url.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
  }
}
