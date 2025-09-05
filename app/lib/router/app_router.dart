import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/consent_page.dart';
import '../features/events/presentation/events_list_page.dart';
import '../features/map/presentation/pages/reports_map_page.dart';
import '../features/notices/presentation/notices_list_page.dart';
import '../features/places/presentation/places_list_page.dart';
import '../features/reports/presentation/report_issue_page.dart';
import '../features/reports/presentation/reports_list_page.dart';
import '../features/shell/presentation/audience_picker_page.dart';
import '../features/shell/presentation/resident_shell.dart';
import '../features/shell/presentation/tourist_shell.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash / Audience Picker
      GoRoute(
        path: '/splash',
        builder: (context, state) => const AudiencePickerPage(),
      ),

      // Consent Page
      GoRoute(
        path: '/consent',
        builder: (context, state) => const ConsentPage(),
      ),

      // Tourist Shell
      ShellRoute(
        builder: (context, state, child) => TouristShell(child: child),
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
        builder: (context, state, child) => ResidentShell(child: child),
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
            builder: (context, state) => const DownloadsPage(),
          ),
          GoRoute(
            path: '/resident/reports',
            builder: (context, state) => const ReportsListPage(),
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
    ],
  );
}

// Placeholder pages - will be implemented in their respective features
class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Discover')));
}

class RoutesPage extends StatelessWidget {
  const RoutesPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Routes')));
}

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

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Info')));
}

class NoticesPage extends StatelessWidget {
  const NoticesPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Notices')));
}

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

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Settings')));
}
