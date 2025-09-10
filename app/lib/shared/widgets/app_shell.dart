import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/color_extensions.dart';
import '../../core/theme/theme_mode_controller.dart';
import '../../features/auth/data/permissions.dart';
import '../navigation/navigation_config.dart';
import '../widgets/app_navigation_drawer.dart';

/// Zentrale App-Shell mit einheitlicher Navigation
/// Ersetzt sowohl TouristShell als auch ResidentShell
class AppShell extends ConsumerWidget {
  final Widget child;
  final bool showBottomNav;
  final AppShellType type;

  const AppShell({
    super.key,
    required this.child,
    this.showBottomNav = true,
    this.type = AppShellType.resident,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = GoRouter.of(context);
    final location = GoRouterState.of(context).uri.toString();

    // Verbesserte Zurück-Button Logik für GoRouter
    final canGoBack = _canGoBack(location);
    final canShowCommunity = ref.watch(canAccessCommunityProvider);
    final width = MediaQuery.of(context).size.width;
    final useRail = width >= 900; // Breakpoint für Desktop / Tablet quer

    final appBar = AppBar(
      title: Text(_getPageTitle(context)),
      centerTitle: true,
      leading: canGoBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _goBack(context, goRouter, location),
              tooltip: 'Zurück',
            )
          : (!useRail
                ? Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                      tooltip: 'Menü',
                    ),
                  )
                : null),
      actions: _buildAppBarActions(context),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
    );

    if (useRail) {
      return Scaffold(
        appBar: appBar,
        body: Row(
          children: [
            _AdaptiveSideNavigation(canShowCommunity: canShowCommunity),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      drawer: const AppNavigationDrawer(),
      body: child,
      bottomNavigationBar: showBottomNav
          ? _buildBottomNav(context, canShowCommunity)
          : null,
    );
  }

  String _getPageTitle(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    // Dynamische Titel basierend auf der Route
    if (location == '/home') return 'Aukrug';
    if (location.contains('/resident/notices')) return 'Mitteilungen';
    if (location.contains('/resident/events')) return 'Veranstaltungen';
    if (location.contains('/resident/downloads')) return 'Downloads';
    if (location.contains('/resident/reports/map')) return 'Meldungen Karte';
    if (location.contains('/resident/reports')) return 'Mängelmelder';
    if (location.contains('/resident/settings')) return 'Einstellungen';
    if (location.contains('/community/feed')) return 'Community';
    if (location.contains('/community/groups')) return 'Gruppen';
    if (location.contains('/community/messages')) return 'Nachrichten';
    if (location.contains('/tourist/places')) {
      return 'Orte & Sehenswürdigkeiten';
    }
    if (location.contains('/tourist/routes')) return 'Wanderrouten';
    if (location.contains('/tourist/discover')) return 'Entdecken';
    if (location.contains('/tourist/info')) return 'Tourismus-Info';
    if (location.contains('/privacy-settings')) return 'Datenschutz';

    return 'Aukrug';
  }

  List<Widget>? _buildAppBarActions(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    // Verschiedene Actions je nach Seite
    if (location.contains('/resident/reports') && !location.contains('/map')) {
      return [
        IconButton(
          icon: const Icon(Icons.map_outlined),
          onPressed: () => context.go('/resident/reports/map'),
          tooltip: 'Kartenansicht',
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => context.go('/resident/report'),
          tooltip: 'Neue Meldung',
        ),
      ];
    }

    if (location.contains('/resident/reports/map')) {
      return [
        IconButton(
          icon: const Icon(Icons.list),
          onPressed: () => context.go('/resident/reports'),
          tooltip: 'Listenansicht',
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => context.go('/resident/report'),
          tooltip: 'Neue Meldung',
        ),
      ];
    }

    if (location.contains('/community')) {
      return [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // TODO: Community-Suche implementieren
          },
          tooltip: 'Suchen',
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => context.go('/community/notifications'),
          tooltip: 'Benachrichtigungen',
        ),
      ];
    }

    // Standard Actions für alle anderen Seiten
    return [
      IconButton(
        icon: const Icon(Icons.account_circle_outlined),
        onPressed: () => context.go('/privacy-settings'),
        tooltip: 'Profil',
      ),
    ];
  }

  Widget? _buildBottomNav(BuildContext context, bool canShowCommunity) {
    final location = GoRouterState.of(context).uri.toString();

    // Spezifische Community-Navigation nur für reine Community-Routen
    if (location.startsWith('/community/') &&
        !location.contains('/resident/')) {
      return _buildCommunityBottomNav(context);
    }

    // Resident Navigation (inkl. Community-Zugriff)
    if (location.startsWith('/resident/') ||
        location.startsWith('/community/')) {
      return _buildResidentBottomNav(context, canShowCommunity);
    }

    if (location.startsWith('/tourist/')) {
      return _buildTouristBottomNav(context);
    }

    return null;
  }

  BottomNavigationBar _buildResidentBottomNav(
    BuildContext context,
    bool canShowCommunity,
  ) {
    final location = GoRouterState.of(context).uri.toString();
    final items = buildResidentNavItems(includeCommunity: canShowCommunity);
    final currentIdx = currentIndexFor(items, location);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(
        context,
      ).colorScheme.onSurface.alphaFrac(0.6),
      currentIndex: currentIdx,
      onTap: (index) => context.go(items[index].route),
      items: [
        for (final i in items)
          BottomNavigationBarItem(
            icon: Icon(i.icon),
            activeIcon: Icon(i.activeIcon),
            label: i.label,
          ),
      ],
    );
  }

  BottomNavigationBar _buildTouristBottomNav(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final items = touristNavItems;
    final currentIdx = currentIndexFor(items, location);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(
        context,
      ).colorScheme.onSurface.alphaFrac(0.6),
      currentIndex: currentIdx,
      onTap: (index) => context.go(items[index].route),
      items: [
        for (final i in items)
          BottomNavigationBarItem(
            icon: Icon(i.icon),
            activeIcon: Icon(i.activeIcon),
            label: i.label,
          ),
      ],
    );
  }

  BottomNavigationBar _buildCommunityBottomNav(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final items = communityNavItems;
    final currentIdx = currentIndexFor(items, location);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(
        context,
      ).colorScheme.onSurface.alphaFrac(0.6),
      currentIndex: currentIdx,
      onTap: (index) => context.go(items[index].route),
      items: [
        for (final i in items)
          BottomNavigationBarItem(
            icon: Icon(i.icon),
            activeIcon: Icon(i.activeIcon),
            label: i.label,
          ),
      ],
    );
  }

  /// Bestimmt ob ein Zurück-Button angezeigt werden soll basierend auf der aktuellen Route
  bool _canGoBack(String location) {
    // Homepage, Splash und Audience Picker haben keinen Zurück-Button
    if (location == '/home' ||
        location == '/splash' ||
        location == '/consent' ||
        location == '/welcome') {
      return false;
    }

    // Shell-Hauptseiten haben keinen Zurück-Button (z.B. /tourist/discover, /resident/notices)
    final mainShellPages = [
      '/tourist/discover',
      '/resident/notices',
      '/community',
    ];

    if (mainShellPages.contains(location)) {
      return false;
    }

    // Spezielle Seiten die explizit Zurück-Buttons brauchen
    final needsBackButton = [
      '/resident/reports',
      '/resident/reports/map',
      '/resident/report',
      '/resident/downloads',
      '/resident/events',
      '/resident/settings',
      '/tourist/info',
      '/tourist/routes',
      '/privacy-settings',
    ];

    if (needsBackButton.any((page) => location.startsWith(page))) {
      return true;
    }

    // Alle anderen Seiten haben einen Zurück-Button
    return true;
  }

  /// Intelligente Zurück-Navigation für GoRouter
  void _goBack(
    BuildContext context,
    GoRouter goRouter,
    String currentLocation,
  ) {
    // Versuche zuerst Navigator.pop() für modale Dialoge etc.
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    // GoRouter-basierte Zurück-Navigation
    if (goRouter.canPop()) {
      goRouter.pop();
      return;
    }

    // Fallback: Gehe zu einer sinnvollen Hauptseite basierend auf der aktuellen Route
    if (currentLocation.startsWith('/tourist/')) {
      goRouter.go('/tourist/discover');
    } else if (currentLocation.startsWith('/resident/')) {
      goRouter.go('/resident/notices');
    } else if (currentLocation.startsWith('/community/')) {
      goRouter.go('/community');
    } else {
      // Standard-Fallback zur Homepage
      goRouter.go('/home');
    }
  }

  // Legacy Index & Tap-Methoden entfernt – zentrale NavigationConfig übernimmt.
}

