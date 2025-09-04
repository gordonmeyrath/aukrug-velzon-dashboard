import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logging_interceptor.g.dart';

/// Interceptor for logging HTTP requests and responses
@riverpod
LoggingInterceptor loggingInterceptor(LoggingInterceptorRef ref) {
  return LoggingInterceptor();
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log('🌐 ${options.method} ${options.uri}', name: 'HTTP_REQUEST');

    if (options.data != null) {
      developer.log('📤 Request Data: ${options.data}', name: 'HTTP_REQUEST');
    }

    if (options.headers.isNotEmpty) {
      developer.log('📋 Headers: ${options.headers}', name: 'HTTP_REQUEST');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log(
      '✅ ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
      name: 'HTTP_RESPONSE',
    );

    developer.log('📥 Response: ${response.data}', name: 'HTTP_RESPONSE');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '❌ ${err.response?.statusCode ?? 'NO_STATUS'} ${err.requestOptions.method} ${err.requestOptions.uri}',
      name: 'HTTP_ERROR',
      error: err,
    );

    if (err.response?.data != null) {
      developer.log(
        '📥 Error Response: ${err.response?.data}',
        name: 'HTTP_ERROR',
      );
    }

    handler.next(err);
  }
}
