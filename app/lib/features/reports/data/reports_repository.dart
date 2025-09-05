import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_error.dart';
import '../domain/report.dart';

part 'reports_repository.g.dart';

@riverpod
ReportsRepository reportsRepository(ReportsRepositoryRef ref) {
  return ReportsRepository();
}

/// Repository for managing municipal issue reports (Mängelmelder)
class ReportsRepository {
  List<Report>? _cachedReports;

  /// Get all reports from fixtures and submitted reports
  Future<List<Report>> getAllReports() async {
    try {
      if (_cachedReports != null) {
        return _cachedReports!;
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

      return _cachedReports!;
    } catch (e) {
      throw AppError.storage('Fehler beim Laden der Meldungen: $e');
    }
  }

  /// Submit a new report
  Future<Report> submitReport(Report report) async {
    try {
      // In einer echten App würde hier die API-Anfrage stattfinden
      // Für die Demo fügen wir den Report lokal hinzu

      final submittedReport = report.copyWith(
        id: DateTime.now().millisecondsSinceEpoch,
        submittedAt: DateTime.now(),
        status: ReportStatus.submitted,
        referenceNumber: _generateReferenceNumber(),
      );

      // Füge zu Cache hinzu
      _cachedReports ??= [];
      _cachedReports!.insert(0, submittedReport);

      return submittedReport;
    } catch (e) {
      throw AppError.network('Fehler beim Einreichen der Meldung: $e');
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
      if (category != null && report.category != category) return false;
      if (status != null && report.status != status) return false;
      if (priority != null && report.priority != priority) return false;
      if (fromDate != null &&
          report.submittedAt != null &&
          report.submittedAt!.isBefore(fromDate))
        return false;
      if (toDate != null &&
          report.submittedAt != null &&
          report.submittedAt!.isAfter(toDate))
        return false;
      if (hasImages != null &&
          (report.imageUrls?.isNotEmpty ?? false) != hasImages)
        return false;

      return true;
    }).toList();
  }

  /// Clear cache (useful for testing or refresh)
  void clearCache() {
    _cachedReports = null;
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
}
