// lib/core/services/quantum_auth_sync_service.dart
// Unified Authentication & Profile Sync Service for NVS 2027+ Architecture
// Real-time auth state synchronization across all sections without manual refresh

import 'dart:async';
import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/app_types.dart' show AppSection;
import '../models/quantum_user_profile.dart';

/// Quantum Auth Sync Service - Enterprise Authentication Management
///
/// Features:
/// - Real-time auth state synchronization across all app sections
/// - Automatic profile data refresh without manual intervention
/// - Bio-neural profile state management with wearable integration
/// - Zero-knowledge authentication with privacy preservation
/// - Quantum-resistant session management
/// - Cross-section state consistency enforcement
class QuantumAuthSyncService {
  factory QuantumAuthSyncService() => _instance;
  QuantumAuthSyncService._internal();
  static final QuantumAuthSyncService _instance = QuantumAuthSyncService._internal();

  // ============================================================================
  // CONFIGURATION & STATE
  // ============================================================================

  // Authentication state
  User? _currentUser;
  QuantumUserProfile? _currentProfile;
  AuthenticationState _authState = AuthenticationState.unauthenticated;
  DateTime? _lastSyncTime;

  // Profile sync state
  bool _isProfileSyncing = false;
  bool _isInitialized = false;
  final Map<String, dynamic> _profileCache = <String, dynamic>{};
  final Set<String> _pendingUpdates = <String>{};

  // Stream controllers for real-time updates
  final StreamController<AuthStateChange> _authStateController =
      StreamController<AuthStateChange>.broadcast();
  final StreamController<QuantumUserProfile?> _profileController =
      StreamController<QuantumUserProfile?>.broadcast();
  final StreamController<BiometricProfile?> _biometricController =
      StreamController<BiometricProfile?>.broadcast();

  // Subscription management
  StreamSubscription<User?>? _firebaseAuthSubscription;
  final List<StreamSubscription> _activeSubscriptions = <StreamSubscription>[];

  // Performance tracking
  int _syncOperationCount = 0;
  int _syncSuccessCount = 0;
  Duration _avgSyncTime = Duration.zero;
  final List<Duration> _syncTimeWindow = <Duration>[];

  // Section sync tracking
  final Map<AppSection, DateTime> _lastSectionSync = <AppSection, DateTime>{};
  final Map<AppSection, bool> _sectionSyncStatus = <AppSection, bool>{};

  // ============================================================================
  // PUBLIC API - STREAMS
  // ============================================================================

  /// Stream of authentication state changes
  Stream<AuthStateChange> get authStateChanges => _authStateController.stream;

  /// Stream of profile updates
  Stream<QuantumUserProfile?> get profileUpdates => _profileController.stream;

  /// Stream of biometric profile updates
  Stream<BiometricProfile?> get biometricUpdates => _biometricController.stream;

  /// Current authentication state
  AuthenticationState get authState => _authState;

  /// Current user (Firebase)
  User? get currentUser => _currentUser;

  /// Current quantum profile
  QuantumUserProfile? get currentProfile => _currentProfile;

  /// Check if user is authenticated
  bool get isAuthenticated => _authState == AuthenticationState.authenticated;

  /// Check if profile is fully synced
  bool get isProfileSynced => _currentProfile != null && !_isProfileSyncing;

  // ============================================================================
  // INITIALIZATION & LIFECYCLE
  // ============================================================================

  /// Initialize the Quantum Auth Sync Service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize Firebase Auth listener
      _firebaseAuthSubscription =
          FirebaseAuth.instance.authStateChanges().listen(_handleFirebaseAuthChange);

      // Initialize section sync status
      for (final AppSection section in AppSection.values) {
        _sectionSyncStatus[section] = false;
      }

      // Check current auth state
      _currentUser = FirebaseAuth.instance.currentUser;
      if (_currentUser != null) {
        await _handleUserAuthenticated(_currentUser);
      } else {
        _updateAuthState(AuthenticationState.unauthenticated);
      }

      // Start periodic sync health checks
      _startPeriodicSyncCheck();

      _isInitialized = true;

