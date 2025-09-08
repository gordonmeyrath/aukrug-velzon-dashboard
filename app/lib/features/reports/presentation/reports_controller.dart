import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/delta_sync_analytics.dart';
import '../../../core/feedback/haptic_feedback_service.dart';
import '../../../core/util/failure.dart';
import '../data/reports_preferences.dart';
import '../data/reports_repository.dart';
import '../domain/report.dart';

/// Zustand für Meldungen (Liste + Filter + Lade/Error-Status)
@immutable
class ReportsState {
  final bool loading;
  final Failure? failure;
  final List<Report> all; // ungefiltert
  final List<Report> filtered; // nach query / filter
  final String query;
  final ReportCategory? category;
  final ReportStatus? status;
  final Report? selectedReport;
  final ReportsSort sort;
  final DateTime? lastLoadedAt;
  final int staleMinutes; // 0 = nie automatisch veraltet
  final bool fromCache; // letzte Datenquelle war Cache (offline-first Anzeige)
  final bool isOffline; // erkannter Offline-Zustand
  final DateTime? lastFullSyncAt; // Zeitpunkt letzter vollständiger Sync
  final bool showOnlyNewSinceSync; // UI Filter nur neue seit letztem Sync
  final int
  newSinceSyncCount; // Anzahl neuer/aktualisierter Meldungen seit Full Sync
  final DataOrigin? dataOrigin; // Herkunft laut Repository
  final DeltaStats? deltaStats; // Letzte Delta-Statistik
  final Set<int> highlightedAddedIds; // IDs kürzlich hinzugefügt
  final Set<int> highlightedUpdatedIds; // IDs kürzlich aktualisiert

  const ReportsState({
    required this.loading,
    required this.failure,
    required this.all,
    required this.filtered,
    required this.query,
    required this.category,
    required this.status,
    required this.selectedReport,
    required this.sort,
    required this.lastLoadedAt,
    required this.staleMinutes,
    required this.fromCache,
    required this.isOffline,
    required this.lastFullSyncAt,
    required this.showOnlyNewSinceSync,
    required this.newSinceSyncCount,
    required this.dataOrigin,
    required this.deltaStats,
    required this.highlightedAddedIds,
    required this.highlightedUpdatedIds,
  });

  factory ReportsState.initial() => const ReportsState(
    loading: false,
    failure: null,
    all: [],
    filtered: [],
    query: '',
    category: null,
    status: null,
    selectedReport: null,
    sort: ReportsSort.latest,
    lastLoadedAt: null,
    staleMinutes: 5,
    fromCache: false,
    isOffline: false,
    lastFullSyncAt: null,
    showOnlyNewSinceSync: false,
    newSinceSyncCount: 0,
    dataOrigin: null,
    deltaStats: DeltaStats(),
    highlightedAddedIds: {},
    highlightedUpdatedIds: {},
  );

  ReportsState copyWith({
    bool? loading,
    Failure? failure = const _NoUpdateFailureMarker(),
    List<Report>? all,
    List<Report>? filtered,
    String? query,
    ReportCategory? category = _noUpdateCategory,
    ReportStatus? status = _noUpdateStatus,
    Object? selectedReport = _noUpdateSelectedMarker,
    ReportsSort? sort,
    DateTime? lastLoadedAt,
    bool keepLastLoadedAt = false,
    int? staleMinutes,
    bool? fromCache,
    bool? isOffline,
    DateTime? lastFullSyncAt,
    bool? showOnlyNewSinceSync,
    int? newSinceSyncCount,
    DataOrigin? dataOrigin,
    DeltaStats? deltaStats,
    Set<int>? highlightedAddedIds,
    Set<int>? highlightedUpdatedIds,
  }) {
    return ReportsState(
      loading: loading ?? this.loading,
      failure: failure is _NoUpdateFailureMarker ? this.failure : failure,
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      query: query ?? this.query,
      category: category == _noUpdateCategory ? this.category : category,
      status: status == _noUpdateStatus ? this.status : status,
      selectedReport: identical(selectedReport, _noUpdateSelectedMarker)
          ? this.selectedReport
          : selectedReport as Report?,
      sort: sort ?? this.sort,
      lastLoadedAt: keepLastLoadedAt
          ? this.lastLoadedAt
          : (lastLoadedAt ?? this.lastLoadedAt),
      staleMinutes: staleMinutes ?? this.staleMinutes,
      fromCache: fromCache ?? this.fromCache,
      isOffline: isOffline ?? this.isOffline,
      lastFullSyncAt: lastFullSyncAt ?? this.lastFullSyncAt,
      showOnlyNewSinceSync: showOnlyNewSinceSync ?? this.showOnlyNewSinceSync,
      newSinceSyncCount: newSinceSyncCount ?? this.newSinceSyncCount,
      dataOrigin: dataOrigin ?? this.dataOrigin,
      deltaStats: deltaStats ?? this.deltaStats,
      highlightedAddedIds: highlightedAddedIds ?? this.highlightedAddedIds,
      highlightedUpdatedIds:
          highlightedUpdatedIds ?? this.highlightedUpdatedIds,
    );
  }

