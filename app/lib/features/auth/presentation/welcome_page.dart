import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/loading_widget.dart';
import '../data/auth_service.dart';

/// DSGVO-konforme Welcome Page mit anonymer und E-Mail-basierter Anmeldung
class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SafeArea(
        child: authState.when(
          data: (user) {
            if (user != null) {
              // User ist bereits angemeldet, weiterleiten
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/reports');
              });
              return const Center(child: CircularProgressIndicator());
            }
            return _buildWelcomeContent(context, ref);
          },
          loading: () => const LoadingWidget(),
          error: (error, stack) => _buildWelcomeContent(context, ref),
        ),
      ),
    );
  }

  Widget _buildWelcomeContent(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Spacer(),
          
          // App Logo und Titel
          Icon(
            Icons.location_city,
            size: 120,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 24),
          
          Text(
            'Aukrug Connect',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            'Gemeinde-App für Bürgerservice',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          
          const Spacer(),
          
          // DSGVO-Info Card
          _buildDSGVOInfoCard(context),
          const SizedBox(height: 32),
          
          // Anmelde-Optionen
          _buildAuthOptions(context, ref),
          
          const Spacer(),
          
          // DSGVO-Links
          _buildDSGVOLinks(context),
        ],
      ),
    );
  }

  Widget _buildDSGVOInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Datenschutz & DSGVO',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Diese App ist 100% DSGVO-konform gestaltet. Sie können die App anonym nutzen oder sich mit E-Mail registrieren für erweiterte Funktionen.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Lokale Datenspeicherung, keine Cloud',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Vollständige Kontrolle über Ihre Daten',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuthOptions(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Anonyme Nutzung (DSGVO-konform ohne Einwilligung)
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _handleAnonymousSignIn(context, ref),
            icon: const Icon(Icons.visibility_off),
            label: const Text('Anonym fortfahren'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // E-Mail Registrierung/Anmeldung
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.push('/auth/email'),
            icon: const Icon(Icons.email),
            label: const Text('Mit E-Mail anmelden'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDSGVOLinks(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () => context.push('/privacy'),
          child: Text(
            'Datenschutz',
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ),
        Container(
          width: 1,
          height: 16,
          color: theme.colorScheme.onPrimaryContainer.withOpacity(0.3),
        ),
        TextButton(
          onPressed: () => context.push('/imprint'),
          child: Text(
            'Impressum',
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ),
        Container(
          width: 1,
          height: 16,
          color: theme.colorScheme.onPrimaryContainer.withOpacity(0.3),
        ),
        TextButton(
          onPressed: () => context.push('/terms'),
          child: Text(
            'Nutzungsbedingungen',
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleAnonymousSignIn(BuildContext context, WidgetRef ref) async {
    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.registerAnonymous();
      
      if (user != null) {
        // Invalidate auth state to trigger rebuild
        ref.invalidate(currentUserProvider);
        
        if (context.mounted) {
          context.go('/reports');
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fehler bei der anonymen Anmeldung'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
