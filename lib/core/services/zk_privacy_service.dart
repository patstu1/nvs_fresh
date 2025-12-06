// lib/core/services/zk_privacy_service.dart
// Zero-Knowledge Privacy Service for Anonymous Mode
// Enables privacy-preserving matching without revealing user data

import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quantum_user_profile.dart';

// =============================================================================
// ZERO-KNOWLEDGE DATA MODELS
// =============================================================================

class ZKAnonymousProfile {
  const ZKAnonymousProfile({
    required this.anonymousUserId,
    required this.ageRange,
    required this.locationCluster,
    required this.proofCommitment,
    required this.expiresAt,
    required this.privacyLevel,
  });

  factory ZKAnonymousProfile.fromJson(Map<String, dynamic> json) {
    return ZKAnonymousProfile(
      anonymousUserId: json['anonymous_user_id'] as String,
      ageRange: json['age_range'] as String,
      locationCluster: json['location_cluster'] as String,
      proofCommitment: json['proof_commitment'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      privacyLevel: json['privacy_level'] ?? 'maximum',
    );
  }
  final String anonymousUserId;
  final String ageRange;
  final String locationCluster;
  final String proofCommitment;
  final DateTime expiresAt;
  final String privacyLevel;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'anonymous_user_id': anonymousUserId,
      'age_range': ageRange,
      'location_cluster': locationCluster,
      'proof_commitment': proofCommitment,
      'expires_at': expiresAt.toIso8601String(),
      'privacy_level': privacyLevel,
    };
  }
}

class ZKAnonymousMatch {
  const ZKAnonymousMatch({
    required this.matchId,
    required this.compatibilityProven,
    required this.locationCompatible,
    required this.biometricSynced,
    required this.confidenceLevel,
    required this.encryptedIntroduction,
    required this.proofVerification,
    required this.createdAt,
  });

