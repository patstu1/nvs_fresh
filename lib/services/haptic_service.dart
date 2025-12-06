import 'package:haptic_feedback/haptic_feedback.dart';
import 'dart:async';

// An enum for our custom-designed haptic events
enum NvsHaptic {
  sharpTick, // For scrolling through users
  dataTraceCharge, // For long-press to reveal info
  verdictPositive, // A good AI verdict
  verdictNegative, // A bad AI verdict
  heartbeat, // The "Save" button on the ActionCard
  yo, // The signature YoButton tap
  // Bio-Neural Sync haptic patterns
  bioSync, // Bio-responsive feedback
  chemistryPreview, // Haptic chemistry between users
  neuralPulse, // Neural activity indication
  quantumResonance, // Quantum compatibility feedback
  arousalSync, // Synchronized arousal feedback
  stressRelief, // Stress reduction pattern
  empathyBridge, // Emotional connection feedback
  intimacyWhisper, // Intimate connection preview
}

class HapticService {
  // Timer for complex haptic sequences
  Timer? _hapticSequenceTimer;

  Future<void> init() async {
    // Check if haptic feedback is available
    final canVibrate = await Haptics.canVibrate();
    print("🎮 HapticService Initialized. Can vibrate: $canVibrate");
  }

  void trigger(NvsHaptic hapticType, {double intensity = 1.0}) {
    // Implement a switch statement here.
    // Based on the hapticType, call the appropriate Haptics.vibrate() method
    // with the appropriate haptic patterns.
    // This is where we translate an event into a feeling.
    switch (hapticType) {
      case NvsHaptic.sharpTick:
        Haptics.vibrate(HapticsType.selection);
        break;
      case NvsHaptic.dataTraceCharge:
        Haptics.vibrate(HapticsType.heavy);
        break;
      case NvsHaptic.verdictPositive:
        Haptics.vibrate(HapticsType.success);
        break;
      case NvsHaptic.verdictNegative:
        Haptics.vibrate(HapticsType.error);
        break;
      case NvsHaptic.heartbeat:
        // Custom heartbeat pattern - double tap
        Haptics.vibrate(HapticsType.light);
        Future.delayed(const Duration(milliseconds: 150), () {
          Haptics.vibrate(HapticsType.medium);
        });
        break;
      case NvsHaptic.yo:
        // Sharp, satisfying yo tap
        Haptics.vibrate(HapticsType.selection);
        break;

      // Bio-Neural Sync patterns
      case NvsHaptic.bioSync:
        _triggerBioSyncPattern(intensity);
        break;
      case NvsHaptic.chemistryPreview:
        _triggerChemistryPreview(intensity);
        break;
      case NvsHaptic.neuralPulse:
        _triggerNeuralPulse(intensity);
        break;
      case NvsHaptic.quantumResonance:
        _triggerQuantumResonance(intensity);
        break;
      case NvsHaptic.arousalSync:
        _triggerArousalSync(intensity);
        break;
      case NvsHaptic.stressRelief:
        _triggerStressRelief();
        break;
      case NvsHaptic.empathyBridge:
        _triggerEmpathyBridge(intensity);
        break;
      case NvsHaptic.intimacyWhisper:
        _triggerIntimacyWhisper(intensity);
        break;
    }
    print(
      "🎮 HAPTIC TRIGGER: ${hapticType.name} (intensity: ${intensity.toStringAsFixed(2)})",
    );
  }

  /// Bio-responsive haptic feedback synchronized to user's biometric state
  void _triggerBioSyncPattern(double intensity) {
    final adjustedIntensity = (intensity * 0.8).clamp(0.1, 1.0);

    if (adjustedIntensity > 0.7) {
      Haptics.vibrate(HapticsType.medium);
    } else if (adjustedIntensity > 0.4) {
      Haptics.vibrate(HapticsType.light);
    } else {
      Haptics.vibrate(HapticsType.selection);
    }
  }

  /// Chemistry preview between two users
  void _triggerChemistryPreview(double compatibility) {
    _hapticSequenceTimer?.cancel();

    if (compatibility > 0.8) {
      // High chemistry - crescendo pattern
      Haptics.vibrate(HapticsType.light);
      _hapticSequenceTimer = Timer(const Duration(milliseconds: 100), () {
        Haptics.vibrate(HapticsType.medium);
        _hapticSequenceTimer = Timer(const Duration(milliseconds: 100), () {
          Haptics.vibrate(HapticsType.heavy);
        });
      });
    } else if (compatibility > 0.6) {
      // Medium chemistry - double pulse
      Haptics.vibrate(HapticsType.medium);
      _hapticSequenceTimer = Timer(const Duration(milliseconds: 200), () {
        Haptics.vibrate(HapticsType.medium);
      });
    } else if (compatibility > 0.3) {
      // Low chemistry - single gentle pulse
      Haptics.vibrate(HapticsType.light);
    } else {
      // Poor chemistry - warning pattern
      Haptics.vibrate(HapticsType.error);
    }
  }

