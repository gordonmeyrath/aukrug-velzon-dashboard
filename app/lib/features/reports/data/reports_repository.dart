import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_error.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/sync/conflict_resolver.dart';
import '../../../core/util/failure.dart';
import '../../../core/util/result.dart';
import '../domain/report.dart';
import 'report_cache_entity.dart';

part 'reports_repository.g.dart';

/// Herkunft der zuletzt ausgelieferten Daten (vereinheitlichte Semantik statt bool)
enum DataOrigin {
  /// Frisch geladene vollständige Daten (Full Sync / Fixtures / später API)
  freshFullSync,

  /// Cache wurde primär bedient (Cache-first Pfad, danach stiller Refresh)
  cachePrimed,

  /// Nur Cache verfügbar (Offline / Refresh-Fehler Folge)
  cacheOnly,
}

/// Statistiken der letzten Delta-Aktualisierung
@immutable
class DeltaStats {
  final int added;
  final int updated;
  final int deleted;
  const DeltaStats({this.added = 0, this.updated = 0, this.deleted = 0});
  bool get isEmpty => added == 0 && updated == 0 && deleted == 0;
  @override
  String toString() =>
      'DeltaStats(added=$added, updated=$updated, deleted=$deleted)';
}

@riverpod
ReportsRepository reportsRepository(ReportsRepositoryRef ref) {
  return ReportsRepository(dio: ref.watch(dioClientProvider));
}

/// Repository for managing municipal issue reports (Mängelmelder)
class ReportsRepository {
  ReportsRepository({Dio? dio}) : _dio = dio;
  final Dio? _dio; // optional für Tests
  List<Report>? _cachedReports;
  Isar? _isar;
  DateTime? _lastCacheSync;
  bool _lastRefreshFailed = false;
  DataOrigin _lastOrigin = DataOrigin.freshFullSync; // ersetzt _servedCacheLast
  int _refreshRetryCount = 0;
  Timer? _refreshRetryTimer;
  bool _persistenceAvailable = true; // Fallback für Test-/Headless-Umgebung
  List<int> _pendingDeletedIds =
      []; // IDs, die über Delta als gelöscht gemeldet wurden
  DeltaStats _lastDeltaStats = const DeltaStats();
  final Set<int> _lastAddedIds = <int>{};
  final Set<int> _lastUpdatedIds = <int>{};
  final Map<int, Report> _previousVersions =
      <int, Report>{}; // Vorherige Versionen zuletzt geänderter Reports
  final ConflictResolver _conflictResolver = ConflictResolver();

  bool get hasOnlyCache => _cachedReports != null && _lastRefreshFailed;
  bool get servedCache =>
      _lastOrigin == DataOrigin.cachePrimed; // Backwards Kompat.
  DataOrigin get lastOrigin => _lastOrigin;
  DeltaStats get lastDeltaStats => _lastDeltaStats;
  Set<int> get lastAddedIds => _lastAddedIds;
  Set<int> get lastUpdatedIds => _lastUpdatedIds;
  Report? previousVersionFor(int id) => _previousVersions[id];
  void clearPreviousVersions() => _previousVersions.clear();