  bool get isStale {
    if (staleMinutes == 0) return false; // deaktiviert
    if (lastLoadedAt == null) return true;
    return DateTime.now().difference(lastLoadedAt!).inMinutes >= staleMinutes;
  }
}

class _NoUpdateFailureMarker extends Failure {
  const _NoUpdateFailureMarker() : super('NO_UPDATE');
}

const _noUpdateCategory = ReportCategory.other; // Marker (wird abgefangen)
const _noUpdateStatus = ReportStatus.submitted; // Marker (wird abgefangen)
const _noUpdateSelectedMarker = Object();

/// Controller zur Vereinheitlichung von Listen- & Kartenansicht.
class ReportsController extends StateNotifier<ReportsState> {
  final ReportsRepository repository;
  final Ref ref;
  ReportsController(this.repository, this.ref) : super(ReportsState.initial()) {
    _bootstrap();
  }

  Timer? _highlightClearTimer;
  Timer? _deltaPollTimer;
  int _consecutiveEmptyDeltas = 0;
  final DeltaSyncAnalytics _analytics = DeltaSyncAnalytics();

  Future<void> _bootstrap() async {
    // Prefs parallel laden und Daten laden
    final prefsFuture = repositoryFuturePrefs;
    await load();
    try {
      final p = await prefsFuture;
      state = state.copyWith(
        query: p.query.isEmpty ? null : p.query,
        category: p.category ?? _noUpdateCategory,
        status: p.status ?? _noUpdateStatus,
        sort: p.sort,
        staleMinutes: p.staleMinutes,
      );
      // Lade DeltaStats falls vorhanden und aktueller State noch leer
      try {
        final service = await ref.read(
          reportsPreferencesServiceProvider.future,
        );
        final ds = service.loadDeltaStats();
        if (ds != null && state.deltaStats?.isEmpty == true) {
          state = state.copyWith(deltaStats: ds);
        }
      } catch (_) {}
      _recompute();
    } catch (_) {
      // Ignoriere Pref Fehler
    }
    _startDeltaPolling();
  }

  Future<ReportsViewPrefs> get repositoryFuturePrefs async {
    // Zugriff via Provider später injizierbar; hier lazy
    try {
      final prefs = await ref.read(reportsViewPrefsProvider.future);
      // falls Full Sync nötig -> Cache invalidieren damit fetchAll frische Daten lädt
      if (ReportsRepository.needsFullSync(prefs.lastFullSyncAt)) {
        repository.clearCache();
      }
      return prefs; // service nicht benötigt hier
    } catch (_) {
      return ReportsViewPrefs.initial();
    }
  }

