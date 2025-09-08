import 'package:aukrug_app/features/reports/data/reports_repository.dart';
import 'package:aukrug_app/features/reports/domain/report.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ReportsRepository', () {
    late ReportsRepository repo;

    setUp(() {
      repo = ReportsRepository();
    });

    test('initial fetchAll returns data (fresh path)', () async {
      final res = await repo.fetchAll();
      expect(res.isSuccess, true);
      res.when(
        success: (list) {
          expect(list, isNotEmpty);
          // Nach erstem Laden sollte servedCache false sein (fresh)
          expect(repo.servedCache, false);
        },
        failure: (_) => fail('Should succeed'),
      );
    });

    test('second fetchAll serves cache (servedCache true)', () async {
      await repo.fetchAll();
      final res2 = await repo.fetchAll();
      expect(res2.isSuccess, true);
      expect(repo.servedCache, true);
    });

    test('needsFullSync logic', () {
      expect(ReportsRepository.needsFullSync(null), true);
      final now = DateTime.now();
      expect(
        ReportsRepository.needsFullSync(
          now.subtract(const Duration(minutes: 30)),
        ),
        false,
      );
      expect(
        ReportsRepository.needsFullSync(
          now.subtract(const Duration(minutes: 61)),
        ),
        true,
      );
    });

    test('simulateRefreshFailureForTest sets origin to cacheOnly', () async {
      // Initial laden -> fresh
      await repo.fetchAll();
      expect(repo.lastOrigin, DataOrigin.freshFullSync);
      // Zweites Laden -> cachePrimed
      await repo.fetchAll();
      expect(repo.lastOrigin, DataOrigin.cachePrimed);
      // Failure simulieren
      repo.simulateRefreshFailureForTest();
      expect(repo.lastOrigin, DataOrigin.cacheOnly);
    });

    test('delta fixture merges updates and new items', () async {
      // Initial full load
      await repo.fetchAll();
      final initial = repo.lastOrigin;
      expect(initial, isNotNull);
      final list1 = await repo.fetchAll();
      expect(list1.isSuccess, true);
      final beforeCount = list1.dataOrNull!.length;
      // Erzeuge künstliche Deltas
      final updated = repo.applyDeltaForTest([
        // Update bestehender Report ID 2 (Status ändern + neuer updatedAt)
        Report(
          id: 2,
          title: 'Defekte Straßenlaterne (Update)',
          description: 'Laterne repariert',
          category: ReportCategory.publicLighting,
          priority: ReportPriority.medium,
          status: ReportStatus.resolved,
          location: const ReportLocation(latitude: 0, longitude: 0),
          submittedAt: DateTime.utc(2025, 8, 25, 18, 45),
          updatedAt: DateTime.utc(2025, 9, 6, 7, 30),
        ),
        // Neuer Report ID 999
        Report(
          id: 999,
          title: 'Neuer Eintrag',
          description: 'Frischer Report',
          category: ReportCategory.other,
          priority: ReportPriority.high,
          status: ReportStatus.submitted,
          location: const ReportLocation(latitude: 0, longitude: 0),
          submittedAt: DateTime.utc(2025, 9, 6, 8, 0),
          updatedAt: DateTime.utc(2025, 9, 6, 8, 0),
        ),
      ]);
      // Sollte mind. ein Element hinzufügen (ID 11) und eins updaten (ID 2)
      expect(updated.any((r) => r.id == 999), true);
      final updated2 = updated.firstWhere((r) => r.id == 2);
      expect(updated2.status, ReportStatus.resolved);
      expect(updated.length >= beforeCount + 1, true);
    });

    test('removeIdsForTest deletes items from cache', () async {
      await repo.fetchAll();
      final res = await repo.fetchAll();
      final before = res.dataOrNull!.length;
      // Wähle zwei existierende IDs (1 und 2)
      final afterList = repo.removeIdsForTest([1, 2]);
      expect(afterList.any((r) => r.id == 1), false);
      expect(afterList.any((r) => r.id == 2), false);
      expect(afterList.length, before - 2);
    });

    test('DeltaStats werden nach Delta Sync befüllt', () async {
      final repo = ReportsRepository();
      final base = await repo.getAllReports();
      expect(base.isNotEmpty, true);
      // Konstruiere künstliche Delta Reports
      final updated = base.first.copyWith(
        title: '${base.first.title} (Delta)',
        updatedAt: DateTime.now().add(const Duration(minutes: 1)),
      );
      final newReport = updated.copyWith(
        id: 99999,
        title: 'Ganz neu',
        submittedAt: DateTime.now().add(const Duration(minutes: 2)),
        updatedAt: DateTime.now().add(const Duration(minutes: 2)),
      );
      final merged = repo.computeDeltaStatsForTest(
        [updated, newReport],
        deletedIds: [base[1].id],
      );
      expect(merged.any((r) => r.id == newReport.id), true);
      final stats = repo.lastDeltaStats;
      expect(stats.added, 1);
      expect(stats.updated, 1);
      expect(stats.deleted, 1);
    });

    test(
      'Version-basierte Konfliktauflösung bevorzugt höhere Versionen',
      () async {
        final repo = ReportsRepository();
        await repo.getAllReports();
        final baseReport = Report(
          id: 1,
          title: 'Original',
          description: 'Original Beschreibung',
          category: ReportCategory.other,
          priority: ReportPriority.low,
          status: ReportStatus.submitted,
          location: const ReportLocation(latitude: 0, longitude: 0),
          submittedAt: DateTime.utc(2025, 9, 1),
          version: 1,
        );
        final higherVersionDelta = baseReport.copyWith(
          title: 'Höhere Version',
          version: 2,
          updatedAt: DateTime.utc(2025, 9, 1), // gleicher Timestamp
        );
        final merged = repo.computeDeltaStatsForTest([higherVersionDelta]);
        final result = merged.firstWhere((r) => r.id == 1);
        expect(result.title, 'Höhere Version');
        expect(result.version, 2);
      },
    );
  });
}
