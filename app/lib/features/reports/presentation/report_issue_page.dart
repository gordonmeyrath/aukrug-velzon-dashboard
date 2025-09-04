import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../localization/app_localizations.dart';

// Report categories
enum ReportCategory {
  infrastructure,
  environment,
  safety,
  lighting,
  cleanliness,
  other;

  String get displayName {
    switch (this) {
      case ReportCategory.infrastructure:
        return 'Infrastruktur';
      case ReportCategory.environment:
        return 'Umwelt';
      case ReportCategory.safety:
        return 'Sicherheit';
      case ReportCategory.lighting:
        return 'Beleuchtung';
      case ReportCategory.cleanliness:
        return 'Sauberkeit';
      case ReportCategory.other:
        return 'Sonstiges';
    }
  }

  IconData get icon {
    switch (this) {
      case ReportCategory.infrastructure:
        return Icons.construction;
      case ReportCategory.environment:
        return Icons.park;
      case ReportCategory.safety:
        return Icons.security;
      case ReportCategory.lighting:
        return Icons.lightbulb;
      case ReportCategory.cleanliness:
        return Icons.cleaning_services;
      case ReportCategory.other:
        return Icons.report_problem;
    }
  }
}

class ReportIssuePage extends ConsumerStatefulWidget {
  const ReportIssuePage({super.key});

  @override
  ConsumerState<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends ConsumerState<ReportIssuePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  ReportCategory _selectedCategory = ReportCategory.infrastructure;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.report),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showHelpDialog(context);
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kategorie auswählen',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ReportCategory.values.map((category) {
                        final isSelected = _selectedCategory == category;
                        return FilterChip(
                          selected: isSelected,
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                category.icon,
                                size: 18,
                                color: isSelected 
                                    ? Theme.of(context).colorScheme.onSecondaryContainer
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Text(category.displayName),
                            ],
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Beschreibung des Problems',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Titel (kurze Zusammenfassung)',
                        border: OutlineInputBorder(),
                        hintText: 'z.B. Schlagloch auf Hauptstraße',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Bitte geben Sie einen Titel ein';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Detaillierte Beschreibung',
                        border: OutlineInputBorder(),
                        hintText: 'Beschreiben Sie das Problem genauer...',
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Bitte geben Sie eine Beschreibung ein';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Standort',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Adresse oder Beschreibung des Ortes',
                        border: OutlineInputBorder(),
                        hintText: 'z.B. Hauptstraße 15 oder "vor dem Rathaus"',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Bitte geben Sie den Standort an';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement GPS location
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('GPS-Standort wird in einer späteren Version implementiert'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.my_location),
                      label: const Text('Aktuellen Standort verwenden'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fotos hinzufügen (optional)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement camera/gallery
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Foto-Upload wird in einer späteren Version implementiert'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Foto aufnehmen'),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement gallery picker
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Galerie-Auswahl wird in einer späteren Version implementiert'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Aus Galerie wählen'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            FilledButton(
              onPressed: _isSubmitting ? null : _submitReport,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Meldung absenden'),
            ),

            const SizedBox(height: 16),

            Text(
              'Ihre Meldung wird an die zuständige Stelle weitergeleitet. Sie erhalten eine Bestätigung mit einer Referenznummer.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO: Implement actual submission to backend
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Senden: $e'),
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 48,
        ),
        title: const Text('Meldung eingegangen'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ihre Meldung wurde erfolgreich übermittelt.'),
            SizedBox(height: 16),
            Text(
              'Referenznummer: AUK-2025-001',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Sie erhalten in Kürze eine Bestätigung per E-Mail. Die Bearbeitung dauert in der Regel 3-5 Werktage.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hilfe zum Mängelmelder'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Was kann gemeldet werden?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Schäden an Straßen und Gehwegen\n'
                   '• Defekte Straßenbeleuchtung\n'
                   '• Probleme mit Grünflächen\n'
                   '• Sicherheitsmängel\n'
                   '• Verschmutzungen im öffentlichen Raum'),
              SizedBox(height: 16),
              Text(
                'Notfälle',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Bei akuten Gefahren wenden Sie sich bitte direkt an:\n'
                   '• Feuerwehr/Rettung: 112\n'
                   '• Polizei: 110\n'
                   '• Gemeindeverwaltung: 04391 599-0'),
            ],
          ),
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
}