  factory ZKAnonymousMatch.fromJson(Map<String, dynamic> json) {
    return ZKAnonymousMatch(
      matchId: json['match_id'] as String,
      compatibilityProven: json['compatibility_proven'] as bool,
      locationCompatible: json['location_compatible'] as bool,
      biometricSynced: json['biometric_synced'] as bool,
      confidenceLevel: (json['confidence_level'] as num).toDouble(),
      encryptedIntroduction: json['encrypted_introduction'] as String,
      proofVerification: json['proof_verification'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
  final String matchId;
  final bool compatibilityProven;
  final bool locationCompatible;
  final bool biometricSynced;
  final double confidenceLevel;
  final String encryptedIntroduction;
  final String proofVerification;
  final DateTime createdAt;
}

class ZKPrivacySettings {
  const ZKPrivacySettings({
    this.anonymousModeEnabled = false,
    this.privacyLevel = 3,
    this.allowBiometricMatching = true,
    this.allowLocationClustering = true,
    this.enableZeroKnowledgeProofs = true,
    this.anonymousSessionDuration = const Duration(hours: 24),
  });

  factory ZKPrivacySettings.fromJson(Map<String, dynamic> json) {
    return ZKPrivacySettings(
      anonymousModeEnabled: json['anonymous_mode_enabled'] ?? false,
      privacyLevel: json['privacy_level'] ?? 3,
      allowBiometricMatching: json['allow_biometric_matching'] ?? true,
      allowLocationClustering: json['allow_location_clustering'] ?? true,
      enableZeroKnowledgeProofs: json['enable_zk_proofs'] ?? true,
      anonymousSessionDuration: Duration(
        seconds: json['session_duration_seconds'] ?? 86400,
      ),
    );
  }
  final bool anonymousModeEnabled;
  final int privacyLevel; // 1-5, higher = more private
  final bool allowBiometricMatching;
  final bool allowLocationClustering;
  final bool enableZeroKnowledgeProofs;
  final Duration anonymousSessionDuration;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'anonymous_mode_enabled': anonymousModeEnabled,
      'privacy_level': privacyLevel,
      'allow_biometric_matching': allowBiometricMatching,
      'allow_location_clustering': allowLocationClustering,
      'enable_zk_proofs': enableZeroKnowledgeProofs,
      'session_duration_seconds': anonymousSessionDuration.inSeconds,
    };
  }

  ZKPrivacySettings copyWith({
    bool? anonymousModeEnabled,
    int? privacyLevel,
    bool? allowBiometricMatching,
    bool? allowLocationClustering,
    bool? enableZeroKnowledgeProofs,
    Duration? anonymousSessionDuration,
  }) {
    return ZKPrivacySettings(
      anonymousModeEnabled: anonymousModeEnabled ?? this.anonymousModeEnabled,
      privacyLevel: privacyLevel ?? this.privacyLevel,
      allowBiometricMatching: allowBiometricMatching ?? this.allowBiometricMatching,
      allowLocationClustering: allowLocationClustering ?? this.allowLocationClustering,
      enableZeroKnowledgeProofs: enableZeroKnowledgeProofs ?? this.enableZeroKnowledgeProofs,
      anonymousSessionDuration: anonymousSessionDuration ?? this.anonymousSessionDuration,
    );
  }
}

// =============================================================================
// ZERO-KNOWLEDGE PRIVACY SERVICE
// =============================================================================

class ZKPrivacyService extends ChangeNotifier {
  ZKPrivacyService({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();
  static const String _baseUrl = 'http://localhost:8001';
  static const String _prefsKey = 'zk_privacy_settings';
  static const String _anonymousProfileKey = 'zk_anonymous_profile';

  final http.Client _httpClient;
  SharedPreferences? _prefs;

  ZKPrivacySettings _settings = const ZKPrivacySettings();
  ZKAnonymousProfile? _currentAnonymousProfile;
  bool _isAnonymousModeActive = false;
  List<ZKAnonymousMatch> _anonymousMatches = <ZKAnonymousMatch>[];
  bool _isLoading = false;

  // =============================================================================
  // GETTERS
  // =============================================================================

  ZKPrivacySettings get settings => _settings;
  ZKAnonymousProfile? get currentAnonymousProfile => _currentAnonymousProfile;
  bool get isAnonymousModeActive => _isAnonymousModeActive;
  List<ZKAnonymousMatch> get anonymousMatches => List.unmodifiable(_anonymousMatches);
  bool get isLoading => _isLoading;

  String get privacyLevelDescription {
    switch (_settings.privacyLevel) {
      case 1:
        return 'Minimal Privacy';
      case 2:
        return 'Basic Privacy';
      case 3:
        return 'Standard Privacy';
      case 4:
        return 'High Privacy';
      case 5:
        return 'Maximum Privacy';
      default:
        return 'Standard Privacy';
    }
  }

  bool get hasActiveAnonymousSession {
    if (_currentAnonymousProfile == null) return false;
    return DateTime.now().isBefore(_currentAnonymousProfile!.expiresAt);
  }

  // =============================================================================
  // INITIALIZATION
  // =============================================================================

  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadSettings();
      await _loadAnonymousProfile();

      if (hasActiveAnonymousSession && _settings.anonymousModeEnabled) {
        _isAnonymousModeActive = true;
      }

      debugPrint('🔐 ZK Privacy Service initialized');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Failed to initialize ZK Privacy Service: $e');
    }
  }

  Future<void> _loadSettings() async {
    final String? settingsJson = _prefs?.getString(_prefsKey);
    if (settingsJson != null) {
      final Map<String, dynamic> json = jsonDecode(settingsJson);
      _settings = ZKPrivacySettings.fromJson(json);
    }
  }

  Future<void> _saveSettings() async {
    await _prefs?.setString(_prefsKey, jsonEncode(_settings.toJson()));
  }

  Future<void> _loadAnonymousProfile() async {
    final String? profileJson = _prefs?.getString(_anonymousProfileKey);
    if (profileJson != null) {
      final Map<String, dynamic> json = jsonDecode(profileJson);
      _currentAnonymousProfile = ZKAnonymousProfile.fromJson(json);
    }
  }

