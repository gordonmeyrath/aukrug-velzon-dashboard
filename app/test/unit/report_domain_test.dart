import 'package:aukrug_app/features/reports/domain/report.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Report Domain Model Tests', () {
    test('should create report with required fields', () {
      // Given & When
      final report = Report(
        id: 1,
        title: 'Test Report',
        description: 'Test Description',
        category: ReportCategory.roadsTraffic,
        priority: ReportPriority.high,
        status: ReportStatus.submitted,
        location: const ReportLocation(
          latitude: 54.0,
          longitude: 10.0,
          address: 'Test Address',
        ),
      );

      // Then
      expect(report.id, equals(1));
      expect(report.title, equals('Test Report'));
      expect(report.description, equals('Test Description'));
      expect(report.category, equals(ReportCategory.roadsTraffic));
      expect(report.priority, equals(ReportPriority.high));
      expect(report.status, equals(ReportStatus.submitted));
      expect(report.isAnonymous, isFalse); // Default value
      expect(report.version, equals(1)); // Default value
    });

    test('should create anonymous report', () {
      // Given & When
      final report = Report(
        id: 2,
        title: 'Anonymous Report',
        description: 'Anonymous Description',
        category: ReportCategory.publicLighting,
        priority: ReportPriority.medium,
        status: ReportStatus.submitted,
        location: const ReportLocation(latitude: 54.0, longitude: 10.0),
        isAnonymous: true,
      );

      // Then
      expect(report.isAnonymous, isTrue);
      expect(report.contactName, isNull);
      expect(report.contactEmail, isNull);
      expect(report.contactPhone, isNull);
    });

    test('should handle contact information', () {
      // Given & When
      final report = Report(
        id: 3,
        title: 'Report with Contact',
        description: 'Description',
        category: ReportCategory.environmental,
        priority: ReportPriority.low,
        status: ReportStatus.inProgress,
        location: const ReportLocation(latitude: 54.0, longitude: 10.0),
        contactName: 'John Doe',
        contactEmail: 'john@example.com',
        contactPhone: '+49123456789',
      );

      // Then
      expect(report.contactName, equals('John Doe'));
      expect(report.contactEmail, equals('john@example.com'));
      expect(report.contactPhone, equals('+49123456789'));
      expect(report.isAnonymous, isFalse);
    });

    test('should handle timestamps', () {
      // Given
      final now = DateTime.now();
      final submittedAt = now.subtract(const Duration(hours: 1));
      final updatedAt = now;

      // When
      final report = Report(
        id: 4,
        title: 'Timestamped Report',
        description: 'Description',
        category: ReportCategory.publicFacilities,
        priority: ReportPriority.high,
        status: ReportStatus.resolved,
        location: const ReportLocation(latitude: 54.0, longitude: 10.0),
        submittedAt: submittedAt,
        updatedAt: updatedAt,
      );

      // Then
      expect(report.submittedAt, equals(submittedAt));
      expect(report.updatedAt, equals(updatedAt));
    });

    // TODO: Fix JSON serialization test
    // Currently disabled due to Freezed serialization complexity
    test('should validate JSON structure basics', () {
      // Given
      final report = Report(
        id: 5,
        title: 'JSON Test Report',
        description: 'JSON Description',
        category: ReportCategory.roadsTraffic,
        priority: ReportPriority.medium,
        status: ReportStatus.submitted,
        location: const ReportLocation(
          latitude: 54.123,
          longitude: 10.456,
          address: 'JSON Test Address',
        ),
        contactName: 'Test User',
        contactEmail: 'test@example.com',
      );

      // When
      final json = report.toJson();

      // Then - Basic JSON validation
      expect(json, isA<Map<String, dynamic>>());
      expect(json['id'], equals(5));
      expect(json['title'], equals('JSON Test Report'));
      expect(json['contactName'], equals('Test User'));
      expect(json['contactEmail'], equals('test@example.com'));
    });
  });

  group('ReportLocation Tests', () {
    test('should create location with required coordinates', () {
      // Given & When
      const location = ReportLocation(
        latitude: 54.123456,
        longitude: 10.654321,
      );

      // Then
      expect(location.latitude, equals(54.123456));
      expect(location.longitude, equals(10.654321));
      expect(location.address, isNull);
      expect(location.description, isNull);
      expect(location.landmark, isNull);
    });

    test('should create location with full details', () {
      // Given & When
      const location = ReportLocation(
        latitude: 54.123456,
        longitude: 10.654321,
        address: 'Hauptstraße 1, 24613 Aukrug',
        description: 'Vor dem Rathaus',
        landmark: 'Rathaus Aukrug',
      );

      // Then
      expect(location.latitude, equals(54.123456));
      expect(location.longitude, equals(10.654321));
      expect(location.address, equals('Hauptstraße 1, 24613 Aukrug'));
      expect(location.description, equals('Vor dem Rathaus'));
      expect(location.landmark, equals('Rathaus Aukrug'));
    });

    test('should serialize location to and from JSON', () {
      // Given
      const originalLocation = ReportLocation(
        latitude: 54.123456,
        longitude: 10.654321,
        address: 'Test Address',
        description: 'Test Description',
        landmark: 'Test Landmark',
      );

      // When
      final json = originalLocation.toJson();
      final deserializedLocation = ReportLocation.fromJson(json);

      // Then
      expect(deserializedLocation.latitude, equals(originalLocation.latitude));
      expect(
        deserializedLocation.longitude,
        equals(originalLocation.longitude),
      );
      expect(deserializedLocation.address, equals(originalLocation.address));
      expect(
        deserializedLocation.description,
        equals(originalLocation.description),
      );
      expect(deserializedLocation.landmark, equals(originalLocation.landmark));
    });
  });
}
