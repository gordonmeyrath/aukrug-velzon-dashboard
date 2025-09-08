import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/util/production_logger.dart';
import '../services/location_verification_service.dart';
import '../services/user_verification_service.dart';

/// DSGVO-konforme Bewohner-Verifikation UI mit Geolokalisierungs-Überwachung
/// Implementiert Privacy-by-Design mit transparenter Datenverarbeitung
/// Neue Features: 7-tägige Standort-Überwachung für automatische Verifikation
class ResidentVerificationPage extends ConsumerStatefulWidget {
  const ResidentVerificationPage({super.key});

  @override
  ConsumerState<ResidentVerificationPage> createState() =>
      _ResidentVerificationPageState();
}

class _ResidentVerificationPageState
    extends ConsumerState<ResidentVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _documentTypeController = TextEditingController();
  final _documentNumberController = TextEditingController();
  final _additionalInfoController = TextEditingController();

  bool _consentGiven = false;
  bool _locationConsentGiven = false; // Neue Einwilligung für Geolokalisierung
  bool _isSubmitting = false;
  bool _includeLocation = false;
  bool _enableLocationVerification =
      false; // Neue Option für automatische Verifikation
  bool _hasLocationPermission = false;
  Position? _currentLocation;

  late UserVerificationService _verificationService;
  late LocationVerificationService _locationService;

  @override
  void initState() {
    super.initState();
    _verificationService = UserVerificationService();
    _locationService = LocationVerificationService();
    _checkLocationPermission();

    // Zeige Verifikations-Information nach dem Build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showVerificationProcessInfo();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _zipController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _documentTypeController.dispose();
    _documentNumberController.dispose();
    _additionalInfoController.dispose();
    _verificationService.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        // Zeige Erklärung wenn Berechtigung verweigert wurde
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          _showLocationPermissionExplanation();
        }
      }

      setState(() {
        _hasLocationPermission =
            permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always;
      });
    } catch (e) {
      ProductionLogger.e('Error checking location permission: $e');
    }
  }

  /// Erklärt dem Benutzer warum Standort-Berechtigung benötigt wird
  void _showLocationPermissionExplanation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.location_on, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            const Text('Standort-Berechtigung'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Für die automatische Bewohner-Verifikation wird die Standort-Berechtigung benötigt:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('🌍 Nächtliche Standortprüfung (4/7 Nächte)'),
            const Text('🔒 Verschlüsselte Übertragung zum Server'),
            const Text('📍 Vergleich mit angegebener Adresse'),
            const Text('✅ Automatische Verifikation bei Erfolg'),
            const Text('🗑️ Sofortige Löschung nach Verifikation'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Text(
                'Ohne Standort-Berechtigung ist nur die Standard-Verifikation mit manueller Admin-Prüfung möglich.',
                style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Weiter ohne Standort'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Geolocator.openLocationSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Einstellungen öffnen'),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    if (!_hasLocationPermission) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = position;
      });
    } catch (e) {
      ProductionLogger.e('Error getting current location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Standort konnte nicht ermittelt werden: $e'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _submitVerification() async {
    if (!_formKey.currentState!.validate() || !_consentGiven) {
      return;
    }

    // Zusätzliche Validierung für Geolokalisierungs-Verifikation
    if (_enableLocationVerification &&
        (!_locationConsentGiven || !_hasLocationPermission)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '⚠️ Für die automatische Verifikation ist die Standort-Einwilligung erforderlich',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Standort abrufen wenn gewünscht
      if ((_includeLocation || _enableLocationVerification) &&
          _hasLocationPermission &&
          _currentLocation == null) {
        await _getCurrentLocation();
      }

      final verification = await _verificationService.startResidentVerification(
        userId: 'current_user_id', // TODO: Echte User-ID
        fullName: _nameController.text.trim(),
        address: _addressController.text.trim(),
        zipCode: _zipController.text.trim(),
        city: _cityController.text.trim(),
        phoneNumber: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        documentType: _documentTypeController.text.trim().isNotEmpty
            ? _documentTypeController.text.trim()
            : null,
        documentNumber: _documentNumberController.text.trim().isNotEmpty
            ? _documentNumberController.text.trim()
            : null,
        additionalInfo: _additionalInfoController.text.trim().isNotEmpty
            ? _additionalInfoController.text.trim()
            : null,
        latitude: (_includeLocation || _enableLocationVerification)
            ? _currentLocation?.latitude
            : null,
        longitude: (_includeLocation || _enableLocationVerification)
            ? _currentLocation?.longitude
            : null,
      );

      if (mounted) {
        // Unterschiedliche Nachrichten je nach Verifikationsmethode
        final message = _enableLocationVerification
            ? '🌍 Automatische Verifikation gestartet! Die App wird 7 Tage lang nächtlich Ihren Standort prüfen.'
            : '🏠 Verifikationsantrag erfolgreich eingereicht!';

        final snackBarColor = _enableLocationVerification
            ? Colors.blue
            : Colors.green;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: snackBarColor,
            duration: Duration(seconds: _enableLocationVerification ? 5 : 3),
          ),
        );

        // Zeige zusätzliche Informationen für Geolokalisierungs-Verifikation
        if (_enableLocationVerification) {
          _showLocationVerificationDialog();
        }

        // Navigate back or to status page
        Navigator.of(context).pop(verification);
      }
    } catch (e) {
      ProductionLogger.e('Error submitting verification: $e');
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

  /// Dialog mit Informationen zur Geolokalisierungs-Verifikation
  void _showLocationVerificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.schedule, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            const Text('Automatische Verifikation'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ihre 7-tägige Standort-Verifikation wurde gestartet:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('• Nächtliche Prüfung zwischen 00:00-04:00 Uhr'),
            const Text(
              '• Automatische Verifikation bei 4/7 erfolgreichen Nächten',
            ),
            const Text('• Benachrichtigung bei Abschluss der Verifikation'),
            const Text('• Alle Daten werden nach Verifikation gelöscht'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                'Tipp: Lassen Sie Ihr Gerät nachts an der angegebenen Adresse, damit die Verifikation erfolgreich verlaufen kann.',
                style: TextStyle(color: Colors.blue.shade700, fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }

  /// Zeigt ausführliche Information über den Verifikationsprozess
  /// WICHTIG: Wird beim Laden der Seite automatisch angezeigt
  /// OPTIONAL: Benutzer kann Dialog abweisen und App ohne Verifikation nutzen
  void _showVerificationProcessInfo() {
    showDialog(
      context: context,
      barrierDismissible: true, // Benutzer kann Dialog abweisen
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue.shade700, size: 28),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Bewohner-Verifikation: So funktioniert es',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Übersicht
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🎯 Warum Verifikation?',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ohne Verifikation gibt es Einschränkungen für Dienste, die nur für Bewohner der Gemeinde Aukrug bestimmt sind.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Automatische Verifikation (Empfohlen)
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.verified, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Automatische Verifikation (Empfohlen)',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '🌙 Wie funktioniert es?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '1. Sie geben Ihre Wohnadresse ein\n'
                        '2. Die App aktiviert eine 7-tägige Überwachung\n'
                        '3. Spontan in 4 von 7 Nächten (zwischen 00:00-04:00 Uhr) sendet Ihr Handy verschlüsselt den Standort an unseren Server\n'
                        '4. Der Server vergleicht Ihre Adresse mit den GPS-Koordinaten\n'
                        '5. Bei Erfolg werden Sie automatisch als Bewohner verifiziert\n'
                        '6. Alle Standortdaten werden sofort nach der Verifikation gelöscht',
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.security,
                              color: Colors.orange.shade700,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Wichtig: Die Standortübertragung erfolgt verschlüsselt und nur zur Verifikation!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
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
                const SizedBox(height: 16),

                // Standard-Verifikation
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.admin_panel_settings,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Standard-Verifikation',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Einmalige Standort-Freigabe\n'
                        '• Manuelle Prüfung durch Administrator\n'
                        '• Kann länger dauern\n'
                        '• Weniger automatisiert',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Datenschutz
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.privacy_tip,
                            color: Colors.purple.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Datenschutz & Sicherheit',
                            style: TextStyle(
                              color: Colors.purple.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '🔒 Verschlüsselung: Alle Standortdaten werden verschlüsselt übertragen\n'
                        '🗑️ Automatische Löschung: Daten werden nach Verifikation sofort entfernt\n'
                        '⏱️ Zeitbegrenzung: Maximum 7 Tage Speicherung\n'
                        '🎯 Zweckbindung: Nur für Bewohner-Verifikation verwendet\n'
                        '📋 DSGVO-konform: Vollständig datenschutzkonform',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Konsequenzen ohne Verifikation
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Ohne Verifikation: Einschränkungen',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '❌ Keine Nutzung bewohner-spezifischer Dienste\n'
                        '❌ Eingeschränkter Zugang zu Gemeinde-Features\n'
                        '❌ Keine Teilnahme an lokalen Abstimmungen\n'
                        '❌ Begrenzte Funktionalität der App',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Später',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Verstanden - Weiter zum Formular',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏠 Bewohner-Verifikation'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DSGVO-Information
              _buildPrivacyNotice(),
              const SizedBox(height: 24),

              // Persönliche Daten
              _buildPersonalDataSection(),
              const SizedBox(height: 24),

              // Adresse
              _buildAddressSection(),
              const SizedBox(height: 24),

              // Optionale Informationen
              _buildOptionalSection(),
              const SizedBox(height: 24),

              // Standort-Freigabe
              _buildLocationSection(),
              const SizedBox(height: 24),

              // Einwilligung
              _buildConsentSection(),
              const SizedBox(height: 32),

              // Submit Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyNotice() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.privacy_tip, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Datenschutz & Privatsphäre',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Diese Bewohner-Verifikation erfolgt DSGVO-konform:',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Ihre Daten werden verschlüsselt gespeichert\n'
              '• Automatische Löschung nach 7 Tagen ohne Verifikation\n'
              '• Nur notwendige Daten für die Bewohner-Bestätigung\n'
              '• Vollständige Kontrolle über Ihre Einwilligungen\n'
              '• Jederzeit widerrufbar (Recht auf Vergessenwerden)',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),

            // Wichtiger Hinweis zu Einschränkungen
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.orange.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Wichtiger Hinweis',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ohne erfolgreiche Bewohner-Verifikation gibt es Einschränkungen bei Diensten, die nur für Bürger der Gemeinde Aukrug bestimmt sind.',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalDataSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Persönliche Daten',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Vollständiger Name *',
                hintText: 'Max Mustermann',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name ist erforderlich';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Telefonnummer (optional)',
                hintText: '+49 123 456789',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wohnadresse in Aukrug',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Straße und Hausnummer *',
                hintText: 'Musterstraße 123',
                prefixIcon: Icon(Icons.home),
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
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _zipController,
                    decoration: const InputDecoration(
                      labelText: 'PLZ *',
                      hintText: '24613',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(5),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'PLZ erforderlich';
                      }
                      if (!value.startsWith('24613')) {
                        return 'Muss Aukrug PLZ sein';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'Ort *',
                      hintText: 'Aukrug',
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
          ],
        ),
      ),
    );
  }

  Widget _buildOptionalSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Optionale Angaben',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Diese Angaben können die Verifikation beschleunigen',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _documentTypeController,
              decoration: const InputDecoration(
                labelText: 'Ausweisart (optional)',
                hintText: 'Personalausweis, Reisepass, etc.',
                prefixIcon: Icon(Icons.credit_card),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _documentNumberController,
              decoration: const InputDecoration(
                labelText: 'Ausweisnummer (optional)',
                hintText: 'Letzten 4 Ziffern oder Kennzeichen',
                prefixIcon: Icon(Icons.confirmation_number),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _additionalInfoController,
              decoration: const InputDecoration(
                labelText: 'Zusätzliche Informationen (optional)',
                hintText: 'Weitere Angaben zur Unterstützung der Verifikation',
                prefixIcon: Icon(Icons.note),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Standort-Verifikation',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Wählen Sie Ihre Verifikationsmethode:',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 16),

            // Standard Standort-Freigabe
            SwitchListTile(
              title: const Text('Einmalige Standort-Freigabe'),
              subtitle: Text(
                _hasLocationPermission
                    ? 'Berechtigung erteilt - Standort kann abgerufen werden'
                    : 'Standortberechtigung erforderlich',
                style: TextStyle(
                  color: _hasLocationPermission ? Colors.green : Colors.orange,
                ),
              ),
              value:
                  _includeLocation &&
                  _hasLocationPermission &&
                  !_enableLocationVerification,
              onChanged: _hasLocationPermission
                  ? (value) {
                      setState(() {
                        _includeLocation = value;
                        if (value) _enableLocationVerification = false;
                      });
                      if (value) _getCurrentLocation();
                    }
                  : null,
              secondary: Icon(
                _hasLocationPermission ? Icons.location_on : Icons.location_off,
                color: _hasLocationPermission ? Colors.green : Colors.grey,
              ),
            ),

            const Divider(),

            // Neue automatische Geolokalisierungs-Verifikation
            Card(
              color: Colors.blue.shade50,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.verified,
                          color: Colors.blue.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Automatische Verifikation (Empfohlen)',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '7-tägige Standort-Überwachung für automatische Bewohner-Verifikation',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        '7-Tage Standort-Verifikation aktivieren',
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• Nächtliche Standortprüfung (00:00-04:00 Uhr)',
                          ),
                          const Text(
                            '• Automatische Verifikation bei 4/7 erfolgreichen Nächten',
                          ),
                          const Text(
                            '• Daten werden nach Verifikation gelöscht',
                          ),
                          if (_enableLocationVerification)
                            const Text(
                              '⚠️ Standort-Überwachung für eine Woche erforderlich',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                      value:
                          _enableLocationVerification && _hasLocationPermission,
                      onChanged: _hasLocationPermission
                          ? (value) {
                              setState(() {
                                _enableLocationVerification = value;
                                _locationConsentGiven =
                                    value; // Automatische Einwilligung
                                if (value) {
                                  _includeLocation =
                                      true; // Aktiviere auch einmalige Standort-Erfassung
                                  _getCurrentLocation();
                                }
                              });
                            }
                          : null,
                      secondary: Icon(
                        Icons.schedule,
                        color: _enableLocationVerification
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                    if (_enableLocationVerification) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: Colors.orange.shade700,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Die App prüft jede Nacht zwischen 00:00-04:00 Uhr Ihren Standort. '
                                'Bei 4 von 7 erfolgreichen Prüfungen werden Sie automatisch verifiziert.',
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            if (_includeLocation && _currentLocation != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade700,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '📍 Standort erfasst: ${_currentLocation!.latitude.toStringAsFixed(6)}, ${_currentLocation!.longitude.toStringAsFixed(6)}',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (!_hasLocationPermission) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Standortberechtigung erforderlich',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Für die automatische Verifikation muss der Standort-Zugriff erlaubt werden.',
                            style: TextStyle(
                              color: Colors.red.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _checkLocationPermission,
                icon: const Icon(Icons.location_on),
                label: const Text('Standort-Berechtigung prüfen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConsentSection() {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Einwilligung zur Datenverarbeitung',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text(
                'Ich willige in die Verarbeitung meiner Daten zur Bewohner-Verifikation ein',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: const Text(
                'Ihre Daten werden ausschließlich zur Bestätigung Ihres Wohnsitzes in Aukrug verwendet und nach spätestens 7 Tagen automatisch gelöscht, falls keine Verifikation erfolgt.',
                style: TextStyle(fontSize: 12),
              ),
              value: _consentGiven,
              onChanged: (value) {
                setState(() {
                  _consentGiven = value ?? false;
                });
              },
              activeColor: Colors.green.shade700,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 8),
            Text(
              '✓ DSGVO-konforme Verarbeitung\n'
              '✓ Jederzeit widerrufbar\n'
              '✓ Transparente Datennutzung\n'
              '✓ Automatische Löschung',
              style: TextStyle(color: Colors.green.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: (_consentGiven && !_isSubmitting)
            ? _submitVerification
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                '🏠 Verifikation einreichen',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
