import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/core/theme/quantum_design_tokens.dart';
import '../../../../core/widgets/quantum_glow_engine.dart';
import '../../../../core/widgets/quantum_bio_responsive_ui.dart';
import '../../../../core/services/quantum_biometric_service.dart';
import '../../../../core/services/quantum_haptic_service.dart';
import '../../../../core/providers/quantum_providers.dart';

/// Bio-Neural Synchronization View - Demonstrates real-time biometric integration
/// Shows live heart rate, HRV, mood inference, and compatibility matching
class BioNeuralSyncView extends ConsumerStatefulWidget {
  const BioNeuralSyncView({super.key});

  @override
  ConsumerState<BioNeuralSyncView> createState() => _BioNeuralSyncViewState();
}

class _BioNeuralSyncViewState extends ConsumerState<BioNeuralSyncView>
    with TickerProviderStateMixin {
  // Animation controllers for bio-responsive effects
  late AnimationController _syncController;
  late AnimationController _pulseController;
  late AnimationController _waveController;

  // Animations
  late Animation<double> _syncAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  // Biometric service
  QuantumBiometricService? _biometricService;

  // Connection simulation for demo
  Timer? _simulationTimer;
  bool _isSimulating = false;
  double _simulatedCompatibility = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeBiometricService();
  }

  void _initializeAnimations() {
    _syncController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _syncAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _syncController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _waveAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.linear),
    );

    _syncController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
    _waveController.repeat();
  }

  Future<void> _initializeBiometricService() async {
    _biometricService = ref.read(quantumBiometricServiceProvider);

    final BiometricServiceStatus status = await _biometricService!.initialize();
    if (status == BiometricServiceStatus.authorized) {
      await _biometricService!.startMonitoring();
      ref.read(biometricMonitoringStateProvider.notifier).state = true;
    }
  }

  void _startCompatibilitySimulation() {
    if (_isSimulating) return;

    setState(() => _isSimulating = true);

    _simulationTimer =
        Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      setState(() {
        _simulatedCompatibility = math.sin(timer.tick * 0.1) * 0.5 + 0.5;
      });

      // Play haptic feedback based on compatibility
      if (_simulatedCompatibility > 0.8) {
        HapticService.playCompatibilityFeedback(
          compatibilityScore: _simulatedCompatibility,
        );
      }

      // Stop simulation after 30 seconds
      if (timer.tick > 60) {
        _stopCompatibilitySimulation();
      }
    });
  }

  void _stopCompatibilitySimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
    setState(() {
      _isSimulating = false;
      _simulatedCompatibility = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<BiometricReading?> currentReading = ref.watch(currentBiometricReadingProvider);
    final AsyncValue<MoodInference?> currentMood = ref.watch(currentMoodInferenceProvider);
    final AsyncValue<BioSignature?> currentBioSignature = ref.watch(currentBioSignatureProvider);
    final bool isMonitoring = ref.watch(biometricMonitoringStateProvider);

    return Scaffold(
      backgroundColor: QuantumDesignTokens.pureBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'BIOMETRIC SYNC',
          style: QuantumDesignTokens.createQuantumTextStyle(
            fontSize: QuantumDesignTokens.fontLG,
            fontWeight: QuantumDesignTokens.weightBold,
            color: QuantumDesignTokens.neonMint,
            glowIntensity: 0.8,
          ),
        ),
        actions: <Widget>const <Widget>[
          BioSyncStatusIndicator(showDetails: true),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Real-time biometric display
            _buildBiometricDisplay(
                currentReading, currentMood, currentBioSignature,),

            const SizedBox(height: 30),

            // Bio-responsive UI demonstration
            _buildBioResponsiveDemo(currentReading, currentMood),

            const SizedBox(height: 30),

            // Compatibility simulation
            _buildCompatibilitySimulation(),

            const SizedBox(height: 30),

            // Haptic feedback testing
            _buildHapticTesting(),

            const SizedBox(height: 30),

            // System controls
            _buildSystemControls(isMonitoring),
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricDisplay(
    AsyncValue<BiometricReading?> reading,
    AsyncValue<MoodInference?> mood,
    AsyncValue<BioSignature?> bioSignature,
  ) {
    return QuantumGlowContainer(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: QuantumDesignTokens.deepGray.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'LIVE BIOMETRIC DATA',
              style: QuantumDesignTokens.createQuantumTextStyle(
                fontSize: QuantumDesignTokens.fontMD,
                fontWeight: QuantumDesignTokens.weightBold,
                color: QuantumDesignTokens.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            reading.when(
              data: (BiometricReading? data) => data != null
                  ? _buildBiometricValues(data, mood.value, bioSignature.value)
                  : _buildNoDataMessage(),
              loading: _buildLoadingIndicator,
              error: (Object error, StackTrace stack) => _buildErrorMessage(error.toString()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricValues(
    BiometricReading reading,
    MoodInference? mood,
    BioSignature? bioSignature,
  ) {
    return Column(
      children: <Widget>[
        // Heart Rate with pulse animation
        HeartRatePulseContainer(
          child: _buildMetricRow(
            'Heart Rate',
            '${reading.heartRate.round()} BPM',
            Icons.favorite,
            QuantumDesignTokens.crimsonAlert,
          ),
        ),

        const SizedBox(height: 16),

        // HRV
        _buildMetricRow(
          'HRV',
          '${reading.hrv.toStringAsFixed(1)} ms',
          Icons.analytics,
          QuantumDesignTokens.electricBlue,
        ),

        const SizedBox(height: 16),

        // Stress Level
        _buildMetricRow(
          'Stress Level',
          '${(reading.stressLevel * 100).round()}%',
          Icons.psychology,
          _getStressColor(reading.stressLevel),
        ),

        const SizedBox(height: 16),

        // Social Receptiveness
        Row(
          children: <Widget>[
            Expanded(
              child: _buildMetricRow(
                'Social Receptiveness',
                '${(reading.socialReceptiveness * 100).round()}%',
                Icons.people,
                QuantumDesignTokens.neonMint,
              ),
            ),
            const SizedBox(width: 16),
            const SocialReceptivenessIndicator(size: 32),
          ],
        ),

        if (mood != null) ...<Widget>[
          const SizedBox(height: 16),
          _buildMoodDisplay(mood),
        ],

        if (bioSignature != null) ...<Widget>[
          const SizedBox(height: 16),
          _buildBioSignatureDisplay(bioSignature),
        ],
      ],
    );
  }

  Widget _buildMetricRow(
      String label, String value, IconData icon, Color color,) {
    return Row(
      children: <Widget>[
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: QuantumDesignTokens.createQuantumTextStyle(
                  fontSize: QuantumDesignTokens.fontXS,
                  color: QuantumDesignTokens.textSecondary,
                ),
              ),
              Text(
                value,
                style: QuantumDesignTokens.createQuantumTextStyle(
                  fontSize: QuantumDesignTokens.fontMD,
                  fontWeight: QuantumDesignTokens.weightBold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodDisplay(MoodInference mood) {
    return MoodResponsiveGradient(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'MOOD INFERENCE',
              style: QuantumDesignTokens.createQuantumTextStyle(
                fontSize: QuantumDesignTokens.fontSM,
                fontWeight: QuantumDesignTokens.weightBold,
                color: QuantumDesignTokens.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mood.mood.toUpperCase(),
              style: QuantumDesignTokens.createQuantumTextStyle(
                fontSize: QuantumDesignTokens.fontLG,
                fontWeight: QuantumDesignTokens.weightBlack,
                color: QuantumDesignTokens.neonMint,
                glowIntensity: 0.6,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Valence: ${(mood.valence * 100).round()}% • '
              'Arousal: ${(mood.arousal * 100).round()}% • '
              'Confidence: ${(mood.confidence * 100).round()}%',
              style: QuantumDesignTokens.createQuantumTextStyle(
                fontSize: QuantumDesignTokens.fontXS,
                color: QuantumDesignTokens.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBioSignatureDisplay(BioSignature signature) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: QuantumDesignTokens.deepGray.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'BIO-SIGNATURE',
            style: QuantumDesignTokens.createQuantumTextStyle(
              fontSize: QuantumDesignTokens.fontSM,
              fontWeight: QuantumDesignTokens.weightBold,
              color: QuantumDesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          const EnergyLevelVisualization(width: double.infinity, height: 40),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: <Widget>[
              _buildSignatureChip('Energy', signature.energyLevel),
              _buildSignatureChip('Stability', signature.emotionalStability),
              _buildSignatureChip(
                  'Parasym.', signature.parasympatheticDominance,),
              _buildSignatureChip('Cognitive', signature.cognitiveLoad),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureChip(String label, double value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: QuantumDesignTokens.neonMint.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        '$label: ${(value * 100).round()}%',
        style: QuantumDesignTokens.createQuantumTextStyle(
          fontSize: QuantumDesignTokens.fontNano,
          color: QuantumDesignTokens.neonMint,
        ),
      ),
    );
  }

  Widget _buildBioResponsiveDemo(
    AsyncValue<BiometricReading?> reading,
    AsyncValue<MoodInference?> mood,
  ) {
    return QuantumGlowContainer(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: QuantumDesignTokens.deepGray.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: QuantumDesignTokens.electricBlue.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'ADAPTIVE INTERFACE DEMO',
              style: QuantumDesignTokens.createQuantumTextStyle(
                fontSize: QuantumDesignTokens.fontMD,
                fontWeight: QuantumDesignTokens.weightBold,
                color: QuantumDesignTokens.textPrimary,
              ),
            ),
            const SizedBox(height: 20),

            // Heart rate synchronized pulsing element
            HeartRatePulseContainer(
              basePulseIntensity: 0.1,
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      QuantumDesignTokens.crimsonAlert,
                      QuantumDesignTokens.crimsonAlert.withValues(alpha: 0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'HEART RATE SYNC',
                    style: QuantumDesignTokens.createQuantumTextStyle(
                      fontSize: QuantumDesignTokens.fontSM,
                      fontWeight: QuantumDesignTokens.weightBold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Mood-responsive gradient background
            MoodResponsiveGradient(
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'MOOD RESPONSIVE GRADIENT',
                    style: QuantumDesignTokens.createQuantumTextStyle(
                      fontSize: QuantumDesignTokens.fontSM,
                      fontWeight: QuantumDesignTokens.weightBold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Breathing effect
            BreathingContainer(
              expansionFactor: 0.08,
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: QuantumDesignTokens.neonMint.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: QuantumDesignTokens.neonMint,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    'BREATHING EFFECT',
                    style: QuantumDesignTokens.createQuantumTextStyle(
                      fontSize: QuantumDesignTokens.fontSM,
                      fontWeight: QuantumDesignTokens.weightBold,
                      color: QuantumDesignTokens.neonMint,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompatibilitySimulation() {
    return QuantumGlowContainer(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: QuantumDesignTokens.deepGray.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: QuantumDesignTokens.warningAmber.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'MATCH SIMULATION',
              style: QuantumDesignTokens.createQuantumTextStyle(
                fontSize: QuantumDesignTokens.fontMD,
                fontWeight: QuantumDesignTokens.weightBold,
                color: QuantumDesignTokens.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            if (_isSimulating) ...<Widget>[
              CompatibilityRing(
                size: 120,
                compatibilityScore: _simulatedCompatibility,
              ),
              const SizedBox(height: 16),
              Text(
                'Simulating biometric matching with nearby user...',
                style: QuantumDesignTokens.createQuantumTextStyle(
                  fontSize: QuantumDesignTokens.fontSM,
                  color: QuantumDesignTokens.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ] else ...<Widget>[
              Center(
                child: ElevatedButton(
                  onPressed: _startCompatibilitySimulation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: QuantumDesignTokens.warningAmber,
                    foregroundColor: QuantumDesignTokens.pureBlack,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16,),
                  ),
                  child: Text(
                    'START SIMULATION',
                    style: QuantumDesignTokens.createQuantumTextStyle(
                      fontSize: QuantumDesignTokens.fontSM,
                      fontWeight: QuantumDesignTokens.weightBold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHapticTesting() {
    return QuantumGlowContainer(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: QuantumDesignTokens.deepGray.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: QuantumDesignTokens.electricBlue.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'VIBRATION FEEDBACK TESTING',
              style: QuantumDesignTokens.createQuantumTextStyle(
                fontSize: QuantumDesignTokens.fontMD,
                fontWeight: QuantumDesignTokens.weightBold,
                color: QuantumDesignTokens.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                _buildHapticButton('Connection', HapticService.playConnectionSuccess),
                _buildHapticButton('High Match', () {
                  QuantumHapticService.playCompatibilityWhisper(
                    compatibilityScore: 0.85,
                  );
                }),
                _buildHapticButton('Perfect Match', QuantumHapticService.playQuantumEntanglement),
                _buildHapticButton('Heartbeat', () {
                  QuantumHapticService.playHeartRateSync(75);
                }),
                _buildHapticButton('Breathing', () {
                  QuantumHapticService.playBreathingSync(16);
                }),
                _buildHapticButton('Alert', QuantumHapticService.playAlert),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHapticButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            QuantumDesignTokens.electricBlue.withValues(alpha: 0.2),
        foregroundColor: QuantumDesignTokens.electricBlue,
        side: BorderSide(
            color: QuantumDesignTokens.electricBlue.withValues(alpha: 0.5),),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        label,
        style: QuantumDesignTokens.createQuantumTextStyle(
          fontSize: QuantumDesignTokens.fontXS,
          fontWeight: QuantumDesignTokens.weightMedium,
        ),
      ),
    );
  }

  Widget _buildSystemControls(bool isMonitoring) {
    return QuantumGlowContainer(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: QuantumDesignTokens.deepGray.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'SYSTEM CONTROLS',
              style: QuantumDesignTokens.createQuantumTextStyle(
                fontSize: QuantumDesignTokens.fontMD,
                fontWeight: QuantumDesignTokens.weightBold,
                color: QuantumDesignTokens.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: _toggleMonitoring,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isMonitoring
                          ? QuantumDesignTokens.crimsonAlert
                          : QuantumDesignTokens.neonMint,
                      foregroundColor: QuantumDesignTokens.pureBlack,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      isMonitoring ? 'STOP MONITORING' : 'START MONITORING',
                      style: QuantumDesignTokens.createQuantumTextStyle(
                        fontSize: QuantumDesignTokens.fontSM,
                        fontWeight: QuantumDesignTokens.weightBold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _initializeOuraRing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        QuantumDesignTokens.electricBlue.withValues(alpha: 0.2),
                    foregroundColor: QuantumDesignTokens.electricBlue,
                    side: BorderSide(color: QuantumDesignTokens.electricBlue),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16,),
                  ),
                  child: Text(
                    'OURA',
                    style: QuantumDesignTokens.createQuantumTextStyle(
                      fontSize: QuantumDesignTokens.fontSM,
                      fontWeight: QuantumDesignTokens.weightBold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataMessage() {
    return Center(
      child: Text(
        'No biometric data available. Start monitoring to see live data.',
        style: QuantumDesignTokens.createQuantumTextStyle(
          fontSize: QuantumDesignTokens.fontSM,
          color: QuantumDesignTokens.textTertiary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(QuantumDesignTokens.neonMint),
      ),
    );
  }

  Widget _buildErrorMessage(String error) {
    return Center(
      child: Text(
        'Error: $error',
        style: QuantumDesignTokens.createQuantumTextStyle(
          fontSize: QuantumDesignTokens.fontSM,
          color: QuantumDesignTokens.crimsonAlert,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Color _getStressColor(double stressLevel) {
    if (stressLevel < 0.3) return QuantumDesignTokens.neonMint;
    if (stressLevel < 0.6) return QuantumDesignTokens.warningAmber;
    return QuantumDesignTokens.crimsonAlert;
  }

  Future<void> _toggleMonitoring() async {
    final bool isCurrentlyMonitoring = ref.read(biometricMonitoringStateProvider);

    if (isCurrentlyMonitoring) {
      await _biometricService?.stopMonitoring();
      ref.read(biometricMonitoringStateProvider.notifier).state = false;
    } else {
      final bool success = await _biometricService?.startMonitoring() ?? false;
      if (success) {
        ref.read(biometricMonitoringStateProvider.notifier).state = true;
      }
    }
  }

  Future<void> _initializeOuraRing() async {
    final bool success = await _biometricService?.initializeOuraRing() ?? false;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Oura Ring initialization started'
              : 'Failed to initialize Oura Ring',
          style: QuantumDesignTokens.createQuantumTextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: success
            ? QuantumDesignTokens.neonMint
            : QuantumDesignTokens.crimsonAlert,
      ),
    );
  }

  @override
  void dispose() {
    _syncController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    _simulationTimer?.cancel();
    super.dispose();
  }
}
