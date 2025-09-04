import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/reports_repository.dart';
import '../domain/report.dart';

part 'reports_provider.g.dart';

@riverpod
Future<List<Report>> allReports(AllReportsRef ref) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return repository.getAllReports();
}

@riverpod
Future<List<Report>> reportsByCategory(
  ReportsByCategoryRef ref,
  ReportCategory category,
) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return repository.getReportsByCategory(category);
}

@riverpod
Future<List<Report>> reportsByStatus(
  ReportsByStatusRef ref,
  ReportStatus status,
) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return repository.getReportsByStatus(status);
}

@riverpod
Future<List<Report>> reportsByPriority(
  ReportsByPriorityRef ref,
  ReportPriority priority,
) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return repository.getReportsByPriority(priority);
}

@riverpod
class ReportsSearch extends _$ReportsSearch {
  @override
  Future<List<Report>> build() async {
    return [];
  }

  Future<void> search(String query, {
    ReportCategory? category,
    ReportStatus? status,
  }) async {
    if (query.isEmpty && category == null && status == null) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final repository = ref.read(reportsRepositoryProvider);
      List<Report> results;
      
      if (query.isNotEmpty) {
        results = await repository.searchReports(query);
      } else {
        results = await repository.getAllReports();
      }
      
      // Apply additional filters
      if (category != null) {
        results = results.where((report) => report.category == category).toList();
      }
      
      if (status != null) {
        results = results.where((report) => report.status == status).toList();
      }
      
      state = AsyncValue.data(results);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

@riverpod
class ReportSubmission extends _$ReportSubmission {
  @override
  AsyncValue<Report?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> submitReport(Report report) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(reportsRepositoryProvider);
      final submittedReport = await repository.submitReport(report);
      
      // Invalidate all reports to refresh the list
      ref.invalidate(allReportsProvider);
      
      state = AsyncValue.data(submittedReport);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

@riverpod
Future<List<Report>> nearbyReports(
  NearbyReportsRef ref, {
  required double latitude,
  required double longitude,
  required double radiusKm,
}) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return repository.getReportsNearLocation(
    latitude: latitude,
    longitude: longitude,
    radiusKm: radiusKm,
  );
}

@riverpod
Future<List<Report>> filteredReports(
  FilteredReportsRef ref, {
  ReportCategory? category,
  ReportStatus? status,
  ReportPriority? priority,
  DateTime? fromDate,
  DateTime? toDate,
  bool? hasImages,
}) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return repository.filterReports(
    category: category,
    status: status,
    priority: priority,
    fromDate: fromDate,
    toDate: toDate,
    hasImages: hasImages,
  );
}