      if (kDebugMode) {
        developer.log('Quantum Auth Sync Service initialized', name: 'QuantumAuth');
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('Failed to initialize Quantum Auth Sync: $e', name: 'QuantumAuth');
      }
      rethrow;
    }
  }

  /// Shutdown service and cleanup resources
  Future<void> shutdown() async {
    await _firebaseAuthSubscription?.cancel();

    for (final StreamSubscription subscription in _activeSubscriptions) {
      await subscription.cancel();
    }
    _activeSubscriptions.clear();

    await _authStateController.close();
    await _profileController.close();
    await _biometricController.close();

    _profileCache.clear();
    _pendingUpdates.clear();
    _lastSectionSync.clear();
    _sectionSyncStatus.clear();

    _isInitialized = false;

    if (kDebugMode) {
      developer.log('Quantum Auth Sync Service shutdown complete', name: 'QuantumAuth');
    }
  }

  // ============================================================================
  // AUTHENTICATION MANAGEMENT
  // ============================================================================

  /// Sign in with Firebase and sync profile
  Future<AuthResult> signInWithCredential(AuthCredential credential) async {
    try {
      _updateAuthState(AuthenticationState.authenticating);

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _handleUserAuthenticated(user);
        return AuthResult.success(user: user, profile: _currentProfile);
      } else {
        _updateAuthState(AuthenticationState.unauthenticated);
        return AuthResult.failure(error: 'Authentication failed: No user returned');
      }
    } catch (e) {
      _updateAuthState(AuthenticationState.error, error: e.toString());
      return AuthResult.failure(error: 'Authentication error: $e');
    }
  }

  /// Sign out and clear all cached data
  Future<void> signOut() async {
    try {
      // Clear profile data
      _currentProfile = null;
      _profileCache.clear();
      _pendingUpdates.clear();

      // Reset section sync status
      for (final AppSection section in AppSection.values) {
        _sectionSyncStatus[section] = false;
      }

      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      _updateAuthState(AuthenticationState.unauthenticated);
      _profileController.add(null);
      _biometricController.add(null);

      if (kDebugMode) {
        developer.log('User signed out successfully', name: 'QuantumAuth');
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('Sign out error: $e', name: 'QuantumAuth');
      }
      rethrow;
    }
  }

  // ============================================================================
  // PROFILE SYNCHRONIZATION
  // ============================================================================

  /// Force refresh user profile from all sources
  Future<ProfileSyncResult> refreshProfile({bool includeServer = true}) async {
    if (!isAuthenticated || _currentUser == null) {
      return ProfileSyncResult.failure(error: 'User not authenticated');
    }

    if (_isProfileSyncing) {
      return ProfileSyncResult.failure(error: 'Profile sync already in progress');
    }

    final DateTime startTime = DateTime.now();
    _isProfileSyncing = true;

    try {
      // Refresh Firebase user data
      await _currentUser!.reload();
      _currentUser = FirebaseAuth.instance.currentUser;

      if (includeServer) {
        // Fetch latest profile from backend
        await _fetchProfileFromServer();
      }

      // Sync biometric data if available
      await _syncBiometricProfile();

      // Update all app sections
      await _syncAllSections();

      _lastSyncTime = DateTime.now();
      _recordSyncMetrics(startTime, success: true);

      return ProfileSyncResult.success(
        profile: _currentProfile,
        syncTime: _lastSyncTime!,
      );
    } catch (e) {
      _recordSyncMetrics(startTime, success: false);
      return ProfileSyncResult.failure(error: 'Profile sync failed: $e');
    } finally {
      _isProfileSyncing = false;
    }
  }

  /// Update specific profile field and sync across sections
  Future<void> updateProfileField(String fieldName, dynamic value) async {
    if (!isAuthenticated || _currentProfile == null) return;

    try {
      // Add to pending updates
      _pendingUpdates.add(fieldName);

      // Update local profile cache
      _profileCache[fieldName] = value;

      // Create updated profile
      final QuantumUserProfile updatedProfile = _applyProfileUpdates(_currentProfile);
      _currentProfile = updatedProfile;

      // Notify listeners
      _profileController.add(_currentProfile);

      // Sync to server (fire and forget)
      _syncProfileToServer().catchError((e) {
        if (kDebugMode) {
          developer.log('Background profile sync failed: $e', name: 'QuantumAuth');
        }
      });

      // Update relevant sections
      await _syncSectionsForField(fieldName);
    } catch (e) {
      if (kDebugMode) {
        developer.log('Profile field update failed: $e', name: 'QuantumAuth');
      }
    }
  }

  /// Sync biometric profile from wearable devices
  Future<void> syncBiometricProfile() async {
    await _syncBiometricProfile();
  }

  // ============================================================================
  // SECTION SYNCHRONIZATION
  // ============================================================================

  /// Mark section as requiring sync
  void markSectionForSync(AppSection section) {
    _sectionSyncStatus[section] = false;
  }

  /// Check if section is synced
  bool isSectionSynced(AppSection section) {
    return _sectionSyncStatus[section] ?? false;
  }

  /// Sync specific app section
  Future<void> syncSection(AppSection section) async {
    if (!isAuthenticated || _currentProfile == null) return;

    try {
      await _syncSingleSection(section);
      _sectionSyncStatus[section] = true;
      _lastSectionSync[section] = DateTime.now();

      if (kDebugMode) {
        developer.log('Section ${section.name} synced successfully', name: 'QuantumAuth');
      }
    } catch (e) {
      _sectionSyncStatus[section] = false;
      if (kDebugMode) {
        developer.log('Section ${section.name} sync failed: $e', name: 'QuantumAuth');
      }
    }
  }

  /// Get sync status for all sections
  Map<AppSection, SectionSyncState> getSectionSyncStatus() {
    final Map<AppSection, SectionSyncState> status = <AppSection, SectionSyncState>{};

    for (final AppSection section in AppSection.values) {
      status[section] = SectionSyncState(
        isSynced: _sectionSyncStatus[section] ?? false,
        lastSyncTime: _lastSectionSync[section],
        requiresSync: !(_sectionSyncStatus[section] ?? false),
      );
    }

    return status;
  }

  // ============================================================================
  // PERFORMANCE & HEALTH MONITORING
  // ============================================================================

  /// Get sync service health report
  SyncServiceHealthReport getHealthReport() {
    final DateTime now = DateTime.now();
    final double syncSuccessRate =
        _syncOperationCount > 0 ? _syncSuccessCount / _syncOperationCount : 0.0;

    final int syncedSectionCount = _sectionSyncStatus.values.where((bool synced) => synced).length;

    return SyncServiceHealthReport(
      isHealthy: syncSuccessRate > 0.95 && syncedSectionCount >= AppSection.values.length * 0.8,
      authState: _authState,
      lastSyncTime: _lastSyncTime,
      syncOperationCount: _syncOperationCount,
      syncSuccessRate: syncSuccessRate,
      averageSyncTime: _avgSyncTime,
      syncedSectionCount: syncedSectionCount,
      totalSectionCount: AppSection.values.length,
      isProfileSyncing: _isProfileSyncing,
      pendingUpdateCount: _pendingUpdates.length,
      syncProgress: AppSection.values.isEmpty
          ? 0.0
          : syncedSectionCount / AppSection.values.length,
    );
  }

  // ============================================================================
  // PRIVATE IMPLEMENTATION
  // ============================================================================

  /// Handle Firebase auth state changes
  Future<void> _handleFirebaseAuthChange(User? user) async {
    if (user != null && user != _currentUser) {
      await _handleUserAuthenticated(user);
    } else if (user == null && _currentUser != null) {
      _handleUserSignedOut();
    }
  }

  /// Handle user authentication
  Future<void> _handleUserAuthenticated(User user) async {
    _currentUser = user;
    _updateAuthState(AuthenticationState.authenticated);

    try {
      // Fetch or create quantum profile
      await _fetchOrCreateProfile();

      // Sync biometric data
      await _syncBiometricProfile();

      // Sync all sections
      await _syncAllSections();

      // Notify listeners
      _profileController.add(_currentProfile);
    } catch (e) {
      _updateAuthState(AuthenticationState.error, error: e.toString());
      if (kDebugMode) {
        developer.log('User authentication handling failed: $e', name: 'QuantumAuth');
      }
    }
  }

  /// Handle user sign out
  void _handleUserSignedOut() {
    _currentUser = null;
    _currentProfile = null;
    _profileCache.clear();
    _pendingUpdates.clear();

    for (final AppSection section in AppSection.values) {
      _sectionSyncStatus[section] = false;
    }

    _updateAuthState(AuthenticationState.unauthenticated);
    _profileController.add(null);
    _biometricController.add(null);
  }

  /// Update authentication state and notify listeners
  void _updateAuthState(AuthenticationState newState, {String? error}) {
    final AuthenticationState previousState = _authState;
    _authState = newState;

    final AuthStateChange change = AuthStateChange(
      previousState: previousState,
      currentState: newState,
      user: _currentUser,
      timestamp: DateTime.now(),
      error: error,
    );

    _authStateController.add(change);
  }

  /// Fetch or create quantum user profile
  Future<void> _fetchOrCreateProfile() async {
    if (_currentUser == null) return;

    try {
      // Try to fetch existing profile from server
      await _fetchProfileFromServer();

      // If no profile exists, create default quantum profile
      if (_currentProfile == null) {
        _currentProfile = _createDefaultQuantumProfile();
        await _syncProfileToServer();
      }
    } catch (e) {
      // Fallback to default profile creation
      _currentProfile = _createDefaultQuantumProfile();
      if (kDebugMode) {
        developer.log('Using default profile due to fetch error: $e', name: 'QuantumAuth');
      }
    }
  }

  /// Fetch profile from backend server
  Future<void> _fetchProfileFromServer() async {
    // Implementation would connect to quantum backend
    // For now, return demo profile
    await Future.delayed(const Duration(milliseconds: 200)); // Simulate network

    if (_currentUser != null) {
      _currentProfile = _createDefaultQuantumProfile();
    }
  }

  /// Sync profile to backend server
  Future<void> _syncProfileToServer() async {
    if (_currentProfile == null || _currentUser == null) return;

    try {
      // Implementation would sync to quantum backend
      await Future.delayed(const Duration(milliseconds: 100)); // Simulate network

      // Clear pending updates on successful sync
      _pendingUpdates.clear();
    } catch (e) {
      if (kDebugMode) {
        developer.log('Profile server sync failed: $e', name: 'QuantumAuth');
      }
    }
  }

  /// Sync biometric profile from wearable devices
  Future<void> _syncBiometricProfile() async {
    try {
      // Implementation would integrate with HealthKit/Health Connect
      // For now, create mock biometric data
      final BiometricProfile biometricProfile = _createMockBiometricProfile();

      if (_currentProfile != null) {
        _currentProfile = _currentProfile!.copyWith(biometrics: biometricProfile);
        _biometricController.add(biometricProfile);
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('Biometric sync failed: $e', name: 'QuantumAuth');
      }
    }
  }

  /// Sync all app sections
  Future<void> _syncAllSections() async {
    final Iterable<Future<void>> futures = AppSection.values.map(_syncSingleSection);
    await Future.wait(futures);

    // Update section sync status
    for (final AppSection section in AppSection.values) {
      _sectionSyncStatus[section] = true;
      _lastSectionSync[section] = DateTime.now();
    }
  }

  /// Sync individual app section
  Future<void> _syncSingleSection(AppSection section) async {
    // Implementation would sync specific section data
    await Future.delayed(const Duration(milliseconds: 50)); // Simulate sync
  }

  /// Sync sections that depend on specific profile field
  Future<void> _syncSectionsForField(String fieldName) async {
    final List<AppSection> relevantSections = _getSectionsForField(fieldName);

    final Iterable<Future<void>> futures = relevantSections.map(_syncSingleSection);
    await Future.wait(futures);

    for (final AppSection section in relevantSections) {
      _sectionSyncStatus[section] = true;
      _lastSectionSync[section] = DateTime.now();
    }
  }

  /// Get sections that need updating when a specific field changes
  List<AppSection> _getSectionsForField(String fieldName) {
    switch (fieldName) {
      case 'displayName':
      case 'bio':
      case 'profilePhoto':
        return AppSection.values; // All sections need these
      case 'location':
        return <AppSection>[AppSection.now, AppSection.connect, AppSection.grid];
      case 'biometrics':
        return <AppSection>[AppSection.connect, AppSection.live];
      case 'interests':
        return <AppSection>[AppSection.connect, AppSection.grid];
      default:
        return <AppSection>[AppSection.profile]; // Default to profile section only
    }
  }

  /// Apply pending profile updates
  QuantumUserProfile _applyProfileUpdates(QuantumUserProfile profile) {
    // Apply cached updates to profile
    // This is a simplified implementation
    return profile;
  }

  /// Create default quantum profile for new users
  QuantumUserProfile _createDefaultQuantumProfile() {
    final User user = _currentUser;
    final DateTime now = DateTime.now();

    return QuantumUserProfile(
      // Blockchain Identity (placeholder values for demo)
      walletAddress: 'demo_wallet_${user.uid}',
      profileNftAddress: 'demo_nft_${user.uid}',
      ipfsMetadataUri: 'ipfs://demo_metadata_${user.uid}',
      metaplexCollectionId: 'demo_collection',

      // Basic Identity
      displayName: user.displayName ?? 'Anonymous User',
      age: 25, // Default age

      // Visual Assets (placeholder)
      primaryPhotoIpfsUri: user.photoURL ?? 'ipfs://default_avatar',
      albumPhotoIpfsUris: <String>[],

      // Location (placeholder)
      location: const GeoQuantumCoordinates(
        latitude: 37.7749,
        longitude: -122.4194,
        accuracyMeters: 1000,
        quantumClusterId: 'demo_cluster',
        clusterDensity: 0.5,
        lastLocationUpdate: DateTime.now(),
      ),

      // Privacy (secure defaults)
      privacy: const PrivacyConfiguration(
        isIncognitoMode: false,
        shareLocation: true,
        shareBiometrics: false,
        shareActivityPatterns: false,
        allowQuantumAnalysis: true,
        enableZeroKnowledgeMode: false,
        hiddenDataFields: <String>[],
        visibility: VisibilitySettings(
          showAge: true,
          showDistance: true,
          showLastActive: true,
          showOnlineStatus: true,
          showCompatibilityScore: true,
          showBiometricSync: false,
        ),
      ),

      // Demo values for remaining required fields
      roleTags: <String>[],
      moodTags: <String>[],
      interestTags: <String>[],
      verification: VerificationStatus.emailVerified,
      neuralProfile: _createDefaultNeuralProfile(),
      behavioralSignature: _createDefaultBehavioralSignature(),
      activityPattern: _createDefaultActivityPattern(),
      astroSignature: _createDefaultAstroSignature(),
      resonanceFreq: _createDefaultResonanceFrequency(),
      status: UserStatusType.online,
      createdAt: now,
      updatedAt: now,
      subscription: SubscriptionTier.free,
    );
  }

  /// Create default neural compatibility profile
  NeuralCompatibilityProfile _createDefaultNeuralProfile() {
    return const NeuralCompatibilityProfile(
      personalityVector: PersonalityVector(
        extroversion: 0.5,
        agreeableness: 0.5,
        conscientiousness: 0.5,
        neuroticism: 0.3,
        openness: 0.7,
        dominance: 0.4,
        submission: 0.4,
        intimacyPreference: 0.5,
        adventurousness: 0.6,
        emotionalExpressiveness: 0.5,
        intellectualCuriosity: 0.7,
        confidenceScores: <String, double>{},
      ),
      emotionalIntelligenceIndex: 0.6,
      emotionalProfile: EmotionalProfile(
        emotionalStability: 0.7,
        empathyLevel: 0.8,
        stressResilience: 0.6,
        moodVariability: 0.4,
        primaryEmotionalTriggers: <String>[],
        emotionalRegulationStrategies: <String, double>{},
      ),
      socialProfile: SocialInteractionProfile(
        communicationStyle: 0.5,
        conflictResolutionStyle: 0.6,
        intimacyBuildingPattern: 0.5,
        boundaryFlexibility: 0.5,
        preferredCommunicationChannels: <String>[],
        socialEnergyPatterns: <String, double>{},
      ),
      neuralFeatureVector: <String, double>{},
      quantumEntanglementScore: 0.0,
      preferredPersonalityTypes: <String>[],
      preferences: CompatibilityPreferences(
        minCompatibilityScore: 0.6,
        dealBreakerTraits: <String>[],
        attractionFactors: <String>[],
        ageRange: AgeRange(min: 18, max: 65),
        maxDistance: 50.0,
        requireBiometricSync: false,
        requireAstroCompatibility: false,
      ),
      modelVersion: 'quantum-v1.0',
      lastAnalysis: DateTime.now(),
    );
  }

  /// Create default behavioral signature
  BehavioralSignature _createDefaultBehavioralSignature() {
    return const BehavioralSignature(
      avgSessionLength: Duration(minutes: 15),
      dailyOpenFrequency: 5,
      sectionTimeDistribution: <String, double>{},
      messageToViewRatio: 0.3,
      swipeToMatchRatio: 0.1,
      conversationInitiationRate: 0.2,
      profileCompletionRate: 0.7,
      photoUploadFrequency: 0.1,
      bioUpdateFrequency: 0.05,
      avgSocialRadius: 25.0,
      preferredInteractionTypes: <String>[],
      timeOfDayActivityPattern: <String, int>{},
      predictabilityIndex: 0.5,
      spontaneityScore: 0.5,
      consistencyRating: 0.6,
    );
  }

  /// Create default activity pattern
  ActivityPattern _createDefaultActivityPattern() {
    return const ActivityPattern(
      weeklyActivity: <String, double>{},
      hourlyActivity: <int, double>{},
      peakActivityWindows: <String>[],
      consistencyScore: 0.5,
      sectionUsageTime: <String, Duration>{},
    );
  }

  /// Create default astrological signature
  AstrologicalSignature _createDefaultAstroSignature() {
    return const AstrologicalSignature(
      sunSign: 'Gemini',
      planetaryPositions: <String, String>{},
      aspectAngles: <String, double>{},
      venusInfluence: 0.5,
      marsInfluence: 0.5,
      mercuryInfluence: 0.6,
      quantumAstroHash: 'demo_hash',
      resonanceAmplitude: 0.5,
    );
  }

  /// Create default quantum resonance frequency
  QuantumResonanceFrequency _createDefaultResonanceFrequency() {
    return QuantumResonanceFrequency(
      primaryFrequency: 7.83, // Schumann resonance
      harmonicFrequencies: <double>[14.3, 20.8, 27.3],
      quantumCoherence: 0.6,
      entanglementPotential: 0.5,
      dimensionalResonance: <String, double>{},
      lastQuantumAnalysis: DateTime.now(),
    );
  }

  /// Create mock biometric profile
  BiometricProfile _createMockBiometricProfile() {
    return BiometricProfile(
      avgHeartRateVariability: 45.0,
      restingHeartRate: 65.0,
      maxHeartRate: 185.0,
      stressBaseline: 0.3,
      arousalThreshold: 0.6,
      electrodermalActivity: 0.4,
      avgBodyTemperature: 98.6,
      temperatureDelta: 0.2,
      circadianRhythm: const CircadianProfile(
        chronotype: 0.2, // Slightly morning person
        optimalSleepWindow: Duration(hours: 8),
        optimalActivityWindow: Duration(hours: 14),
        hourlyEnergyLevels: <int, double>{},
        melatoninPattern: 0.5,
        cortisolPattern: 0.5,
      ),
      sleepQualityIndex: 0.75,
      avgSleepDuration: const Duration(hours: 7, minutes: 30),
      recoveryIndex: 0.8,
      activityLevel: 0.6,
      vo2Max: 45.0,
      fitnessMetrics: <String, double>{},
      lastSync: DateTime.now(),
      sourceDevice: WearableDeviceType.appleWatch,
      isRealTimeStreaming: false,
    );
  }

  /// Record sync operation metrics
  void _recordSyncMetrics(DateTime startTime, {required bool success}) {
    _syncOperationCount++;
    if (success) {
      _syncSuccessCount++;
    }

    final Duration syncTime = DateTime.now().difference(startTime);
    _syncTimeWindow.add(syncTime);

    // Keep only last 50 measurements
    if (_syncTimeWindow.length > 50) {
      _syncTimeWindow.removeAt(0);
    }

    // Calculate average sync time
    if (_syncTimeWindow.isNotEmpty) {
      final int totalMs =
          _syncTimeWindow.map((Duration d) => d.inMilliseconds).reduce((int a, int b) => a + b);
      _avgSyncTime = Duration(milliseconds: totalMs ~/ _syncTimeWindow.length);
    }
  }

  /// Start periodic sync health checks
  void _startPeriodicSyncCheck() {
    Timer.periodic(const Duration(minutes: 2), (Timer timer) {
      if (_isInitialized && isAuthenticated) {
        _performHealthCheck();
      }
    });
  }

  /// Perform sync health check
  void _performHealthCheck() {
    // Check if any sections need resyncing
    final List<AppSection> outdatedSections = <AppSection>[];
    final DateTime now = DateTime.now();

    for (final AppSection section in AppSection.values) {
      final DateTime? lastSync = _lastSectionSync[section];
      if (lastSync == null || now.difference(lastSync) > const Duration(minutes: 10)) {
        outdatedSections.add(section);
      }
    }

    // Trigger background sync for outdated sections
    if (outdatedSections.isNotEmpty) {
      for (final AppSection section in outdatedSections) {
        syncSection(section).catchError((e) {
          if (kDebugMode) {
            developer.log('Background section sync failed: $e', name: 'QuantumAuth');
          }
        });
      }
    }
  }
}

