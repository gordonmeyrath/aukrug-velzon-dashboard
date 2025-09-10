import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/config/feature_flags.dart';
import '../features/auth/presentation/consent_page.dart';
import '../features/auth/presentation/email_auth_page.dart';
import '../features/auth/presentation/privacy_settings_page.dart';
import '../features/auth/presentation/welcome_page.dart';
import '../features/documents/presentation/downloads_center_page.dart';
import '../features/events/presentation/events_list_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/map/presentation/pages/reports_map_page.dart';
import '../features/notices/presentation/notices_list_page.dart';
import '../features/places/presentation/places_list_page.dart';
import '../features/reports/presentation/report_issue_page.dart';
import '../features/reports/presentation/reports_unified_page.dart';
import '../features/resident/presentation/settings_page.dart';
import '../features/shell/presentation/audience_picker_page.dart';
import '../features/tourist/presentation/discover_page.dart';
import '../features/tourist/presentation/info_page.dart';
import '../features/tourist/presentation/routes_page.dart';
import '../shared/widgets/app_shell.dart';

// Community guards temporarily disabled
// import 'guards/community_guard.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  // Ensure feature flags loaded early (fire & forget)
  featureFlags.init();
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) async {
      // Community redirects are now enabled with FEATURE_FEED
      return null;
    },
    routes: [
      // Splash / Audience Picker
      GoRoute(
        path: '/splash',
        builder: (context, state) => const AudiencePickerPage(),
      ),

      // Welcome Page (DSGVO-konform)
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomePage(),
      ),

      // Hauptmenü/Homepage - auch mit AppShell
      GoRoute(
        path: '/home',
        builder: (context, state) =>
            const AppShell(showBottomNav: false, child: HomePage()),
      ),

      // Authentication Routes
      GoRoute(
        path: '/auth/email',
        builder: (context, state) => const EmailAuthPage(),
      ),

      // Consent Page
      GoRoute(
        path: '/consent',
        builder: (context, state) => const ConsentPage(),
      ),

      // Privacy Settings
      GoRoute(
        path: '/privacy-settings',
        builder: (context, state) => const PrivacySettingsPage(),
      ),

      // Production Reports
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsUnifiedPage(),
      ),

      // Tourist Shell
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(type: AppShellType.tourist, child: child),
        routes: [
          GoRoute(
            path: '/tourist/discover',
            builder: (context, state) => const DiscoverPage(),
          ),
          GoRoute(
            path: '/tourist/routes',
            builder: (context, state) => const RoutesPage(),
          ),
          GoRoute(
            path: '/tourist/events',
            builder: (context, state) => const EventsListPage(),
          ),
          GoRoute(
            path: '/tourist/places',
            builder: (context, state) => const PlacesListPage(),
          ),
          GoRoute(
            path: '/tourist/info',
            builder: (context, state) => const InfoPage(),
          ),
        ],
      ),

      // Resident Shell
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(type: AppShellType.resident, child: child),
        routes: [
          GoRoute(
            path: '/resident/notices',
            builder: (context, state) => const NoticesListPage(),
          ),
          GoRoute(
            path: '/resident/events',
            builder: (context, state) => const EventsListPage(),
          ),
          GoRoute(
            path: '/resident/downloads',
            builder: (context, state) => const DownloadsCenterPage(),
          ),
          GoRoute(
            path: '/resident/reports',
            builder: (context, state) => const ReportsUnifiedPage(),
          ),
          GoRoute(
            path: '/resident/reports/map',
            builder: (context, state) => const ReportsMapPage(),
          ),
          GoRoute(
            path: '/resident/report',
            builder: (context, state) => const ReportIssuePage(),
          ),
          GoRoute(
            path: '/resident/settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),

      // Community Shell (accessible at root level for deep links)
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(type: AppShellType.community, child: child),
        routes: [
          GoRoute(
            path: '/community',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Community-Features werden entwickelt')),
            ),
          ),
        ],
      ),
    ],
  );
}

// Placeholder pages - will be implemented in their respective features
// DiscoverPage, RoutesPage and InfoPage now implemented in features/tourist/presentation/

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Events')));
}

class PlacesPage extends StatelessWidget {
  const PlacesPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Places')));
}

// InfoPage now implemented in features/tourist/presentation/info_page.dart
// NoticesPage now implemented in features/resident/presentation/notices_page.dart
// SettingsPage now implemented in features/resident/presentation/settings_page.dart

class ResidentEventsPage extends StatelessWidget {
  const ResidentEventsPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Resident Events')));
}

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Downloads')));
}

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Report')));
}