  /// Platzhalter für zukünftigen Delta-Sync: lädt nur Änderungen seit Timestamp.
  /// Aktuell: Rückgabe leer (keine Änderungen bekannt) -> Fallback auf Full Sync.
  Future<List<Report>> fetchChangesSince(DateTime since) async {
    // 1. Netzwerk versuchen, falls Dio vorhanden
    if (_dio != null) {
      try {
        final resp = await _dio.get(
          '/reports',
          queryParameters: {'since': since.toUtc().toIso8601String()},
        );
        if (resp.statusCode == 304) {
          // Keine Änderungen
          _pendingDeletedIds = [];
          return const <Report>[];
        }
        if (resp.statusCode == 200) {
          final data = resp.data;
          if (data is Map<String, dynamic>) {
            final List<dynamic> list =
                (data['data'] as List<dynamic>?) ?? const [];
            _pendingDeletedIds = <int>[]; // WordPress hat keine deleted_ids
            final deltas = list
                .map((e) => _convertWordPressReport(e as Map<String, dynamic>))
                .where((r) {
                  final ts = r.updatedAt ?? r.submittedAt;
                  return ts != null && ts.isAfter(since);
                })
                .toList();
            return deltas;
          }
        }
      } catch (e) {
        print('API Error: $e');
        // Fallback auf Fixtures
      }
    }
    // 2. Fixture-Fallback
    try {
      final raw = await rootBundle.loadString(
        'assets/fixtures/reports_delta.json',
      );
      final Map<String, dynamic> data = json.decode(raw);
      final List<dynamic> list =
          (data['reports'] as List<dynamic>?) ?? const [];
      _pendingDeletedIds =
          (data['deleted_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [];
      final deltas = list
          .map((e) => Report.fromJson(e as Map<String, dynamic>))
          .where((r) {
            final ts = r.updatedAt ?? r.submittedAt;
            return ts != null && ts.isAfter(since);
          })
          .toList();
      // (Optional) künftige Löschungen: data['deleted_ids'] (Liste von int)
      return deltas;
    } catch (_) {
      // Fallback für Test-Kontext: direktes Filesystem
      try {
        final file = File('assets/fixtures/reports_delta.json');
        if (await file.exists()) {
          final raw = await file.readAsString();
          final Map<String, dynamic> data = json.decode(raw);
          final List<dynamic> list =
              (data['reports'] as List<dynamic>?) ?? const [];
          _pendingDeletedIds =
              (data['deleted_ids'] as List<dynamic>?)
                  ?.map((e) => (e as num).toInt())
                  .toList() ??
              [];
          return list
              .map((e) => Report.fromJson(e as Map<String, dynamic>))
              .where((r) {
                final ts = r.updatedAt ?? r.submittedAt;
                return ts != null && ts.isAfter(since);
              })
              .toList();
        }
      } catch (_) {}
      return <Report>[]; // keine Änderungen
    }
  }

  /// Führt – basierend auf lastFullSyncAt – entweder einen Delta Sync
  /// (falls Änderungen geliefert werden) oder einen Full Sync aus.
  /// Gibt die final gemergte Liste zurück und aktualisiert Cache.
  Future<List<Report>> refreshOrDeltaSync(DateTime? lastFullSyncAt) async {
    // Wenn kein Timestamp -> Full Sync
    if (lastFullSyncAt == null || needsFullSync(lastFullSyncAt)) {
      return await _fullSync();
    }

    // Delta laden (derzeit leer -> Full Fallback)
    final deltas = await fetchChangesSince(lastFullSyncAt);
    if (deltas.isEmpty && _pendingDeletedIds.isEmpty) {
      _lastDeltaStats = const DeltaStats();
      _lastAddedIds.clear();
      _lastUpdatedIds.clear();
      return _cachedReports ?? await _fullSync();
    }

    // Merge: ersetze nach ID, füge neue hinzu
    final current = List<Report>.from(_cachedReports ?? []);
    final byId = {for (final r in current) r.id: r};
    int addedCount = 0;
    int updatedCount = 0;
    _lastAddedIds.clear();
    _lastUpdatedIds.clear();
    _previousVersions.clear();
    for (final d in deltas) {
      final existing = byId[d.id];
      if (existing == null) {
        byId[d.id] = d; // neu
        addedCount++;
        _lastAddedIds.add(d.id);
      } else {
        // Erweiterte Konfliktstrategie mit ConflictResolver
        final resolution = _conflictResolver.resolveConflict(
          existing: existing,
          delta: d,
        );
        if (resolution.preferDelta) {
          _previousVersions[d.id] = existing; // diff track
          byId[d.id] = d;
          updatedCount++;
          _lastUpdatedIds.add(d.id);
        }
        // Andernfalls: behalte existing (kein Update)
      }
    }
    // Deletions anwenden
    int deletedCount = 0;
    if (_pendingDeletedIds.isNotEmpty) {
      for (final id in _pendingDeletedIds) {
        if (byId.remove(id) != null) deletedCount++;
      }
    }
    final merged = byId.values.toList()
      ..sort(
        (a, b) => (b.submittedAt ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.submittedAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
      );
    _cachedReports = merged;
    _pendingDeletedIds = []; // nach Merge zurücksetzen
    _lastDeltaStats = DeltaStats(
      added: addedCount,
      updated: updatedCount,
      deleted: deletedCount,
    );
    // Persistiere
    if (_persistenceAvailable) {
      try {
        final isar = await _db();
        await _replaceCache(merged, isar);
        _lastCacheSync = DateTime.now();
      } catch (_) {
        _persistenceAvailable = false;
      }
    }
    return merged;
  }

  Future<List<Report>> _fullSync() async {
    final fresh = await getAllReports();
    if (_persistenceAvailable) {
      try {
        final isar = await _db();
        await _replaceCache(fresh, isar);
        _lastCacheSync = DateTime.now();
      } catch (_) {
        _persistenceAvailable = false;
      }
    }
    return fresh;
  }

  static bool needsFullSync(
    DateTime? lastFullSyncAt, {
    Duration interval = const Duration(minutes: 60),
  }) {
    if (lastFullSyncAt == null) return true;
    return DateTime.now().difference(lastFullSyncAt) >= interval;
  }

  Future<Isar> _db() async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationDocumentsDirectory();
    try {
      _isar = await Isar.open(
        [ReportCacheEntitySchema],
        directory: dir.path,
        name: 'reports',
      );
    } catch (_) {
      // Falls Codegen (Schema) noch nicht vorliegt -> leeres In-Memory (fallback)
      rethrow;
    }
    return _isar!;
  }

  /// Lädt alle Reports zunächst aus lokalem Cache (falls vorhanden) und
  /// aktualisiert anschließend aus Quelle (Fixtures / später API).
  Future<List<Report>> getAllReportsCachedFirst() async {
    if (!_persistenceAvailable) {
      // Direkt frische Daten laden (Fixtures) – kein persistenter Cache
      final fresh = await getAllReports();
      _lastOrigin = DataOrigin.freshFullSync;
      return fresh;
    }
    try {
      final isar = await _db();
      final cached = await isar
          .collection<ReportCacheEntity>()
          .where()
          .findAll();
      if (cached.isNotEmpty) {
        _cachedReports = cached.map((e) => e.toDomain()).toList();
        _lastOrigin =
            DataOrigin.cachePrimed; // initial Cache bevor frisch ersetzt
      }
      // Danach normalen Ladepfad (fixtures) verwenden und Cache aktualisieren
      final fresh = await getAllReports();
      // Prüfen ob wir sync brauchen (oder wenn Cache leer war)
      if (_lastCacheSync == null || cached.length != fresh.length) {
        await _replaceCache(fresh, isar);
        _lastCacheSync = DateTime.now();
      }
      if (cached.isEmpty) {
        // Es gab keinen Cache, also frische Daten
        _lastOrigin = DataOrigin.freshFullSync;
      }
      return _cachedReports!;
    } catch (_) {
      // Persistenter Cache nicht verfügbar -> Fallback ohne Isar
      _persistenceAvailable = false;
      final fresh = await getAllReports();
      _lastOrigin = DataOrigin.freshFullSync;
      return fresh;
    }
  }

  Future<void> _replaceCache(List<Report> reports, Isar isar) async {
    await isar.writeTxn(() async {
      await isar.collection<ReportCacheEntity>().clear();
      final entities = reports.map((r) => r.toCacheEntity()).toList();
      await isar.collection<ReportCacheEntity>().putAll(entities);
    });
  }

  /// Get all reports from fixtures and submitted reports
  Future<List<Report>> getAllReports() async {
    try {
      if (_cachedReports != null) {
        return _cachedReports!; // bereits zuvor geladen
      }

      // Load fixture reports
      final String response = await rootBundle.loadString(
        'assets/fixtures/reports.json',
      );
      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> reportsJson = data['reports'];

      _cachedReports = reportsJson
          .map((json) => Report.fromJson(json as Map<String, dynamic>))
          .toList();
      _lastOrigin = DataOrigin.freshFullSync; // frisch eingelesen

      return _cachedReports!;
    } catch (e) {
      throw AppError.storage('Fehler beim Laden der Meldungen: $e');
    }
  }

  /// Result<T>-Variante für moderne Fehlerbehandlung (Migration Pfad)
  Future<Result<List<Report>>> fetchAll() async {
    try {
      // Zuerst Cache anzeigen wenn vorhanden, dann fresh laden
      if (_cachedReports != null) {
        _refreshInBackground();
        // Herkunft hängt davon ab ob wir im Fehlerzustand nur Cache haben
        _lastOrigin = hasOnlyCache
            ? DataOrigin.cacheOnly
            : DataOrigin.cachePrimed;
        return Success(_cachedReports!);
      }
      final data = await getAllReportsCachedFirst();
      _lastOrigin = DataOrigin.freshFullSync; // frische Daten
      return Success(data);
    } catch (e, st) {
      return Error(
        unknownFailure('Fehler beim Laden der Meldungen', cause: e, st: st),
      );
    }
  }

  /// Erkennen, ob aktuell Offline (rudimentär: keine Verbindungstypen verfügbar)
  Future<bool> isCurrentlyOffline() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result.contains(ConnectivityResult.none);
    } catch (_) {
      return false; // im Zweifel nicht offline melden
    }
  }

