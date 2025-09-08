import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/demo_content_service.dart';

/// Central app scaffold with:
/// - AppBar (auto back button if canPop, else burger menu)
/// - Side drawer with primary navigation
/// - Optional Demo banner/status
class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Widget? floatingActionButton;
  final bool showDemoStatus;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.bottom,
    this.floatingActionButton,
    this.showDemoStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final theme = Theme.of(context);

    final scaffold = Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        bottom: bottom,
        leading: canPop
            ? const BackButton()
            : Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                  tooltip: 'Menü',
                ),
              ),
        actions: actions,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          if (showDemoStatus) const DemoStatusWidget(),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );

    // Always show DEMO banner in simulator/testing
    return DemoBanner(child: scaffold);
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).uri.toString();

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.secondaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Aukrug',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            _navItem(
              context,
              icon: Icons.home_rounded,
              label: 'Start',
              selected: location == '/home',
              onTap: () => context.go('/home'),
            ),

            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text('Bürger', style: theme.textTheme.labelLarge),
            ),
            _navItem(
              context,
              icon: Icons.notifications,
              label: 'Mitteilungen',
              selected: location.contains('/resident/notices'),
              onTap: () => context.go('/resident/notices'),
            ),
            _navItem(
              context,
              icon: Icons.event,
              label: 'Events',
              selected: location.contains('/resident/events'),
              onTap: () => context.go('/resident/events'),
            ),
            _navItem(
              context,
              icon: Icons.download,
              label: 'Downloads',
              selected: location.contains('/resident/downloads'),
              onTap: () => context.go('/resident/downloads'),
            ),
            _navItem(
              context,
              icon: Icons.report_problem,
              label: 'Meldungen',
              selected:
                  location.contains('/resident/reports') ||
                  location.contains('/resident/report'),
              onTap: () => context.go('/resident/reports'),
            ),
            _navItem(
              context,
              icon: Icons.map,
              label: 'Meldungen Karte',
              selected: location.contains('/resident/reports/map'),
              onTap: () => context.go('/resident/reports/map'),
            ),

            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text('Einstellungen', style: theme.textTheme.labelLarge),
            ),
            _navItem(
              context,
              icon: Icons.settings,
              label: 'App-Einstellungen',
              selected: location.contains('/resident/settings'),
              onTap: () => context.go('/resident/settings'),
            ),
            _navItem(
              context,
              icon: Icons.privacy_tip,
              label: 'Datenschutz',
              selected: location.contains('/privacy-settings'),
              onTap: () => context.go('/privacy-settings'),
            ),

            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text('Demo', style: theme.textTheme.labelLarge),
            ),
            _navItem(
              context,
              icon: Icons.list_alt,
              label: 'Demo-Meldungen',
              selected: location == '/reports',
              onTap: () => context.go('/reports'),
            ),
            _navItem(
              context,
              icon: Icons.person,
              label: 'Anmelden',
              selected: location.contains('/auth/email'),
              onTap: () => context.go('/auth/email'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? theme.colorScheme.primary : theme.iconTheme.color,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? theme.colorScheme.primary : null,
          fontWeight: selected ? FontWeight.bold : null,
        ),
      ),
      selected: selected,
      onTap: () {
        Navigator.of(context).maybePop(); // close any pushed route like dialogs
        Navigator.of(context).pop(); // close the drawer
        onTap();
      },
    );
  }
}