  Future<void> _saveAnonymousProfile() async {
    if (_currentAnonymousProfile != null) {
      await _prefs?.setString(
        _anonymousProfileKey,
        jsonEncode(_currentAnonymousProfile!.toJson()),
      );
    } else {
      await _prefs?.remove(_anonymousProfileKey);
    }
  }

  // =============================================================================
  // PRIVACY SETTINGS MANAGEMENT
  // =============================================================================

  Future<void> updatePrivacySettings(ZKPrivacySettings newSettings) async {
    _settings = newSettings;
    await _saveSettings();

    // If anonymous mode was disabled, clean up
    if (!newSettings.anonymousModeEnabled && _isAnonymousModeActive) {
      await exitAnonymousMode();
    }

    debugPrint('🔐 Privacy settings updated');
    notifyListeners();
  }

  Future<void> setPrivacyLevel(int level) async {
    if (level < 1 || level > 5) return;

    final ZKPrivacySettings newSettings = _settings.copyWith(privacyLevel: level);
    await updatePrivacySettings(newSettings);
  }

  Future<void> toggleAnonymousMode() async {
    if (_isAnonymousModeActive) {
      await exitAnonymousMode();
    } else {
      await enterAnonymousMode();
    }
  }

  // =============================================================================
  // ANONYMOUS MODE MANAGEMENT
  // =============================================================================

