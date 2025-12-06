import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Stub VideoService to prevent compilation errors
/// Full WebRTC implementation disabled for performance
class VideoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stub methods - implement as needed
  Future<void> initializeVideo() async {
    // Stub implementation
  }

  Future<void> createRoom() async {
    // Stub implementation
  }

  Future<void> joinRoom(String roomId) async {
    // Stub implementation
  }

  void dispose() {
    // Stub cleanup
  }
}




