import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getUserSettings() async {
    final User? user = _auth.currentUser;
    if (user == null) return null;
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _firestore.collection('users').doc(user.uid).get();
    return doc.data()?['settings'] as Map<String, dynamic>?;
  }

  Future<void> updateUserSettings(Map<String, dynamic> settings) async {
    final User? user = _auth.currentUser;
    if (user == null) return;
    await _firestore
        .collection('users')
        .doc(user.uid)
        .update(<Object, Object?>{'settings': settings});
  }
}
