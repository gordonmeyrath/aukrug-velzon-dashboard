import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Camera service for managing photo capture and gallery selection
class CameraService {
  final ImagePicker _picker = ImagePicker();

  /// Take a photo using device camera
  Future<File?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo == null) return null;

      // Process and save the image
      return await _processAndSaveImage(File(photo.path));
    } catch (e) {
      debugPrint('Error taking photo: $e');
      return null;
    }
  }

  /// Select photo from gallery
  Future<File?> selectFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo == null) return null;

      // Process and save the image
      return await _processAndSaveImage(File(photo.path));
    } catch (e) {
      debugPrint('Error selecting photo: $e');
      return null;
    }
  }

  /// Select multiple photos from gallery
  Future<List<File>> selectMultipleFromGallery() async {
    try {
      final List<XFile> photos = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      List<File> processedFiles = [];
      for (XFile photo in photos) {
        final File? processedFile = await _processAndSaveImage(
          File(photo.path),
        );
        if (processedFile != null) {
          processedFiles.add(processedFile);
        }
      }

      return processedFiles;
    } catch (e) {
      debugPrint('Error selecting multiple photos: $e');
      return [];
    }
  }

  /// Process and save image with compression and optimization
  Future<File?> _processAndSaveImage(File imageFile) async {
    try {
      // Read the image
      final Uint8List imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);

      if (image == null) return null;

      // Resize if image is too large
      if (image.width > 1920 || image.height > 1080) {
        image = img.copyResize(
          image,
          width: image.width > image.height ? 1920 : null,
          height: image.height >= image.width ? 1080 : null,
        );
      }

      // Ensure proper orientation
      image = img.bakeOrientation(image);

      // Compress the image
      final List<int> compressedBytes = img.encodeJpg(image, quality: 85);

      // Save to app directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName =
          'report_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = path.join(appDir.path, 'images', fileName);

      // Create directory if it doesn't exist
      final Directory imageDir = Directory(path.dirname(filePath));
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }

      // Write the compressed image
      final File savedFile = File(filePath);
      await savedFile.writeAsBytes(compressedBytes);

      return savedFile;
    } catch (e) {
      debugPrint('Error processing image: $e');
      return null;
    }
  }

  /// Delete image file
  Future<bool> deleteImage(String filePath) async {
    try {
      final File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }

  /// Get image file size in bytes
  Future<int> getImageSize(String filePath) async {
    try {
      final File file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      debugPrint('Error getting image size: $e');
      return 0;
    }
  }

  /// Validate image file
  Future<bool> isValidImage(String filePath) async {
    try {
      final File file = File(filePath);
      if (!await file.exists()) return false;

      final Uint8List bytes = await file.readAsBytes();
      final img.Image? image = img.decodeImage(bytes);

      return image != null;
    } catch (e) {
      return false;
    }
  }

  /// Show photo source selection dialog
  Future<File?> showPhotoSourceDialog(BuildContext context) async {
    return await showModalBottomSheet<File?>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
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
                _PhotoSourceButton(
                  icon: Icons.camera_alt,
                  label: 'Kamera',
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final File? photo = await takePhoto();
                    if (context.mounted) {
                      Navigator.of(context).pop(photo);
                    }
                  },
                ),
                const SizedBox(height: 8),
                _PhotoSourceButton(
                  icon: Icons.photo_library,
                  label: 'Galerie',
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final File? photo = await selectFromGallery();
                    if (context.mounted) {
                      Navigator.of(context).pop(photo);
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Abbrechen'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Photo source selection button
class _PhotoSourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _PhotoSourceButton({
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

/// Provider for CameraService
final cameraServiceProvider = Provider<CameraService>((ref) {
  return CameraService();
});
