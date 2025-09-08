import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_bar.dart';
import '../models/marketplace_models.dart';
import '../providers/marketplace_providers.dart';
import '../widgets/marketplace_category_selector.dart';
import '../widgets/marketplace_image_picker.dart';

class MarketplaceEditScreen extends ConsumerStatefulWidget {
  final int? listingId; // null for create, set for edit

  const MarketplaceEditScreen({super.key, this.listingId});

  @override
  ConsumerState<MarketplaceEditScreen> createState() =>
      _MarketplaceEditScreenState();
}

class _MarketplaceEditScreenState extends ConsumerState<MarketplaceEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String _selectedCurrency = 'EUR';
  String _selectedLocationArea = '';
  List<int> _selectedCategoryIds = [];
  List<File> _selectedImages = [];
  List<String> _existingImageUrls = [];
  bool _contactViaMessenger = true;
  bool _isSubmitting = false;

  final List<String> _availableCurrencies = ['EUR', 'USD'];
  final List<String> _availableAreas = [
    'Aukrug',
    'Bargstedt',
    'Böken',
    'Ehndorf',
    'Homfeld',
    'Innien',
    'Padenstedt',
    'Sarlhusen',
  ];

  MarketplaceListing? _existingListing;

  @override
  void initState() {
    super.initState();
    if (widget.listingId != null) {
      _loadExistingListing();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingListing() async {
    try {
      final listing = await ref
          .read(marketplaceRepositoryProvider)
          .getListing(widget.listingId!);

      if (listing != null && mounted) {
        setState(() {
          _existingListing = listing;
          _titleController.text = listing.title;
          _descriptionController.text = listing.description;
          _priceController.text = listing.price.toString();
          _selectedCurrency = listing.currency;
          _selectedLocationArea = listing.locationArea;
          _selectedCategoryIds =
              listing.categories?.map((cat) => int.parse(cat)).toList() ?? [];
          _existingImageUrls = List.from(listing.images);
          _contactViaMessenger = listing.contactViaMessenger;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Laden der Anzeige: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final verificationStatus = ref.watch(verificationStatusProvider);
    final categories = ref.watch(marketplaceCategoriesProvider);

    return Scaffold(
      appBar: AukrugAppBar(
        title: widget.listingId == null
            ? 'Anzeige erstellen'
            : 'Anzeige bearbeiten',
      ),
      body: _buildEditContent(context),
    );
  }

  Widget _buildVerificationRequiredContent(
    BuildContext context,
    VerificationStatus status,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(status.statusIcon, size: 64, color: status.statusColor),
            const SizedBox(height: 24),
            Text(
              status.displayStatus,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              status.hasPendingRequest
                  ? 'Deine Verifikation wird geprüft. Du wirst benachrichtigt, sobald sie abgeschlossen ist.'
                  : 'Um Anzeigen zu erstellen, musst du dich als Einwohner oder Unternehmen verifizieren lassen.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (!status.hasPendingRequest)
              ElevatedButton.icon(
                onPressed: () => context.push('/marketplace/verification'),
                icon: const Icon(Icons.verified_user),
                label: const Text('Jetzt verifizieren'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditContent(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Images Section
                  _buildImageSection(context),

                  const SizedBox(height: 24),

                  // Title
                  _buildTitleField(),

                  const SizedBox(height: 16),

                  // Description
                  _buildDescriptionField(),

                  const SizedBox(height: 16),

                  // Price and Currency
                  _buildPriceSection(),

                  const SizedBox(height: 16),

                  // Location
                  _buildLocationField(),

                  const SizedBox(height: 16),

                  // Categories
                  _buildCategorySection(),

                  const SizedBox(height: 16),

                  // Contact Options
                  _buildContactOptions(),

                  const SizedBox(height: 24),

                  // Terms and Conditions
                  _buildTermsSection(),
                ],
              ),
            ),
          ),

          // Submit Button
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bilder',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Füge bis zu 5 Bilder hinzu. Das erste Bild wird als Titelbild verwendet.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        MarketplaceImagePicker(
          selectedImages: _selectedImages,
          existingImageUrls: _existingImageUrls,
          onImagesChanged: (images) {
            setState(() {
              _selectedImages = images;
            });
          },
          onExistingImageRemoved: (index) {
            setState(() {
              _existingImageUrls.removeAt(index);
            });
          },
          maxImages: 5,
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Titel *',
        hintText: 'Was verkaufst du?',
        border: OutlineInputBorder(),
      ),
      maxLength: 100,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Bitte gib einen Titel ein';
        }
        if (value.trim().length < 5) {
          return 'Der Titel muss mindestens 5 Zeichen lang sein';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Beschreibung *',
        hintText: 'Beschreibe deine Anzeige detailliert...',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 5,
      maxLength: 2000,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Bitte gib eine Beschreibung ein';
        }
        if (value.trim().length < 20) {
          return 'Die Beschreibung muss mindestens 20 Zeichen lang sein';
        }
        return null;
      },
    );
  }

  Widget _buildPriceSection() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Preis *',
              border: OutlineInputBorder(),
              prefixText: '€ ',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Bitte gib einen Preis ein';
              }
              final price = double.tryParse(value.trim());
              if (price == null || price < 0) {
                return 'Ungültiger Preis';
              }
              if (price > 99999) {
                return 'Preis zu hoch (max. 99.999€)';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: DropdownButtonFormField<String>(
            value: _selectedCurrency,
            decoration: const InputDecoration(
              labelText: 'Währung',
              border: OutlineInputBorder(),
            ),
            items: _availableCurrencies.map((currency) {
              return DropdownMenuItem(value: currency, child: Text(currency));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedCurrency = value;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return DropdownButtonFormField<String>(
      value: _selectedLocationArea.isEmpty ? null : _selectedLocationArea,
      decoration: const InputDecoration(
        labelText: 'Standort *',
        border: OutlineInputBorder(),
        hintText: 'Wähle deinen Bereich',
      ),
      items: _availableAreas.map((area) {
        return DropdownMenuItem(value: area, child: Text(area));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedLocationArea = value ?? '';
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Bitte wähle einen Standort';
        }
        return null;
      },
    );
  }

  Widget _buildCategorySection() {
    return Consumer(
      builder: (context, ref, child) {
        final categoriesAsync = ref.watch(marketplaceCategoriesProvider);

        return categoriesAsync.when(
          data: (categories) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kategorien',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              MarketplaceCategorySelector(
                categories: categories,
                selectedCategoryIds: _selectedCategoryIds,
                onCategoriesChanged: (categoryIds) {
                  setState(() {
                    _selectedCategoryIds = categoryIds;
                  });
                },
                multiSelect: true,
                maxSelections: 3,
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text(
            'Fehler beim Laden der Kategorien: $error',
            style: TextStyle(color: Colors.red[700]),
          ),
        );
      },
    );
  }

  Widget _buildContactOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kontaktoptionen',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Kontakt über Messenger'),
                  subtitle: const Text('Sichere, verschlüsselte Kommunikation'),
                  value: _contactViaMessenger,
                  onChanged: (value) {
                    setState(() {
                      _contactViaMessenger = value;
                    });
                  },
                  secondary: const Icon(Icons.message),
                ),
                if (_contactViaMessenger)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.security, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Deine Kontaktdaten bleiben geschützt. Interessenten können dich über unseren sicheren Messenger kontaktieren.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.blue[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.grey[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Wichtige Hinweise',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• Keine Fake-Anzeigen oder irreführenden Inhalte\n'
            '• Respektvoller Umgang mit anderen Nutzern\n'
            '• Keine gewerblichen Anzeigen ohne Verifikation\n'
            '• Bei Verstößen behalten wir uns vor, Anzeigen zu löschen',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitListing,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    widget.listingId == null
                        ? 'Anzeige veröffentlichen'
                        : 'Änderungen speichern',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitListing() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate images
    if (_selectedImages.isEmpty && _existingImageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte füge mindestens ein Bild hinzu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Convert new images to base64
      final imageBase64List = <String>[];
      for (final imageFile in _selectedImages) {
        final bytes = await imageFile.readAsBytes();
        final base64String = base64Encode(bytes);
        imageBase64List.add(base64String);
      }

      // Add existing images (for edit mode)
      imageBase64List.addAll(_existingImageUrls);

      final price = double.parse(_priceController.text.trim());

      if (widget.listingId == null) {
        // Create new listing
        final request = MarketplaceCreateRequest(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          price: price,
          currency: _selectedCurrency,
          locationArea: _selectedLocationArea,
          imageBase64List: imageBase64List,
          contactViaMessenger: _contactViaMessenger,
          categoryIds: _selectedCategoryIds.isNotEmpty
              ? _selectedCategoryIds
              : null,
        );

        await ref.read(marketplaceRepositoryProvider).createListing(request);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Anzeige erfolgreich erstellt!'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      } else {
        // Update existing listing
        final request = MarketplaceUpdateRequest(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          price: price,
          currency: _selectedCurrency,
          locationArea: _selectedLocationArea,
          imageBase64List: imageBase64List,
          contactViaMessenger: _contactViaMessenger,
          categoryIds: _selectedCategoryIds.isNotEmpty
              ? _selectedCategoryIds
              : null,
        );

        await ref
            .read(marketplaceRepositoryProvider)
            .updateListing(widget.listingId!, request);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Anzeige erfolgreich aktualisiert!'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Ein Fehler ist aufgetreten';

        if (e is VerificationRequiredException) {
          errorMessage = 'Verifikation erforderlich';
        } else if (e is RateLimitExceededException) {
          errorMessage = 'Tageslimit erreicht. Versuche es morgen erneut.';
        } else if (e is MarketplaceException) {
          errorMessage = e.message;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
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
