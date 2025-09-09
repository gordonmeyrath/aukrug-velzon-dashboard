import '../../features/reports/domain/report.dart';

/// Strategien zur Konfliktauflösung bei Delta Merges
enum ConflictResolutionStrategy {
  /// Timestamp-basiert (aktuelles Verhalten)
  timestamp,

  /// Server-Version bevorzugen
  serverVersionWins,

  /// Client-Version bevorzugen
  clientVersionWins,

  /// Höhere Versionsnummer bevorzugen
  higherVersionWins,
}

/// Service für intelligente Konfliktauflösung
class ConflictResolver {
  final ConflictResolutionStrategy strategy;

  const ConflictResolver({
    this.strategy = ConflictResolutionStrategy.higherVersionWins,
  });

  /// Löst Konflikt zwischen lokalem und Delta Report
  /// Gibt true zurück wenn Delta Report bevorzugt werden soll
  bool shouldPreferDelta({required Report existing, required Report delta}) {
    switch (strategy) {
      case ConflictResolutionStrategy.timestamp:
        return _timestampWins(existing, delta);
      case ConflictResolutionStrategy.serverVersionWins:
        return true; // Delta kommt vom Server
      case ConflictResolutionStrategy.clientVersionWins:
        return false; // Existing ist lokaler Stand
      case ConflictResolutionStrategy.higherVersionWins:
        return _higherVersionWins(existing, delta);
    }
  }

  bool _timestampWins(Report existing, Report delta) {
    final existingTs = existing.updatedAt ?? existing.submittedAt;
    final deltaTs = delta.updatedAt ?? delta.submittedAt;

    if (deltaTs != null && existingTs != null) {
      return deltaTs.isAfter(existingTs);
    }
    return deltaTs != null; // Wenn nur Delta Timestamp hat
  }

  bool _higherVersionWins(Report existing, Report delta) {
    // Fallback auf Timestamp wenn Versionen gleich
    if (existing.version == delta.version) {
      return _timestampWins(existing, delta);
    }
    return delta.version > existing.version;
  }

  /// Erstellt Merge-Metadaten für Debug/Analytics
  ConflictResolution resolveConflict({
    required Report existing,
    required Report delta,
  }) {
    final preferDelta = shouldPreferDelta(existing: existing, delta: delta);
    return ConflictResolution(
      preferDelta: preferDelta,
      strategy: strategy,
      existingVersion: existing.version,
      deltaVersion: delta.version,
      existingTimestamp: existing.updatedAt ?? existing.submittedAt,
      deltaTimestamp: delta.updatedAt ?? delta.submittedAt,
    );
  }
}

/// Metadaten einer Konfliktauflösung
class ConflictResolution {
  final bool preferDelta;
  final ConflictResolutionStrategy strategy;
  final int existingVersion;
  final int deltaVersion;
  final DateTime? existingTimestamp;
  final DateTime? deltaTimestamp;

  const ConflictResolution({
    required this.preferDelta,
    required this.strategy,
    required this.existingVersion,
    required this.deltaVersion,
    this.existingTimestamp,
    this.deltaTimestamp,
  });

  @override
  String toString() {
    return 'ConflictResolution(preferDelta: $preferDelta, strategy: $strategy, versions: $existingVersion->$deltaVersion)';
  }
}
