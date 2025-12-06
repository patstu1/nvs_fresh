import 'package:cloud_firestore/cloud_firestore.dart';
import 'room_model.dart';

class RoomRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Room>> getRooms() {
    return _firestore.collection('rooms').orderBy('updatedAt', descending: true).snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) =>
              snapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            final Map<String, dynamic> data = doc.data();
            return Room.fromJson(<String, dynamic>{
              'id': doc.id,
              ...data,
            });
          }).toList(),
        );
  }
}
