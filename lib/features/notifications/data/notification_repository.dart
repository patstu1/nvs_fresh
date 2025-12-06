// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'notification_model.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<AppNotification>> getUserNotifications() {
    final User? user = _auth.currentUser;
    if (user == null) {
      return Stream.value(<AppNotification>[]);
    }
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) =>
              snapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            final Map<String, dynamic> data = doc.data();
            return AppNotification.fromJson(<String, dynamic>{
              'id': doc.id,
              ...data,
            });
          }).toList(),
        );
  }
}
