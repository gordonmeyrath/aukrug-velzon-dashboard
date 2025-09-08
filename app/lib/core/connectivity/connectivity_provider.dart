import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StreamProvider für Konnektivitätsänderungen.
final connectivityChangesProvider =
    StreamProvider<Iterable<ConnectivityResult>>((ref) {
      return Connectivity().onConnectivityChanged;
    });

/// Abgeleiteter Provider: true wenn offline (kein Result != none).
final isOfflineProvider = Provider<bool>((ref) {
  final resultsAsync = ref.watch(connectivityChangesProvider);
  return resultsAsync.maybeWhen(
    data: (results) =>
        results.isEmpty || results.every((r) => r == ConnectivityResult.none),
    orElse: () => false,
  );
});
