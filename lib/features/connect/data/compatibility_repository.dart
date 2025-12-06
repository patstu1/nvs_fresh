import 'package:cloud_firestore/cloud_firestore.dart';

class CompatibilityData {
  CompatibilityData({required this.score, required this.bloom}); // 0..1.0

  factory CompatibilityData.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic>? data = doc.data();
    return CompatibilityData(
      score: (data?['score'] ?? 0) as int,
      bloom: ((data?['bloom'] ?? 0.0) as num).toDouble(),
    );
  }
  final int score; // 0..100
  final double bloom;
}

class CompatibilityRepository {
  CompatibilityRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Stream<CompatibilityData?> watchCompatibility(String userId, String matchUserId) {
    return _firestore
        .collection('compatibility')
        .doc(userId)
        .collection('matches')
        .doc(matchUserId)
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> snap) {
      if (!snap.exists) return null;
      return CompatibilityData.fromDoc(snap);
    });
  }
}



