import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get user profile from Firestore
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;
      return UserProfile.fromFirestore(doc.data()!);
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  /// Update user profile in Firestore
  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.id)
          .set(profile.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  /// Create new user profile
  Future<void> createUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.id)
          .set(profile.toJson());
    } catch (e) {
      print('Error creating user profile: $e');
      rethrow;
    }
  }

  /// Get current user profile
  Future<UserProfile?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return getUserProfile(user.uid);
  }

  /// Update user online status
  Future<void> updateOnlineStatus(bool isOnline) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'isOnline': isOnline,
        'lastActiveAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating online status: $e');
    }
  }

  /// Get nearby users
  Future<List<UserProfile>> getNearbyUsers({
    required double latitude,
    required double longitude,
    required double radiusKm,
    int limit = 50,
  }) async {
    try {
      // Simple implementation - in production you'd use GeoFlutterFire or similar
      final snapshot = await _firestore
          .collection('users')
          .where('isOnline', isEqualTo: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => UserProfile.fromFirestore(doc.data()))
          .where((profile) => profile.id != _auth.currentUser?.uid)
          .toList();
    } catch (e) {
      print('Error getting nearby users: $e');
      return [];
    }
  }

  /// Search users
  Future<List<UserProfile>> searchUsers(String query) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('displayName', isGreaterThanOrEqualTo: query)
          .where('displayName', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(20)
          .get();

      return snapshot.docs
          .map((doc) => UserProfile.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

  /// Get user stream for real-time updates
  Stream<UserProfile?> getUserStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map(
          (doc) => doc.exists ? UserProfile.fromFirestore(doc.data()!) : null,
        );
  }
}
