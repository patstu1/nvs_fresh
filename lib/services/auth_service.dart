import 'package:firebase_auth/firebase_auth.dart';
// Explicit User import for latest Firebase versions

/// Authentication service for Firebase integration
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String baseUrl = 'http://localhost:3000/api/auth';

  /// Get current user
  static User? get currentUser => _auth.currentUser;

  /// Get current user stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  static Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Verify token with backend
      await _verifyTokenWithBackend();

      return credential;
    } on FirebaseAuthException catch (e) {
      print('Auth error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  /// Create user with email and password
  static Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name if provided
      if (displayName != null && credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
      }

      // Verify token with backend
      await _verifyTokenWithBackend();

      return credential;
    } on FirebaseAuthException catch (e) {
      print('Auth error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get current user ID token
  static Future<String?> getIdToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  /// Verify token with backend
  static Future<bool> _verifyTokenWithBackend() async {
    try {
      final token = await getIdToken();
      if (token == null) return false;

      // TODO: Implement token verification with backend
      return true; // Temporarily return true for development
    } catch (e) {
      print('Token verification error: $e');
      return false;
    }
  }

  /// Get user profile from backend
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final token = await getIdToken();
      if (token == null) return null;

      // TODO: Implement profile fetch with backend
      // For now, return null to indicate no additional profile data
      return null;
    } catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }

  /// Send password reset email
  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('Password reset error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  /// Update user profile
  static Future<void> updateProfile({String? displayName, String? photoURL}) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoURL);
    }
  }

  /// Check if user is authenticated
  static bool get isAuthenticated => _auth.currentUser != null;

  /// Check if user email is verified
  static bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  /// Send email verification
  static Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /// Reload current user data
  static Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  /// Delete current user account
  static Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.delete();
    }
  }

  // THE MISSING METHODS.
  // The implementation can be a placeholder, but the signature must be perfect.
  static Future<UserCredential?> signInWithEmail(String email, String password) async {
    print("Attempting sign-in for $email");
    return await signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<UserCredential?> signUpWithEmail(String email, String password) async {
    print("Attempting sign-up for $email");
    return await createUserWithEmailAndPassword(email: email, password: password);
  }
}
