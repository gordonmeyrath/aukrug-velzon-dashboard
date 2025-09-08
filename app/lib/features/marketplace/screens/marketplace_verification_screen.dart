import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/marketplace_models.dart';
import '../controllers/marketplace_controller.dart';
import '../../auth/data/auth_service.dart';

class MarketplaceVerificationScreen extends ConsumerStatefulWidget {
  const MarketplaceVerificationScreen({super.key});

  @override
  ConsumerState<MarketplaceVerificationScreen> createState() =>
      _MarketplaceVerificationScreenState();
}

class _MarketplaceVerificationScreenState
    extends ConsumerState<MarketplaceVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _businessNumberController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _notesController = TextEditingController();

  String _requestedStatus = 'resident';
  File? _idDocument;
  File? _proofOfResidence;
  File? _businessDocument;
  bool _acceptsTerms = false;
  bool _acceptsDataProcessing = false;
  bool _isSubmitting = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _businessNameController.dispose();
    _businessNumberController.dispose();
    _businessAddressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check current verification status
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifizierung beantragen'),
        elevation: 0,
      ),
      body: currentUserAsync.when(
        data: (user) {
          if (user == null) {
            return _buildLoginRequired(context);
          }

          return _buildVerificationForm(context);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildError(context, error),
      ),
    );
  }

  Widget _buildLoginRequired(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Anmeldung erforderlich',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Sie müssen angemeldet sein, um eine Verifizierung zu beantragen.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Navigate to login screen
                Navigator.of(context).pushReplacementNamed('/auth/login');
              },
              child: const Text('Anmelden'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Fehler beim Laden',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(currentUserProvider);
              },
              child: const Text('Erneut versuchen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildInfoCard(context),
                const SizedBox(height: 24),
                _buildVerificationTypeSelector(context),
                const SizedBox(height: 24),
                _buildPersonalDataSection(context),
                if (_requestedStatus == 'business') ...[
                  const SizedBox(height: 24),
                  _buildBusinessDataSection(context),
                ],
                const SizedBox(height: 24),
                _buildDocumentSection(context),
                const SizedBox(height: 24),
                _buildNotesSection(context),
                const SizedBox(height: 24),
                _buildConsentSection(context),
                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Verifizierung beantragen',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Mit einer Verifizierung erhöhen Sie das Vertrauen anderer Nutzer '
              'und erhalten erweiterte Funktionen im Marktplatz. Die Prüfung '
              'erfolgt manuell durch unser Team und dauert in der Regel 2-3 Werktage.',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.security, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Ihre Daten werden vertraulich behandelt und nur zur Verifizierung verwendet.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationTypeSelector(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Art der Verifizierung',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            RadioListTile<String>(
              value: 'resident',
              groupValue: _requestedStatus,
              onChanged: (value) {
                setState(() {
                  _requestedStatus = value!;
                });
              },
              title: const Text('Anwohner'),
              subtitle: const Text(
                'Ich wohne in Aukrug und möchte als Anwohner verifiziert werden.',
              ),
              contentPadding: EdgeInsets.zero,
            ),

            RadioListTile<String>(
              value: 'business',
              groupValue: _requestedStatus,
              onChanged: (value) {
                setState(() {
                  _requestedStatus = value!;
                });
              },
              title: const Text('Lokales Unternehmen'),
              subtitle: const Text(
                'Ich vertrete ein lokales Unternehmen in Aukrug oder Umgebung.',
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalDataSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Persönliche Daten',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'Vorname *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vorname ist erforderlich';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nachname *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nachname ist erforderlich';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Straße und Hausnummer *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Adresse ist erforderlich';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                SizedBox(
                  width: 120,
                  child: TextFormField(
                    controller: _postalCodeController,
                    decoration: const InputDecoration(
                      labelText: 'PLZ *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'PLZ erforderlich';
                      }
                      if (value.length != 5 || int.tryParse(value) == null) {
                        return 'Ungültige PLZ';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'Ort *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ort ist erforderlich';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Telefonnummer',
                border: OutlineInputBorder(),
                helperText:
                    'Optional, aber empfohlen für eine schnellere Bearbeitung',
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessDataSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unternehmensdaten',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _businessNameController,
              decoration: const InputDecoration(
                labelText: 'Firmenname *',
                border: OutlineInputBorder(),
              ),
              validator: _requestedStatus == 'business'
                  ? (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Firmenname ist erforderlich';
                      }
                      return null;
                    }
                  : null,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _businessNumberController,
              decoration: const InputDecoration(
                labelText: 'Handelsregisternummer / Steuernummer',
                border: OutlineInputBorder(),
                helperText: 'Falls vorhanden',
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _businessAddressController,
              decoration: const InputDecoration(
                labelText: 'Geschäftsadresse',
                border: OutlineInputBorder(),
                helperText: 'Falls abweichend von der Privatadresse',
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dokumente',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Bitte laden Sie die erforderlichen Dokumente hoch. Alle persönlichen '
              'Daten außer Name und Adresse können geschwärzt werden.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            // ID Document
            _buildDocumentUpload(
              context,
              title: 'Personalausweis / Reisepass *',
              subtitle: 'Vorder- und Rückseite',
              document: _idDocument,
              onTap: () => _pickDocument('id'),
              isRequired: true,
            ),

            const SizedBox(height: 16),

            // Proof of residence
            _buildDocumentUpload(
              context,
              title: 'Wohnsitznachweis *',
              subtitle: 'Meldebescheinigung, Energierechnung o.Ä.',
              document: _proofOfResidence,
              onTap: () => _pickDocument('residence'),
              isRequired: true,
            ),

            if (_requestedStatus == 'business') ...[
              const SizedBox(height: 16),
              _buildDocumentUpload(
                context,
                title: 'Gewerbeanmeldung / Handelsregisterauszug',
                subtitle: 'Nachweis der Geschäftstätigkeit',
                document: _businessDocument,
                onTap: () => _pickDocument('business'),
                isRequired: false,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentUpload(
    BuildContext context, {
    required String title,
    required String subtitle,
    required File? document,
    required VoidCallback onTap,
    required bool isRequired,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isRequired && document == null
              ? Colors.red[300]!
              : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: document != null
                ? Colors.green.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            document != null ? Icons.check_circle : Icons.upload_file,
            color: document != null ? Colors.green : Colors.grey[600],
          ),
        ),
        title: Text(title),
        subtitle: Text(document != null ? 'Dokument hochgeladen' : subtitle),
        trailing: document != null
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    if (title.contains('Personalausweis')) {
                      _idDocument = null;
                    } else if (title.contains('Wohnsitznachweis')) {
                      _proofOfResidence = null;
                    } else if (title.contains('Gewerbeanmeldung')) {
                      _businessDocument = null;
                    }
                  });
                },
              )
            : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Zusätzliche Informationen',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Anmerkungen',
                border: OutlineInputBorder(),
                helperText:
                    'Optional: Zusätzliche Informationen zur Verifizierung',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsentSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Einverständniserklärung',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            CheckboxListTile(
              value: _acceptsTerms,
              onChanged: (value) {
                setState(() {
                  _acceptsTerms = value ?? false;
                });
              },
              title: const Text('Nutzungsbedingungen akzeptieren'),
              subtitle: const Text(
                'Ich habe die Nutzungsbedingungen gelesen und akzeptiere sie.',
              ),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),

            CheckboxListTile(
              value: _acceptsDataProcessing,
              onChanged: (value) {
                setState(() {
                  _acceptsDataProcessing = value ?? false;
                });
              },
              title: const Text('Datenverarbeitung zustimmen'),
              subtitle: const Text(
                'Ich stimme der Verarbeitung meiner Daten zur Verifizierung zu. '
                'Die Daten werden nach der Prüfung gelöscht.',
              ),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    final canSubmit =
        _formKey.currentState?.validate() == true &&
        _idDocument != null &&
        _proofOfResidence != null &&
        _acceptsTerms &&
        _acceptsDataProcessing &&
        (_requestedStatus != 'business' ||
            _businessNameController.text.trim().isNotEmpty);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canSubmit && !_isSubmitting ? _submitVerification : null,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Verifizierung beantragen'),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDocument(String type) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          switch (type) {
            case 'id':
              _idDocument = File(image.path);
              break;
            case 'residence':
              _proofOfResidence = File(image.path);
              break;
            case 'business':
              _businessDocument = File(image.path);
              break;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Auswählen des Dokuments: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _submitVerification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Mock submission for now - this would integrate with the actual API
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verifizierungsantrag erfolgreich eingereicht!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Einreichen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
