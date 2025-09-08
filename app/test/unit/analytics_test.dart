import 'package:aukrug_app/core/analytics/intelligent_report_analytics.dart';
import 'package:aukrug_app/features/reports/domain/report.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mocks with: flutter packages pub run build_runner build
@GenerateMocks([])
import 'analytics_test.mocks.dart';

void main() {
  group('IntelligentReportAnalytics Tests', () {
    late IntelligentReportAnalytics analytics;

    setUp(() {
      analytics = IntelligentReportAnalytics();
    });

    test('should handle empty reports list', () async {
      // Given
      final emptyReports = <Report>[];

      // When
      final result = await analytics.analyzeReports(emptyReports);

      // Then
      expect(result.totalReports, equals(0));
      expect(result.resolvedReports, equals(0));
      expect(result.resolutionRate, equals(0.0));
      expect(result.categoryDistribution, isEmpty);
      expect(result.priorityDistribution, isEmpty);
      expect(result.mostCommonCategory, equals('Keine Berichte'));
    });

    test('should calculate basic statistics correctly', () async {
      // Given
      final reports = [
        Report(
          id: 1,
          title: 'Test Report 1',
          description: 'Description 1',
          category: ReportCategory.roadsTraffic,
          priority: ReportPriority.high,
          status: ReportStatus.resolved,
          location: const ReportLocation(
            latitude: 54.0,
            longitude: 10.0,
            address: 'Test Address',
          ),
        ),
        Report(
          id: 2,
          title: 'Test Report 2',
          description: 'Description 2',
          category: ReportCategory.roadsTraffic,
          priority: ReportPriority.medium,
          status: ReportStatus.inProgress,
          location: const ReportLocation(
            latitude: 54.1,
            longitude: 10.1,
            address: 'Test Address 2',
          ),
        ),
      ];

      // When
      final result = await analytics.analyzeReports(reports);

      // Then
      expect(result.totalReports, equals(2));
      expect(result.resolvedReports, equals(1));
      expect(result.resolutionRate, equals(0.5));
      expect(
        result.categoryDistribution[ReportCategory.roadsTraffic],
        equals(2),
      );
      expect(result.priorityDistribution[ReportPriority.high], equals(1));
      expect(result.priorityDistribution[ReportPriority.medium], equals(1));
    });

    test('should generate meaningful insights', () async {
      // Given
      final reports = [
        Report(
          id: 1,
          title: 'Test Report',
          description: 'Description',
          category: ReportCategory.roadsTraffic,
          priority: ReportPriority.high,
          status: ReportStatus.resolved,
          location: const ReportLocation(latitude: 54.0, longitude: 10.0),
        ),
      ];

      // When
      final analyticsResult = await analytics.analyzeReports(reports);
      final insights = analytics.generateInsights(analyticsResult);

      // Then
      expect(insights, isNotEmpty);
      expect(insights.first, contains('Gesamt 1 Berichte'));
    });

    test('should handle high resolution rate', () async {
      // Given
      final reports = List.generate(
        10,
        (index) => Report(
          id: index,
          title: 'Test Report $index',
          description: 'Description $index',
          category: ReportCategory.roadsTraffic,
          priority: ReportPriority.medium,
          status: ReportStatus.resolved, // All resolved
          location: const ReportLocation(latitude: 54.0, longitude: 10.0),
        ),
      );

      // When
      final analyticsResult = await analytics.analyzeReports(reports);
      final insights = analytics.generateInsights(analyticsResult);

      // Then
      expect(analyticsResult.resolutionRate, equals(1.0));
      expect(
        insights.any((insight) => insight.contains('Hohe Bearbeitungsrate')),
        isTrue,
      );
    });
  });
}