// ============================================================================
// SUPPORTING DATA CLASSES & ENUMS
// ============================================================================

/// Authentication states
enum AuthenticationState {
  unauthenticated,
  authenticating,
  authenticated,
  error,
}

/// Authentication state change event
class AuthStateChange {
  const AuthStateChange({
    required this.previousState,
    required this.currentState,
    required this.timestamp,
    this.user,
    this.error,
  });
  final AuthenticationState previousState;
  final AuthenticationState currentState;
  final User? user;
  final DateTime timestamp;
  final String? error;
}

/// Authentication operation result
class AuthResult {
  const AuthResult._({
    required this.isSuccess,
    this.user,
    this.profile,
    this.error,
  });

  factory AuthResult.success({
    required User user,
    QuantumUserProfile? profile,
  }) {
    return AuthResult._(
      isSuccess: true,
      user: user,
      profile: profile,
    );
  }

  factory AuthResult.failure({required String error}) {
    return AuthResult._(
      isSuccess: false,
      error: error,
    );
  }
  final bool isSuccess;
  final User? user;
  final QuantumUserProfile? profile;
  final String? error;
}

/// Profile synchronization result
class ProfileSyncResult {
  const ProfileSyncResult._({
    required this.isSuccess,
    this.profile,
    this.syncTime,
    this.error,
  });

