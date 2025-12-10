// lib/core/providers/quantum_providers.dart
// Unified Riverpod Providers for Quantum-Edge Architecture
// Centralized state management for all quantum services

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Agora service removed
import '../services/quantum_performance_engine.dart' as qperf;
import '../services/quantum_biometric_service.dart';
import '../services/quantum_shader_service.dart';
import '../services/zk_privacy_service.dart';
import '../services/quantum_120fps_engine.dart' as fps120;
import '../models/app_types.dart'
    show AppSection, BioResponsiveThemeData;

// ============================================================================
// QUANTUM SERVICES
// ============================================================================

// Agora providers removed

/// Quantum Performance Engine Provider - 120FPS Optimization
final Provider<qperf.QuantumPerformanceEngine> quantumPerformanceEngineProvider =
    Provider<qperf.QuantumPerformanceEngine>((ref) {
  return qperf.QuantumPerformanceEngine();
});

/// Quantum Shader Service Provider - Bio-Responsive GLSL Effects
final Provider<QuantumShaderService> quantumShaderServiceProvider =
    Provider<QuantumShaderService>((ref) {
  return QuantumShaderService.instance;
});

/// Quantum Biometric Service Provider - Bio-Neural Synchronization
final Provider<QuantumBiometricService> quantumBiometricServiceProvider =
    Provider<QuantumBiometricService>((ref) {
  return QuantumBiometricService();
});

/// Zero-Knowledge Privacy Service Provider - Anonymous Mode
final Provider<ZKPrivacyService> zkPrivacyServiceProvider =
    Provider<ZKPrivacyService>((ref) {
  return ZKPrivacyService();
});

/// Quantum 120FPS Engine Provider - Ultra-High Performance
final Provider<fps120.Quantum120FPSEngine> quantum120FPSEngineProvider =
    Provider<fps120.Quantum120FPSEngine>((ref) {
  return fps120.Quantum120FPSEngine.instance;
});

// ============================================================================
// AUTHENTICATION STATE
// ============================================================================

/// Current Firebase User Provider
final StreamProvider<User?> currentUserProvider =
    StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// ============================================================================
// AGORA TOKEN MANAGEMENT
// ============================================================================

/// Agora Token Provider Factory - Creates token provider for specific channel
// Agora token provider removed

/// Agora Service Health Provider
// Agora health provider removed

// ============================================================================
// SYNC STATUS MONITORING
// ============================================================================

// ============================================================================
// USER INTERFACE STATE
// ============================================================================

/// Theme Mode Provider (for bio-responsive theming)
final StateProvider<QuantumThemeMode> themeModeProvider =
    StateProvider<QuantumThemeMode>((ref) {
  return QuantumThemeMode.quantum;
});

