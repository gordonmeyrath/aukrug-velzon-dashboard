import 'package:flutter/material.dart';

enum NavDestination {
  residentNotices,
  residentEvents,
  residentReports,
  communityFeed,
  residentDownloads,
  touristDiscover,
  touristPlaces,
  touristRoutes,
  touristEvents,
  touristInfo,
  communityGroups,
  communityMessages,
  communityNotifications,
  communityProfile,
}

class NavItem {
  final NavDestination id;
  final String route;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final List<String> matchPrefixes;
  const NavItem({
    required this.id,
    required this.route,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.matchPrefixes,
  });
  bool matches(String location) =>
      matchPrefixes.any((p) => location.startsWith(p) || location.contains(p));
}

const _residentBase = <NavItem>[
  NavItem(
    id: NavDestination.residentNotices,
    route: '/resident/notices',
    label: 'Mitteilungen',
    icon: Icons.notifications_outlined,
    activeIcon: Icons.notifications,
    matchPrefixes: ['/resident/notices'],
  ),
  NavItem(
    id: NavDestination.residentEvents,
    route: '/resident/events',
    label: 'Events',
    icon: Icons.event_outlined,
    activeIcon: Icons.event,
    matchPrefixes: ['/resident/events'],
  ),
  NavItem(
    id: NavDestination.residentReports,
    route: '/resident/reports',
    label: 'Meldungen',
    icon: Icons.report_problem_outlined,
    activeIcon: Icons.report_problem,
    matchPrefixes: ['/resident/reports', '/resident/report'],
  ),
  NavItem(
    id: NavDestination.residentDownloads,
    route: '/resident/downloads',
    label: 'Downloads',
    icon: Icons.download_outlined,
    activeIcon: Icons.download,
    matchPrefixes: ['/resident/downloads'],
  ),
];

const _communityInsert = NavItem(
  id: NavDestination.communityFeed,
  route: '/community/feed',
  label: 'Community',
  icon: Icons.people_outlined,
  activeIcon: Icons.people,
  matchPrefixes: ['/community'],
);

List<NavItem> buildResidentNavItems({required bool includeCommunity}) {
  if (!includeCommunity) return List.unmodifiable(_residentBase);
  final list = List<NavItem>.from(_residentBase);
  list.insert(3, _communityInsert); // Zwischen Reports und Downloads
  return List.unmodifiable(list);
}

const touristNavItems = <NavItem>[
  NavItem(
    id: NavDestination.touristDiscover,
    route: '/tourist/discover',
    label: 'Entdecken',
    icon: Icons.explore_outlined,
    activeIcon: Icons.explore,
    matchPrefixes: ['/tourist/discover'],
  ),
  NavItem(
    id: NavDestination.touristPlaces,
    route: '/tourist/places',
    label: 'Orte',
    icon: Icons.place_outlined,
    activeIcon: Icons.place,
    matchPrefixes: ['/tourist/places'],
  ),
  NavItem(
    id: NavDestination.touristRoutes,
    route: '/tourist/routes',
    label: 'Routen',
    icon: Icons.route_outlined,
    activeIcon: Icons.route,
    matchPrefixes: ['/tourist/routes'],
  ),
  NavItem(
    id: NavDestination.touristEvents,
    route: '/tourist/events',
    label: 'Events',
    icon: Icons.event_outlined,
    activeIcon: Icons.event,
    matchPrefixes: ['/tourist/events'],
  ),
  NavItem(
    id: NavDestination.touristInfo,
    route: '/tourist/info',
    label: 'Info',
    icon: Icons.info_outlined,
    activeIcon: Icons.info,
    matchPrefixes: ['/tourist/info'],
  ),
];

const communityNavItems = <NavItem>[
  NavItem(
    id: NavDestination.communityFeed,
    route: '/community/feed',
    label: 'Feed',
    icon: Icons.dynamic_feed_outlined,
    activeIcon: Icons.dynamic_feed,
    matchPrefixes: ['/community/feed'],
  ),
  NavItem(
    id: NavDestination.communityGroups,
    route: '/community/groups',
    label: 'Gruppen',
    icon: Icons.groups_outlined,
    activeIcon: Icons.groups,
    matchPrefixes: ['/community/groups'],
  ),
  NavItem(
    id: NavDestination.communityMessages,
    route: '/community/messages',
    label: 'Nachrichten',
    icon: Icons.chat_bubble_outline,
    activeIcon: Icons.chat_bubble,
    matchPrefixes: ['/community/messages'],
  ),
  NavItem(
    id: NavDestination.communityNotifications,
    route: '/community/notifications',
    label: 'Hinweise',
    icon: Icons.notifications_outlined,
    activeIcon: Icons.notifications,
    matchPrefixes: ['/community/notifications'],
  ),
  NavItem(
    id: NavDestination.communityProfile,
    route: '/community/profile',
    label: 'Profil',
    icon: Icons.person_outline,
    activeIcon: Icons.person,
    matchPrefixes: ['/community/profile'],
  ),
];

int currentIndexFor(List<NavItem> items, String location) {
  final idx = items.indexWhere((i) => i.matches(location));
  return idx >= 0 ? idx : 0;
}