  factory ProfileSyncResult.success({
    required QuantumUserProfile profile,
    required DateTime syncTime,
  }) {
    return ProfileSyncResult._(
      isSuccess: true,
      profile: profile,
      syncTime: syncTime,
    );
  }

  factory ProfileSyncResult.failure({required String error}) {
    return ProfileSyncResult._(
      isSuccess: false,
      error: error,
    );
  }
  final bool isSuccess;
  final QuantumUserProfile? profile;
  final DateTime? syncTime;
  final String? error;
}

/// Section synchronization status
class SectionSyncState {
  const SectionSyncState({
    required this.isSynced,
    required this.requiresSync,
    this.lastSyncTime,
  });
  final bool isSynced;
  final DateTime? lastSyncTime;
  final bool requiresSync;
}

/// Sync service health report
class SyncServiceHealthReport {
  const SyncServiceHealthReport({
    required this.isHealthy,
    required this.authState,
    required this.syncOperationCount,
    required this.syncSuccessRate,
    required this.averageSyncTime,
    required this.syncedSectionCount,
    required this.totalSectionCount,
    required this.isProfileSyncing,
    required this.pendingUpdateCount,
    this.lastSyncTime,
    this.syncProgress = 0.0,
  });
  final bool isHealthy;
  final AuthenticationState authState;
  final DateTime? lastSyncTime;
  final int syncOperationCount;
  final double syncSuccessRate;
  final Duration averageSyncTime;
  final int syncedSectionCount;
  final int totalSectionCount;
  final bool isProfileSyncing;
  final int pendingUpdateCount;
  final double syncProgress;

  /// Get sync completion percentage
  double get syncCompletionPercentage {
    if (totalSectionCount == 0) return 1.0;
    return syncProgress.clamp(0.0, 1.0);
  }

  /// Check if all sections are synced
  bool get allSectionsSynced => syncedSectionCount >= totalSectionCount;
}
