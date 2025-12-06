// lib/features/connect/presentation/pages/ai_connect_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/core/models/app_types.dart';

import '../../domain/models/compatibility_match.dart';
import '../../data/ai_matchmaking_service.dart';
import '../widgets/visual_radar_widget.dart';
import 'package:nvs/core/theme/quantum_design_tokens.dart';
import '../../../../core/providers/quantum_providers.dart';

/// AI-powered Connect view with the NVS Synaptic Core
/// This is the neural interface to human chemistry visualization
class AIConnectView extends ConsumerStatefulWidget {
  const AIConnectView({super.key});

  @override
  ConsumerState<AIConnectView> createState() => _AIConnectViewState();
}

class _AIConnectViewState extends ConsumerState<AIConnectView>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _neuralController;
  late AnimationController _syncController;
  late Animation<double> _headerAnimation;
  late Animation<double> _neuralAnimation;
  late Animation<double> _syncAnimation;

  CompatibilityMatch? selectedMatch;
  bool showLegend = true;

  @override
  void initState() {
    super.initState();
    _initializeBioNeuralAnimations();
  }

  /// Initialize bio-neural synchronization animations
  void _initializeBioNeuralAnimations() {
    // Header pulse animation
    _headerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _headerAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeInOut),
    );

    // Neural network activity simulation
    _neuralController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _neuralAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _neuralController, curve: Curves.easeInOutSine),
    );

    // Bio-synchronization wave animation
    _syncController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _syncAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _syncController, curve: Curves.elasticOut),
    );

    // Start bio-neural activity
    _headerController.repeat(reverse: true);
    _neuralController.repeat(reverse: true);
    _syncController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _headerController.dispose();
    _neuralController.dispose();
    _syncController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<dynamic> performanceMetrics = ref.watch(performanceMetricsProvider);
    final bool shouldEnableGlow = ref.watch(shouldEnableGlowEffectsProvider);
    final BioResponsiveThemeData? bioThemeData = ref.watch(bioResponsiveThemeProvider);
    final AsyncValue<List<CompatibilityMatch>> matchesAsync = ref.watch(compatibilityMatchesStreamProvider);

    return Scaffold(
      backgroundColor: QuantumDesignTokens.pureBlack,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            Expanded(
              child: matchesAsync.when(
                data: _buildConnectInterface,
                loading: _buildLoadingInterface,
                error: (Object error, StackTrace stack) => _buildErrorInterface(error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final bool shouldEnableGlow = ref.watch(shouldEnableGlowEffectsProvider);

    return QuantumGlowContainer(
      child: Container(
        padding: const EdgeInsets.all(QuantumDesignTokens.spaceLG),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              QuantumDesignTokens.cardBackground,
              QuantumDesignTokens.cardBackground.withValues(alpha: 0.7),
            ],
          ),
          border: const Border(
            bottom: BorderSide(color: QuantumDesignTokens.neonMint, width: 0.5),
          ),
        ),
        child: AnimatedBuilder(
          animation: Listenable.merge(<Listenable?>[_headerAnimation, _neuralAnimation, _syncAnimation]),
          builder: (BuildContext context, Widget? child) {
            final double headerScale = _headerAnimation.value;
            final double neuralIntensity = _neuralAnimation.value;
            final double syncPulse = _syncAnimation.value;

            return Transform.scale(
              scale: headerScale,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    // Bio-Neural Sync Icon with animated glow
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: QuantumDesignTokens.neonMint.withValues(alpha: 0.2),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: QuantumDesignTokens.neonMint.withValues(alpha: syncPulse * 0.8),
                            blurRadius: 20 * syncPulse,
                            spreadRadius: 2 * syncPulse,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.psychology,
                        color: QuantumDesignTokens.neonMint,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'SYNAPTIC CORE',
                            style: TextStyle(
                              color: QuantumDesignTokens.neonMint,
                              fontSize: 24,
                              fontFamily: 'MagdaCleanMono',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'Neural compatibility matrix active',
                            style: TextStyle(
                              color: QuantumDesignTokens.textSecondary,
                              fontSize: 14,
                              fontFamily: 'MagdaCleanMono',
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _refreshMatches,
                      icon: const Icon(
                        Icons.refresh,
                        color: QuantumDesignTokens.neonMint,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => showLegend = !showLegend),
                      icon: Icon(
                        showLegend ? Icons.visibility : Icons.visibility_off,
                        color: QuantumDesignTokens.neonMint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildStatusIndicators(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusIndicators() {
    return Row(
      children: <Widget>[
        _buildStatusIndicator('NEURAL NET', Colors.green, 'ONLINE'),
        const SizedBox(width: 16),
        _buildStatusIndicator('VECTOR DB', Colors.blue, 'SYNCED'),
        const SizedBox(width: 16),
        _buildStatusIndicator('BIO-SYNC', Colors.orange, 'PENDING'),
      ],
    );
  }

  Widget _buildStatusIndicator(String label, Color color, String status) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontFamily: 'MagdaCleanMono',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              status,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 8,
                fontFamily: 'MagdaCleanMono',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectInterface(List<CompatibilityMatch> matches) {
    return Stack(
      children: <Widget>[
        // Main radar interface
        Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: VisualRadarWidget(
              matches: matches,
              onNodeTap: _selectMatch,
              width: 350,
              height: 350,
            ),
          ),
        ),

        // Legend overlay
        if (showLegend)
          const Positioned(
            top: 20,
            right: 20,
            child: RadarLegend(),
          ),

        // Match details panel
        if (selectedMatch != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildMatchDetailsPanel(selectedMatch!),
          ),

        // Match count indicator
        Positioned(
          top: 20,
          left: 20,
          child: _buildMatchCountIndicator(matches.length),
        ),
      ],
    );
  }

  Widget _buildMatchCountIndicator(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: QuantumDesignTokens.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: QuantumDesignTokens.neonMint.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.people_outline,
            color: QuantumDesignTokens.neonMint,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            '$count NEURAL SIGNALS',
            style: const TextStyle(
              color: QuantumDesignTokens.neonMint,
              fontSize: 12,
              fontFamily: 'MagdaCleanMono',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchDetailsPanel(CompatibilityMatch match) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: QuantumDesignTokens.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border.all(color: QuantumDesignTokens.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: match.tier.color.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          // Panel header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: match.tier.color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 25,
                  backgroundColor: match.tier.color.withOpacity(0.2),
                  backgroundImage: match.userProfile.avatarUrl != null
                      ? NetworkImage(match.userProfile.avatarUrl!)
                      : null,
                  child: match.userProfile.avatarUrl == null
                      ? Text(
                          match.userProfile.username
                              .substring(0, 1)
                              .toUpperCase(),
                          style: TextStyle(
                            color: match.tier.color,
                            fontFamily: 'MagdaCleanMono',
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        match.userProfile.effectiveDisplayName,
                        style: const TextStyle(
                          color: QuantumDesignTokens.textPrimary,
                          fontSize: 18,
                          fontFamily: 'MagdaCleanMono',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        match.tier.label,
                        style: TextStyle(
                          color: match.tier.color,
                          fontSize: 12,
                          fontFamily: 'MagdaCleanMono',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: match.tier.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(match.score * 100).toInt()}%',
                    style: TextStyle(
                      color: match.tier.color,
                      fontSize: 16,
                      fontFamily: 'MagdaCleanMono',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => selectedMatch = null),
                  icon: const Icon(
                    Icons.close,
                    color: QuantumDesignTokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Compatibility breakdown
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildCompatibilityBreakdown(match.breakdown),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _connectWithUser(match),
                    icon: const Icon(Icons.connect_without_contact),
                    label: const Text('INITIATE CONTACT'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: match.tier.color,
                      foregroundColor: QuantumDesignTokens.background,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _analyzeCompatibility(match),
                  icon: const Icon(Icons.analytics),
                  label: const Text('DEEP SCAN'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: QuantumDesignTokens.surface,
                    foregroundColor: QuantumDesignTokens.neonMint,
                    side: const BorderSide(color: QuantumDesignTokens.neonMint),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompatibilityBreakdown(CompatibilityBreakdown breakdown) {
    final List<(String, double)> factors = <(String, double)>[
      ('ASTRO ALIGN', breakdown.astrologicalAlignment),
      ('ROLE COMPAT', breakdown.roleCompatibility),
      ('BIO RESONANCE', breakdown.biometricResonance),
      ('BEHAVIORAL', breakdown.behavioralSynergy),
      ('SEMANTIC', breakdown.semanticSimilarity),
    ];

    return Column(
      children: factors
          .map(((String, double) factor) => _buildFactorBar(factor.$1, factor.$2))
          .toList(),
    );
  }

  Widget _buildFactorBar(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: QuantumDesignTokens.textSecondary,
                fontSize: 10,
                fontFamily: 'MagdaCleanMono',
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: QuantumDesignTokens.background,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value,
                child: Container(
                  decoration: BoxDecoration(
                    color: QuantumDesignTokens.neonMint,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: QuantumDesignTokens.neonMint.withOpacity(0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(value * 100).toInt()}%',
            style: const TextStyle(
              color: QuantumDesignTokens.textPrimary,
              fontSize: 10,
              fontFamily: 'MagdaCleanMono',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingInterface() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: QuantumDesignTokens.neonMint.withOpacity(0.3), width: 2,),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(QuantumDesignTokens.neonMint),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'INITIALIZING NEURAL PATHWAYS...',
            style: TextStyle(
              color: QuantumDesignTokens.neonMint,
              fontSize: 16,
              fontFamily: 'MagdaCleanMono',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Processing 256-dimensional compatibility vectors',
            style: TextStyle(
              color: QuantumDesignTokens.textSecondary,
              fontSize: 12,
              fontFamily: 'MagdaCleanMono',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorInterface(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.error_outline,
            color: QuantumDesignTokens.error,
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'NEURAL NETWORK OFFLINE',
            style: TextStyle(
              color: QuantumDesignTokens.error,
              fontSize: 18,
              fontFamily: 'MagdaCleanMono',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(
              color: QuantumDesignTokens.textSecondary,
              fontSize: 12,
              fontFamily: 'MagdaCleanMono',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _refreshMatches,
            icon: const Icon(Icons.refresh),
            label: const Text('RETRY CONNECTION'),
            style: ElevatedButton.styleFrom(
              backgroundColor: QuantumDesignTokens.error,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _selectMatch(CompatibilityMatch match) {
    setState(() {
      selectedMatch = match;
    });
  }

  void _refreshMatches() {
    ref.invalidate(compatibilityMatchesStreamProvider);
  }

  void _connectWithUser(CompatibilityMatch match) {
    // Initiate quantum connection protocol
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Initiating neural connection with ${match.userProfile.effectiveDisplayName}...',),
        backgroundColor: match.tier.color,
      ),
    );
  }

  void _analyzeCompatibility(CompatibilityMatch match) {
    // Navigate to quantum compatibility matrix analysis
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Deep scanning compatibility matrix with ${match.userProfile.effectiveDisplayName}...',),
        backgroundColor: QuantumDesignTokens.neonMint,
      ),
    );
  }
}
