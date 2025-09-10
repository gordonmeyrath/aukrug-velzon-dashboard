import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/color_extensions.dart';
import '../../../core/widgets/clean_app_scaffold.dart';
import '../../../core/widgets/loading_widget.dart';
import '../data/auth_service.dart';
import '../domain/user.dart';

/// DSGVO-konforme E-Mail Authentifizierung mit expliziter Einwilligung
class EmailAuthPage extends ConsumerStatefulWidget {
  const EmailAuthPage({super.key});

  @override
  ConsumerState<EmailAuthPage> createState() => _EmailAuthPageState();
}

class _EmailAuthPageState extends ConsumerState<EmailAuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isSignIn = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  // DSGVO Consent States
  bool _consentToDataProcessing = false;
  bool _consentToLocationProcessing = false;
  bool _consentToPhotoProcessing = false;
  final bool _allowReportSubmission = true; // Mindestvoraussetzung
  DataRetentionPeriod _dataRetentionPeriod = DataRetentionPeriod.oneYear;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: _isSignIn ? 'Anmelden' : 'Registrieren',
      body: _isLoading
          ? const LoadingWidget()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildAuthModeToggle(),
                    const SizedBox(height: 32),

                    _buildEmailField(),
                    const SizedBox(height: 16),

                    _buildPasswordField(),
                    const SizedBox(height: 16),

                    // Zusätzliche Felder für Registrierung
                    if (!_isSignIn) ...[
                      _buildDisplayNameField(),
                      const SizedBox(height: 16),

                      _buildPhoneField(),
                      const SizedBox(height: 24),

                      _buildDSGVOConsent(),
                      const SizedBox(height: 24),
                    ],

                    _buildSubmitButton(),
                    const SizedBox(height: 16),

                    _buildAnonymousOption(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAuthModeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton('Anmelden', _isSignIn, () {
              setState(() {
                _isSignIn = true;
              });
            }),
          ),
          Expanded(
            child: _buildToggleButton('Registrieren', !_isSignIn, () {
              setState(() {
                _isSignIn = false;
              });
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'E-Mail-Adresse',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Bitte geben Sie eine E-Mail-Adresse ein';
        }
        if (!value.contains('@') || !value.contains('.')) {
          return 'Bitte geben Sie eine gültige E-Mail-Adresse ein';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Passwort',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Bitte geben Sie ein Passwort ein';
        }
        if (!_isSignIn && value.length < 6) {
          return 'Passwort muss mindestens 6 Zeichen haben';
        }
        return null;
      },
    );
  }

  Widget _buildDisplayNameField() {
    return TextFormField(
      controller: _displayNameController,
      decoration: const InputDecoration(
        labelText: 'Anzeigename (optional)',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
        helperText: 'Wird für die Anzeige in der App verwendet',
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'Telefonnummer (optional)',
        prefixIcon: Icon(Icons.phone),
        border: OutlineInputBorder(),
        helperText: 'Für Rückfragen zu Ihren Meldungen',
      ),
    );
  }

  Widget _buildDSGVOConsent() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.privacy_tip, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'DSGVO-Einwilligung',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            'Bitte wählen Sie, welche Datenverarbeitungen Sie erlauben möchten:',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          // Pflicht-Consent
          _buildConsentCheckbox(
            value: _allowReportSubmission,
            title: 'Meldungen erstellen und übermitteln',
            subtitle: 'Erforderlich für die grundlegende App-Nutzung',
            required: true,
            onChanged: null, // Nicht änderbar
          ),

          // Optional Consents
          _buildConsentCheckbox(
            value: _consentToDataProcessing,
            title: 'Datenverarbeitung für erweiterte Funktionen',
            subtitle: 'Speicherung von Profildaten und Verlauf',
            required: false,
            onChanged: (value) {
              setState(() {
                _consentToDataProcessing = value ?? false;
              });
            },
          ),

          _buildConsentCheckbox(
            value: _consentToLocationProcessing,
            title: 'GPS-Standortverarbeitung',
            subtitle: 'Automatische Ortserfassung für Meldungen',
            required: false,
            onChanged: (value) {
              setState(() {
                _consentToLocationProcessing = value ?? false;
              });
            },
          ),

          _buildConsentCheckbox(
            value: _consentToPhotoProcessing,
            title: 'Foto-Verarbeitung',
            subtitle: 'Bearbeitung und Komprimierung von Bildern',
            required: false,
            onChanged: (value) {
              setState(() {
                _consentToPhotoProcessing = value ?? false;
              });
            },
          ),

          const SizedBox(height: 16),

          // Data Retention Period
          Text('Datenspeicherungsdauer:', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),

          DropdownButtonFormField<DataRetentionPeriod>(
            value: _dataRetentionPeriod,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: DataRetentionPeriod.values.map((period) {
              return DropdownMenuItem(
                value: period,
                child: Text(_getRetentionPeriodText(period)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _dataRetentionPeriod = value;
                });
              }
            },
          ),

          const SizedBox(height: 16),

          Text(
            'Sie können diese Einstellungen jederzeit in den App-Einstellungen ändern.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.alphaFrac(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentCheckbox({
    required bool value,
    required String title,
    required String subtitle,
    required bool required,
    ValueChanged<bool?>? onChanged,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(value: value, onChanged: required ? null : onChanged),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: required ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (required)
                  Text(
                    '(Erforderlich)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.alphaFrac(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return FilledButton.icon(
      onPressed: _handleSubmit,
      icon: Icon(_isSignIn ? Icons.login : Icons.person_add),
      label: Text(_isSignIn ? 'Anmelden' : 'Registrieren'),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildAnonymousOption() {
    return TextButton.icon(
      onPressed: () => context.pop(),
      icon: const Icon(Icons.visibility_off),
      label: const Text('Zurück zur anonymen Nutzung'),
    );
  }

  String _getRetentionPeriodText(DataRetentionPeriod period) {
    switch (period) {
      case DataRetentionPeriod.threeMonths:
        return '3 Monate';
      case DataRetentionPeriod.sixMonths:
        return '6 Monate';
      case DataRetentionPeriod.oneYear:
        return '1 Jahr';
      case DataRetentionPeriod.twoYears:
        return '2 Jahre';
      case DataRetentionPeriod.custom:
        return 'Benutzerdefiniert';
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_isSignIn && !_consentToDataProcessing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Für die Registrierung ist die Einwilligung zur Datenverarbeitung erforderlich',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);

      if (_isSignIn) {
        final user = await authService.signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (user != null) {
          ref.invalidate(currentUserProvider);
          if (mounted) {
            context.go('/reports');
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Anmeldung fehlgeschlagen. Prüfen Sie Ihre Eingaben.',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        // Registrierung
        final privacySettings = PrivacySettings(
          allowReportSubmission: _allowReportSubmission,
          consentToLocationProcessing: _consentToLocationProcessing,
          consentToPhotoProcessing: _consentToPhotoProcessing,
          allowLocationTracking: _consentToLocationProcessing,
          dataRetentionPeriod: _dataRetentionPeriod,
          consentGivenAt: DateTime.now(),
        );

        final user = await authService.registerWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _displayNameController.text.trim().isEmpty
              ? null
              : _displayNameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          privacySettings: privacySettings,
        );

        if (user != null) {
          ref.invalidate(currentUserProvider);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registrierung erfolgreich!'),
                backgroundColor: Colors.green,
              ),
            );
            context.go('/reports');
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registrierung fehlgeschlagen.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