enum AppShellType { resident, tourist, community }

class _AdaptiveSideNavigation extends ConsumerWidget {
  final bool canShowCommunity;
  const _AdaptiveSideNavigation({required this.canShowCommunity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    // Ermitteln welches Set von Navigation Items gilt
    late final List<NavItem> items;
    if (location.startsWith('/community/') &&
        !location.contains('/resident/')) {
      items = communityNavItems;
    } else if (location.startsWith('/tourist/')) {
      items = touristNavItems;
    } else {
      items = buildResidentNavItems(includeCommunity: canShowCommunity);
    }

    final currentIdx = currentIndexFor(items, location);
    final themeMode = ref.watch(themeModeProvider);
    final themeController = ref.read(themeModeProvider.notifier);

    return NavigationRail(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: null,
      labelType: NavigationRailLabelType.all,
      selectedIndex: currentIdx,
      groupAlignment: -1.0,
      onDestinationSelected: (i) => context.go(items[i].route),
      leading: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: _AppLogoCondensed(),
      ),
      trailing: _RailTrailing(
        themeMode: themeMode,
        onToggle: () {
          // Zyklischer Wechsel System -> Hell -> Dunkel -> System
          final next = switch (themeMode) {
            ThemeMode.system => ThemeMode.light,
            ThemeMode.light => ThemeMode.dark,
            ThemeMode.dark => ThemeMode.system,
          };
          themeController.setMode(next);
        },
      ),
      destinations: [
        for (final i in items)
          NavigationRailDestination(
            icon: Icon(i.icon),
            selectedIcon: Icon(i.activeIcon),
            label: Text(i.label),
          ),
      ],
    );
  }
}

class _RailTrailing extends StatelessWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggle;
  const _RailTrailing({required this.themeMode, required this.onToggle});
  IconData get _icon => switch (themeMode) {
    ThemeMode.system => Icons.auto_mode_rounded,
    ThemeMode.light => Icons.light_mode,
    ThemeMode.dark => Icons.dark_mode,
  };
  String get _tooltip =>
      'Theme: ${switch (themeMode) {
        ThemeMode.system => 'System',
        ThemeMode.light => 'Hell',
        ThemeMode.dark => 'Dunkel',
      }} (klicken zum Wechsel)';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          IconButton(tooltip: _tooltip, onPressed: onToggle, icon: Icon(_icon)),
        ],
      ),
    );
  }
}

class _AppLogoCondensed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'A',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: scheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
