import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/etag_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

part 'dio_client.g.dart';

/// Dio HTTP client configured for the Aukrug API
@riverpod
Dio dioClient(DioClientRef ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBase,
      connectTimeout: AppConfig.apiTimeout,
      receiveTimeout: AppConfig.apiTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add interceptors in order
  dio.interceptors.addAll([
    ref.watch(authInterceptorProvider),
    ref.watch(etagInterceptorProvider),
    if (AppConfig.enableLogging) ref.watch(loggingInterceptorProvider),
  ]);

  return dio;
}
