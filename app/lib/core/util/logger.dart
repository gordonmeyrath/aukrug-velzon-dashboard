import 'package:flutter/foundation.dart';

import '../config/app_config.dart';

/// Leichte Logger-Abstraktion (später ersetzbar durch sentry / crashlytics)
class AppLogger {
  static void d(String msg) {
    if (AppConfig.enableLogging && kDebugMode) debugPrint('[D] $msg');
  }

  static void i(String msg) {
    if (AppConfig.enableLogging) debugPrint('[I] $msg');
  }

  static void w(String msg, {Object? error, StackTrace? st}) {
    if (AppConfig.enableLogging) debugPrint('[W] $msg ${error ?? ''}');
  }

  static void e(String msg, {Object? error, StackTrace? st}) {
    debugPrint('[E] $msg ${error ?? ''}\n${st ?? ''}');
  }
}