  /// Neural activity pulse pattern
  void _triggerNeuralPulse(double intensity) {
    final pulseCount = (intensity * 3).round().clamp(1, 3);

    void pulseTick(int remaining) {
      if (remaining <= 0) return;

      Haptics.vibrate(HapticsType.light);
      if (remaining > 1) {
        _hapticSequenceTimer = Timer(const Duration(milliseconds: 80), () {
          pulseTick(remaining - 1);
        });
      }
    }

    _hapticSequenceTimer?.cancel();
    pulseTick(pulseCount);
  }

  /// Quantum resonance compatibility feedback
  void _triggerQuantumResonance(double resonance) {
    _hapticSequenceTimer?.cancel();

    // Create wave-like haptic pattern based on quantum resonance
    final waveCount = (resonance * 5).round().clamp(2, 5);
    int currentWave = 0;

    void triggerWave() {
      if (currentWave >= waveCount) return;

      final waveIntensity = (currentWave / waveCount * resonance).clamp(
        0.1,
        1.0,
      );

      if (waveIntensity > 0.6) {
        Haptics.vibrate(HapticsType.medium);
      } else {
        Haptics.vibrate(HapticsType.light);
      }

      currentWave++;
      if (currentWave < waveCount) {
        _hapticSequenceTimer = Timer(
          const Duration(milliseconds: 120),
          triggerWave,
        );
      }
    }

    triggerWave();
  }

  /// Arousal-synchronized haptic feedback
  void _triggerArousalSync(double arousal) {
    final frequency = (arousal * 300 + 100).round(); // 100-400ms intervals

    _hapticSequenceTimer?.cancel();

    void rhythmicPulse() {
      Haptics.vibrate(arousal > 0.7 ? HapticsType.medium : HapticsType.light);

      if (arousal > 0.3) {
        // Continue rhythm if arousal is significant
        _hapticSequenceTimer = Timer(
          Duration(milliseconds: frequency),
          rhythmicPulse,
        );
      }
    }

    rhythmicPulse();
  }

  /// Stress relief calming pattern
  void _triggerStressRelief() {
    _hapticSequenceTimer?.cancel();

    // Gentle, slowing rhythm for stress relief
    final intervals = [300, 400, 500, 600, 700]; // Gradually slowing
    int currentInterval = 0;

    void calmingPulse() {
      if (currentInterval >= intervals.length) return;

      Haptics.vibrate(HapticsType.light);

      _hapticSequenceTimer = Timer(
        Duration(milliseconds: intervals[currentInterval]),
        () {
          currentInterval++;
          if (currentInterval < intervals.length) {
            calmingPulse();
          }
        },
      );
    }

    calmingPulse();
  }

  /// Empathy bridge connection feedback
  void _triggerEmpathyBridge(double empathy) {
    _hapticSequenceTimer?.cancel();

    // Warm, embracing haptic pattern
    Haptics.vibrate(HapticsType.light);
    _hapticSequenceTimer = Timer(const Duration(milliseconds: 50), () {
      Haptics.vibrate(HapticsType.medium);
      _hapticSequenceTimer = Timer(const Duration(milliseconds: 100), () {
        Haptics.vibrate(HapticsType.light);
        if (empathy > 0.7) {
          _hapticSequenceTimer = Timer(const Duration(milliseconds: 150), () {
            Haptics.vibrate(HapticsType.light); // Final gentle touch
          });
        }
      });
    });
  }

  /// Intimate whisper preview
  void _triggerIntimacyWhisper(double intimacy) {
    _hapticSequenceTimer?.cancel();

    if (intimacy > 0.8) {
      // Deep intimate connection - slow, building pattern
      Haptics.vibrate(HapticsType.light);
      _hapticSequenceTimer = Timer(const Duration(milliseconds: 200), () {
        Haptics.vibrate(HapticsType.light);
        _hapticSequenceTimer = Timer(const Duration(milliseconds: 150), () {
          Haptics.vibrate(HapticsType.medium);
          _hapticSequenceTimer = Timer(const Duration(milliseconds: 100), () {
            Haptics.vibrate(HapticsType.light);
          });
        });
      });
    } else if (intimacy > 0.5) {
      // Moderate intimacy - gentle double pulse
      Haptics.vibrate(HapticsType.light);
      _hapticSequenceTimer = Timer(const Duration(milliseconds: 300), () {
        Haptics.vibrate(HapticsType.light);
      });
    } else {
      // Light intimacy - single soft pulse
      Haptics.vibrate(HapticsType.light);
    }
  }

  /// Stop any ongoing haptic sequences
  void stopSequence() {
    _hapticSequenceTimer?.cancel();
    _hapticSequenceTimer = null;
  }

  /// Dispose resources
  void dispose() {
    _hapticSequenceTimer?.cancel();
  }
}
