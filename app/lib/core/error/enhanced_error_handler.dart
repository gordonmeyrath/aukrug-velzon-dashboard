import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../util/production_logger.dart';

/// Enhanced error handling system with intelligent recovery and user feedback
class EnhancedErrorHandler {
  static final Map<String, DateTime> _errorCooldowns = {};
  static final Map<String, int> _errorCounts = {};
  static const Duration _cooldownDuration = Duration(minutes: 5);
  static const int _maxRetries = 3;

  /// Handle errors with context-aware recovery strategies
  static Future<T?> handleError<T>({
    required Future<T> Function() operation,
    required BuildContext context,
    String? userMessage,
    bool showToUser = true,
    bool allowRetry = true,
    ErrorRecoveryStrategy strategy = ErrorRecoveryStrategy.graceful,
    Map<String, dynamic>? metadata,
  }) async {
    final operationId = operation.toString();

    try {
      final timer = PerformanceTimer('error_handler_operation');
      final result = await operation();
      timer.stop();

      // Reset error count on success
      _errorCounts.remove(operationId);
      _errorCooldowns.remove(operationId);

      return result;
    } catch (error, stackTrace) {
      return await _processError<T>(
        error: error,
        stackTrace: stackTrace,
        context: context,
        operationId: operationId,
        userMessage: userMessage,
        showToUser: showToUser,
        allowRetry: allowRetry,
        strategy: strategy,
        metadata: metadata,
        originalOperation: operation,
      );
    }
  }

  /// Process error with intelligent recovery
  static Future<T?> _processError<T>({
    required Object error,
    required StackTrace stackTrace,
    required BuildContext context,
    required String operationId,
    String? userMessage,
    bool showToUser = true,
    bool allowRetry = true,
    ErrorRecoveryStrategy strategy = ErrorRecoveryStrategy.graceful,
    Map<String, dynamic>? metadata,
    Future<T> Function()? originalOperation,
  }) async {
    // Log error with context
    ProductionLogger.e(
      'Operation failed: $operationId',
      tag: 'ERROR_HANDLER',
      error: error,
      stackTrace: stackTrace,
    );

    // Update error tracking
    _errorCounts[operationId] = (_errorCounts[operationId] ?? 0) + 1;
    _errorCooldowns[operationId] = DateTime.now();

    // Determine error type and appropriate response
    final errorInfo = _analyzeError(error);
    final userFriendlyMessage = userMessage ?? _generateUserMessage(errorInfo);

    // Apply recovery strategy
    switch (strategy) {
      case ErrorRecoveryStrategy.automatic:
        return await _attemptAutomaticRecovery<T>(
          error: errorInfo,
          context: context,
          operationId: operationId,
          originalOperation: originalOperation,
          userMessage: userFriendlyMessage,
        );

      case ErrorRecoveryStrategy.graceful:
        if (showToUser && context.mounted) {
          await _showGracefulError(
            context,
            errorInfo,
            userFriendlyMessage,
            allowRetry,
            originalOperation,
          );
        }
        break;

      case ErrorRecoveryStrategy.silent:
        // Log but don't show to user
        break;

      case ErrorRecoveryStrategy.critical:
        if (context.mounted) {
          await _showCriticalError(context, errorInfo, userFriendlyMessage);
        }
        break;
    }

    return null;
  }

  /// Analyze error type and severity
  static ErrorInfo _analyzeError(Object error) {
    if (error is SocketException) {
      return ErrorInfo(
        type: ErrorType.network,
        severity: ErrorSeverity.recoverable,
        isRetryable: true,
        suggestedAction: 'Prüfen Sie Ihre Internetverbindung',
        technicalDetails: error.toString(),
      );
    }

    if (error is TimeoutException) {
      return ErrorInfo(
        type: ErrorType.timeout,
        severity: ErrorSeverity.recoverable,
        isRetryable: true,
        suggestedAction: 'Vorgang erneut versuchen',
        technicalDetails: error.toString(),
      );
    }

    if (error is FormatException) {
      return ErrorInfo(
        type: ErrorType.parsing,
        severity: ErrorSeverity.moderate,
        isRetryable: false,
        suggestedAction: 'App neu starten',
        technicalDetails: error.toString(),
      );
    }

    if (error is FileSystemException) {
      return ErrorInfo(
        type: ErrorType.storage,
        severity: ErrorSeverity.moderate,
        isRetryable: true,
        suggestedAction: 'Speicherplatz prüfen',
        technicalDetails: error.toString(),
      );
    }

    if (error.toString().contains('permission')) {
      return ErrorInfo(
        type: ErrorType.permission,
        severity: ErrorSeverity.recoverable,
        isRetryable: false,
        suggestedAction: 'Berechtigungen in Einstellungen prüfen',
        technicalDetails: error.toString(),
      );
    }

    // Unknown error
    return ErrorInfo(
      type: ErrorType.unknown,
      severity: ErrorSeverity.critical,
      isRetryable: false,
      suggestedAction: 'App neu starten oder Support kontaktieren',
      technicalDetails: error.toString(),
    );
  }

