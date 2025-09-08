import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/feedback_service.dart';
import '../../../../core/theme/color_extensions.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../domain/user.dart';
import 'controllers/privacy_settings_controller.dart';

/// DSGVO-konforme Privacy Settings Page
/// Entkoppelt UI (ConsumerWidget) von Business-Logik (StateNotifier)
class PrivacySettingsPage extends ConsumerWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(privacySettingsControllerProvider);
    final user = state.user;

    return AppScaffold(
      title: 'Datenschutz-Einstellungen',
      body: state.loading && user == null
          ? const Center(child: CircularProgressIndicator())
          : user == null
          ? const Center(child: Text('Kein Benutzer angemeldet'))
          : RefreshIndicator(
              onRefresh: () async =>
                  ref.read(privacySettingsControllerProvider.notifier).reload(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPrivacyHeader(context, user),
                    const SizedBox(height: 24),
                    _buildConsentSection(context, ref, user, state.loading),
                    const SizedBox(height: 24),
                    _buildDataProcessingSection(
                      context,
                      ref,
                      user,
                      state.loading,
                    ),
                    const SizedBox(height: 24),
                    _buildDataRetentionSection(
                      context,
                      ref,
                      user,
                      state.loading,
                    ),
                    const SizedBox(height: 24),
                    _buildUserRightsSection(context, ref, user, state.loading),
                    const SizedBox(height: 24),
                    _buildLegalLinksSection(context),
                    if (state.error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        state.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}

// --- Header ---------------------------------------------------------------
Widget _buildPrivacyHeader(BuildContext context, User user) {
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
            Icon(Icons.security, color: theme.colorScheme.primary, size: 24),
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
        if (user.privacySettings.consentGivenAt != null) ...[
          const SizedBox(height: 8),
          Text(
            'Letzter Consent: ${_formatDateTime(user.privacySettings.consentGivenAt!)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.alphaFrac(0.7),
            ),
          ),
        ],
      ],
    ),
  );
}

// --- Sections -------------------------------------------------------------
Widget _buildConsentSection(
  BuildContext context,
  WidgetRef ref,
  User user,
  bool loading,
) {
  final settings = user.privacySettings;
  return _buildSection(
    context: context,
    title: 'Einwilligungen',
    icon: Icons.check_circle,
    children: [
      _buildSwitchTile(
        title: 'Standortverarbeitung',
        subtitle: 'GPS-Daten für automatische Ortserfassung',
        value: settings.consentToLocationProcessing,
        onChanged: loading
            ? null
            : (v) async => _feedback(
                context,
                await ref
                    .read(privacySettingsControllerProvider.notifier)
                    .updateSetting('consentToLocationProcessing', v),
              ),
      ),
      _buildSwitchTile(
        title: 'Foto-Verarbeitung',
        subtitle: 'Bildbearbeitung und Komprimierung',
        value: settings.consentToPhotoProcessing,
        onChanged: loading
            ? null
            : (v) async => _feedback(
                context,
                await ref
                    .read(privacySettingsControllerProvider.notifier)
                    .updateSetting('consentToPhotoProcessing', v),
              ),
      ),
      _buildSwitchTile(
        title: 'E-Mail Kontakt',
        subtitle: 'Erlaubnis für E-Mail-Kontakt von der Gemeinde',
        value: settings.allowEmailContact,
        onChanged: loading
            ? null
            : (v) async => _feedback(
                context,
                await ref
                    .read(privacySettingsControllerProvider.notifier)
                    .updateSetting('allowEmailContact', v),
              ),
      ),
      _buildSwitchTile(
        title: 'Telefon Kontakt',
        subtitle: 'Erlaubnis für telefonischen Kontakt',
        value: settings.allowPhoneContact,
        onChanged: loading
            ? null
            : (v) async => _feedback(
                context,
                await ref
                    .read(privacySettingsControllerProvider.notifier)
                    .updateSetting('allowPhoneContact', v),
              ),
      ),
    ],
  );
}