/// Bio-Responsive Theme Data Provider
final Provider<BioResponsiveThemeData?> bioResponsiveThemeProvider =
    Provider<BioResponsiveThemeData?>((ref) {
  final AsyncValue<BiometricReading?> biometricReading =
      ref.watch(currentBiometricReadingProvider);

  return biometricReading.when(
    data: (BiometricReading? reading) {
      if (reading == null) return null;

      final double arousalLevel = _calculateArousalLevel(reading);

      return BioResponsiveThemeData(
        arousalLevel: arousalLevel,
        heartRate: reading.heartRate.round(),
        bodyTemperature: reading.bodyTemperature,
        isRealTime: true,
        lastUpdate: reading.timestamp,
      );
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Current App Section Provider
final StateProvider<AppSection> currentAppSectionProvider =
    StateProvider<AppSection>((ref) {
  return AppSection.grid; // Default to MEATUP
});

// ============================================================================
// PERFORMANCE MONITORING
// ============================================================================

/// Performance Metrics Provider
final StreamProvider<dynamic> performanceMetricsProvider =
    StreamProvider<qperf.PerformanceMetrics>((ref) async* {
  final qperf.QuantumPerformanceEngine performanceEngine = ref.watch(quantumPerformanceEngineProvider);

  // Emit current metrics every second
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    yield performanceEngine.getCurrentMetrics();
  }
});

/// Performance Mode Provider
final StateProvider<qperf.PerformanceMode> performanceModeProvider =
    StateProvider<qperf.PerformanceMode>((ref) {
  return qperf.PerformanceMode.balanced;
});

/// Should Enable Complex Animations Provider
final Provider<bool> shouldEnableComplexAnimationsProvider =
    Provider<bool>((ref) {
  final qperf.QuantumPerformanceEngine performanceEngine = ref.watch(quantumPerformanceEngineProvider);
  return performanceEngine.shouldEnableComplexAnimations();
});

/// Should Enable Glow Effects Provider
final Provider<bool> shouldEnableGlowEffectsProvider = Provider<bool>((ref) {
  final qperf.QuantumPerformanceEngine performanceEngine = ref.watch(quantumPerformanceEngineProvider);
  return performanceEngine.shouldEnableGlowEffects();
});

/// Optimal Animation Duration Provider
final ProviderFamily<Duration, Duration> optimalAnimationDurationProvider =
    Provider.family<Duration, Duration>((ref, Duration baseDuration) {
  final qperf.QuantumPerformanceEngine performanceEngine = ref.watch(quantumPerformanceEngineProvider);
  return performanceEngine.getOptimalAnimationDuration(baseDuration);
});

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

/// Calculate arousal level from the latest biometric reading
double _calculateArousalLevel(BiometricReading reading) {
  final double normalizedStress = reading.stressLevel.clamp(0.0, 1.0);
  final double normalizedArousal = reading.arousalLevel.clamp(0.0, 1.0);
  // Lower HRV often correlates with higher arousal, so invert the normalized value.
  final double normalizedHrv = (1 - (reading.hrv / 100).clamp(0.0, 1.0));

  return ((normalizedStress + normalizedArousal + normalizedHrv) / 3).clamp(0.0, 1.0);
}

// ============================================================================
// SUPPORTING DATA CLASSES
// ============================================================================

/// Agora token request parameters
// Agora token request removed

/// Quantum theme modes
enum QuantumThemeMode {
  quantum,
  bioResponsive,
  performance,
  accessibility,
}

/// Quantum theme variants
enum QuantumThemeVariant {
  standard,
  bioSync,
  excited,
  calm,
  focus,
}

// ============================================================================
// BIOMETRIC MONITORING PROVIDERS
// ============================================================================

/// Current biometric reading stream provider
final StreamProvider<BiometricReading?> currentBiometricReadingProvider =
    StreamProvider<BiometricReading?>((ref) {
  final QuantumBiometricService biometricService = ref.watch(quantumBiometricServiceProvider);
  return biometricService.biometricStream.map((BiometricReading reading) => reading);
});

/// Current mood inference stream provider
final StreamProvider<MoodInference?> currentMoodInferenceProvider =
    StreamProvider<MoodInference?>((ref) {
  final QuantumBiometricService biometricService = ref.watch(quantumBiometricServiceProvider);
  return biometricService.moodStream.map((MoodInference mood) => mood);
});

/// Current bio-signature stream provider
final StreamProvider<BioSignature?> currentBioSignatureProvider =
    StreamProvider<BioSignature?>((ref) {
  final QuantumBiometricService biometricService = ref.watch(quantumBiometricServiceProvider);
  return biometricService.bioSignatureStream.map((BioSignature signature) => signature);
});

/// Biometric monitoring state provider
final StateProvider<bool> biometricMonitoringStateProvider =
    StateProvider<bool>((ref) => false);

/// Social optimality score provider
final Provider<SocialOptimalityScore?> socialOptimalityProvider =
    Provider<SocialOptimalityScore?>((ref) {
  final QuantumBiometricService biometricService = ref.watch(quantumBiometricServiceProvider);
  return biometricService.calculateSocialOptimality();
});

/// Bio-threshold calibration provider
final StateProvider<BiometricThresholds?> bioThresholdsProvider =
    StateProvider<BiometricThresholds?>((ref) => null);

// ============================================================================
// ZERO-KNOWLEDGE PRIVACY PROVIDERS
// ============================================================================

/// ZK Privacy settings provider
final StateProvider<ZKPrivacySettings> zkPrivacySettingsProvider =
    StateProvider<ZKPrivacySettings>((ref) {
  return const ZKPrivacySettings();
});

/// Anonymous mode state provider
final StateProvider<bool> anonymousModeStateProvider =
    StateProvider<bool>((ref) => false);

/// Current anonymous profile provider
final StateProvider<ZKAnonymousProfile?> currentAnonymousProfileProvider =
    StateProvider<ZKAnonymousProfile?>((ref) => null);

/// Anonymous matches provider
final StateProvider<List<ZKAnonymousMatch>> anonymousMatchesProvider =
    StateProvider<List<ZKAnonymousMatch>>((ref) => <ZKAnonymousMatch>[]);

/// ZK Privacy service initialization provider
final FutureProvider<void> zkPrivacyInitProvider =
    FutureProvider<void>((ref) async {
  final ZKPrivacyService zkService = ref.watch(zkPrivacyServiceProvider);
  await zkService.initialize();
});

// ============================================================================
// 120FPS PERFORMANCE PROVIDERS
// ============================================================================

/// Current 120FPS performance metrics provider
final StateProvider<dynamic> fps120MetricsProvider =
    StateProvider<fps120.PerformanceMetrics?>((ref) => null);

/// Current performance level provider
final StateProvider<fps120.PerformanceLevel> performanceLevelProvider =
    StateProvider<fps120.PerformanceLevel>((ref) {
  return fps120.PerformanceLevel.high;
});

/// Optimization mode provider
final StateProvider<fps120.OptimizationMode> optimizationModeProvider =
    StateProvider<fps120.OptimizationMode>((ref) {
  return fps120.OptimizationMode.adaptive;
});

/// Biometric performance profile provider
final StateProvider<fps120.BiometricPerformanceProfile?> biometricPerformanceProfileProvider =
    StateProvider<fps120.BiometricPerformanceProfile?>((ref) => null);

/// 120FPS engine initialization provider
final FutureProvider<void> fps120InitProvider = FutureProvider<void>((ref) async {
  ref.watch(quantum120FPSEngineProvider);
});

/// Target FPS provider (computed from engine state)
final Provider<int> targetFPSProvider = Provider<int>((ref) {
  final fps120.Quantum120FPSEngine engine = ref.watch(quantum120FPSEngineProvider);
  return engine.targetFPS;
});

/// Performance optimal state provider
final Provider<bool> isPerformanceOptimalProvider = Provider<bool>((ref) {
  final fps120.Quantum120FPSEngine engine = ref.watch(quantum120FPSEngineProvider);
  return engine.isPerformingOptimally;
});
