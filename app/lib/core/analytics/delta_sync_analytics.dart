/// Analytics für Delta Sync Polling Effizienz
class DeltaSyncAnalytics {
  final Map<String, dynamic> _metrics = {};
  int _totalPolls = 0;
  int _emptyPolls = 0;
  int _successfulDeltas = 0;
  Duration _totalPollTime = Duration.zero;
  DateTime? _lastPollStart;

  /// Startet Messung eines Poll-Vorgangs
  void startPoll() {
    _lastPollStart = DateTime.now();
    _totalPolls++;
  }

  /// Beendet Poll-Messung mit Ergebnis
  void endPoll({required bool hadDeltas, required bool wasSuccessful}) {
    if (_lastPollStart != null) {
      final duration = DateTime.now().difference(_lastPollStart!);
      _totalPollTime += duration;
      _lastPollStart = null;
    }

    if (wasSuccessful) {
      if (hadDeltas) {
        _successfulDeltas++;
      } else {
        _emptyPolls++;
      }
    }
  }

  /// Durchschnittliche Poll-Dauer
  Duration get averagePollDuration {
    if (_totalPolls == 0) return Duration.zero;
    return Duration(
      milliseconds: (_totalPollTime.inMilliseconds / _totalPolls).round(),
    );
  }

  /// Erfolgsrate (0.0 - 1.0)
  double get successRate {
    if (_totalPolls == 0) return 0.0;
    return (_successfulDeltas + _emptyPolls) / _totalPolls;
  }

  /// Delta-Effizienz (Anteil mit tatsächlichen Änderungen)
  double get deltaEfficiency {
    final successful = _successfulDeltas + _emptyPolls;
    if (successful == 0) return 0.0;
    return _successfulDeltas / successful;
  }

  /// Leere Polls Streak (consecutiv)
  int get emptyPollStreak => _emptyPolls;

  /// Gesamtanzahl Polls
  int get totalPolls => _totalPolls;

  /// Polls mit Änderungen
  int get successfulDeltas => _successfulDeltas;

  /// Exportiere Metriken als Map
  Map<String, dynamic> toMetrics() {
    return {
      'totalPolls': _totalPolls,
      'emptyPolls': _emptyPolls,
      'successfulDeltas': _successfulDeltas,
      'averagePollDurationMs': averagePollDuration.inMilliseconds,
      'successRate': successRate,
      'deltaEfficiency': deltaEfficiency,
      'totalPollTimeMs': _totalPollTime.inMilliseconds,
    };
  }

  /// Reset aller Metriken
  void reset() {
    _totalPolls = 0;
    _emptyPolls = 0;
    _successfulDeltas = 0;
    _totalPollTime = Duration.zero;
    _lastPollStart = null;
    _metrics.clear();
  }

  @override
  String toString() {
    return 'DeltaSyncAnalytics(polls: $_totalPolls, efficiency: ${(deltaEfficiency * 100).toStringAsFixed(1)}%, avgDuration: ${averagePollDuration.inMilliseconds}ms)';
  }
}