  Future<bool> enterAnonymousMode({QuantumUserProfile? userProfile}) async {
    if (_isAnonymousModeActive) return true;

    _isLoading = true;
    notifyListeners();

    try {
      // Create anonymous profile if needed
      if (_currentAnonymousProfile == null || !hasActiveAnonymousSession) {
        final bool success = await _createAnonymousProfile(userProfile);
        if (!success) return false;
      }

      _isAnonymousModeActive = true;

      final ZKPrivacySettings newSettings = _settings.copyWith(anonymousModeEnabled: true);
      await updatePrivacySettings(newSettings);

      debugPrint('🔐 Entered anonymous mode: ${_currentAnonymousProfile?.anonymousUserId}');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to enter anonymous mode: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> exitAnonymousMode() async {
    _isAnonymousModeActive = false;
    _anonymousMatches.clear();

    final ZKPrivacySettings newSettings = _settings.copyWith(anonymousModeEnabled: false);
    await updatePrivacySettings(newSettings);

    debugPrint('🔐 Exited anonymous mode');
    notifyListeners();
  }

  Future<bool> _createAnonymousProfile(QuantumUserProfile? userProfile) async {
    if (userProfile == null) return false;

    try {
      final Map<String, dynamic> requestBody = <String, dynamic>{
        'age': userProfile.age ?? 25,
        'latitude': userProfile.location?.latitude ?? 0.0,
        'longitude': userProfile.location?.longitude ?? 0.0,
        'interests': userProfile.interests,
        'biometric_data': _extractBiometricData(userProfile),
        'preferences': _extractPreferences(userProfile),
        'privacy_level': _settings.privacyLevel,
      };

      final http.Response response = await _httpClient.post(
        Uri.parse('$_baseUrl/create_anonymous_profile'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        _currentAnonymousProfile = ZKAnonymousProfile.fromJson(responseData);
        await _saveAnonymousProfile();

        debugPrint('🔐 Created anonymous profile: ${_currentAnonymousProfile?.anonymousUserId}');
        return true;
      } else {
        debugPrint('❌ Failed to create anonymous profile: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error creating anonymous profile: $e');
      return false;
    }
  }

  Map<String, double> _extractBiometricData(QuantumUserProfile profile) {
    final biometrics = profile.biometricSignature;
    return <String, double>{
      'heart_rate': biometrics?.baselineHRV ?? 70.0,
      'hrv': biometrics?.baselineHRV ?? 50.0,
      'stress_level': 0.5, // Default neutral level
      'arousal_level': 0.5, // Default neutral level
      'skin_temp': 37.0, // Default body temperature
    };
  }

  Map<String, dynamic> _extractPreferences(QuantumUserProfile profile) {
    final prefs = profile.preferences;
    return <String, dynamic>{
      'social_energy': prefs?.socialEnergyLevel ?? 0.5,
      'activity_level': prefs?.activityLevel ?? 0.5,
      'intimacy_preference': prefs?.intimacyPreference ?? 0.5,
      'communication_style': prefs?.communicationStyle ?? 0.5,
    };
  }

  // =============================================================================
  // ANONYMOUS MATCHING
  // =============================================================================

  Future<List<ZKAnonymousMatch>> findAnonymousMatches({
    double maxDistanceKm = 50.0,
    double minCompatibility = 0.7,
    String privacyMode = 'high',
  }) async {
    if (!_isAnonymousModeActive || _currentAnonymousProfile == null) {
      return <ZKAnonymousMatch>[];
    }

    _isLoading = true;
    notifyListeners();

    try {
      final Map<String, Object> requestBody = <String, Object>{
        'anonymous_user_id': _currentAnonymousProfile!.anonymousUserId,
        'max_distance_km': maxDistanceKm,
        'min_compatibility': minCompatibility,
        'privacy_mode': privacyMode,
      };

      final http.Response response = await _httpClient.post(
        Uri.parse('$_baseUrl/find_anonymous_matches'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        _anonymousMatches = responseData.map((json) => ZKAnonymousMatch.fromJson(json)).toList();

        debugPrint('🔐 Found ${_anonymousMatches.length} anonymous matches');
        return _anonymousMatches;
      } else {
        debugPrint('❌ Failed to find anonymous matches: ${response.statusCode}');
        return <ZKAnonymousMatch>[];
      }
    } catch (e) {
      debugPrint('❌ Error finding anonymous matches: $e');
      return <ZKAnonymousMatch>[];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =============================================================================
  // ZERO-KNOWLEDGE PROOF VERIFICATION
  // =============================================================================

  Future<bool> verifyZKProof(String proofId, String userSignature) async {
    try {
      final Map<String, String> requestBody = <String, String>{
        'proof_id': proofId,
        'user_signature': userSignature,
      };

      final http.Response response = await _httpClient.post(
        Uri.parse('$_baseUrl/verify_zk_proof'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final bool verified = responseData['verified'] as bool;

        debugPrint('🔐 ZK Proof verification: $verified');
        return verified;
      }

      return false;
    } catch (e) {
      debugPrint('❌ Error verifying ZK proof: $e');
      return false;
    }
  }

  // =============================================================================
  // UTILITY METHODS
  // =============================================================================

  String generateUserSignature(String data) {
    // Generate a signature for the user (simplified)
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String combined = '$data:$timestamp';
    final Uint8List bytes = utf8.encode(combined);
    final Digest digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool isCompatibilityMatch(ZKAnonymousMatch match) {
    return match.compatibilityProven && match.locationCompatible && match.confidenceLevel >= 0.7;
  }

  String getMatchQualityDescription(ZKAnonymousMatch match) {
    if (match.confidenceLevel >= 0.9) return 'Excellent Match';
    if (match.confidenceLevel >= 0.8) return 'Great Match';
    if (match.confidenceLevel >= 0.7) return 'Good Match';
    if (match.confidenceLevel >= 0.6) return 'Fair Match';
    return 'Potential Match';
  }

  Color getMatchQualityColor(ZKAnonymousMatch match) {
    if (match.confidenceLevel >= 0.9) return const Color(0xFF00FFF0); // Neon cyan
    if (match.confidenceLevel >= 0.8) return const Color(0xFF00FF88); // Neon green
    if (match.confidenceLevel >= 0.7) return const Color(0xFFFFFF00); // Neon yellow
    if (match.confidenceLevel >= 0.6) return const Color(0xFFFF8800); // Neon orange
    return const Color(0xFFFF4444); // Neon red
  }

  // =============================================================================
  // CLEANUP
  // =============================================================================

  Future<void> clearAnonymousData() async {
    _currentAnonymousProfile = null;
    _anonymousMatches.clear();
    await _prefs?.remove(_anonymousProfileKey);

    debugPrint('🔐 Cleared anonymous data');
    notifyListeners();
  }

  @override
  void dispose() {
    _httpClient.close();
    super.dispose();
  }
}
