import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import '../middleware/token_middleware.dart';

/// Enterprise-grade Authentication service with security hardening
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static final LocalAuthentication _localAuth = LocalAuthentication();

  // Use environment variable for base URL (no hardcoded localhost)
  static String get baseUrl => const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.nvs.app/auth', // Production URL
  );

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
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

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
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
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
    final User? user = _auth.currentUser;
    if (user != null) {
      return user.getIdToken();
    }
    return null;
  }

  /// Verify token with backend
  static Future<bool> _verifyTokenWithBackend() async {
    try {
      final String? token = await getIdToken();
      if (token == null) return false;

      final http.Response? response = await TokenMiddleware.apiRequest(
        baseUrl: baseUrl,
        method: 'POST',
        endpoint: '/auth/verify',
        headers: <String, String>{'Authorization': 'Bearer $token'},
      );

      return response?.statusCode == 200;
    } catch (e) {
      print('Token verification error: $e');
      return false;
    }
  }

  /// Get user profile from backend
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final String? token = await getIdToken();
      if (token == null) return null;

      final http.Response? response = await TokenMiddleware.apiRequest(
        baseUrl: baseUrl,
        method: 'GET',
        endpoint: '/auth/profile',
        headers: <String, String>{'Authorization': 'Bearer $token'},
      );

      if (response?.statusCode == 200) {
        final data = json.decode(response!.body);
        return data['user'];
      }
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
  static Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    final User? user = _auth.currentUser;
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
    final User? user = _auth.currentUser;
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
    final User? user = _auth.currentUser;
    if (user != null) {
      await user.delete();
    }
  }
}