  Future<void> _refreshInBackground() async {
    try {
      final fresh = await getAllReports();
      final isar = await _db();
      await _replaceCache(fresh, isar);
      _lastRefreshFailed = false;
      _refreshRetryCount = 0;
      _refreshRetryTimer?.cancel();
    } catch (_) {
      // Hintergrundfehler ignoriert
      _lastRefreshFailed = true;
      if (_cachedReports != null) {
        _lastOrigin = DataOrigin.cacheOnly;
      }
      _scheduleRefreshRetry();
    }
  }

  void _scheduleRefreshRetry() {
    if (_refreshRetryTimer?.isActive ?? false) return; // bereits geplant
    _refreshRetryCount = math.min(_refreshRetryCount + 1, 8); // Deckel
    final delaySeconds = math.min(
      60,
      (1 << _refreshRetryCount),
    ); // 2,4,8,... max 60
    _refreshRetryTimer = Timer(Duration(seconds: delaySeconds), () {
      _refreshInBackground();
    });
  }

  /// Submit a new report
  Future<Report> submitReport(Report report) async {
    try {
      // 1. Try API submission if Dio is available
      if (_dio != null) {
        try {
          final payload = _convertReportToWordPress(report);
          final resp = await _dio.post('/reports', data: payload);

          if (resp.statusCode == 200 || resp.statusCode == 201) {
            final data = resp.data;
            if (data is Map<String, dynamic> && data['success'] == true) {
              // API success - convert response back to Report
              final apiReport = report.copyWith(
                id: data['report_id'] ?? DateTime.now().millisecondsSinceEpoch,
                submittedAt: DateTime.now(),
                status: ReportStatus.submitted,
                referenceNumber: _generateReferenceNumber(),
              );

              // Update local cache
              _cachedReports ??= [];
              _cachedReports!.insert(0, apiReport);

              // Cache to Isar
              try {
                final isar = await _db();
                await isar.writeTxn(() async {
                  await isar.collection<ReportCacheEntity>().put(
                    apiReport.toCacheEntity(),
                  );
                });
              } catch (_) {
                // Cache errors are non-critical
              }

              return apiReport;
            }
          }
        } catch (e) {
          print('API submission failed: $e, falling back to local');
          // Fall through to local submission
        }
      }

      // 2. Fallback: Local submission (demo mode)
      final submittedReport = report.copyWith(
        id: DateTime.now().millisecondsSinceEpoch,
        submittedAt: DateTime.now(),
        status: ReportStatus.submitted,
        referenceNumber: _generateReferenceNumber(),
      );

      // Add to cache
      _cachedReports ??= [];
      _cachedReports!.insert(0, submittedReport);

      // Persist to cache optimistically
      try {
        final isar = await _db();
        await isar.writeTxn(() async {
          await isar.collection<ReportCacheEntity>().put(
            submittedReport.toCacheEntity(),
          );
        });
      } catch (_) {
        // Cache errors are ignored
      }

      return submittedReport;
    } catch (e) {
      throw AppError.network('Fehler beim Einreichen der Meldung: $e');
    }
  }

