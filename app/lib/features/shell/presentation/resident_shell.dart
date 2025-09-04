import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Resident shell with bottom navigation
class ResidentShell extends StatelessWidget {
  final Widget child;

  const ResidentShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey.shade600,
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onTabTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Mitteilungen',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: 'Downloads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_problem),
            label: 'Mängel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.contains('/notices')) return 0;
    if (location.contains('/events')) return 1;
    if (location.contains('/downloads')) return 2;
    if (location.contains('/report')) return 3;
    if (location.contains('/settings')) return 4;
    return 0;
  }

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/resident/notices');
        break;
      case 1:
        context.go('/resident/events');
        break;
      case 2:
        context.go('/resident/downloads');
        break;
      case 3:
        context.go('/resident/report');
        break;
      case 4:
        context.go('/resident/settings');
        break;
    }
  }
}
