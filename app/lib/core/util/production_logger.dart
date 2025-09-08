import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../config/app_config.dart';

/// Enhanced production-ready logger with intelligent log management
class ProductionLogger {
  static const String _logFileName = 'aukrug_app.log';
  static const int _maxLogFileSize = 1024 * 1024; // 1MB
  static const int _maxLogFiles = 5;

  static File? _logFile;
  static final List<String> _logBuffer = [];
  static const int _bufferSize = 100;

  /// Initialize logging system
  static Future<void> initialize() async {
    if (!AppConfig.enableLogging) return;

    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${documentsDir.path}/logs');

      if (!await logsDir.exists()) {
        await logsDir.create(recursive: true);
      }

      _logFile = File('${logsDir.path}/$_logFileName');

      // Clean up old logs on startup
      await _cleanupOldLogs(logsDir);

      // Write startup log
      _writeToFile(
        '[STARTUP] ${DateTime.now().toIso8601String()} - Aukrug App ${AppConfig.version}',
      );
    } catch (e) {
      // Fallback to debug print if file logging fails
      debugPrint('[LOG_INIT_ERROR] $e');
    }
  }

  /// Debug level logging - only in debug mode
  static void d(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    final formattedMessage = _formatMessage('D', message, tag: tag);
    debugPrint(formattedMessage);

    if (AppConfig.enableLogging) {
      _addToBuffer(formattedMessage);
    }
  }

  /// Info level logging - always logged
  static void i(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final formattedMessage = _formatMessage('I', message, tag: tag);

    if (kDebugMode) {
      debugPrint(formattedMessage);
    }

    if (AppConfig.enableLogging) {
      _addToBuffer(formattedMessage);
    }
  }

  /// Warning level logging - always logged and stored
  static void w(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final formattedMessage = _formatMessage(
      'W',
      message,
      tag: tag,
      error: error,
    );

    debugPrint(formattedMessage);

    if (AppConfig.enableLogging) {
      _addToBuffer(formattedMessage);
      _flushBuffer(); // Immediately flush warnings
    }
  }

  /// Error level logging - always logged, stored, and reported
  static void e(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final formattedMessage = _formatMessage(
      'E',
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );

    debugPrint(formattedMessage);

    // Always store errors regardless of settings
    _addToBuffer(formattedMessage);
    _flushBuffer(); // Immediately flush errors

    // In production, consider sending to crash reporting service
    if (kReleaseMode && error != null) {
      _reportError(message, error, stackTrace);
    }
  }

  /// Performance logging for monitoring app performance
  static void perf(
    String operation,
    Duration duration, {
    String? tag,
    Map<String, dynamic>? metadata,
  }) {
    final metadataStr = metadata != null
        ? ' | ${metadata.entries.map((e) => '${e.key}=${e.value}').join(', ')}'
        : '';
    final message = '$operation took ${duration.inMilliseconds}ms$metadataStr';

    final formattedMessage = _formatMessage(
      'P',
      message,
      tag: tag ?? 'PERFORMANCE',
    );

    if (kDebugMode) {
      debugPrint(formattedMessage);
    }

    if (AppConfig.enableLogging) {
      _addToBuffer(formattedMessage);
    }
  }

  /// User action logging for analytics and debugging
  static void userAction(String action, {Map<String, dynamic>? context}) {
    if (!AppConfig.enableAnalytics) return;

    final contextStr = context != null
        ? ' | ${context.entries.map((e) => '${e.key}=${e.value}').join(', ')}'
        : '';
    final message = 'User: $action$contextStr';

    final formattedMessage = _formatMessage('U', message, tag: 'USER_ACTION');

    if (kDebugMode) {
      debugPrint(formattedMessage);
    }

    _addToBuffer(formattedMessage);
  }

  /// API call logging with performance metrics
  static void api(
    String method,
    String endpoint,
    int statusCode,
    Duration duration, {
    int? responseSize,
  }) {
    final sizeStr = responseSize != null
        ? ' | ${_formatBytes(responseSize)}'
        : '';
    final message =
        '$method $endpoint -> $statusCode (${duration.inMilliseconds}ms$sizeStr)';

    final level = statusCode >= 400 ? 'W' : 'I';
    final formattedMessage = _formatMessage(level, message, tag: 'API');

    if (kDebugMode || statusCode >= 400) {
      debugPrint(formattedMessage);
    }

    if (AppConfig.enableLogging) {
      _addToBuffer(formattedMessage);
    }
  }

  /// Format log message with timestamp and metadata
  static String _formatMessage(
    String level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final tagStr = tag != null ? '[$tag] ' : '';
    final errorStr = error != null ? ' | ERROR: $error' : '';
    final stackStr = stackTrace != null && kDebugMode ? '\n$stackTrace' : '';

    return '$timestamp [$level] $tagStr$message$errorStr$stackStr';
  }

  /// Add message to buffer and flush if needed
  static void _addToBuffer(String message) {
    _logBuffer.add(message);

    if (_logBuffer.length >= _bufferSize) {
      _flushBuffer();
    }
  }

  /// Flush buffer to file
  static void _flushBuffer() {
    if (_logBuffer.isEmpty || _logFile == null) return;

    try {
      final content = '${_logBuffer.join('\n')}\n';
      _logFile!.writeAsStringSync(content, mode: FileMode.append);
      _logBuffer.clear();

      // Check if log rotation is needed
      _checkLogRotation();
    } catch (e) {
      // Don't log the logging error to avoid infinite loops
      debugPrint('[LOG_FLUSH_ERROR] $e');
    }
  }

  /// Check if log file needs rotation
  static void _checkLogRotation() {
    if (_logFile == null) return;

    try {
      final fileSize = _logFile!.lengthSync();
      if (fileSize > _maxLogFileSize) {
        _rotateLogFile();
      }
    } catch (e) {
      debugPrint('[LOG_ROTATION_ERROR] $e');
    }
  }

  /// Rotate log file when it gets too large
  static void _rotateLogFile() {
    if (_logFile == null) return;

    try {
      final logsDir = _logFile!.parent;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final archiveName = 'aukrug_app_$timestamp.log';
      final archiveFile = File('${logsDir.path}/$archiveName');

      // Move current log to archive
      _logFile!.copySync(archiveFile.path);
      _logFile!.deleteSync();

      // Create new log file
      _logFile!.createSync();

      // Write rotation log
      _writeToFile(
        '[LOG_ROTATION] ${DateTime.now().toIso8601String()} - Rotated to $archiveName',
      );
    } catch (e) {
      debugPrint('[LOG_ROTATION_ERROR] $e');
    }
  }

  /// Clean up old log files
  static Future<void> _cleanupOldLogs(Directory logsDir) async {
    try {
      final logFiles = logsDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.log'))
          .toList();

      // Sort by modification time (newest first)
      logFiles.sort(
        (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
      );

      // Keep only the newest files
      if (logFiles.length > _maxLogFiles) {
        for (int i = _maxLogFiles; i < logFiles.length; i++) {
          await logFiles[i].delete();
        }
      }
    } catch (e) {
      debugPrint('[LOG_CLEANUP_ERROR] $e');
    }
  }

  /// Write directly to file (for critical logs)
  static void _writeToFile(String message) {
    if (_logFile == null) return;

    try {
      _logFile!.writeAsStringSync('$message\n', mode: FileMode.append);
    } catch (e) {
      debugPrint('[LOG_WRITE_ERROR] $e');
    }
  }

  /// Report error to crash reporting service (placeholder)
  static void _reportError(
    String message,
    Object error,
    StackTrace? stackTrace,
  ) {
    // In a real app, this would send to Firebase Crashlytics, Sentry, etc.
    debugPrint('[CRASH_REPORT] $message: $error');
  }

  /// Format bytes for human readable output
  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  /// Get log files for debugging or support
  static Future<List<File>> getLogFiles() async {
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${documentsDir.path}/logs');

      if (!await logsDir.exists()) return [];

      return logsDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.log'))
          .toList();
    } catch (e) {
      debugPrint('[GET_LOGS_ERROR] $e');
      return [];
    }
  }

  /// Clear all log files
  static Future<void> clearLogs() async {
    try {
      final logFiles = await getLogFiles();
      for (final file in logFiles) {
        await file.delete();
      }

      // Reinitialize logging
      await initialize();
    } catch (e) {
      debugPrint('[CLEAR_LOGS_ERROR] $e');
    }
  }

  /// Get log statistics
  static Future<LogStatistics> getLogStatistics() async {
    try {
      final logFiles = await getLogFiles();
      int totalSize = 0;
      int totalLines = 0;

      for (final file in logFiles) {
        totalSize += await file.length();
        final content = await file.readAsString();
        totalLines += '\n'.allMatches(content).length;
      }

      return LogStatistics(
        fileCount: logFiles.length,
        totalSizeBytes: totalSize,
        totalLines: totalLines,
      );
    } catch (e) {
      debugPrint('[LOG_STATS_ERROR] $e');
      return LogStatistics(fileCount: 0, totalSizeBytes: 0, totalLines: 0);
    }
  }

  /// Flush any remaining logs (call on app termination)
  static void shutdown() {
    _flushBuffer();
    _writeToFile(
      '[SHUTDOWN] ${DateTime.now().toIso8601String()} - App shutdown',
    );
  }
}

/// Log statistics for monitoring
class LogStatistics {
  final int fileCount;
  final int totalSizeBytes;
  final int totalLines;

  LogStatistics({
    required this.fileCount,
    required this.totalSizeBytes,
    required this.totalLines,
  });

  String get formattedSize => ProductionLogger._formatBytes(totalSizeBytes);
}

/// Performance measurement utility
class PerformanceTimer {
  final String operation;
  final String? tag;
  final Stopwatch _stopwatch;
  final Map<String, dynamic>? metadata;

  PerformanceTimer(this.operation, {this.tag, this.metadata})
    : _stopwatch = Stopwatch()..start();

  /// Stop timer and log the result
  void stop() {
    _stopwatch.stop();
    ProductionLogger.perf(
      operation,
      _stopwatch.elapsed,
      tag: tag,
      metadata: metadata,
    );
  }
}

/// Mixin for easy performance logging
mixin PerformanceLogging {
  PerformanceTimer startTimer(
    String operation, {
    String? tag,
    Map<String, dynamic>? metadata,
  }) {
    return PerformanceTimer(operation, tag: tag, metadata: metadata);
  }
}

/// Provider for production logger
final productionLoggerProvider = Provider<ProductionLogger>((ref) {
  return ProductionLogger();
});
