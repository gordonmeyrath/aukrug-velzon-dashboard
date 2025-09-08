import 'package:aukrug_app/features/reports/presentation/reports_unified_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReportsUnifiedPage Widget Tests', () {
    testWidgets('should display reports page title', (
      WidgetTester tester,
    ) async {
      // Given
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ReportsUnifiedPage())),
      );

      // When
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Berichte'), findsOneWidget);
    });

    testWidgets('should show FAB for creating new report', (
      WidgetTester tester,
    ) async {
      // Given
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ReportsUnifiedPage())),
      );

      // When
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should display loading indicator initially', (
      WidgetTester tester,
    ) async {
      // Given
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ReportsUnifiedPage())),
      );

      // When - pump once to build but don't settle
      await tester.pump();

      // Then
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should have proper navigation structure', (
      WidgetTester tester,
    ) async {
      // Given
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ReportsUnifiedPage())),
      );

      // When
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });

  group('ReportsUnifiedPage Integration Tests', () {
    testWidgets('should handle empty state gracefully', (
      WidgetTester tester,
    ) async {
      // Given
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ReportsUnifiedPage())),
      );

      // When
      await tester.pumpAndSettle();

      // Then - App should not crash with empty state
      expect(find.byType(ReportsUnifiedPage), findsOneWidget);
    });

    testWidgets('should maintain state during rebuilds', (
      WidgetTester tester,
    ) async {
      // Given
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ReportsUnifiedPage())),
      );

      // When
      await tester.pumpAndSettle();

      // Trigger rebuild
      await tester.pump();

      // Then
      expect(find.byType(ReportsUnifiedPage), findsOneWidget);
    });
  });
}
