import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Production-ready central app scaffold with:
/// - Consistent AppBar with proper navigation
/// - Material Design 3 styling
/// - No demo overlays or testing artifacts
class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final bool extendBodyBehindAppBar;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.drawer,
    this.floatingActionButton,
    this.actions,
    this.extendBodyBehindAppBar = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = GoRouter.of(context).canPop();

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: AppBar(
        title: Text(title),
        actions: actions,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: canPop
            ? null // Let system handle back button automatically
            : drawer != null
                ? Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                    ),
                  )
                : null,
      ),
      drawer: drawer,
      body: SafeArea(
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

/// Production navigation drawer
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
            
            // Tourist Section
            _sectionHeader(context, 'Für Besucher'),
            _navItem(
              context,
              icon: Icons.event,
              label: 'Veranstaltungen',
              selected: location.startsWith('/events'),
              onTap: () => context.go('/events'),
            ),
            _navItem(
              context,
              icon: Icons.place,
              label: 'Sehenswürdigkeiten',
              selected: location.startsWith('/places'),
              onTap: () => context.go('/places'),
            ),
            _navItem(
              context,
              icon: Icons.route,
              label: 'Wanderwege',
              selected: location.startsWith('/routes'),
              onTap: () => context.go('/routes'),
            ),
            
            const Divider(),
            
            // Residents Section
            _sectionHeader(context, 'Für Einwohner'),
            _navItem(
              context,
              icon: Icons.announcement,
              label: 'Mitteilungen',
              selected: location.startsWith('/notices'),
              onTap: () => context.go('/notices'),
            ),
            _navItem(
              context,
              icon: Icons.download,
              label: 'Downloads',
              selected: location.startsWith('/downloads'),
              onTap: () => context.go('/downloads'),
            ),
            _navItem(
              context,
              icon: Icons.report_problem,
              label: 'Meldungen',
              selected: location.startsWith('/reports'),
              onTap: () => context.go('/reports'),
            ),
            _navItem(
              context,
              icon: Icons.people,
              label: 'Community',
              selected: location.startsWith('/community'),
              onTap: () => context.go('/community'),
            ),
            
            const Divider(),
            
            _navItem(
              context,
              icon: Icons.settings,
              label: 'Einstellungen',
              selected: location.startsWith('/settings'),
              onTap: () => context.go('/settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
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
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: selected,
      onTap: () {
        Navigator.pop(context); // Close drawer
        onTap();
      },
    );
  }
}
