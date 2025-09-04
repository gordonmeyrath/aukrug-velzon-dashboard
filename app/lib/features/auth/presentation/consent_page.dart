import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// GDPR consent page for data processing permissions
class ConsentPage extends StatefulWidget {
  const ConsentPage({super.key});

  @override
  State<ConsentPage> createState() => _ConsentPageState();
}

class _ConsentPageState extends State<ConsentPage> {
  bool _analyticsConsent = false; // Default: opt-out
  bool _pushConsent = false; // Default: opt-in required
  bool _locationConsent = false; // Default: optional

  @override
  Widget build(BuildContext context) {
    final audience =
        GoRouterState.of(context).uri.queryParameters['audience'] ?? 'tourist';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Datenschutz & Einstellungen'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ihre Privatsphäre ist wichtig',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Text(
              'Wir respektieren Ihre Privatsphäre und verarbeiten nur die Daten, denen Sie ausdrücklich zustimmen. Alle Einstellungen können jederzeit geändert werden.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            // Analytics Toggle
            _ConsentToggle(
              title: 'Nutzungsstatistiken',
              description:
                  'Anonyme Daten zur Verbesserung der App (standardmäßig deaktiviert)',
              value: _analyticsConsent,
              onChanged: (value) => setState(() => _analyticsConsent = value),
              required: false,
            ),
            const SizedBox(height: 16),

            // Push Notifications Toggle
            _ConsentToggle(
              title: 'Push-Benachrichtigungen',
              description:
                  'Erhalten Sie wichtige Mitteilungen und Veranstaltungshinweise',
              value: _pushConsent,
              onChanged: (value) => setState(() => _pushConsent = value),
              required: false,
            ),
            const SizedBox(height: 16),

            // Location Toggle
            _ConsentToggle(
              title: 'Standortdaten',
              description: 'Für ortsbezogene Inhalte und Navigation (optional)',
              value: _locationConsent,
              onChanged: (value) => setState(() => _locationConsent = value),
              required: false,
            ),
            const SizedBox(height: 32),

            // Privacy Policy Link
            Center(
              child: TextButton(
                onPressed: () {
                  // TODO: Open privacy policy
                },
                child: const Text('Datenschutzerklärung lesen'),
              ),
            ),
            const SizedBox(height: 24),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _saveConsentAndContinue(audience),
                style: ElevatedButton.styleFrom(
                  backgroundColor: audience == 'tourist'
                      ? Colors.green.shade600
                      : Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Einstellungen speichern & fortfahren',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveConsentAndContinue(String audience) async {
    final prefs = await SharedPreferences.getInstance();

    // Save consent preferences
    await prefs.setBool('consent_analytics', _analyticsConsent);
    await prefs.setBool('consent_push', _pushConsent);
    await prefs.setBool('consent_location', _locationConsent);
    await prefs.setBool('consent_given', true);
    await prefs.setString('user_audience', audience);

    if (!mounted) return;

    // Navigate to appropriate shell
    if (audience == 'tourist') {
      context.go('/tourist/discover');
    } else {
      context.go('/resident/notices');
    }
  }
}

class _ConsentToggle extends StatelessWidget {
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool required;

  const _ConsentToggle({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (required) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Erforderlich',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: required ? null : onChanged,
              activeColor: Colors.green.shade600,
            ),
          ],
        ),
      ),
    );
  }
}