  Future<Result<Report>> submitReportResult(Report report) async {
    try {
      final r = await submitReport(report);
      return Success(r);
    } catch (e, st) {
      return Error(
        networkFailure('Fehler beim Einreichen der Meldung', cause: e, st: st),
      );
    }
  }

  /// Get reports by category
  Future<List<Report>> getReportsByCategory(ReportCategory category) async {
    final allReports = await getAllReports();
    return allReports.where((report) => report.category == category).toList();
  }

  /// Get reports by status
  Future<List<Report>> getReportsByStatus(ReportStatus status) async {
    final allReports = await getAllReports();
    return allReports.where((report) => report.status == status).toList();
  }

  /// Get reports by priority
  Future<List<Report>> getReportsByPriority(ReportPriority priority) async {
    final allReports = await getAllReports();
    return allReports.where((report) => report.priority == priority).toList();
  }

  /// Search reports by title or description
  Future<List<Report>> searchReports(String query) async {
    if (query.isEmpty) return [];

    final allReports = await getAllReports();
    final lowerQuery = query.toLowerCase();

    return allReports.where((report) {
      return report.title.toLowerCase().contains(lowerQuery) ||
          report.description.toLowerCase().contains(lowerQuery) ||
          (report.location.address?.toLowerCase().contains(lowerQuery) ??
              false);
    }).toList();
  }

