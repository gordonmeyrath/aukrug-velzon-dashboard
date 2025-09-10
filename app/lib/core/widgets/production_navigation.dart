import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Production navigation component following Material Design 3 guidelines
/// Implements adaptive navigation based on screen size and user type
class ProductionNavigation extends StatelessWidget {
  final Widget child;
  final bool isResident;
  final bool showBottomNav;
  
  const ProductionNavigation({
    super.key,
    required this.child,
    this.isResident = false,
    this.showBottomNav = true,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLargeScreen = mediaQuery.size.width >= 1200;
    final isMediumScreen = mediaQuery.size.width >= 600;
    
    // Use NavigationRail for large screens, BottomNav for mobile
    if (isLargeScreen) {
      return _buildNavigationRail(context);
    } else if (isMediumScreen) {
      return _buildNavigationRail(context, extended: false);
    } else {
      return _buildBottomNavigation(context);
    }
  }
  
  Widget _buildNavigationRail(BuildContext context, {bool extended = true}) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: extended,
            elevation: null, // Fix für UI-Overlay-Problem
            destinations: _getNavigationDestinations(),
            selectedIndex: _getCurrentIndex(context),
            onDestinationSelected: (index) => _navigate(context, index),
            labelType: extended ? null : NavigationRailLabelType.all,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
  
  Widget _buildBottomNavigation(BuildContext context) {
    if (!showBottomNav) {
      return Scaffold(body: child);
    }
    
    final destinations = _getBottomNavItems();
    
    return Scaffold(
      body: child,
      bottomNavigationBar: destinations.length <= 5
          ? NavigationBar(
              selectedIndex: _getCurrentIndex(context),
              onDestinationSelected: (index) => _navigate(context, index),
              destinations: destinations,
            )
          : BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _getCurrentIndex(context),
              onTap: (index) => _navigate(context, index),
              items: destinations.map((dest) => BottomNavigationBarItem(
                icon: dest.icon,
                label: dest.label,
              )).toList(),
            ),
    );
  }
  
  List<NavigationRailDestination> _getNavigationDestinations() {
    if (isResident) {
      return const [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          selectedIcon: Icon(Icons.home),
          label: Text('Start'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.announcement),
          selectedIcon: Icon(Icons.announcement),
          label: Text('Mitteilungen'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.download),
          selectedIcon: Icon(Icons.download),
          label: Text('Downloads'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.report_problem),
          selectedIcon: Icon(Icons.report_problem),
          label: Text('Meldungen'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.people),
          selectedIcon: Icon(Icons.people),
          label: Text('Community'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          selectedIcon: Icon(Icons.settings),
          label: Text('Einstellungen'),
        ),
      ];
    } else {
      return const [
        NavigationRailDestination(
          icon: Icon(Icons.explore),
          selectedIcon: Icon(Icons.explore),
          label: Text('Entdecken'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.event),
          selectedIcon: Icon(Icons.event),
          label: Text('Veranstaltungen'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.place),
          selectedIcon: Icon(Icons.place),
          label: Text('Orte'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.route),
          selectedIcon: Icon(Icons.route),
          label: Text('Routen'),
        ),
      ];
    }
  }
  
  List<NavigationDestination> _getBottomNavItems() {
    if (isResident) {
      return const [
        NavigationDestination(
          icon: Icon(Icons.home),
          selectedIcon: Icon(Icons.home),
          label: 'Start',
        ),
        NavigationDestination(
          icon: Icon(Icons.announcement),
          selectedIcon: Icon(Icons.announcement),
          label: 'Mitteilungen',
        ),
        NavigationDestination(
          icon: Icon(Icons.download),
          selectedIcon: Icon(Icons.download),
          label: 'Downloads',
        ),
        NavigationDestination(
          icon: Icon(Icons.report_problem),
          selectedIcon: Icon(Icons.report_problem),
          label: 'Meldungen',
        ),
        NavigationDestination(
          icon: Icon(Icons.people),
          selectedIcon: Icon(Icons.people),
          label: 'Community',
        ),
      ];
    } else {
      return const [
        NavigationDestination(
          icon: Icon(Icons.explore),
          selectedIcon: Icon(Icons.explore),
          label: 'Entdecken',
        ),
        NavigationDestination(
          icon: Icon(Icons.event),
          selectedIcon: Icon(Icons.event),
          label: 'Events',
        ),
        NavigationDestination(
          icon: Icon(Icons.place),
          selectedIcon: Icon(Icons.place),
          label: 'Orte',
        ),
        NavigationDestination(
          icon: Icon(Icons.route),
          selectedIcon: Icon(Icons.route),
          label: 'Routen',
        ),
      ];
    }
  }
  
  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    
    if (isResident) {
      if (location.startsWith('/home')) return 0;
      if (location.startsWith('/notices')) return 1;
      if (location.startsWith('/downloads')) return 2;
      if (location.startsWith('/reports')) return 3;
      if (location.startsWith('/community')) return 4;
      if (location.startsWith('/settings')) return 5;
      return 0;
    } else {
      if (location.startsWith('/tourist/discover')) return 0;
      if (location.startsWith('/events')) return 1;
      if (location.startsWith('/places')) return 2;
      if (location.startsWith('/routes')) return 3;
      return 0;
    }
  }
  
  void _navigate(BuildContext context, int index) {
    if (isResident) {
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/notices');
          break;
        case 2:
          context.go('/downloads');
          break;
        case 3:
          context.go('/reports');
          break;
        case 4:
          context.go('/community');
          break;
        case 5:
          context.go('/settings');
          break;
      }
    } else {
      switch (index) {
        case 0:
          context.go('/tourist/discover');
          break;
        case 1:
          context.go('/events');
          break;
        case 2:
          context.go('/places');
          break;
        case 3:
          context.go('/routes');
          break;
      }
    }
  }
}
