import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/color_extensions.dart';
import '../../auth/data/auth_service.dart';

/// Hauptmenü für alle Bürger-Funktionen der Aukrug App
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(currentUserProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header - gradient hero
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.secondaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.alphaFrac(0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.home_rounded,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Willkommen in Aukrug',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                      currentUser.when(
                        data: (user) => Text(
                          user != null
                              ? 'Angemeldet als ${user.email.isEmpty ? "Anonymer Nutzer" : user.email}'
                              : 'Nicht angemeldet',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer
                                .alphaFrac(0.85),
                          ),
                        ),
                        loading: () => const Text('Lade...'),
                        error: (_, __) => const Text('Fehler beim Laden'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Hinweis: (DemoStatusWidget ehemals in AppScaffold entfernt)
          const SizedBox(height: 16),

          // Hauptfunktionen
          Text(
            'Hauptfunktionen',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Funktions-Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio:
                1.1, // Reduced from 1.2 to 1.1 to accommodate 7 cards
            children: [
              // Problem melden
              _MenuCard(
                icon: Icons.report_problem,
                title: 'Problem melden',
                subtitle: 'Schäden & Probleme melden',
                color: Colors.red.shade400,
                onTap: () => context.go('/resident/report'),
              ),

              // Community - Aktiv
              _MenuCard(
                icon: Icons.groups,
                title: 'Community',
                subtitle: 'Gruppen & Nachbarschaft',
                color: Colors.deepPurple.shade400,
                onTap: () {
                  context.go('/community');
                },
              ),

              // Meine Meldungen
              _MenuCard(
                icon: Icons.list_alt,
                title: 'Meine Meldungen',
                subtitle: 'Eigene Berichte verwalten',
                color: Colors.blue.shade400,
                onTap: () => context.go('/resident/reports'),
              ),

              // Karte
              _MenuCard(
                icon: Icons.map,
                title: 'Karte',
                subtitle: 'Probleme auf Karte anzeigen',
                color: Colors.green.shade400,
                onTap: () => context.go('/resident/reports/map'),
              ),

              // Veranstaltungen
              _MenuCard(
                icon: Icons.event,
                title: 'Veranstaltungen',
                subtitle: 'Termine & Events',
                color: Colors.orange.shade400,
                onTap: () => context.go('/resident/events'),
              ),

              // Bekanntmachungen
              _MenuCard(
                icon: Icons.announcement,
                title: 'Bekanntmachungen',
                subtitle: 'Amtliche Mitteilungen',
                color: Colors.purple.shade400,
                onTap: () => context.go('/resident/notices'),
              ),

              // Orte & Einrichtungen
              _MenuCard(
                icon: Icons.location_on,
                title: 'Orte & Einrichtungen',
                subtitle: 'Öffentliche Einrichtungen',
                color: Colors.teal.shade400,
                onTap: () => context.go('/tourist/places'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Service-Funktionen
          Text(
            'Service',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Service-Liste
          Column(
            children: [
              _ServiceListTile(
                icon: Icons.camera_alt,
                title: 'Kamera-Service',
                subtitle: 'Fotos für Meldungen aufnehmen',
                onTap: () => _showCameraServiceInfo(context),
              ),
              _ServiceListTile(
                icon: Icons.privacy_tip,
                title: 'Datenschutz',
                subtitle: 'Privatsphäre-Einstellungen',
                onTap: () => context.go('/privacy-settings'),
              ),
              _ServiceListTile(
                icon: Icons.help,
                title: 'Hilfe & Kontakt',
                subtitle: 'Support & Informationen',
                onTap: () => _showHelpInfo(context),
              ),
              _ServiceListTile(
                icon: Icons.info,
                title: 'Über die App',
                subtitle: 'Version & Impressum',
                onTap: () => _showAboutInfo(context),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Notfall-Kontakte
          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.emergency, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Notfall-Kontakte',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Polizei: 110\nFeuerwehr/Rettung: 112\nGemeindeverwaltung: 04873/8794-0',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showCameraServiceInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kamera-Service'),
        content: const Text(
          'Der Kamera-Service ermöglicht es Ihnen, Fotos für Ihre Meldungen aufzunehmen. '
          'Alle Fotos werden DSGVO-konform verarbeitet und nur mit Ihrer Zustimmung verwendet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelpInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hilfe & Kontakt'),
        content: const Text(
          'Bei Fragen zur App wenden Sie sich an:\n\n'
          'Gemeinde Aukrug\n'
          'Telefon: 04873/8794-0\n'
          'E-Mail: info@aukrug.de\n\n'
          'Technischer Support:\n'
          'support@aukrug-app.de',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Über die App'),
        content: const Text(
          'Aukrug Bürger-App v0.9.0\n\n'
          'Diese App ermöglicht es Bürgern, Probleme zu melden, '
          'Veranstaltungen zu verfolgen und mit der Gemeinde zu kommunizieren.\n\n'
          '100% DSGVO-konform entwickelt.\n\n'
          '© 2025 Gemeinde Aukrug',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Menu Card Widget für die Hauptfunktionen
class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8), // Reduced from 10 to 8
                decoration: BoxDecoration(
                  color: color.alphaFrac(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: color,
                ), // Reduced from 28 to 24
              ),
              const SizedBox(height: 6), // Reduced from 8 to 6
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 13, // Reduced font size
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 11, // Reduced from 12 to 11
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Service List Tile Widget
class _ServiceListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ServiceListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