  /// Generate user-friendly error message
  static String _generateUserMessage(ErrorInfo errorInfo) {
    switch (errorInfo.type) {
      case ErrorType.network:
        return 'Verbindungsproblem. Bitte prüfen Sie Ihre Internetverbindung.';
      case ErrorType.timeout:
        return 'Der Vorgang dauert länger als erwartet. Möchten Sie es erneut versuchen?';
      case ErrorType.storage:
        return 'Speicherproblem. Bitte prüfen Sie den verfügbaren Speicherplatz.';
      case ErrorType.permission:
        return 'Fehlende Berechtigung. Bitte prüfen Sie die App-Einstellungen.';
      case ErrorType.parsing:
        return 'Datenverarbeitungsfehler. Bitte versuchen Sie es später erneut.';
      case ErrorType.unknown:
        return 'Ein unerwarteter Fehler ist aufgetreten. Bitte kontaktieren Sie den Support.';
    }
  }

  /// Attempt automatic recovery
  static Future<T?> _attemptAutomaticRecovery<T>({
    required ErrorInfo error,
    required BuildContext context,
    required String operationId,
    Future<T> Function()? originalOperation,
    required String userMessage,
  }) async {
    if (!error.isRetryable || originalOperation == null) return null;

    final retryCount = _errorCounts[operationId] ?? 0;
    if (retryCount >= _maxRetries) {
      if (context.mounted) {
        await _showMaxRetriesError(context, userMessage);
      }
      return null;
    }

    // Calculate retry delay with exponential backoff
    final delay = Duration(seconds: (retryCount * 2).clamp(1, 10));

    if (context.mounted) {
      _showRetryingSnackBar(context, retryCount + 1, delay);
    }

    await Future.delayed(delay);

    // Retry the operation
    try {
      final result = await originalOperation();

      // Reset error tracking on success
      _errorCounts.remove(operationId);
      _errorCooldowns.remove(operationId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verbindung wiederhergestellt'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      return result;
    } catch (retryError) {
      // Recursive retry with updated count
      return await _processError<T>(
        error: retryError,
        stackTrace: StackTrace.current,
        context: context,
        operationId: operationId,
        userMessage: userMessage,
        showToUser: true,
        allowRetry: true,
        strategy: ErrorRecoveryStrategy.automatic,
        originalOperation: originalOperation,
      );
    }
  }

  /// Show graceful error dialog with recovery options
  static Future<void> _showGracefulError<T>(
    BuildContext context,
    ErrorInfo errorInfo,
    String userMessage,
    bool allowRetry,
    Future<T> Function()? originalOperation,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(
          _getErrorIcon(errorInfo.severity),
          color: _getErrorColor(errorInfo.severity),
          size: 48,
        ),
        title: Text(_getErrorTitle(errorInfo.severity)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userMessage),
            if (errorInfo.suggestedAction.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      size: 16,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorInfo.suggestedAction,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          if (allowRetry && errorInfo.isRetryable && originalOperation != null)
            FilledButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await handleError(
                  operation: originalOperation,
                  context: context,
                  strategy: ErrorRecoveryStrategy.automatic,
                );
              },
              child: const Text('Erneut versuchen'),
            ),
        ],
      ),
    );
  }

  /// Show critical error with contact options
  static Future<void> _showCriticalError(
    BuildContext context,
    ErrorInfo errorInfo,
    String userMessage,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.error, color: Colors.red, size: 48),
        title: const Text('Kritischer Fehler'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(userMessage),
            const SizedBox(height: 16),
            const Text(
              'Wenn das Problem weiterhin besteht, kontaktieren Sie bitte den Support.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schließen'),
          ),
          FilledButton(
            onPressed: () {
              // Open support contact
              Navigator.of(context).pop();
              _contactSupport(context, errorInfo);
            },
            child: const Text('Support kontaktieren'),
          ),
        ],
      ),
    );
  }

  /// Show max retries reached error
  static Future<void> _showMaxRetriesError(
    BuildContext context,
    String userMessage,
  ) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$userMessage\nMaximale Wiederholungsversuche erreicht.'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Details',
          onPressed: () {
            // Show detailed error info
          },
        ),
      ),
    );
  }

  /// Show retrying snackbar
  static void _showRetryingSnackBar(
    BuildContext context,
    int attempt,
    Duration delay,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Wiederholung $attempt in ${delay.inSeconds}s...'),
        backgroundColor: Colors.orange,
        duration: delay + const Duration(seconds: 1),
      ),
    );
  }

  /// Contact support with error details
  static void _contactSupport(BuildContext context, ErrorInfo errorInfo) {
    // Implementation would open email client or support form
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Support-Funktion wird geöffnet...'),
        action: SnackBarAction(
          label: 'Details kopieren',
          onPressed: () {
            // Copy error details to clipboard
          },
        ),
      ),
    );
  }

  /// Get appropriate icon for error severity
  static IconData _getErrorIcon(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.recoverable:
        return Icons.warning_amber;
      case ErrorSeverity.moderate:
        return Icons.error_outline;
      case ErrorSeverity.critical:
        return Icons.error;
    }
  }

  /// Get appropriate color for error severity
  static Color _getErrorColor(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.recoverable:
        return Colors.orange;
      case ErrorSeverity.moderate:
        return Colors.red;
      case ErrorSeverity.critical:
        return Colors.red.shade700;
    }
  }

  /// Get appropriate title for error severity
  static String _getErrorTitle(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.recoverable:
        return 'Temporäres Problem';
      case ErrorSeverity.moderate:
        return 'Fehler aufgetreten';
      case ErrorSeverity.critical:
        return 'Kritischer Fehler';
    }
  }

  /// Check if operation is in cooldown
  static bool isInCooldown(String operationId) {
    final lastError = _errorCooldowns[operationId];
    if (lastError == null) return false;

    return DateTime.now().difference(lastError) < _cooldownDuration;
  }

  /// Get error statistics for monitoring
  static Map<String, int> getErrorStatistics() {
    return Map.from(_errorCounts);
  }

  /// Clear error tracking (useful for testing)
  static void clearErrorTracking() {
    _errorCounts.clear();
    _errorCooldowns.clear();
  }
}

