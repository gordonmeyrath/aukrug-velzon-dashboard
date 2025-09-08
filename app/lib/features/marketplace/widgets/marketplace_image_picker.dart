import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MarketplaceImagePicker extends StatefulWidget {
  final List<File> selectedImages;
  final List<String> existingImageUrls;
  final Function(List<File>) onImagesChanged;
  final Function(int) onExistingImageRemoved;
  final int maxImages;

  const MarketplaceImagePicker({
    super.key,
    required this.selectedImages,
    required this.existingImageUrls,
    required this.onImagesChanged,
    required this.onExistingImageRemoved,
    this.maxImages = 5,
  });

  @override
  State<MarketplaceImagePicker> createState() => _MarketplaceImagePickerState();
}

class _MarketplaceImagePickerState extends State<MarketplaceImagePicker> {
  final ImagePicker _picker = ImagePicker();

  int get totalImages =>
      widget.selectedImages.length + widget.existingImageUrls.length;
  bool get canAddMore => totalImages < widget.maxImages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image Grid
        if (totalImages > 0)
          SizedBox(
            height: 120,
            child: ReorderableListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: totalImages + (canAddMore ? 1 : 0),
              onReorder: _onReorder,
              itemBuilder: (context, index) {
                // Add button at the end
                if (index == totalImages) {
                  return _buildAddImageButton(context, index);
                }

                // Existing images first
                if (index < widget.existingImageUrls.length) {
                  return _buildExistingImageCard(context, index);
                }

                // New selected images
                final newImageIndex = index - widget.existingImageUrls.length;
                return _buildSelectedImageCard(context, newImageIndex, index);
              },
            ),
          )
        else
          _buildEmptyState(context),

        const SizedBox(height: 8),

        // Instructions
        Text(
          'Bilder per Drag & Drop sortieren • $totalImages/${widget.maxImages} Bilder',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 32,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 8),
              Text(
                'Bilder hinzufügen',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                'Tippen um Galerie zu öffnen',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExistingImageCard(BuildContext context, int index) {
    return Container(
      key: ValueKey('existing-$index'),
      width: 120,
      height: 120,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: index == 0
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300]!,
                width: index == 0 ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.existingImageUrls[index],
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 32),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
          ),

          // Primary image badge
          if (index == 0)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Titel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // Remove button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => widget.onExistingImageRemoved(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedImageCard(
    BuildContext context,
    int imageIndex,
    int listIndex,
  ) {
    final image = widget.selectedImages[imageIndex];
    final isFirst = widget.existingImageUrls.isEmpty && imageIndex == 0;

    return Container(
      key: ValueKey('selected-$listIndex'),
      width: 120,
      height: 120,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isFirst
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300]!,
                width: isFirst ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Primary image badge
          if (isFirst)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Titel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // Remove button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removeSelectedImage(imageIndex),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton(BuildContext context, int index) {
    return Container(
      key: ValueKey('add-$index'),
      width: 120,
      height: 120,
      margin: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: _pickImages,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[300]!,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 24,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 4),
              Text(
                'Hinzufügen',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    if (!canAddMore) return;

    final remainingSlots = widget.maxImages - totalImages;

    try {
      if (remainingSlots == 1) {
        // Pick single image
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );

        if (image != null) {
          final newImages = List<File>.from(widget.selectedImages);
          newImages.add(File(image.path));
          widget.onImagesChanged(newImages);
        }
      } else {
        // Pick multiple images
        final List<XFile> images = await _picker.pickMultiImage(
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );

        if (images.isNotEmpty) {
          final newImages = List<File>.from(widget.selectedImages);
          final imagesToAdd = images.take(remainingSlots);

          for (final image in imagesToAdd) {
            newImages.add(File(image.path));
          }

          widget.onImagesChanged(newImages);

          if (images.length > remainingSlots) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Nur $remainingSlots von ${images.length} Bildern hinzugefügt (Maximum: ${widget.maxImages})',
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Auswählen der Bilder: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeSelectedImage(int imageIndex) {
    final newImages = List<File>.from(widget.selectedImages);
    newImages.removeAt(imageIndex);
    widget.onImagesChanged(newImages);
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    // Don't allow reordering the add button
    if (oldIndex == totalImages || newIndex == totalImages) return;

    // Handle reordering between existing and new images
    if (oldIndex < widget.existingImageUrls.length &&
        newIndex < widget.existingImageUrls.length) {
      // Reordering within existing images - this would need to be implemented
      // in the parent widget as it affects the existingImageUrls list
    } else if (oldIndex >= widget.existingImageUrls.length &&
        newIndex >= widget.existingImageUrls.length) {
      // Reordering within selected images
      final adjustedOldIndex = oldIndex - widget.existingImageUrls.length;
      final adjustedNewIndex = newIndex - widget.existingImageUrls.length;

      final newImages = List<File>.from(widget.selectedImages);
      final item = newImages.removeAt(adjustedOldIndex);
      newImages.insert(adjustedNewIndex, item);
      widget.onImagesChanged(newImages);
    }
    // Mixed reordering between existing and new images would require
    // more complex handling in the parent widget
  }
}
