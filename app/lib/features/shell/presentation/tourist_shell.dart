import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Tourist shell with bottom navigation
class TouristShell extends StatelessWidget {
  final Widget child;

  const TouristShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey.shade600,
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onTabTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Entdecken',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.route), label: 'Routen'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.place), label: 'Orte'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.contains('/discover')) return 0;
    if (location.contains('/routes')) return 1;
    if (location.contains('/events')) return 2;
    if (location.contains('/places')) return 3;
    if (location.contains('/info')) return 4;
    return 0;
  }

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/tourist/discover');
        break;
      case 1:
        context.go('/tourist/routes');
        break;
      case 2:
        context.go('/tourist/events');
        break;
      case 3:
        context.go('/tourist/places');
        break;
      case 4:
        context.go('/tourist/info');
        break;
    }
  }
}
