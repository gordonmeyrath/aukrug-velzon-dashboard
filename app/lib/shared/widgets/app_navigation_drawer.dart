import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/color_extensions.dart';
import '../../core/theme/theme_mode_controller.dart';
import '../../features/auth/data/permissions.dart';

/// Hauptnavigation-Drawer für die gesamte App
class AppNavigationDrawer extends ConsumerWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final location = GoRouterState.of(context).uri.toString();
    final canShowCommunity = ref.watch(canAccessCommunityProvider);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header mit Gradient
            Container(
              width: double.infinity,
              height: 120,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aukrug',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bürger-App',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer
                                .alphaFrac(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  // Hauptmenü
                  _buildNavItem(
                    context,
                    icon: Icons.home_rounded,
                    title: 'Startseite',
                    route: '/home',
                    isSelected: location == '/home',
                  ),

                  const Divider(height: 16),

                  // Bürger-Funktionen Titel
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      'Bürger-Service',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Mitteilungen
                  _buildNavItem(
                    context,
                    icon: Icons.notifications_outlined,
                    title: 'Mitteilungen',
                    subtitle: 'Amtliche Bekanntmachungen',
                    route: '/resident/notices',
                    isSelected: location.contains('/resident/notices'),
                  ),

                  // Events
                  _buildNavItem(
                    context,
                    icon: Icons.event_outlined,
                    title: 'Veranstaltungen',
                    subtitle: 'Community Events',
                    route: '/resident/events',
                    isSelected: location.contains('/resident/events'),
                  ),

                  // Downloads
                  _buildNavItem(
                    context,
                    icon: Icons.download_outlined,
                    title: 'Downloads',
                    subtitle: 'Dokumente & Formulare',
                    route: '/resident/downloads',
                    isSelected: location.contains('/resident/downloads'),
                  ),

                  // Meldungen
                  _buildNavItem(
                    context,
                    icon: Icons.report_problem_outlined,
                    title: 'Mängelmelder',
                    subtitle: 'Probleme melden',
                    route: '/resident/reports',
                    isSelected: location.contains('/resident/reports'),
                    badge: '!',
                  ),

                  // Community (sichtbar nur wenn freigeschaltet)
                  if (canShowCommunity)
                    _buildNavItem(
                      context,
                      icon: Icons.people_outlined,
                      title: 'Community',
                      subtitle: 'Bürgerforum',
                      route: '/community/feed',
                      isSelected: location.contains('/community'),
                    ),

                  const Divider(height: 16),

                  // Tourismus-Funktionen Titel
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      'Tourismus',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Orte entdecken
                  _buildNavItem(
                    context,
                    icon: Icons.place_outlined,
                    title: 'Orte & Sehenswürdigkeiten',
                    subtitle: 'Entdecken Sie Aukrug',
                    route: '/tourist/places',
                    isSelected: location.contains('/tourist/places'),
                  ),

                  // Routen
                  _buildNavItem(
                    context,
                    icon: Icons.route_outlined,
                    title: 'Wanderrouten',
                    subtitle: 'Geocaching & Wege',
                    route: '/tourist/routes',
                    isSelected: location.contains('/tourist/routes'),
                  ),

                  const Divider(height: 16),

                  // App-Einstellungen Titel
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      'Einstellungen',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.outline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Datenschutz
                  _buildNavItem(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    title: 'Datenschutz',
                    route: '/privacy-settings',
                    isSelected: location.contains('/privacy-settings'),
                  ),

                  // App-Einstellungen
                  _buildNavItem(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'App-Einstellungen',
                    route: '/resident/settings',
                    isSelected: location.contains('/resident/settings'),
                  ),
                ],
              ),
            ),

            // Footer: Theme Switch + App Info
            const Divider(),
            _ThemeModeSelector(),
            const Divider(height: 0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Aukrug App v1.0.0',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '100% DSGVO-konform',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required String route,
    bool isSelected = false,
    String? badge,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected
            ? theme.colorScheme.primaryContainer.alphaFrac(0.3)
            : null,
      ),
      child: ListTile(
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.alphaFrac(0.7),
              size: 24,
            ),
            if (badge != null)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    badge,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onError,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.alphaFrac(0.6),
                ),
              )
            : null,
        dense: subtitle == null,
        onTap: () {
          Navigator.of(context).pop(); // Drawer schließen
          context.go(route);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _ThemeModeSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final controller = ref.read(themeModeProvider.notifier);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Darstellung',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.system,
                label: Text('System'),
                icon: Icon(Icons.auto_mode_rounded),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text('Hell'),
                icon: Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text('Dunkel'),
                icon: Icon(Icons.dark_mode_outlined),
              ),
            ],
            selected: {mode},
            showSelectedIcon: false,
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              ),
            ),
            onSelectionChanged: (selection) {
              final selected = selection.first;
              controller.setMode(selected);
            },
          ),
        ],
      ),
    );
  }
}
