package com.nvs.app

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Native Android bridge for advanced haptic feedback
 * Uses Vibrator and VibrationEffect APIs for custom haptic patterns
 */
class HapticBridge : FlutterPlugin, MethodChannel.MethodCallHandler {

    private lateinit var context: Context
    private lateinit var methodChannel: MethodChannel
    private var vibrator: Vibrator? = null
    private var supportsHaptics = false

    companion object {
        private const val METHOD_CHANNEL_NAME = "nvs/haptic"
        private const val MAX_AMPLITUDE = 255
        private const val MIN_AMPLITUDE = 1
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL_NAME)
        methodChannel.setMethodCallHandler(this)

        initializeVibrator()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> initializeHapticSystem(result)
            "playPattern" -> {
                val args = call.arguments as? Map<String, Any>
                playCustomPattern(args ?: emptyMap(), result)
            }
            "stop" -> stopHaptics(result)
            "isAvailable" -> result.success(supportsHaptics)
            else -> result.notImplemented()
        }
    }

    // MARK: - Haptic System Initialization

    private fun initializeVibrator() {
        vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val vibratorManager = context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
            vibratorManager.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        }

        supportsHaptics = vibrator?.hasVibrator() == true
    }

    private fun initializeHapticSystem(result: MethodChannel.Result) {
        if (supportsHaptics) {
            result.success(mapOf(
                "status" to "initialized",
                "supports_haptics" to true,
                "api_level" to Build.VERSION.SDK_INT,
                "supports_amplitude_control" to supportsAmplitudeControl()
            ))
        } else {
            result.error(
                "HAPTICS_UNSUPPORTED",
                "Device does not support haptic feedback",
                null
            )
        }
    }

    private fun supportsAmplitudeControl(): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
               vibrator?.hasAmplitudeControl() == true
    }

    // MARK: - Custom Pattern Playback

    private fun playCustomPattern(args: Map<String, Any>, result: MethodChannel.Result) {
        val pattern = args["pattern"] as? List<Int>

        if (pattern == null || pattern.isEmpty()) {
            result.error("INVALID_PATTERN", "Pattern must be a non-empty array of integers", null)
            return
        }

        if (!supportsHaptics || vibrator == null) {
            result.success(mapOf("status" to "unsupported"))
            return
        }

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                playModernHapticPattern(pattern)
            } else {
                playLegacyHapticPattern(pattern)
            }

            result.success(mapOf(
                "status" to "played",
                "pattern_length" to pattern.size
            ))

        } catch (e: Exception) {
            result.error(
                "HAPTIC_PLAYBACK_FAILED",
                "Failed to play haptic pattern: ${e.message}",
                null
            )
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun playModernHapticPattern(pattern: List<Int>) {
        val timings = mutableListOf<Long>()
        val amplitudes = mutableListOf<Int>()

        // Process pattern in pairs (amplitude, duration)
        for (i in pattern.indices step 2) {
            val amplitude = pattern[i].coerceIn(0, MAX_AMPLITUDE)
            val duration = if (i + 1 < pattern.size) {
                pattern[i + 1].coerceIn(10, 2000).toLong()
            } else {
                100L // Default duration
            }

            timings.add(duration)
            amplitudes.add(amplitude)
        }

        val vibrationEffect = if (supportsAmplitudeControl()) {
            VibrationEffect.createWaveform(
                timings.toLongArray(),
                amplitudes.toIntArray(),
                -1 // Don't repeat
            )
        } else {
            // Fallback to basic timing pattern for devices without amplitude control
            val basicTimings = mutableListOf<Long>()
            for (i in pattern.indices step 2) {
                val amplitude = pattern[i]
                val duration = if (i + 1 < pattern.size) pattern[i + 1].toLong() else 100L

                if (amplitude > 0) {
                    basicTimings.add(duration)
                    basicTimings.add(50) // Brief pause between pulses
                } else {
                    basicTimings.add(duration) // Pause duration
                }
            }

            VibrationEffect.createWaveform(basicTimings.toLongArray(), -1)
        }

        vibrator?.vibrate(vibrationEffect)
    }

    @Suppress("DEPRECATION")
    private fun playLegacyHapticPattern(pattern: List<Int>) {
        val timings = mutableListOf<Long>()

        // Convert intensity/duration pairs to legacy timing pattern
        for (i in pattern.indices step 2) {
            val amplitude = pattern[i]
            val duration = if (i + 1 < pattern.size) pattern[i + 1].toLong() else 100L

            if (amplitude > 0) {
                // Map amplitude to duration variations for legacy devices
                val adjustedDuration = when {
                    amplitude < 85 -> duration / 2 // Light vibration
                    amplitude < 170 -> duration // Medium vibration
                    else -> (duration * 1.5).toLong() // Heavy vibration
                }

                timings.add(adjustedDuration)
                timings.add(50) // Brief pause
            } else {
                timings.add(duration) // Pause duration
            }
        }

        vibrator?.vibrate(timings.toLongArray(), -1)
    }

    // MARK: - Predefined Haptic Patterns

    private fun playHeartRateSync(heartRate: Double) {
        val beatInterval = (60000 / heartRate).toLong() // ms per beat
        val beatIntensity = when {
            heartRate < 60 -> 80  // Gentle for low HR
            heartRate < 100 -> 120 // Normal intensity
            heartRate < 150 -> 180 // Strong for elevated HR
            else -> 220 // Intense for high HR
        }

        val pattern = listOf(beatIntensity, 100, 0, (beatInterval - 100).toInt())
        playCustomPattern(mapOf("pattern" to pattern), object : MethodChannel.Result {
            override fun success(result: Any?) {}
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {}
            override fun notImplemented() {}
        })
    }

    private fun playQuantumEntanglementPattern() {
        // Complex pattern representing quantum entanglement
        val quantumPattern = listOf(
            80, 50,   // Particle 1
            0, 25,    // Separation
            80, 50,   // Particle 2 (synchronized)
            0, 25,    // Brief pause
            150, 25,  // Entanglement pulse
            200, 25,  // Quantum coherence
            255, 50,  // Peak entanglement
            120, 100, // Stabilization
            0, 500    // Quantum decoherence pause
        )

        playCustomPattern(mapOf("pattern" to quantumPattern), object : MethodChannel.Result {
            override fun success(result: Any?) {}
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {}
            override fun notImplemented() {}
        })
    }

    private fun playCompatibilityWhisper(compatibilityScore: Double) {
        val (intensity, duration) = getCompatibilityCharacteristics(compatibilityScore)

        val whisperPattern = when {
            compatibilityScore >= 0.9 -> {
                // Quantum sync - complex harmonic pattern
                listOf(intensity, 50, intensity/2, 30, intensity, 80, intensity/3, 40, intensity, 100)
            }
            compatibilityScore >= 0.8 -> {
                // High compatibility - rhythmic pattern
                listOf(intensity, duration, intensity/2, 50, intensity, duration)
            }
            compatibilityScore >= 0.6 -> {
                // Moderate compatibility - gentle pulses
                listOf(intensity, duration, 0, 100, intensity/2, duration/2)
            }
            compatibilityScore >= 0.4 -> {
                // Low compatibility - subtle notification
                listOf(intensity, duration, 0, 200)
            }
            else -> {
                // Minimal compatibility - brief pulse
                listOf(intensity, duration/2)
            }
        }

        playCustomPattern(mapOf("pattern" to whisperPattern), object : MethodChannel.Result {
            override fun success(result: Any?) {}
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {}
            override fun notImplemented() {}
        })
    }

    private fun getCompatibilityCharacteristics(score: Double): Pair<Int, Int> {
        return when {
            score >= 0.9 -> Pair(200, 150) // High intensity, longer duration
            score >= 0.8 -> Pair(160, 120) // Strong intensity
            score >= 0.6 -> Pair(120, 100) // Medium intensity
            score >= 0.4 -> Pair(80, 80)   // Light intensity
            else -> Pair(50, 60)           // Minimal intensity
        }
    }

    // MARK: - Biometric-Responsive Patterns

    private fun playBioResponsivePattern(
        arousalLevel: Double,
        stressLevel: Double,
        energyLevel: Double
    ) {
        // Create adaptive pattern based on biometric state
        val baseIntensity = (100 + (energyLevel * 100)).toInt().coerceIn(50, 200)
        val stressModifier = (1.0 - stressLevel * 0.5) // Reduce intensity if stressed
        val arousalTiming = (100 + (arousalLevel * 100)).toInt() // Faster pulses if aroused

        val adaptiveIntensity = (baseIntensity * stressModifier).toInt()

        val bioPattern = listOf(
            adaptiveIntensity, arousalTiming,
            0, arousalTiming / 2,
            adaptiveIntensity / 2, arousalTiming,
            0, arousalTiming
        )

        playCustomPattern(mapOf("pattern" to bioPattern), object : MethodChannel.Result {
            override fun success(result: Any?) {}
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {}
            override fun notImplemented() {}
        })
    }

    // MARK: - Haptic Control

    private fun stopHaptics(result: MethodChannel.Result) {
        try {
            vibrator?.cancel()
            result.success(mapOf("status" to "stopped"))
        } catch (e: Exception) {
            result.error(
                "HAPTIC_STOP_FAILED",
                "Failed to stop haptic feedback: ${e.message}",
                null
            )
        }
    }

    // MARK: - Advanced Haptic Effects

    @RequiresApi(Build.VERSION_CODES.O)
    private fun createBioNeuralSyncEffect(
        userHeartRate: Double,
        targetHeartRate: Double,
        compatibilityScore: Double
    ): VibrationEffect? {
        if (!supportsAmplitudeControl()) return null

        // Synchronize haptic rhythm to the average of two heart rates
        val avgHeartRate = (userHeartRate + targetHeartRate) / 2
        val beatInterval = (60000 / avgHeartRate).toLong()

        // Create harmonious pattern based on compatibility
        val syncIntensity = (compatibilityScore * 200).toInt().coerceIn(50, 255)
        val harmonyOffset = (beatInterval * 0.25).toLong() // Quarter beat offset

        val timings = longArrayOf(
            beatInterval / 4,     // User beat (lead)
            harmonyOffset,        // Harmony delay
            beatInterval / 4,     // Target beat (harmony)
            beatInterval - harmonyOffset - (beatInterval / 2) // Rest
        )

        val amplitudes = intArrayOf(
            syncIntensity,        // User intensity
            0,                    // Silence during harmony delay
            (syncIntensity * 0.8).toInt(), // Target intensity (slightly softer)
            0                     // Rest silence
        )

        return VibrationEffect.createWaveform(timings, amplitudes, -1)
    }

    /**
     * Create a haptic pattern that represents neural network synchronization
     */
    @RequiresApi(Build.VERSION_CODES.O)
    private fun createNeuralSyncPattern(
        neuralActivity: Double,
        syncQuality: Double
    ): VibrationEffect? {
        if (!supportsAmplitudeControl()) return null

        // Neural firing pattern - rapid micro-pulses
        val firingRate = (neuralActivity * 10).toInt().coerceIn(3, 15) // 3-15 Hz
        val pulseInterval = 1000L / firingRate
        val syncIntensity = (syncQuality * 150).toInt().coerceIn(30, 180)

        val timings = mutableListOf<Long>()
        val amplitudes = mutableListOf<Int>()

        // Create burst pattern - neurons firing in synchronized bursts
        repeat(5) { burst ->
            repeat(3) { pulse ->
                timings.add(20) // Short neural pulse
                amplitudes.add(syncIntensity - (pulse * 20)) // Decreasing intensity

                timings.add(pulseInterval - 20) // Inter-pulse interval
                amplitudes.add(0)
            }

            // Inter-burst interval (longer pause)
            timings.add(pulseInterval * 2)
            amplitudes.add(0)
        }

        return VibrationEffect.createWaveform(
            timings.toLongArray(),
            amplitudes.toIntArray(),
            -1
        )
    }
}

