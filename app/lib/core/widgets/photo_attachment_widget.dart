import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/camera_service.dart';

/// Widget for displaying and managing photo attachments in reports
class PhotoAttachmentWidget extends ConsumerWidget {
  final List<File> photos;
  final Function(File) onAddPhoto;
  final Function(int) onRemovePhoto;
  final bool isEditable;
  final int maxPhotos;

  const PhotoAttachmentWidget({
    super.key,
    required this.photos,
    required this.onAddPhoto,
    required this.onRemovePhoto,
    this.isEditable = true,
    this.maxPhotos = 5,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Fotos',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (photos.isNotEmpty)
              Text(
                '${photos.length}/$maxPhotos',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Photo Grid
        if (photos.isNotEmpty) ...[
          _PhotoGrid(
            photos: photos,
            onRemovePhoto: isEditable ? onRemovePhoto : null,
          ),
          const SizedBox(height: 12),
        ],

        // Add Photo Button
        if (isEditable && photos.length < maxPhotos)
          _AddPhotoButton(onPressed: () => _showPhotoOptions(context, ref)),
      ],
    );
  }

  void _showPhotoOptions(BuildContext context, WidgetRef ref) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _PhotoOptionsSheet(
        onPhotoSelected: onAddPhoto,
        cameraService: ref.read(cameraServiceProvider),
      ),
    );
  }
}

/// Grid layout for displaying photos
class _PhotoGrid extends StatelessWidget {
  final List<File> photos;
  final Function(int)? onRemovePhoto;

  const _PhotoGrid({required this.photos, this.onRemovePhoto});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return _PhotoItem(
          photo: photos[index],
          onRemove: onRemovePhoto != null ? () => onRemovePhoto!(index) : null,
          onTap: () => _showPhotoPreview(context, photos, index),
        );
      },
    );
  }

  void _showPhotoPreview(
    BuildContext context,
    List<File> photos,
    int initialIndex,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            PhotoPreviewPage(photos: photos, initialIndex: initialIndex),
      ),
    );
  }
}

/// Individual photo item with optional remove button
class _PhotoItem extends StatelessWidget {
  final File photo;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  const _PhotoItem({required this.photo, this.onRemove, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Stack(
          children: [
            // Photo
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                photo,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Icon(
                      Icons.broken_image,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  );
                },
              ),
            ),

            // Remove button
            if (onRemove != null)
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Add photo button
class _AddPhotoButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddPhotoButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Foto hinzufügen',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Photo options bottom sheet
class _PhotoOptionsSheet extends StatelessWidget {
  final Function(File) onPhotoSelected;
  final CameraService cameraService;

  const _PhotoOptionsSheet({
    required this.onPhotoSelected,
    required this.cameraService,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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

            // Camera option
            _OptionButton(
              icon: Icons.camera_alt,
              label: 'Kamera',
              onPressed: () => _handleCameraSelection(context),
            ),
            const SizedBox(height: 8),

            // Gallery option
            _OptionButton(
              icon: Icons.photo_library,
              label: 'Galerie',
              onPressed: () => _handleGallerySelection(context),
            ),
            const SizedBox(height: 16),

            // Cancel
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCameraSelection(BuildContext context) async {
    Navigator.of(context).pop();
    final File? photo = await cameraService.takePhoto();
    if (photo != null) {
      onPhotoSelected(photo);
    }
  }

  Future<void> _handleGallerySelection(BuildContext context) async {
    Navigator.of(context).pop();
    final File? photo = await cameraService.selectFromGallery();
    if (photo != null) {
      onPhotoSelected(photo);
    }
  }
}

/// Option button for photo source selection
class _OptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _OptionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

/// Full-screen photo preview page
class PhotoPreviewPage extends StatefulWidget {
  final List<File> photos;
  final int initialIndex;

  const PhotoPreviewPage({
    super.key,
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<PhotoPreviewPage> createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_currentIndex + 1} von ${widget.photos.length}'),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.photos.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: Image.file(
                widget.photos[index],
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 64,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
