import 'dart:async';

/// Exponentielles Retry für flüchtige Operationen (Netzwerk, Cache Race Conditions)
Future<T> retry<T>(
  Future<T> Function() action, {
  int maxAttempts = 3,
  Duration initialDelay = const Duration(milliseconds: 200),
  bool Function(Object error)? shouldRetry,
}) async {
  int attempt = 0;
  var delay = initialDelay;
  while (true) {
    attempt++;
    try {
      return await action();
    } catch (e) {
      if (attempt >= maxAttempts) rethrow;
      if (shouldRetry != null && !shouldRetry(e)) rethrow;
      await Future.delayed(delay);
      delay *= 2; // exponentielles Backoff
    }
  }
}
