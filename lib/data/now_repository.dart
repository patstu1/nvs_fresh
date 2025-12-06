import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nvs/meatup_core.dart';

class NowRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<UserProfile>> getNowUsers() {
    return _firestore
        .collection('users')
        .where('nowContent', isGreaterThan: {})
        .where('isOnline', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserProfile.fromFirestore(doc))
            .toList());
  }
}
