import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/auth_service.dart';
import '../domain/user.dart';

/// DSGVO-konforme Privacy Settings Page
/// Artikel 7, 12, 13, 14, 21 DSGVO compliance
class PrivacySettingsPage extends ConsumerStatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  ConsumerState<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends ConsumerState<PrivacySettingsPage> {
  User? _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await ref.read(authServiceProvider).getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datenschutz-Einstellungen'),
        centerTitle: true,
      ),
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPrivacyHeader(),
                  const SizedBox(height: 24),
                  
                  _buildConsentSection(),
                  const SizedBox(height: 24),
                  
                  _buildDataProcessingSection(),
                  const SizedBox(height: 24),
                  
                  _buildDataRetentionSection(),
                  const SizedBox(height: 24),
                  
                  _buildUserRightsSection(),
                  const SizedBox(height: 24),
                  
                  _buildLegalLinksSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildPrivacyHeader() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'DSGVO-konforme Einstellungen',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Verwalten Sie Ihre Datenschutz-Einstellungen und Einwilligungen. Alle Änderungen werden sofort wirksam.',
            style: theme.textTheme.bodyMedium,
          ),
          if (_currentUser?.privacySettings.consentGivenAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Letzter Consent: ${_formatDateTime(_currentUser!.privacySettings.consentGivenAt!)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConsentSection() {
    final settings = _currentUser!.privacySettings;
    
    return _buildSection(
      title: 'Einwilligungen',
      icon: Icons.check_circle,
      children: [
        _buildSwitchTile(
          title: 'Standortverarbeitung',
          subtitle: 'GPS-Daten für automatische Ortserfassung',
          value: settings.consentToLocationProcessing,
          onChanged: (value) => _updatePrivacySetting('consentToLocationProcessing', value),
        ),
        
        _buildSwitchTile(
          title: 'Foto-Verarbeitung',
          subtitle: 'Bildbearbeitung und Komprimierung',
          value: settings.consentToPhotoProcessing,
          onChanged: (value) => _updatePrivacySetting('consentToPhotoProcessing', value),
        ),
        
        _buildSwitchTile(
          title: 'E-Mail Kontakt',
          subtitle: 'Erlaubnis für E-Mail-Kontakt von der Gemeinde',
          value: settings.allowEmailContact,
          onChanged: (value) => _updatePrivacySetting('allowEmailContact', value),
        ),
        
        _buildSwitchTile(
          title: 'Telefon Kontakt',
          subtitle: 'Erlaubnis für telefonischen Kontakt',
          value: settings.allowPhoneContact,
          onChanged: (value) => _updatePrivacySetting('allowPhoneContact', value),
        ),
      ],
    );
  }

  Widget _buildDataProcessingSection() {
    final theme = Theme.of(context);
    final settings = _currentUser!.privacySettings;
    
    return _buildSection(
      title: 'Datenverarbeitung',
      icon: Icons.data_usage,
      children: [
        _buildInfoTile(
          title: 'Meldungen erstellen',
          subtitle: 'Erforderlich für grundlegende App-Funktionen',
          value: 'Aktiviert (Erforderlich)',
          trailing: Icon(
            Icons.lock,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        
        _buildSwitchTile(
          title: 'Standort-Tracking',
          subtitle: 'Kontinuierliche GPS-Erfassung für Meldungen',
          value: settings.allowLocationTracking,
          onChanged: (value) => _updatePrivacySetting('allowLocationTracking', value),
        ),
        
        _buildSwitchTile(
          title: 'Nutzungsanalyse',
          subtitle: 'Anonyme Analyse zur App-Verbesserung',
          value: settings.allowUsageAnalytics,
          onChanged: (value) => _updatePrivacySetting('allowUsageAnalytics', value),
        ),
        
        _buildSwitchTile(
          title: 'Personalisierung',
          subtitle: 'Anpassung der App an Ihre Präferenzen',
          value: settings.allowPersonalization,
          onChanged: (value) => _updatePrivacySetting('allowPersonalization', value),
        ),
      ],
    );
  }

  Widget _buildDataRetentionSection() {
    final settings = _currentUser!.privacySettings;
    
    return _buildSection(
      title: 'Datenspeicherung',
      icon: Icons.storage,
      children: [
        ListTile(
          title: const Text('Aufbewahrungsdauer'),
          subtitle: Text('Wie lange sollen Ihre Daten gespeichert werden?'),
          trailing: DropdownButton<DataRetentionPeriod>(
            value: settings.dataRetentionPeriod,
            onChanged: (value) {
              if (value != null) {
                _updatePrivacySetting('dataRetentionPeriod', value);
              }
            },
            items: DataRetentionPeriod.values.map((period) {
              return DropdownMenuItem(
                value: period,
                child: Text(period.displayName),
              );
            }).toList(),
          ),
        ),
        
        _buildSwitchTile(
          title: 'Automatische Löschung alter Meldungen',
          subtitle: 'Meldungen nach Ablauf der Frist automatisch löschen',
          value: settings.autoDeleteOldReports,
          onChanged: (value) => _updatePrivacySetting('autoDeleteOldReports', value),
        ),
        
        _buildSwitchTile(
          title: 'Anonymisierung alter Daten',
          subtitle: 'Persönliche Daten anonymisieren statt löschen',
          value: settings.anonymizeOldData,
          onChanged: (value) => _updatePrivacySetting('anonymizeOldData', value),
        ),
      ],
    );
  }

  Widget _buildUserRightsSection() {
    final theme = Theme.of(context);
    final settings = _currentUser!.privacySettings;
    
    return _buildSection(
      title: 'Ihre DSGVO-Rechte',
      icon: Icons.gavel,
      children: [
        _buildActionTile(
          title: 'Datenexport anfordern',
          subtitle: 'Alle Ihre Daten in maschinenlesbarer Form herunterladen',
          actionText: 'Export',
          onTap: _requestDataExport,
          lastAction: settings.lastDataExportRequest,
        ),
        
        _buildActionTile(
          title: 'Datenlöschung beantragen',
          subtitle: 'Ihre persönlichen Daten löschen lassen',
          actionText: 'Löschen',
          onTap: _requestDataDeletion,
          lastAction: settings.lastDataDeletionRequest,
          isDestructive: true,
        ),
        
        _buildInfoTile(
          title: 'Datenberichtigung',
          subtitle: 'Ändern Sie Ihre Daten in den Profileinstellungen',
          value: 'Verfügbar',
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/profile'),
          ),
        ),
        
        _buildInfoTile(
          title: 'Datenübertragbarkeit',
          subtitle: 'Ihre Daten an andere Dienste übertragen',
          value: 'JSON/CSV Export',
          trailing: Icon(
            Icons.download,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildLegalLinksSection() {
    return _buildSection(
      title: 'Rechtliche Informationen',
      icon: Icons.info,
      children: [
        _buildLinkTile(
          title: 'Datenschutzerklärung',
          subtitle: 'Vollständige Datenschutzerklärung lesen',
          onTap: () => context.push('/privacy-policy'),
        ),
        
        _buildLinkTile(
          title: 'Impressum',
          subtitle: 'Rechtliche Angaben zur App',
          onTap: () => context.push('/imprint'),
        ),
        
        _buildLinkTile(
          title: 'Nutzungsbedingungen',
          subtitle: 'Bedingungen für die App-Nutzung',
          onTap: () => context.push('/terms'),
        ),
        
        _buildLinkTile(
          title: 'DSGVO-Informationen',
          subtitle: 'Ihre Rechte nach der Datenschutz-Grundverordnung',
          onTap: () => context.push('/gdpr-info'),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: _isLoading ? null : onChanged,
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String subtitle,
    required String value,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? Text(
        value,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onTap,
    DateTime? lastAction,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          if (lastAction != null)
            Text(
              'Zuletzt: ${_formatDateTime(lastAction)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
        ],
      ),
      trailing: ElevatedButton(
        onPressed: _isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive ? theme.colorScheme.error : null,
          foregroundColor: isDestructive ? theme.colorScheme.onError : null,
        ),
        child: Text(actionText),
      ),
    );
  }

  Widget _buildLinkTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Future<void> _updatePrivacySetting(String setting, dynamic value) async {
    if (_currentUser == null || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final currentSettings = _currentUser!.privacySettings;
      
      // Create new privacy settings with updated value
      PrivacySettings newSettings;
      
      switch (setting) {
        case 'consentToLocationProcessing':
          newSettings = currentSettings.copyWith(consentToLocationProcessing: value);
          break;
        case 'consentToPhotoProcessing':
          newSettings = currentSettings.copyWith(consentToPhotoProcessing: value);
          break;
        case 'allowEmailContact':
          newSettings = currentSettings.copyWith(allowEmailContact: value);
          break;
        case 'allowPhoneContact':
          newSettings = currentSettings.copyWith(allowPhoneContact: value);
          break;
        case 'allowLocationTracking':
          newSettings = currentSettings.copyWith(allowLocationTracking: value);
          break;
        case 'allowUsageAnalytics':
          newSettings = currentSettings.copyWith(allowUsageAnalytics: value);
          break;
        case 'allowPersonalization':
          newSettings = currentSettings.copyWith(allowPersonalization: value);
          break;
        case 'dataRetentionPeriod':
          newSettings = currentSettings.copyWith(dataRetentionPeriod: value);
          break;
        case 'autoDeleteOldReports':
          newSettings = currentSettings.copyWith(autoDeleteOldReports: value);
          break;
        case 'anonymizeOldData':
          newSettings = currentSettings.copyWith(anonymizeOldData: value);
          break;
        default:
          return;
      }

      final updatedUser = await authService.updateUserProfile(
        user: _currentUser!,
        privacySettings: newSettings,
      );

      if (updatedUser != null) {
        setState(() {
          _currentUser = updatedUser;
        });
        
        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Einstellungen gespeichert'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Speichern: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _requestDataExport() async {
    if (_currentUser == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Datenexport'),
        content: const Text(
          'Möchten Sie alle Ihre gespeicherten Daten exportieren? '
          'Der Export wird als JSON-Datei bereitgestellt.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exportieren'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final authService = ref.read(authServiceProvider);
      final export = await authService.exportUserData(_currentUser!.id);
      
      if (export != null) {
        // In einer echten App würde hier der Download initiiert
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Datenexport wurde erstellt'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Update user state
        await _loadCurrentUser();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Export: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _requestDataDeletion() async {
    if (_currentUser == null) return;

    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Datenlöschung'),
        content: const Text(
          'Wie möchten Sie Ihre Daten löschen?\n\n'
          '• Anonymisierung: Ihre persönlichen Daten werden entfernt, '
          'aber Meldungen bleiben für die Gemeinde erhalten.\n\n'
          '• Vollständige Löschung: Alle Ihre Daten werden unwiderruflich gelöscht.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop('anonymize'),
            child: const Text('Anonymisieren'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop('delete'),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Vollständig löschen'),
          ),
        ],
      ),
    );

    if (choice == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bestätigung'),
        content: Text(
          choice == 'delete'
              ? 'Sind Sie sicher, dass Sie alle Ihre Daten unwiderruflich löschen möchten?'
              : 'Sind Sie sicher, dass Sie Ihre persönlichen Daten anonymisieren möchten?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Bestätigen'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final authService = ref.read(authServiceProvider);
      final success = await authService.deleteUserData(
        _currentUser!.id,
        fullDeletion: choice == 'delete',
      );
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              choice == 'delete' 
                ? 'Alle Daten wurden gelöscht' 
                : 'Daten wurden anonymisiert',
            ),
            backgroundColor: Colors.green,
          ),
        );
        
        if (choice == 'delete') {
          // Redirect to welcome page after full deletion
          context.go('/welcome');
        } else {
          // Update user state after anonymization
          await _loadCurrentUser();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler bei der Löschung: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
