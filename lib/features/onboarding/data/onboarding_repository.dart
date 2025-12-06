// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:nvs/meatup_core.dart';

class OnboardingRepository {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateProfile(UserProfile profile) async {
    // Temporarily disabled Firebase integration
    // final User? user = _auth.currentUser;
    // if (user == null) return;
    // await _firestore.collection('users').doc(user.uid).update(profile.toJson());
    print('OnboardingRepository.updateProfile: ${profile.toString()}');
  }

  Future<UserProfile?> getCurrentUserProfile() async {
    // Temporarily disabled Firebase integration
    // final User? user = _auth.currentUser;
    // if (user == null) return null;
    // final DocumentSnapshot<Map<String, dynamic>> doc =
    //     await _firestore.collection('users').doc(user.uid).get();
    // if (!doc.exists) return null;
    // return UserProfile.fromFirestore(doc.data()!);
    return null;
  }
}
