import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  Future<File?> pickImage({
    ImageSource source = ImageSource.gallery,
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  Future<List<File>> pickMultipleImages({
    int maxImages = 10,
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality,
      );

      return images.map((image) => File(image.path)).toList();
    } catch (e) {
      print('Error picking multiple images: $e');
      return [];
    }
  }

  Future<String> uploadImage(String filePath) async {
    // Return a mock URL
    return 'https://picsum.photos/200';
  }

  Future<List<String>> uploadMultipleImages({
    required List<File> imageFiles,
    required String userId,
    String? folder,
  }) async {
    final List<String> uploadedUrls = [];

    for (final imageFile in imageFiles) {
      final url = await uploadImage(imageFile.path);
      uploadedUrls.add(url);
        }

    return uploadedUrls;
  }

  Future<void> deleteImage(String url) async {}

  Future<void> deleteUserImages(String userId) async {
    // No-op for mock service
  }

  Future<double> getImageFileSize(File imageFile) async {
    try {
      final int bytes = await imageFile.length();
      return bytes / (1024 * 1024); // Convert to MB
    } catch (e) {
      print('Error getting file size: $e');
      return 0;
    }
  }

  Future<bool> isImageFileSizeValid(File imageFile,
      {double maxSizeMB = 10}) async {
    final double sizeMB = await getImageFileSize(imageFile);
    return sizeMB <= maxSizeMB;
  }
}

final mediaServiceProvider = Provider<MediaService>((ref) {
  return MediaService();
});
