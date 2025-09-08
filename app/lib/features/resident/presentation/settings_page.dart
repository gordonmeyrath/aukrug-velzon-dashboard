import 'package:flutter/material.dart';

import '../../../../core/design/widgets/app_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = false;
  bool _analyticsEnabled = true;
  String _selectedLanguage = 'Deutsch';
  String _selectedTheme = 'System';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
        automaticallyImplyLeading: false, // Da bereits in AppShell
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Benutzer-Profil Sektion
            _SettingsSection(
              title: 'Profil',
              icon: Icons.person,
              children: [
                _SettingsTile(
                  icon: Icons.account_circle,
                  title: 'Benutzerkonto',
                  subtitle: 'Konto-Informationen verwalten',
                  onTap: () => _showComingSoon(context, 'Benutzerkonto'),
                ),
                _SettingsTile(
                  icon: Icons.lock,
                  title: 'Datenschutz',
                  subtitle: 'Datenschutz-Einstellungen',
                  onTap: () => _showComingSoon(context, 'Datenschutz'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Benachrichtigungen
            _SettingsSection(
              title: 'Benachrichtigungen',
              icon: Icons.notifications,
              children: [
                _SwitchTile(
                  icon: Icons.notifications_active,
                  title: 'Push-Benachrichtigungen',
                  subtitle: 'Erhalte wichtige Mitteilungen',
                  value: _notificationsEnabled,
                  onChanged: (value) =>
                      setState(() => _notificationsEnabled = value),
                ),
                _SettingsTile(
                  icon: Icons.tune,
                  title: 'Benachrichtigungs-Kategorien',
                  subtitle: 'Anpassen welche Mitteilungen Sie erhalten',
                  onTap: () =>
                      _showComingSoon(context, 'Benachrichtigungs-Kategorien'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // App-Verhalten
            _SettingsSection(
              title: 'App-Verhalten',
              icon: Icons.settings,
              children: [
                _SwitchTile(
                  icon: Icons.location_on,
                  title: 'Standort-Dienste',
                  subtitle: 'Für standortbasierte Features',
                  value: _locationEnabled,
                  onChanged: (value) =>
                      setState(() => _locationEnabled = value),
                ),
                _SwitchTile(
                  icon: Icons.analytics,
                  title: 'Nutzungsstatistiken',
                  subtitle: 'Hilft bei der App-Verbesserung',
                  value: _analyticsEnabled,
                  onChanged: (value) =>
                      setState(() => _analyticsEnabled = value),
                ),
                _DropdownTile(
                  icon: Icons.language,
                  title: 'Sprache',
                  value: _selectedLanguage,
                  options: const ['Deutsch', 'English'],
                  onChanged: (value) =>
                      setState(() => _selectedLanguage = value!),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Darstellung
            _SettingsSection(
              title: 'Darstellung',
              icon: Icons.palette,
              children: [
                _DropdownTile(
                  icon: Icons.dark_mode,
                  title: 'Design',
                  value: _selectedTheme,
                  options: const ['System', 'Hell', 'Dunkel'],
                  onChanged: (value) => setState(() => _selectedTheme = value!),
                ),
                _SettingsTile(
                  icon: Icons.text_fields,
                  title: 'Textgröße',
                  subtitle: 'Schriftgröße anpassen',
                  onTap: () => _showComingSoon(context, 'Textgröße'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Support & Info
            _SettingsSection(
              title: 'Support & Info',
              icon: Icons.help,
              children: [
                _SettingsTile(
                  icon: Icons.help_outline,
                  title: 'Hilfe & FAQ',
                  subtitle: 'Häufig gestellte Fragen',
                  onTap: () => _showComingSoon(context, 'Hilfe & FAQ'),
                ),
                _SettingsTile(
                  icon: Icons.feedback,
                  title: 'Feedback senden',
                  subtitle: 'Teilen Sie uns Ihre Meinung mit',
                  onTap: () => _showComingSoon(context, 'Feedback'),
                ),
                _SettingsTile(
                  icon: Icons.info,
                  title: 'Über die App',
                  subtitle: 'Version 1.0.0',
                  onTap: () => _showAboutDialog(),
                ),
                _SettingsTile(
                  icon: Icons.description,
                  title: 'Nutzungsbedingungen',
                  subtitle: 'AGB und Datenschutzerklärung',
                  onTap: () => _showComingSoon(context, 'Nutzungsbedingungen'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Cache & Daten
            _SettingsSection(
              title: 'Daten & Speicher',
              icon: Icons.storage,
              children: [
                _SettingsTile(
                  icon: Icons.delete_sweep,
                  title: 'Cache leeren',
                  subtitle: 'Temporäre Dateien entfernen',
                  onTap: () => _clearCache(context),
                ),
                _SettingsTile(
                  icon: Icons.cloud_sync,
                  title: 'Daten synchronisieren',
                  subtitle: 'Manuell mit Server synchronisieren',
                  onTap: () => _syncData(context),
                ),
                _SettingsTile(
                  icon: Icons.download,
                  title: 'Offline-Daten',
                  subtitle: 'Downloads und Offline-Inhalte verwalten',
                  onTap: () => _showComingSoon(context, 'Offline-Daten'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Abmelden',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _showLogoutDialog(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature wird in einer zukünftigen Version verfügbar sein',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Aukrug App',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.location_city, size: 64),
      children: [
        const Text('Die offizielle App der Gemeinde Aukrug.'),
        const SizedBox(height: 16),
        const Text('Entwickelt für die Bürgerinnen und Bürger von Aukrug.'),
      ],
    );
  }

  void _clearCache(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cache leeren'),
        content: const Text(
          'Möchten Sie wirklich den App-Cache leeren? Dies kann die Ladezeiten vorübergehend erhöhen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache erfolgreich geleert'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Leeren'),
          ),
        ],
      ),
    );
  }

  void _syncData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Synchronisation gestartet...'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Simuliere Sync-Vorgang
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Synchronisation abgeschlossen'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abmelden'),
        content: const Text('Möchten Sie sich wirklich abmelden?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement logout logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Abmeldung wird implementiert...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Abmelden',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AppCard(child: Column(children: children)),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

class _DropdownTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _DropdownTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: DropdownButton<String>(
        value: value,
        items: options
            .map(
              (option) => DropdownMenuItem(value: option, child: Text(option)),
            )
            .toList(),
        onChanged: onChanged,
        underline: Container(),
      ),
    );
  }
}
