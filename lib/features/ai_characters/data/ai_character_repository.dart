import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ai_character_model.dart';

class AICharacterRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection references
  CollectionReference get _conversationsCollection => _firestore.collection('ai_conversations');
  CollectionReference get _userPreferencesCollection => _firestore.collection('user_preferences');
  CollectionReference get _matchmakingDataCollection => _firestore.collection('matchmaking_data');
  CollectionReference get _reportsCollection => _firestore.collection('reports');

  // Save conversation message
  Future<void> saveConversationMessage({
    required AICharacterType characterType,
    required String message,
    required bool isUserMessage,
    required Map<String, dynamic>? metadata,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    await _conversationsCollection.add(<String, Object>{
      'userId': user.uid,
      'characterType': characterType.name,
      'message': message,
      'isUserMessage': isUserMessage,
      'timestamp': FieldValue.serverTimestamp(),
      'metadata': metadata ?? <String, dynamic>{},
    });
  }

  // Get conversation history
  Stream<QuerySnapshot> getConversationHistory(AICharacterType characterType) {
    final User? user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _conversationsCollection
        .where('userId', isEqualTo: user.uid)
        .where('characterType', isEqualTo: characterType.name)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();
  }

  // Save user preferences for matchmaking
  Future<void> saveUserPreferences({
    required Map<String, dynamic> preferences,
    required Map<String, dynamic>? astrologyData,
    required Map<String, dynamic>? stylePreferences,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    await _userPreferencesCollection.doc(user.uid).set(
      <String, Object?>{
        'preferences': preferences,
        'astrologyData': astrologyData,
        'stylePreferences': stylePreferences,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  // Get user preferences
  Future<Map<String, dynamic>?> getUserPreferences() async {
    final User? user = _auth.currentUser;
    if (user == null) return null;

    final DocumentSnapshot<Object?> doc = await _userPreferencesCollection.doc(user.uid).get();
    return doc.data() as Map<String, dynamic>?;
  }

  // Save matchmaking data
  Future<void> saveMatchmakingData({
    required String targetUserId,
    required Map<String, dynamic> compatibilityData,
    required String recommendation,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    await _matchmakingDataCollection.add(<String, Object>{
      'userId': user.uid,
      'targetUserId': targetUserId,
      'compatibilityData': compatibilityData,
      'recommendation': recommendation,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get potential matches based on preferences
  Future<List<Map<String, dynamic>>> getPotentialMatches({
    required Map<String, dynamic> preferences,
    required GeoPoint? userLocation,
    int limit = 20,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) return <Map<String, dynamic>>[];

    final Query query = _firestore
        .collection('users')
        .where('isActive', isEqualTo: true)
        .where('userId', isNotEqualTo: user.uid);

    // Add location filter if available
    if (userLocation != null) {
      // This would need a geohash implementation for proper geoqueries
      // For now, we'll get all users and filter in memory
    }

    final QuerySnapshot<Object?> snapshot = await query.limit(limit).get();
    return snapshot.docs.map((QueryDocumentSnapshot<Object?> doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return <String, dynamic>{
        'userId': doc.id,
        ...data,
      };
    }).toList();
  }

  // Report a user
  Future<void> reportUser({
    required String reportedUserId,
    required String reason,
    required String description,
    required List<String> evidence,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    await _reportsCollection.add(<String, Object>{
      'reporterId': user.uid,
      'reportedUserId': reportedUserId,
      'reason': reason,
      'description': description,
      'evidence': evidence,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get user's reports
  Stream<QuerySnapshot> getUserReports() {
    final User? user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _reportsCollection
        .where('reporterId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Update user's AI interaction preferences
  Future<void> updateAIInteractionPreferences({
    required AICharacterType characterType,
    required Map<String, dynamic> preferences,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    await _userPreferencesCollection.doc(user.uid).update(<Object, Object?>{
      'aiPreferences.${characterType.name}': preferences,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get AI interaction analytics
  Future<Map<String, dynamic>> getAIInteractionAnalytics() async {
    final User? user = _auth.currentUser;
    if (user == null) return <String, dynamic>{};

    final QuerySnapshot<Object?> conversations =
        await _conversationsCollection.where('userId', isEqualTo: user.uid).get();

    final Map<String, dynamic> analytics = <String, dynamic>{
      'totalConversations': conversations.docs.length,
      'domBotInteractions': 0,
      'webmasterInteractions': 0,
      'lastInteraction': null,
    };

    for (final QueryDocumentSnapshot<Object?> doc in conversations.docs) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      final String characterType = data['characterType'] as String;

      if (characterType == 'domBot') {
        analytics['domBotInteractions']++;
      } else if (characterType == 'webmaster') {
        analytics['webmasterInteractions']++;
      }

      final Timestamp? timestamp = data['timestamp'] as Timestamp?;
      if (timestamp != null) {
        final DateTime? lastInteraction = analytics['lastInteraction'] as DateTime?;
        final DateTime currentTimestampDate = timestamp.toDate();
        if (lastInteraction == null || currentTimestampDate.isAfter(lastInteraction)) {
          analytics['lastInteraction'] = currentTimestampDate;
        }
      }
    }

    return analytics;
  }

  // Save user's relationship questions answers
  Future<void> saveRelationshipAnswers({
    required Map<String, dynamic> answers,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    await _userPreferencesCollection.doc(user.uid).update(<Object, Object?>{
      'relationshipAnswers': answers,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get user's relationship answers
  Future<Map<String, dynamic>?> getRelationshipAnswers() async {
    final User? user = _auth.currentUser;
    if (user == null) return null;

    final DocumentSnapshot<Object?> doc = await _userPreferencesCollection.doc(user.uid).get();
    final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    return data?['relationshipAnswers'] as Map<String, dynamic>?;
  }
}
