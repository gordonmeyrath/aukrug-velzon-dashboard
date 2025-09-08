import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/color_extensions.dart';
import '../../../core/services/location_service.dart';
import '../../../core/widgets/photo_attachment_widget.dart';
import '../../../localization/app_localizations.dart';
import '../../map/presentation/widgets/aukrug_map.dart';
import '../../map/presentation/widgets/map_marker_factory.dart';
import '../domain/report.dart';
import 'reports_provider.dart';

/// Helper extension to get icons for report categories
extension ReportCategoryExtension on ReportCategory {
  IconData get icon {
    switch (this) {
      case ReportCategory.roadsTraffic:
        return Icons.directions_car;
      case ReportCategory.publicLighting:
        return Icons.lightbulb;
      case ReportCategory.wasteManagement:
        return Icons.delete;
      case ReportCategory.parksGreenSpaces:
        return Icons.park;
      case ReportCategory.waterDrainage:
        return Icons.water_drop;
      case ReportCategory.publicFacilities:
        return Icons.domain;
      case ReportCategory.vandalism:
        return Icons.report_problem;
      case ReportCategory.environmental:
        return Icons.eco;
      case ReportCategory.accessibility:
        return Icons.accessible;
      case ReportCategory.other:
        return Icons.help_outline;
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
  final _contactNameController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactPhoneController = TextEditingController();

  ReportCategory _selectedCategory = ReportCategory.roadsTraffic;
  ReportPriority _selectedPriority = ReportPriority.medium;
  bool _isSubmitting = false;

  // Location selection
  LatLng? _selectedLocation;
  bool _showLocationMap = false;
  bool _isLoadingLocation = false;

  // Photo attachments
  final List<File> _selectedPhotos = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _contactNameController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.report),
        automaticallyImplyLeading: false, // Da bereits in AppShell
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
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.onSecondaryContainer
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
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
                      'Priorität',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ReportPriority.values.map((priority) {
                        final isSelected = _selectedPriority == priority;
                        return FilterChip(
                          selected: isSelected,
                          label: Text(priority.displayName),
                          backgroundColor: isSelected
                              ? _getPriorityColor(priority).alphaFrac(0.3)
                              : null,
                          selectedColor: _getPriorityColor(
                            priority,
                          ).alphaFrac(0.5),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedPriority = priority;
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
                      onPressed: _isLoadingLocation
                          ? null
                          : _getCurrentLocation,
                      icon: _isLoadingLocation
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location),
                      label: Text(
                        _isLoadingLocation
                            ? 'GPS wird ermittelt...'
                            : 'Aktuellen Standort verwenden',
                      ),
                    ),

                    const SizedBox(height: 8),

                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showLocationMap = !_showLocationMap;
                        });
                      },
                      icon: Icon(
                        _showLocationMap ? Icons.keyboard_arrow_up : Icons.map,
                      ),
                      label: Text(
                        _showLocationMap
                            ? 'Karte ausblenden'
                            : 'Auf Karte auswählen',
                      ),
                    ),

                    // Map for location selection
                    if (_showLocationMap) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 220,
                        child: AukrugMap(
                          center: _selectedLocation,
                          markers: _selectedLocation != null
                              ? [
                                  MapMarkerFactory.createLocationMarker(
                                    _selectedLocation!,
                                    label: 'Standort',
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    icon: Icons.location_on,
                                  ),
                                ]
                              : const [],
                          showUserLocation: true,
                          onMapTap: (latLng) {
                            setState(() {
                              _selectedLocation = latLng;
                              _locationController.text =
                                  'Ausgewählter Standort: ${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)}';
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tippen Sie auf die Karte, um einen Standort auszuwählen',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
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
                      'Kontaktinformationen (optional)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Für Rückfragen und Status-Updates',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _contactNameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _contactEmailController,
                      decoration: const InputDecoration(
                        labelText: 'E-Mail',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _contactPhoneController,
                      decoration: const InputDecoration(
                        labelText: 'Telefon',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: PhotoAttachmentWidget(
                  photos: _selectedPhotos,
                  onAddPhoto: _addPhoto,
                  onRemovePhoto: _removePhoto,
                  maxPhotos: 5,
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
      // Create report object
      final report = Report(
        id: DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        priority: _selectedPriority,
        status: ReportStatus.submitted,
        location: ReportLocation(
          latitude:
              _selectedLocation?.latitude ??
              54.3233, // Default Aukrug coordinates
          longitude: _selectedLocation?.longitude ?? 9.7500,
          address: _locationController.text.trim(),
        ),
        imageUrls: _selectedPhotos.map((file) => file.path).toList(),
        contactName: _contactNameController.text.trim().isNotEmpty
            ? _contactNameController.text.trim()
            : null,
        contactEmail: _contactEmailController.text.trim().isNotEmpty
            ? _contactEmailController.text.trim()
            : null,
        contactPhone: _contactPhoneController.text.trim().isNotEmpty
            ? _contactPhoneController.text.trim()
            : null,
        isAnonymous:
            _contactNameController.text.trim().isEmpty &&
            _contactEmailController.text.trim().isEmpty &&
            _contactPhoneController.text.trim().isEmpty,
        submittedAt: DateTime.now(),
      );

      // Submit using provider
      final submissionNotifier = ref.read(reportSubmissionProvider.notifier);
      await submissionNotifier.submitReport(report);

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

  /// Get current GPS location
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final locationService = ref.read(locationServiceProvider);
      final status = await locationService.getLocationStatus();

      if (status != LocationServiceStatus.available) {
        String message;
        switch (status) {
          case LocationServiceStatus.disabled:
            message =
                'GPS ist deaktiviert. Bitte aktivieren Sie GPS in den Einstellungen.';
            break;
          case LocationServiceStatus.permissionDenied:
            message =
                'GPS-Berechtigung verweigert. Bitte erteilen Sie die Berechtigung.';
            break;
          case LocationServiceStatus.permissionDeniedForever:
            message =
                'GPS-Berechtigung dauerhaft verweigert. Bitte aktivieren Sie sie in den App-Einstellungen.';
            break;
          default:
            message = 'GPS ist nicht verfügbar.';
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.orange),
          );
        }
        return;
      }

      final location = await locationService.getCurrentLocation(
        accuracy: LocationAccuracyLevel.high,
        timeLimit: const Duration(seconds: 10),
      );

      if (location != null) {
        if (locationService.isWithinAukrug(location)) {
          setState(() {
            _selectedLocation = location;
            _locationController.text =
                'GPS-Standort: ${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}';
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('GPS-Standort erfolgreich ermittelt'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          final distance = locationService.getDistanceToAukrug(location);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Sie befinden sich außerhalb von Aukrug (${(distance! / 1000).toStringAsFixed(1)} km entfernt). Möchten Sie trotzdem diesen Standort verwenden?',
                ),
                backgroundColor: Colors.orange,
                action: SnackBarAction(
                  label: 'Ja',
                  onPressed: () {
                    setState(() {
                      _selectedLocation = location;
                      _locationController.text =
                          'GPS-Standort (außerhalb): ${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}';
                    });
                  },
                ),
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('GPS-Standort konnte nicht ermittelt werden'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim GPS-Zugriff: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  /// Add photo from camera or gallery
  Future<void> _addPhoto(File photoFile) async {
    if (_selectedPhotos.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximal 5 Fotos erlaubt'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _selectedPhotos.add(photoFile);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto hinzugefügt'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// Remove photo at index
  void _removePhoto(int index) {
    if (index < _selectedPhotos.length) {
      setState(() {
        _selectedPhotos.removeAt(index);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Foto entfernt')));
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
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
              Text(
                '• Schäden an Straßen und Gehwegen\n'
                '• Defekte Straßenbeleuchtung\n'
                '• Probleme mit Grünflächen\n'
                '• Sicherheitsmängel\n'
                '• Verschmutzungen im öffentlichen Raum',
              ),
              SizedBox(height: 16),
              Text('Notfälle', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                'Bei akuten Gefahren wenden Sie sich bitte direkt an:\n'
                '• Feuerwehr/Rettung: 112\n'
                '• Polizei: 110\n'
                '• Gemeindeverwaltung: 04391 599-0',
              ),
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

  /// Get color for priority level
  Color _getPriorityColor(ReportPriority priority) {
    switch (priority) {
      case ReportPriority.low:
        return Colors.green;
      case ReportPriority.medium:
        return Colors.orange;
      case ReportPriority.high:
        return Colors.red;
      case ReportPriority.urgent:
        return Colors.purple;
    }
  }
}
