import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'now_map_model.dart';

class NowMapRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get auth => _auth;

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _userLocationsCollection =>
      _firestore.collection('user_locations');

  // Get nearby users with real-time updates
  Stream<List<NowMapUser>> getNearbyUsersStream(
      GeoPoint currentLocation, MapFilters filters) {
    return _userLocationsCollection
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      final users = <NowMapUser>[];

      for (final doc in snapshot.docs) {
        try {
          final user = NowMapUser.fromFirestore(doc, currentLocation);
          if (filters.matchesUser(user)) {
            users.add(user);
          }
        } catch (e) {
          // Skip invalid documents
          continue;
        }
      }

      // Sort by distance
      users.sort((a, b) => a.distance.compareTo(b.distance));

      return users;
    });
  }

  // Update current user's location
  Future<void> updateUserLocation(GeoPoint location) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final geohash =
        GeoHasher().encode(location.latitude, location.longitude, precision: 6);

    await _userLocationsCollection.doc(user.uid).set({
      'location': location,
      'geohash': geohash,
      'lastUpdated': FieldValue.serverTimestamp(),
      'isActive': true,
      'userId': user.uid,
    }, SetOptions(merge: true));
  }

  // Get user's current location
  Future<GeoPoint?> getCurrentUserLocation() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _userLocationsCollection.doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['location'] as GeoPoint;
      }
    } catch (e) {
      // Handle error
    }

    return null;
  }

  // Request location permission and get current location
  Future<GeoPoint?> getDeviceLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return GeoPoint(position.latitude, position.longitude);
  }

  // Create user clusters based on proximity
  List<UserCluster> createUserClusters(
      List<NowMapUser> users, double clusterRadius) {
    if (users.isEmpty) return [];

    final clusters = <UserCluster>[];
    final processedUsers = <String>{};

    for (final user in users) {
      if (processedUsers.contains(user.id)) continue;

      // Find nearby users to cluster
      final nearbyUsers = <NowMapUser>[user];
      processedUsers.add(user.id);

      for (final otherUser in users) {
        if (otherUser.id == user.id || processedUsers.contains(otherUser.id)) {
          continue;
        }

        final distance = Geolocator.distanceBetween(
          user.location.latitude,
          user.location.longitude,
          otherUser.location.latitude,
          otherUser.location.longitude,
        );

        if (distance <= clusterRadius) {
          nearbyUsers.add(otherUser);
          processedUsers.add(otherUser.id);
        }
      }

      // Calculate cluster center
      final centerLat =
          nearbyUsers.map((u) => u.location.latitude).reduce((a, b) => a + b) /
              nearbyUsers.length;
      final centerLng =
          nearbyUsers.map((u) => u.location.longitude).reduce((a, b) => a + b) /
              nearbyUsers.length;
      final center = GeoPoint(centerLat, centerLng);

      // Determine cluster color based on user states
      Color clusterColor;
      if (nearbyUsers.any((u) => u.isOnline)) {
        clusterColor = const Color(0xFF4BEFE0); // Mint for online users
      } else if (nearbyUsers.any((u) => u.isVerified)) {
        clusterColor = Colors.blue; // Blue for verified users
      } else {
        clusterColor = Colors.grey; // Grey for offline users
      }

      clusters.add(UserCluster(
        id: 'cluster_${center.latitude}_${center.longitude}',
        center: center,
        users: nearbyUsers,
        radius: clusterRadius,
        clusterColor: clusterColor,
      ));
    }

    return clusters;
  }

  // Send YO to a user
  Future<void> sendYO(String targetUserId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('notifications').add({
      'type': 'yo',
      'senderId': user.uid,
      'receiverId': targetUserId,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
      'data': {
        'message': '🫱 YO!',
        'action': 'yo',
      },
    });
  }

  // Add user to favorites
  Future<void> addToFavorites(String targetUserId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(targetUserId)
        .set({
      'timestamp': FieldValue.serverTimestamp(),
      'targetUserId': targetUserId,
    });
  }

  // Remove user from favorites
  Future<void> removeFromFavorites(String targetUserId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(targetUserId)
        .delete();
  }

  // Get user's favorites
  Stream<List<String>> getUserFavorites() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  // Start a chat with a user
  Future<String> startChat(String targetUserId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Check if chat already exists
    final existingChats = await _firestore
        .collection('chats')
        .where('participants', arrayContains: user.uid)
        .get();

    for (final chat in existingChats.docs) {
      final participants = List<String>.from(chat.data()['participants']);
      if (participants.contains(targetUserId)) {
        return chat.id; // Return existing chat ID
      }
    }

    // Create new chat
    final chatRef = await _firestore.collection('chats').add({
      'participants': [user.uid, targetUserId],
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': null,
      'lastMessageTime': null,
    });

    return chatRef.id;
  }

  // Get user profile data
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }

  // Update user's anonymous status
  Future<void> updateAnonymousStatus(bool isAnonymous) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _userLocationsCollection.doc(user.uid).update({
      'isAnonymous': isAnonymous,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Get popular tags
  Future<List<String>> getPopularTags() async {
    try {
      final snapshot = await _firestore
          .collection('tags')
          .orderBy('usageCount', descending: true)
          .limit(20)
          .get();

      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      return [];
    }
  }

  // Search users by tags
  Stream<List<NowMapUser>> searchUsersByTags(
      List<String> tags, GeoPoint currentLocation) {
    return _userLocationsCollection
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      final users = <NowMapUser>[];

      for (final doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          final userTags = List<String>.from(data['tags'] ?? []);

          if (tags.any((tag) => userTags.contains(tag))) {
            final user = NowMapUser.fromFirestore(doc, currentLocation);
            users.add(user);
          }
        } catch (e) {
          continue;
        }
      }

      return users;
    });
  }

  // Get user activity statistics
  Future<Map<String, dynamic>> getUserActivityStats() async {
    final user = _auth.currentUser;
    if (user == null) return {};

    try {
      final now = DateTime.now();
      final oneHourAgo = now.subtract(const Duration(hours: 1));
      final oneDayAgo = now.subtract(const Duration(days: 1));

      final hourlyUsers = await _userLocationsCollection
          .where('lastUpdated', isGreaterThan: Timestamp.fromDate(oneHourAgo))
          .count()
          .get();

      final dailyUsers = await _userLocationsCollection
          .where('lastUpdated', isGreaterThan: Timestamp.fromDate(oneDayAgo))
          .count()
          .get();

      return {
        'activeLastHour': hourlyUsers.count,
        'activeLastDay': dailyUsers.count,
        'totalUsers': await _userLocationsCollection
            .count()
            .get()
            .then((value) => value.count),
      };
    } catch (e) {
      return {};
    }
  }

  // Get current user's anonymous status
  Future<bool> getCurrentUserAnonymousStatus() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    final doc = await _userLocationsCollection.doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return data['isAnonymous'] ?? false;
    }
    return false;
  }
}
