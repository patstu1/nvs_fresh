import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesService {
  FavoritesService() : _firestore = FirebaseFirestore.instance, _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String? get _uid => _auth.currentUser?.uid;

  Stream<Set<String>> favoriteIdsStream() {
    final String? uid = _uid;
    if (uid == null) {
      return Stream<Set<String>>.value(<String>{});
    }
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .snapshots()
        .map(
          (QuerySnapshot<Map<String, dynamic>> snap) =>
              snap.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.id).toSet(),
        );
  }

  Future<bool> isFavorite(String userId) async {
    final String? uid = _uid;
    if (uid == null) return false;
    final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(userId)
        .get();
    return doc.exists;
  }

  Future<void> toggleFavorite(String userId) async {
    final String? uid = _uid;
    if (uid == null) return;

    final DocumentReference<Map<String, dynamic>> ref = _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(userId);

    final DocumentSnapshot<Map<String, dynamic>> doc = await ref.get();
    if (doc.exists) {
      await ref.delete();
    } else {
      await ref.set(<String, dynamic>{'timestamp': FieldValue.serverTimestamp()});
    }
  }
}