Widget _buildDataProcessingSection(
  BuildContext context,
  WidgetRef ref,
  User user,
  bool loading,
) {
  final theme = Theme.of(context);
  final settings = user.privacySettings;
  return _buildSection(
    context: context,
    title: 'Datenverarbeitung',
    icon: Icons.data_usage,
    children: [
      _buildInfoTile(
        context: context,
        title: 'Meldungen erstellen',
        subtitle: 'Erforderlich für grundlegende App-Funktionen',
        value: 'Aktiviert (Erforderlich)',
        trailing: Icon(Icons.lock, color: theme.colorScheme.primary, size: 20),
      ),
      _buildSwitchTile(
        title: 'Standort-Tracking',
        subtitle: 'Kontinuierliche GPS-Erfassung für Meldungen',
        value: settings.allowLocationTracking,
        onChanged: loading
            ? null
            : (v) async => _feedback(
                context,
                await ref
                    .read(privacySettingsControllerProvider.notifier)
                    .updateSetting('allowLocationTracking', v),
              ),
      ),
      _buildSwitchTile(
        title: 'Nutzungsanalyse',
        subtitle: 'Anonyme Analyse zur App-Verbesserung',
        value: settings.allowUsageAnalytics,
        onChanged: loading
            ? null
            : (v) async => _feedback(
                context,
                await ref
                    .read(privacySettingsControllerProvider.notifier)
                    .updateSetting('allowUsageAnalytics', v),
              ),
      ),
      _buildSwitchTile(
        title: 'Personalisierung',
        subtitle: 'Anpassung der App an Ihre Präferenzen',
        value: settings.allowPersonalization,
        onChanged: loading
            ? null
            : (v) async => _feedback(
                context,
                await ref
                    .read(privacySettingsControllerProvider.notifier)
                    .updateSetting('allowPersonalization', v),
              ),
      ),
    ],
  );
}

Widget _buildDataRetentionSection(
  BuildContext context,
  WidgetRef ref,
  User user,
  bool loading,
) {
  final settings = user.privacySettings;
  return _buildSection(
    context: context,
    title: 'Datenspeicherung',
    icon: Icons.storage,
    children: [
      ListTile(
        title: const Text('Aufbewahrungsdauer'),
        subtitle: const Text('Wie lange sollen Ihre Daten gespeichert werden?'),
        trailing: DropdownButton<DataRetentionPeriod>(
          value: settings.dataRetentionPeriod,
          onChanged: loading
              ? null
              : (value) async {
                  if (value != null) {
                    _feedback(
                      context,
                      await ref
                          .read(privacySettingsControllerProvider.notifier)
                          .updateSetting('dataRetentionPeriod', value),
                    );
                  }
                },
          items: DataRetentionPeriod.values
              .map(
                (p) => DropdownMenuItem(value: p, child: Text(p.displayName)),
              )
              .toList(),
        ),
      ),
      _buildSwitchTile(
        title: 'Automatische Löschung alter Meldungen',
        subtitle: 'Meldungen nach Ablauf der Frist automatisch löschen',
        value: settings.autoDeleteOldReports,
        onChanged: loading
            ? null
            : (v) async => _feedback(
                context,
                await ref
                    .read(privacySettingsControllerProvider.notifier)
                    .updateSetting('autoDeleteOldReports', v),
              ),
      ),
      _buildSwitchTile(
        title: 'Anonymisierung alter Daten',
        subtitle: 'Persönliche Daten anonymisieren statt löschen',
        value: settings.anonymizeOldData,
        onChanged: loading
            ? null
            : (v) async => _feedback(
                context,
                await ref
                    .read(privacySettingsControllerProvider.notifier)
                    .updateSetting('anonymizeOldData', v),
              ),
      ),
    ],
  );
}