  Future<void> load() async {
    state = state.copyWith(
      loading: true,
      failure: const _NoUpdateFailureMarker(),
    );
    final offline = await repository.isCurrentlyOffline();
    // Unterscheidung: erster Load nutzt fetchAll (Cache-first) um schnell etwas anzuzeigen
    // Anschließend (refresh()) verwenden wir refreshOrDeltaSync.
    final result = await repository.fetchAll();
    result.when(
      success: (all) {
        final now = DateTime.now();
        // Wenn servedCache true -> kein Full Sync Abschluss, lastFullSyncAt nicht setzen
        final fullSyncTime = repository.servedCache
            ? state.lastFullSyncAt
            : now;
        final newCount = _computeNewSinceSyncCount(all, fullSyncTime);
        state = state.copyWith(
          loading: false,
          all: all,
          filtered: _applyFilters(all: all),
          failure: null,
          lastLoadedAt: now,
          fromCache:
              repository.servedCache || offline || repository.hasOnlyCache,
          isOffline: offline,
          lastFullSyncAt: fullSyncTime,
          newSinceSyncCount: newCount,
          dataOrigin: repository.lastOrigin,
          deltaStats: const DeltaStats(),
          highlightedAddedIds: const {},
          highlightedUpdatedIds: const {},
        );
        _persist();
      },
      failure: (f) {
        state = state.copyWith(
          loading: false,
          failure: f,
          lastLoadedAt: DateTime.now(),
          isOffline: offline,
        );
      },
    );
  }

  void setQuery(String q) {
    state = state.copyWith(query: q.trim());
    _recompute();
    _persist();
  }

  void setCategory(ReportCategory? category) {
    state = state.copyWith(category: category);
    _recompute();
    _persist();
  }

  void setStatus(ReportStatus? status) {
    state = state.copyWith(status: status);
    _recompute();
    _persist();
  }

  void clearFilters() {
    state = state.copyWith(query: '', category: null, status: null);
    _recompute();
    _persist();
  }

  void setSort(ReportsSort sort) {
    if (state.sort == sort) return;
    state = state.copyWith(sort: sort);
    _recompute();
    _persist();
  }

  void updateOfflineFlag(bool offline) {
    if (state.isOffline == offline) return;
    state = state.copyWith(isOffline: offline);
  }

  void selectReport(Report? report) {
    state = state.copyWith(selectedReport: report);
  }

  Report? previousVersionOf(int id) {
    return repository.previousVersionFor(id);
  }

  void clearPreviousVersions() {
    repository.clearPreviousVersions();
  }

  /// Liefert erste neue oder aktualisierte Report-ID (oder null)
  int? firstHighlightedId() {
    if (state.highlightedAddedIds.isNotEmpty) {
      return state.highlightedAddedIds.first;
    }
    if (state.highlightedUpdatedIds.isNotEmpty) {
      return state.highlightedUpdatedIds.first;
    }
    return null;
  }

  /// Zugriff auf Polling Analytics
  DeltaSyncAnalytics get analytics => _analytics;

  /// Reset Analytics (für Testing/Debug)
  void resetAnalytics() => _analytics.reset();

  void toggleShowOnlyNewSinceSync() {
    state = state.copyWith(showOnlyNewSinceSync: !state.showOnlyNewSinceSync);
    _recompute();
    _persist();
  }

  Future<void> submitReport(Report draft) async {
    // Optimistisches Hinzufügen am Anfang
    final temp = draft.copyWith(
      id: DateTime.now().millisecondsSinceEpoch,
      status: ReportStatus.submitted,
      submittedAt: DateTime.now(),
    );
    final previous = state.all;
    final updatedAll = [temp, ...previous];
    state = state.copyWith(
      all: updatedAll,
      filtered: _applyFilters(all: updatedAll),
    );
    final res = await repository.submitReportResult(draft);
    res.when(
      success: (real) {
        final replaced = [real, ...previous];
        state = state.copyWith(
          all: replaced,
          filtered: _applyFilters(all: replaced),
          lastLoadedAt: state.lastLoadedAt, // unverändert
        );
      },
      failure: (f) {
        state = state.copyWith(
          all: previous,
          filtered: _applyFilters(all: previous),
          failure: f,
          lastLoadedAt: state.lastLoadedAt,
        );
      },
    );
  }

