import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/enhanced_photo_service.dart';
import '../widgets/photo_attachment_widget.dart';

/// Enhanced photo attachment widget with AI features
class EnhancedPhotoAttachmentWidget extends ConsumerStatefulWidget {
  final List<File> photos;
  final Function(File) onAddPhoto;
  final Function(int) onRemovePhoto;
  final bool isEditable;
  final int maxPhotos;
  final bool enableAIEnhancement;

  const EnhancedPhotoAttachmentWidget({
    super.key,
    required this.photos,
    required this.onAddPhoto,
    required this.onRemovePhoto,
    this.isEditable = true,
    this.maxPhotos = 5,
    this.enableAIEnhancement = true,
  });

  @override
  ConsumerState<EnhancedPhotoAttachmentWidget> createState() =>
      _EnhancedPhotoAttachmentWidgetState();
}

class _EnhancedPhotoAttachmentWidgetState
    extends ConsumerState<EnhancedPhotoAttachmentWidget> {
  bool _isProcessing = false;
  PhotoResult? _lastPhotoResult;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with AI indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Fotos',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.enableAIEnhancement) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'KI',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            if (widget.photos.isNotEmpty)
              Text(
                '${widget.photos.length}/${widget.maxPhotos}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Processing indicator
        if (_isProcessing) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const LinearProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(
                    'KI-gestützte Bildverbesserung läuft...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bitte warten Sie einen Moment',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Photo results with AI insights
        if (_lastPhotoResult != null) ...[
          _buildPhotoResultCard(_lastPhotoResult!),
          const SizedBox(height: 12),
        ],

        // Standard photo grid
        if (widget.photos.isNotEmpty) ...[
          PhotoAttachmentWidget(
            photos: widget.photos,
            onAddPhoto: widget.onAddPhoto,
            onRemovePhoto: widget.onRemovePhoto,
            isEditable: widget.isEditable,
            maxPhotos: widget.maxPhotos,
          ),
        ] else if (widget.isEditable &&
            widget.photos.length < widget.maxPhotos) ...[
          _buildEnhancedAddButton(),
        ],
      ],
    );
  }

  Widget _buildPhotoResultCard(PhotoResult result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'KI-Analyse Ergebnis',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Annotations
            if (result.annotations.isNotEmpty) ...[
              Text(
                'Erkannte Objekte:',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: result.annotations.map((annotation) {
                  return Chip(
                    label: Text(
                      '${annotation.object} (${(annotation.confidence * 100).toInt()}%)',
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.secondaryContainer,
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],

            // Suggested category
            if (result.annotations.any((a) => a.suggestedCategory != null)) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      size: 16,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Vorgeschlagene Kategorie: ${_getCategoryName(result.annotations.firstWhere((a) => a.suggestedCategory != null).suggestedCategory!)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Metadata
            Text(
              'Bilddetails:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              '${result.metadata.width}x${result.metadata.height} • ${_formatFileSize(result.metadata.fileSize)} • ${result.metadata.orientation}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedAddButton() {
    return InkWell(
      onTap: widget.isEditable ? _showEnhancedPhotoOptions : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            style: BorderStyle.solid,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              'Foto hinzufügen',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.enableAIEnhancement) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Mit KI-Verbesserung',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showEnhancedPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Foto hinzufügen',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Enhanced camera option
              _buildEnhancedOptionButton(
                icon: Icons.camera_enhance,
                label: 'KI-optimierte Kamera',
                subtitle: 'Automatische Bildverbesserung',
                onPressed: () => _handleEnhancedCamera(context),
                isPrimary: true,
              ),
              const SizedBox(height: 8),

              // Standard camera option
              _buildEnhancedOptionButton(
                icon: Icons.camera_alt,
                label: 'Standard Kamera',
                subtitle: 'Ohne Nachbearbeitung',
                onPressed: () => _handleStandardCamera(context),
              ),
              const SizedBox(height: 8),

              // Gallery option
              _buildEnhancedOptionButton(
                icon: Icons.photo_library,
                label: 'Aus Galerie wählen',
                subtitle: 'Vorhandene Fotos',
                onPressed: () => _handleGallery(context),
              ),
              const SizedBox(height: 16),

              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Abbrechen'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedOptionButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isPrimary
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: isPrimary
            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
            : null,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: isPrimary
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isPrimary
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : null,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isPrimary
                            ? Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer.withOpacity(0.8)
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isPrimary)
                Icon(
                  Icons.auto_awesome,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleEnhancedCamera(BuildContext context) async {
    Navigator.of(context).pop();
    setState(() => _isProcessing = true);

    try {
      final enhancedPhotoService = ref.read(enhancedPhotoServiceProvider);
      final result = await enhancedPhotoService.takePhotoWithAI();

      if (result != null) {
        setState(() {
          _lastPhotoResult = result;
          _isProcessing = false;
        });
        widget.onAddPhoto(result.enhancedFile);
      } else {
        setState(() => _isProcessing = false);
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler bei KI-Verbesserung: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleStandardCamera(BuildContext context) async {
    Navigator.of(context).pop();
    // Use standard camera service
    final cameraService = ref.read(cameraServiceProvider);
    final photo = await cameraService.takePhoto();
    if (photo != null) {
      widget.onAddPhoto(photo);
    }
  }

  Future<void> _handleGallery(BuildContext context) async {
    Navigator.of(context).pop();
    final cameraService = ref.read(cameraServiceProvider);
    final photo = await cameraService.selectFromGallery();
    if (photo != null) {
      widget.onAddPhoto(photo);
    }
  }

  String _getCategoryName(String category) {
    final Map<String, String> categoryNames = {
      'roadsTraffic': 'Straßen & Verkehr',
      'publicLighting': 'Öffentliche Beleuchtung',
      'wasteManagement': 'Abfallentsorgung',
      'parksGreenSpaces': 'Parks & Grünflächen',
      'waterDrainage': 'Wasser & Entwässerung',
      'publicFacilities': 'Öffentliche Einrichtungen',
      'vandalism': 'Vandalismus',
      'environmental': 'Umwelt',
      'accessibility': 'Barrierefreiheit',
      'other': 'Sonstiges',
    };
    return categoryNames[category] ?? category;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Provider for camera service (reference to existing service)
final cameraServiceProvider = Provider<dynamic>((ref) {
  // This would reference the existing CameraService
  throw UnimplementedError('Reference to existing CameraService');
});