Widget _buildUserRightsSection(
  BuildContext context,
  WidgetRef ref,
  User user,
  bool loading,
) {
  final theme = Theme.of(context);
  final settings = user.privacySettings;
  return _buildSection(
    context: context,
    title: 'Ihre DSGVO-Rechte',
    icon: Icons.gavel,
    children: [
      _buildActionTile(
        context: context,
        title: 'Datenexport anfordern',
        subtitle: 'Alle Ihre Daten in maschinenlesbarer Form herunterladen',
        actionText: 'Export',
        lastAction: settings.lastDataExportRequest,
        isDestructive: false,
        onTap: loading
            ? null
            : () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Datenexport'),
                    content: const Text(
                      'Möchten Sie alle Ihre gespeicherten Daten exportieren? Der Export wird als JSON-Datei bereitgestellt.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(c).pop(false),
                        child: const Text('Abbrechen'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(c).pop(true),
                        child: const Text('Exportieren'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  final ok = await ref
                      .read(privacySettingsControllerProvider.notifier)
                      .requestExport();
                  _feedback(
                    context,
                    ok,
                    success: 'Datenexport wurde erstellt',
                    failure: 'Fehler beim Export',
                  );
                }
              },
      ),
      _buildActionTile(
        context: context,
        title: 'Datenlöschung beantragen',
        subtitle: 'Ihre persönlichen Daten löschen lassen',
        actionText: 'Löschen',
        lastAction: settings.lastDataDeletionRequest,
        isDestructive: true,
        onTap: loading
            ? null
            : () async {
                final choice = await _dialogDeletionChoice(context);
                if (choice == null) return;
                final confirmed = await _dialogDeletionConfirm(
                  context,
                  choice == 'delete',
                );
                if (confirmed != true) return;
                final (success, navigate) = await ref
                    .read(privacySettingsControllerProvider.notifier)
                    .requestDeletion(fullDeletion: choice == 'delete');
                if (success) {
                  FeedbackService.showSuccess(
                    context,
                    choice == 'delete'
                        ? 'Alle Daten wurden gelöscht'
                        : 'Daten wurden anonymisiert',
                  );
                  if (navigate && context.mounted) context.go('/welcome');
                } else {
                  FeedbackService.showError(context, 'Fehler bei der Löschung');
                }
              },
      ),
      _buildInfoTile(
        context: context,
        title: 'Datenberichtigung',
        subtitle: 'Ändern Sie Ihre Daten in den Profileinstellungen',
        value: 'Verfügbar',
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => context.push('/profile'),
        ),
      ),
      _buildInfoTile(
        context: context,
        title: 'Datenübertragbarkeit',
        subtitle: 'Ihre Daten an andere Dienste übertragen',
        value: 'JSON/CSV Export',
        trailing: Icon(Icons.download, color: theme.colorScheme.primary),
      ),
    ],
  );
}

Widget _buildLegalLinksSection(BuildContext context) {
  return _buildSection(
    context: context,
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

// --- Generic Building Blocks ---------------------------------------------
Widget _buildSection({
  required BuildContext context,
  required String title,
  required IconData icon,
  required List<Widget> children,
}) {
  final theme = Theme.of(context);
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: theme.colorScheme.outline.alphaFrac(0.3)),
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
  required ValueChanged<bool>? onChanged,
}) => SwitchListTile(
  title: Text(title),
  subtitle: Text(subtitle),
  value: value,
  onChanged: onChanged,
);

Widget _buildInfoTile({
  required BuildContext context,
  required String title,
  required String subtitle,
  required String value,
  Widget? trailing,
}) {
  final theme = Theme.of(context);
  return ListTile(
    title: Text(title),
    subtitle: Text(subtitle),
    trailing:
        trailing ??
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
  );
}

Widget _buildActionTile({
  required BuildContext context,
  required String title,
  required String subtitle,
  required String actionText,
  required VoidCallback? onTap,
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
              color: theme.colorScheme.onSurface.alphaFrac(0.6),
            ),
          ),
      ],
    ),
    trailing: ElevatedButton(
      onPressed: onTap,
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
}) => ListTile(
  title: Text(title),
  subtitle: Text(subtitle),
  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  onTap: onTap,
);

// --- Dialogs & Feedback ---------------------------------------------------
Future<String?> _dialogDeletionChoice(
  BuildContext context,
) => showDialog<String>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Datenlöschung'),
    content: const Text(
      'Wie möchten Sie Ihre Daten löschen?\n\n'
      '• Anonymisierung: Ihre persönlichen Daten werden entfernt, aber Meldungen bleiben für die Gemeinde erhalten.\n\n'
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

Future<bool?> _dialogDeletionConfirm(
  BuildContext context,
  bool full,
) => showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Bestätigung'),
    content: Text(
      full
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

void _feedback(
  BuildContext context,
  bool ok, {
  String success = 'Einstellungen gespeichert',
  String failure = 'Fehler beim Speichern',
}) {
  if (ok) {
    FeedbackService.showSuccess(context, success);
  } else {
    FeedbackService.showError(context, failure);
  }
}

String _formatDateTime(DateTime dateTime) =>
    '${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