  Future<void> _persist() async {
    try {
      final service = await ref.read(reportsPreferencesServiceProvider.future);
      final prefs = ReportsViewPrefs(
        query: state.query,
        category: state.category,
        status: state.status,
        sort: state.sort,
        staleMinutes: state.staleMinutes,
        // lastFullSyncAt nur speichern wenn vorhanden (nur echte Full Sync Zeit)
        lastFullSyncAt: state.lastFullSyncAt,
        showOnlyNewSinceSync: state.showOnlyNewSinceSync,
      );
      await service.save(prefs);
      // DeltaStats optional protokollieren (nur wenn nicht leer)
      final ds = state.deltaStats;
      if (ds != null && !ds.isEmpty) {
        await service.saveDeltaStats(
          added: ds.added,
          updated: ds.updated,
          deleted: ds.deleted,
          at: DateTime.now(),
        );
      }
    } catch (_) {
      // Ignorieren
    }
  }

  void setStaleMinutes(int minutes) {
    if (minutes < 0) minutes = 0;
    if (state.staleMinutes == minutes) return;
    state = state.copyWith(staleMinutes: minutes);
    _persist();
  }

  Future<void> refresh() async {
    // Versuche Delta-Sync falls möglich, sonst Full
    state = state.copyWith(
      loading: true,
      failure: const _NoUpdateFailureMarker(),
    );
    final offline = await repository.isCurrentlyOffline();
    try {
      final merged = await repository.refreshOrDeltaSync(state.lastFullSyncAt);
      final now = DateTime.now();
      final didFull =
          repository.servedCache ==
          false; // heuristik: nach fullSync servedCache false
      final baseSync = didFull ? now : state.lastFullSyncAt;
      final newCount = _computeNewSinceSyncCount(merged, baseSync);
      state = state.copyWith(
        loading: false,
        all: merged,
        filtered: _applyFilters(all: merged),
        failure: null,
        lastLoadedAt: now,
        fromCache: offline || repository.hasOnlyCache,
        isOffline: offline,
        lastFullSyncAt: didFull ? now : state.lastFullSyncAt,
        newSinceSyncCount: didFull ? 0 : newCount,
        dataOrigin: repository.lastOrigin,
        deltaStats: didFull ? const DeltaStats() : repository.lastDeltaStats,
        highlightedAddedIds: didFull ? const {} : repository.lastAddedIds,
        highlightedUpdatedIds: didFull ? const {} : repository.lastUpdatedIds,
      );
      _scheduleHighlightClear();
      // Haptic Feedback bei neuen Deltas
      final stats = repository.lastDeltaStats;
      if (!didFull && stats.added > 0) {
        HapticFeedbackService.onNewContent();
      } else if (!didFull && stats.updated > 0 && stats.added == 0) {
        HapticFeedbackService.onImportantUpdate();
      }
      _persist();
      _adjustPollingAfterDelta();
    } catch (e) {
      state = state.copyWith(
        loading: false,
        failure: unknownFailure('Aktualisierung fehlgeschlagen', cause: e),
        isOffline: offline,
        lastLoadedAt: DateTime.now(),
      );
    }
  }

  void _scheduleHighlightClear() {
    _highlightClearTimer?.cancel();
    if (state.highlightedAddedIds.isEmpty &&
        state.highlightedUpdatedIds.isEmpty)
      return;
    _highlightClearTimer = Timer(const Duration(seconds: 25), () {
      state = state.copyWith(
        highlightedAddedIds: const {},
        highlightedUpdatedIds: const {},
      );
    });
  }

  void _startDeltaPolling() {
    _deltaPollTimer?.cancel();
    // initial Intervall moderat
    _deltaPollTimer = Timer(const Duration(seconds: 45), _pollDeltaOnce);
  }

