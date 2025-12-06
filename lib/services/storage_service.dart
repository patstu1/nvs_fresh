import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> initialize() async {
    try {
      // Initialize storage buckets for user content
      await _storage.ref('user_content').list();

      // Set up secure storage for sensitive data
      await _secureStorage.write(key: 'storage_initialized', value: 'true');
    } catch (e) {
      print('Storage service initialization error: $e');
      rethrow;
    }
  }

  // Methods for handling user media and data
  Future<String> uploadUserMedia(String path, List<int> data) async {
    try {
      final ref = _storage.ref().child('user_media').child(path);
      final uploadTask = ref.putData(
        Uint8List.fromList(data),
        SettableMetadata(contentType: _getContentType(path)),
      );

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading media: $e');
      rethrow;
    }
  }

  Future<String> uploadImageFromBytes(List<int> imageBytes, String fileName) async {
    try {
      final ref = _storage.ref().child('images').child(fileName);
      final uploadTask = ref.putData(
        Uint8List.fromList(imageBytes),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  Future<String> uploadVideoFromBytes(List<int> videoBytes, String fileName) async {
    try {
      final ref = _storage.ref().child('videos').child(fileName);
      final uploadTask = ref.putData(
        Uint8List.fromList(videoBytes),
        SettableMetadata(contentType: 'video/mp4'),
      );

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading video: $e');
      rethrow;
    }
  }

  Future<void> deleteUserMedia(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      print('Error deleting media: $e');
      rethrow;
    }
  }

  Future<String> processAttachment(String attachmentPath) async {
    try {
      // Process and optimize the attachment
      final ref = _storage.ref().child('attachments').child(attachmentPath);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error processing attachment: $e');
      rethrow;
    }
  }

  String _getContentType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }
}