/// Error recovery strategies
enum ErrorRecoveryStrategy {
  automatic, // Try to recover automatically with retries
  graceful, // Show user-friendly error with options
  silent, // Log but don't show to user
  critical, // Show critical error dialog
}

/// Error types for classification
enum ErrorType { network, timeout, storage, permission, parsing, unknown }

/// Error severity levels
enum ErrorSeverity {
  recoverable, // Can likely be resolved automatically
  moderate, // Requires user action but not critical
  critical, // Serious issue requiring immediate attention
}

/// Comprehensive error information
class ErrorInfo {
  final ErrorType type;
  final ErrorSeverity severity;
  final bool isRetryable;
  final String suggestedAction;
  final String technicalDetails;

  ErrorInfo({
    required this.type,
    required this.severity,
    required this.isRetryable,
    required this.suggestedAction,
    required this.technicalDetails,
  });
}

/// Widget wrapper for automatic error handling
class ErrorBoundary extends ConsumerWidget {
  final Widget child;
  final String? fallbackMessage;
  final Widget? fallbackWidget;
  final ErrorRecoveryStrategy strategy;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.fallbackMessage,
    this.fallbackWidget,
    this.strategy = ErrorRecoveryStrategy.graceful,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ErrorBoundaryWidget(
      fallbackMessage: fallbackMessage,
      fallbackWidget: fallbackWidget,
      strategy: strategy,
      child: child,
    );
  }
}

/// Internal error boundary implementation
class ErrorBoundaryWidget extends StatefulWidget {
  final Widget child;
  final String? fallbackMessage;
  final Widget? fallbackWidget;
  final ErrorRecoveryStrategy strategy;

  const ErrorBoundaryWidget({
    super.key,
    required this.child,
    this.fallbackMessage,
    this.fallbackWidget,
    this.strategy = ErrorRecoveryStrategy.graceful,
  });

  @override
  State<ErrorBoundaryWidget> createState() => _ErrorBoundaryWidgetState();
}

class _ErrorBoundaryWidgetState extends State<ErrorBoundaryWidget> {
  bool hasError = false;
  Object? error;

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return widget.fallbackWidget ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  widget.fallbackMessage ?? 'Ein Fehler ist aufgetreten',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      hasError = false;
                      error = null;
                    });
                  },
                  child: const Text('Erneut versuchen'),
                ),
              ],
            ),
          );
    }

    return widget.child;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Set up error handler for this widget
    FlutterError.onError = (FlutterErrorDetails details) {
      setState(() {
        hasError = true;
        error = details.exception;
      });

      ProductionLogger.e(
        'Widget error boundary caught error',
        tag: 'ERROR_BOUNDARY',
        error: details.exception,
        stackTrace: details.stack,
      );
    };
  }
}

/// Provider for enhanced error handler
final enhancedErrorHandlerProvider = Provider<EnhancedErrorHandler>((ref) {
  return EnhancedErrorHandler();
});