  void _pollDeltaOnce() async {
    if (state.loading) {
      _startDeltaPolling();
      return;
    }
    // kein Delta Poll ohne Full Sync Basis
    if (state.lastFullSyncAt == null) {
      _startDeltaPolling();
      return;
    }
    if (state.isOffline) {
      _deltaPollTimer = Timer(const Duration(minutes: 2), _pollDeltaOnce);
      return;
    }

    _analytics.startPoll();
    final before = DateTime.now();
    bool hadDeltas = false;
    bool wasSuccessful = false;

    try {
      await refresh();
      wasSuccessful = true;
      hadDeltas = state.deltaStats != null && !state.deltaStats!.isEmpty;
    } catch (_) {
      wasSuccessful = false;
    }

    _analytics.endPoll(hadDeltas: hadDeltas, wasSuccessful: wasSuccessful);
    final took = DateTime.now().difference(before);

    // adaptives Intervall berechnen
    Duration next;
    if (hadDeltas) {
      _consecutiveEmptyDeltas = 0;
      next = const Duration(seconds: 45);
    } else {
      _consecutiveEmptyDeltas++;
      final calc = 45 * math.pow(1.6, _consecutiveEmptyDeltas);
      final base = calc.toInt();
      final clamped = base.clamp(45, 900);
      next = Duration(seconds: clamped);
    }
    // Falls Request sehr kurz (<500ms) war, minimal delay erhöhen für Schonung
    if (took < const Duration(milliseconds: 500)) {
      next += const Duration(seconds: 10);
    }
    _deltaPollTimer = Timer(next, _pollDeltaOnce);
  }

  void _adjustPollingAfterDelta() {
    if (state.deltaStats != null && !state.deltaStats!.isEmpty) {
      // Sofort früher neuer Poll für schnelles Nachladen bei Aktivität
      _deltaPollTimer?.cancel();
      _deltaPollTimer = Timer(const Duration(seconds: 30), _pollDeltaOnce);
    }
  }

  @override
  void dispose() {
    _deltaPollTimer?.cancel();
    _highlightClearTimer?.cancel();
    super.dispose();
  }

  int _computeNewSinceSyncCount(
    List<Report> reports,
    DateTime? lastFullSyncAt,
  ) {
    if (lastFullSyncAt == null) return 0;
    int c = 0;
    for (final r in reports) {
      final changed = r.updatedAt ?? r.submittedAt;
      if (changed != null && changed.isAfter(lastFullSyncAt)) c++;
    }
    return c;
  }

  List<Report> _applyFilters({required List<Report> all}) {
    Iterable<Report> current = all;
    if (state.query.isNotEmpty) {
      final q = state.query.toLowerCase();
      current = current.where(
        (r) =>
            r.title.toLowerCase().contains(q) ||
            r.description.toLowerCase().contains(q) ||
            (r.location.address?.toLowerCase().contains(q) ?? false),
      );
    }
    if (state.category != null) {
      current = current.where((r) => r.category == state.category);
    }
    if (state.status != null) {
      current = current.where((r) => r.status == state.status);
    }
    if (state.showOnlyNewSinceSync && state.lastFullSyncAt != null) {
      current = current.where(
        (r) => (r.submittedAt ?? r.updatedAt ?? r.submittedAt ?? DateTime(0))
            .isAfter(state.lastFullSyncAt!),
      );
    }
    final list = current.toList();
    _sortInPlace(list, state.sort);
    return list;
  }

  void _recompute() {
    state = state.copyWith(filtered: _applyFilters(all: state.all));
  }
}

/// Sortierkriterien für Meldungen
enum ReportsSort { latest, oldest, priorityHighFirst, status }

void _sortInPlace(List<Report> list, ReportsSort sort) {
  switch (sort) {
    case ReportsSort.latest:
      list.sort((a, b) => _date(b.submittedAt).compareTo(_date(a.submittedAt)));
      break;
    case ReportsSort.oldest:
      list.sort((a, b) => _date(a.submittedAt).compareTo(_date(b.submittedAt)));
      break;
    case ReportsSort.priorityHighFirst:
      list.sort(
        (a, b) =>
            _priorityWeight(b.priority).compareTo(_priorityWeight(a.priority)),
      );
      break;
    case ReportsSort.status:
      list.sort((a, b) => a.status.index.compareTo(b.status.index));
      break;
  }
}

int _priorityWeight(ReportPriority p) {
  switch (p) {
    case ReportPriority.low:
      return 0;
    case ReportPriority.medium:
      return 1;
    case ReportPriority.high:
      return 2;
    case ReportPriority.urgent:
      return 3;
  }
}

DateTime _date(DateTime? d) => d ?? DateTime.fromMillisecondsSinceEpoch(0);

final reportsControllerProvider =
    StateNotifierProvider<ReportsController, ReportsState>((ref) {
      final repo = ref.watch(reportsRepositoryProvider);
      return ReportsController(repo, ref);
    });
