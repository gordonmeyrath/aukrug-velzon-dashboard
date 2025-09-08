import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/info_api_repository.dart';

class InfoPage extends ConsumerWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoAsync = ref.watch(infoApiRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aukrug Info'),
        automaticallyImplyLeading: false, // Da bereits in AppShell
      ),
      body: infoAsync.when(
        data: (appInfo) => _buildContent(context, appInfo),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Fehler beim Laden der App-Informationen'),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(infoApiRepositoryProvider),
                child: const Text('Erneut versuchen'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic>? appInfo) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Card(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.info_outline, size: 64, color: Colors.blue),
                  const SizedBox(height: 16),
                  Text(
                    appInfo?['app_title'] ?? 'Aukrug App',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appInfo?['app_description'] ??
                        'Entdecken Sie die Gemeinde Aukrug',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (appInfo?['app_version'] != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Version ${appInfo!['app_version']}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Contact Information
          _buildSectionCard(context, 'Kontakt', Icons.contact_phone, [
            _buildInfoItem(
              'Gemeindeverwaltung',
              appInfo?['contact_office'] ?? 'Hauptstraße 1, 24613 Aukrug',
              Icons.location_on,
            ),
            _buildInfoItem(
              'Telefon',
              appInfo?['contact_phone'] ?? '04873 / 123456',
              Icons.phone,
            ),
            _buildInfoItem(
              'E-Mail',
              appInfo?['contact_email'] ?? 'info@aukrug.de',
              Icons.email,
            ),
          ]),

          const SizedBox(height: 16),

          // Opening Hours
          _buildSectionCard(context, 'Öffnungszeiten', Icons.access_time, [
            _buildInfoItem(
              'Montag - Freitag',
              appInfo?['office_hours_weekdays'] ?? '8:00 - 16:00 Uhr',
              Icons.schedule,
            ),
            _buildInfoItem(
              'Samstag',
              appInfo?['office_hours_saturday'] ?? 'Nach Vereinbarung',
              Icons.schedule,
            ),
            _buildInfoItem(
              'Sonntag',
              appInfo?['office_hours_sunday'] ?? 'Geschlossen',
              Icons.schedule,
            ),
          ]),

          const SizedBox(height: 16),

          // Emergency Information
          _buildSectionCard(context, 'Notfälle', Icons.emergency, [
            _buildEmergencyItem('112', 'Feuerwehr/Rettungsdienst', Colors.red),
            _buildEmergencyItem('110', 'Polizei', Colors.blue),
          ]),

          const SizedBox(height: 24),

          // App Information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App-Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoItem(
                    'Entwickelt für',
                    'Gemeinde Aukrug',
                    Icons.public,
                  ),
                  _buildInfoItem(
                    'Support',
                    appInfo?['support_contact'] ?? 'support@aukrug.de',
                    Icons.support_agent,
                  ),
                  if (appInfo?['last_updated'] != null)
                    _buildInfoItem(
                      'Letzte Aktualisierung',
                      appInfo!['last_updated'],
                      Icons.update,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(value, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyItem(String number, String service, Color color) {
    return InkWell(
      onTap: () => _callEmergency(),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    number,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(service),
                ],
              ),
            ),
            Icon(Icons.phone, color: color),
          ],
        ),
      ),
    );
  }

  void _callEmergency() {
    // TODO: Open phone dialer with emergency number
  }
}
