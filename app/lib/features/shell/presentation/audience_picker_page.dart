import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/color_extensions.dart';

/// Modern Splash Screen - Audience picker page im Material 3 Design
class AudiencePickerPage extends StatelessWidget {
  const AudiencePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Sachlicher, kommunaler Hintergrund (hell, neutral)
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainerHighest,
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32.0,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Aukrug Branding Section
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Modern Logo Container
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.alphaFrac(
                                  0.06,
                                ),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: theme.colorScheme.primary.alphaFrac(
                                    0.15,
                                  ),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.apartment_rounded,
                                size: 76,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // App Title
                            Text(
                              'Gemeinde Aukrug',
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),

                            Text(
                              'Bürger-App',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),

                            // Subtitle
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: theme.colorScheme.outlineVariant
                                      .alphaFrac(0.6),
                                ),
                              ),
                              child: Text(
                                'DSGVO-konform • Sicher • Benutzerfreundlich',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Selection Section
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Wählen Sie Ihre Perspektive:',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),

                            // Tourist Button (ruhiges Grün)
                            _ModernChoiceCard(
                              icon: Icons.landscape_rounded,
                              title: 'Ich besuche Aukrug',
                              subtitle: 'Touristische Informationen',
                              color: const Color(0xFF2E7D32), // Forest Green
                              onTap: () =>
                                  context.go('/consent?audience=tourist'),
                            ),

                            const SizedBox(height: 16),

                            // Resident Button (kommunales Blau)
                            _ModernChoiceCard(
                              icon: Icons.home_work_rounded,
                              title: 'Ich lebe hier',
                              subtitle: 'Bürgerdienste & Funktionen',
                              color: const Color(0xFF1E3A8A), // Navy Blue
                              isPrimary: true,
                              onTap: () =>
                                  context.go('/consent?audience=resident'),
                            ),
                          ],
                        ),

                        // Footer Section
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Info Text
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme
                                      .colorScheme
                                      .surfaceContainerHighest
                                      .alphaFrac(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Diese Auswahl bestimmt die für Sie relevanten Inhalte.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 11,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Skip to Main Menu
                              TextButton.icon(
                                onPressed: () => context.go('/home'),
                                icon: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                  color: theme.colorScheme.primary,
                                ),
                                label: Text(
                                  'Direkt zum Hauptmenü',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Modern Choice Card Widget
class _ModernChoiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ModernChoiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.alphaFrac(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: isPrimary ? color : color.alphaFrac(0.08),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isPrimary
                        ? Colors.white.alphaFrac(0.15)
                        : color.alphaFrac(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: isPrimary ? Colors.white : color,
                  ),
                ),
                const SizedBox(width: 16),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isPrimary
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isPrimary
                              ? Colors.white.alphaFrac(0.9)
                              : theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: isPrimary ? Colors.white.alphaFrac(0.85) : color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