  Future<Result<List<Report>>> searchReportsResult(String query) async {
    try {
      final list = await searchReports(query);
      return Success(list);
    } catch (e, st) {
      return Error(unknownFailure('Fehler bei der Suche', cause: e, st: st));
    }
  }

  /// Get report by ID
  Future<Report?> getReportById(int id) async {
    final allReports = await getAllReports();
    try {
      return allReports.firstWhere((report) => report.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get user's own reports (filtered by contact email)
  Future<List<Report>> getUserReports(String userEmail) async {
    final allReports = await getAllReports();
    return allReports
        .where(
          (report) => report.contactEmail == userEmail && !report.isAnonymous,
        )
        .toList();
  }

  /// Get reports within a geographic area
  Future<List<Report>> getReportsNearLocation({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    final allReports = await getAllReports();

    return allReports.where((report) {
      final distance = _calculateDistance(
        latitude,
        longitude,
        report.location.latitude,
        report.location.longitude,
      );
      return distance <= radiusKm;
    }).toList();
  }

  /// Filter reports by multiple criteria
  Future<List<Report>> filterReports({
    ReportCategory? category,
    ReportStatus? status,
    ReportPriority? priority,
    DateTime? fromDate,
    DateTime? toDate,
    bool? hasImages,
  }) async {
    final allReports = await getAllReports();

    return allReports.where((report) {
      if (category != null && report.category != category) {
        return false;
      }
      if (status != null && report.status != status) {
        return false;
      }
      if (priority != null && report.priority != priority) {
        return false;
      }
      if (fromDate != null &&
          report.submittedAt != null &&
          report.submittedAt!.isBefore(fromDate)) {
        return false;
      }
      if (toDate != null &&
          report.submittedAt != null &&
          report.submittedAt!.isAfter(toDate)) {
        return false;
      }
      if (hasImages != null &&
          (report.imageUrls?.isNotEmpty ?? false) != hasImages) {
        return false;
      }

      return true;
    }).toList();
  }

  Future<Result<List<Report>>> filterReportsResult({
    ReportCategory? category,
    ReportStatus? status,
    ReportPriority? priority,
    DateTime? fromDate,
    DateTime? toDate,
    bool? hasImages,
  }) async {
    try {
      final data = await filterReports(
        category: category,
        status: status,
        priority: priority,
        fromDate: fromDate,
        toDate: toDate,
        hasImages: hasImages,
      );
      return Success(data);
    } catch (e, st) {
      return Error(unknownFailure('Fehler beim Filtern', cause: e, st: st));
    }
  }

  /// Clear cache (useful for testing or refresh)
  void clearCache() {
    _cachedReports = null;
    // Persistenten Cache lassen wir bestehen
  }

  /// Generate a reference number for reports
  String _generateReferenceNumber() {
    final now = DateTime.now();
    return 'AUK-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecondsSinceEpoch.toString().substring(8)}';
  }

  /// Calculate distance between two coordinates in kilometers
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    // Vereinfachte Distanzberechnung (für Demo ausreichend)
    const double earthRadius = 6371; // km

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  /// Test-Hook um einen fehlgeschlagenen Hintergrundrefresh zu simulieren.
  /// Setzt Origin auf cacheOnly wenn bereits Cache vorhanden.
  @visibleForTesting
  void simulateRefreshFailureForTest() {
    if (_cachedReports != null) {
      _lastRefreshFailed = true;
      _lastOrigin = DataOrigin.cacheOnly;
    }
  }

  /// Test-Hook: Anwenden eines künstlichen Delta-Sets (Reports mit neueren Timestamps)
  @visibleForTesting
  List<Report> applyDeltaForTest(List<Report> deltas) {
    final current = List<Report>.from(_cachedReports ?? []);
    final byId = {for (final r in current) r.id: r};
    for (final d in deltas) {
      final existing = byId[d.id];
      if (existing == null) {
        byId[d.id] = d;
      } else {
        final existingTs = existing.updatedAt ?? existing.submittedAt;
        final deltaTs = d.updatedAt ?? d.submittedAt;
        if (deltaTs != null && existingTs != null) {
          if (deltaTs.isAfter(existingTs)) {
            byId[d.id] = d;
          }
        } else {
          byId[d.id] = d;
        }
      }
    }
    final merged = byId.values.toList()
      ..sort(
        (a, b) => (b.submittedAt ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.submittedAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
      );
    _cachedReports = merged;
    return merged;
  }

  /// Test-Hook: Entfernt angegebene IDs (simulierte deletions)
  @visibleForTesting
  List<Report> removeIdsForTest(List<int> ids) {
    if (_cachedReports == null) return [];
    _cachedReports = _cachedReports!.where((r) => !ids.contains(r.id)).toList();
    return _cachedReports!;
  }

  /// Test-Hook: Wendet ein Delta an und berechnet DeltaStats ohne fetchChangesSince.
  @visibleForTesting
  List<Report> computeDeltaStatsForTest(
    List<Report> deltas, {
    List<int> deletedIds = const [],
  }) {
    final current = List<Report>.from(_cachedReports ?? []);
    final byId = {for (final r in current) r.id: r};
    int added = 0;
    int updated = 0;
    for (final d in deltas) {
      final existing = byId[d.id];
      if (existing == null) {
        byId[d.id] = d;
        added++;
      } else {
        final existingTs = existing.updatedAt ?? existing.submittedAt;
        final deltaTs = d.updatedAt ?? d.submittedAt;
        if (deltaTs != null && existingTs != null) {
          if (deltaTs.isAfter(existingTs)) {
            byId[d.id] = d;
            updated++;
          }
        } else {
          byId[d.id] = d;
          updated++;
        }
      }
    }
    int deleted = 0;
    for (final id in deletedIds) {
      if (byId.remove(id) != null) deleted++;
    }
    final merged = byId.values.toList()
      ..sort(
        (a, b) => (b.submittedAt ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.submittedAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
      );
    _cachedReports = merged;
    _lastDeltaStats = DeltaStats(
      added: added,
      updated: updated,
      deleted: deleted,
    );
    return merged;
  }

  /// Konvertiert WordPress API Report Format zu Flutter App Format
  Report _convertWordPressReport(Map<String, dynamic> data) {
    // WordPress API Format: { id, title, description, status, category, priority, address, created_at, reporter_name }
    // Flutter App Format: Report.fromJson erwartetes Format

    return Report.fromJson({
      'id': data['id'],
      'title': data['title'] ?? '',
      'description': data['description'] ?? '',
      'category': _convertWordPressCategoryToFlutter(data['category']),
      'priority': _convertWordPressPriorityToFlutter(data['priority']),
      'status': _convertWordPressStatus(data['status']),
      'location': data['address'] != null
          ? {
              'address': data['address'],
              'latitude': data['latitude'],
              'longitude': data['longitude'],
            }
          : null,
      'reporter': {
        'name': data['reporter_name'] ?? 'Anonym',
        'email': '', // Not exposed in public API
        'isAnonymous': (data['reporter_name'] ?? '') == 'Anonym',
      },
      'submittedAt': data['created_at'],
      'updatedAt': data['updated_at'] ?? data['created_at'],
      'assignedTo': null, // Not in public API
      'attachments': <String>[], // TODO: Implement when photo upload is ready
      'comments':
          (data['comments'] as List<dynamic>?)
              ?.map(
                (c) => {
                  'id': c['id'],
                  'author': c['author_name'],
                  'message': c['message'],
                  'timestamp': c['created_at'],
                  'isFromAdmin': c['author_role'] == 'admin',
                },
              )
              .toList() ??
          <Map<String, dynamic>>[],
    });
  }

  ReportCategory _convertWordPressCategoryToFlutter(String? wpCategory) {
    // Map WordPress categories to Flutter app categories
    final Map<String, ReportCategory> categoryMap = {
      'strasse': ReportCategory.roadsTraffic,
      'beleuchtung': ReportCategory.publicLighting,
      'abfall': ReportCategory.wasteManagement,
      'vandalismus': ReportCategory.vandalism,
      'gruenflaeche': ReportCategory.parksGreenSpaces,
      'wasser': ReportCategory.waterDrainage,
      'gebaeude': ReportCategory.publicFacilities,
      'umwelt': ReportCategory.environmental,
      'barrierefreiheit': ReportCategory.accessibility,
      'sonstiges': ReportCategory.other,
    };
    return categoryMap[wpCategory] ?? ReportCategory.other;
  }

  ReportPriority _convertWordPressPriorityToFlutter(String? wpPriority) {
    // Map WordPress priority to Flutter app priority
    final Map<String, ReportPriority> priorityMap = {
      'niedrig': ReportPriority.low,
      'normal': ReportPriority.medium,
      'hoch': ReportPriority.high,
      'dringend': ReportPriority.urgent,
    };
    return priorityMap[wpPriority] ?? ReportPriority.medium;
  }

  String _convertWordPressStatus(String? wpStatus) {
    // Map WordPress status to Flutter app status
    const Map<String, String> statusMap = {
      'open': 'submitted',
      'in_progress': 'inProgress',
      'resolved': 'resolved',
      'closed': 'completed',
    };
    return statusMap[wpStatus] ?? 'submitted';
  }

  /// Konvertiert Flutter App Report zu WordPress API Format
  Map<String, dynamic> _convertReportToWordPress(Report report) {
    return {
      'title': report.title,
      'description': report.description,
      'category': _convertCategoryToWordPress(report.category),
      'priority': _convertPriorityToWordPress(report.priority),
      'address': report.location.address,
      'latitude': report.location.latitude,
      'longitude': report.location.longitude,
      'contact_name': report.contactName,
      'contact_email': report.contactEmail,
    };
  }

  String _convertCategoryToWordPress(ReportCategory category) {
    // Map Flutter app categories to WordPress categories
    final Map<ReportCategory, String> categoryMap = {
      ReportCategory.roadsTraffic: 'strasse',
      ReportCategory.publicLighting: 'beleuchtung',
      ReportCategory.wasteManagement: 'abfall',
      ReportCategory.vandalism: 'vandalismus',
      ReportCategory.parksGreenSpaces: 'gruenflaeche',
      ReportCategory.waterDrainage: 'wasser',
      ReportCategory.publicFacilities: 'gebaeude',
      ReportCategory.environmental: 'umwelt',
      ReportCategory.accessibility: 'barrierefreiheit',
      ReportCategory.other: 'sonstiges',
    };
    return categoryMap[category] ?? 'sonstiges';
  }

  String _convertPriorityToWordPress(ReportPriority priority) {
    // Map Flutter app priority to WordPress priority
    final Map<ReportPriority, String> priorityMap = {
      ReportPriority.low: 'niedrig',
      ReportPriority.medium: 'normal',
      ReportPriority.high: 'hoch',
      ReportPriority.urgent: 'dringend',
    };
    return priorityMap[priority] ?? 'normal';
  }
}
