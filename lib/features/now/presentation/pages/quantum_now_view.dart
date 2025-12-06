// lib/features/now/presentation/pages/quantum_now_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/quantum_metacity_view.dart';
import 'package:nvs/core/widgets/bio_responsive_scaffold.dart';
import 'package:nvs/meatup_core.dart';

/// The quantum-enhanced NOW section
/// Replaces the spinning globe with a live, interactive metacity visualization
class QuantumNowView extends ConsumerStatefulWidget {
  const QuantumNowView({super.key});

  @override
  ConsumerState<QuantumNowView> createState() => _QuantumNowViewState();
}

class _QuantumNowViewState extends ConsumerState<QuantumNowView>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  UserCluster? selectedCluster;
  bool showDataOverlay = true;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BioResponsiveScaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildQuantumHeader(),
            Expanded(
              child: _buildMetacityInterface(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantumHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.4),
          ],
        ),
        border: const Border(
          bottom: BorderSide(color: NVSColors.border, width: 0.5),
        ),
      ),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: <Color>[
                            NVSColors.neonMint,
                            NVSColors.neonMint.withOpacity(0.3),
                          ],
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: NVSColors.neonMint.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.public,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'QUANTUM METACITY',
                            style: TextStyle(
                              color: NVSColors.neonMint,
                              fontSize: 24,
                              fontFamily: 'MagdaCleanMono',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'Live neural clustering across dimensional space',
                            style: TextStyle(
                              color: NVSColors.textSecondary,
                              fontSize: 14,
                              fontFamily: 'MagdaCleanMono',
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleDataOverlay,
                      icon: Icon(
                        showDataOverlay ? Icons.layers : Icons.layers_outlined,
                        color: NVSColors.neonMint,
                      ),
                    ),
                    IconButton(
                      onPressed: _refreshMetacity,
                      icon: const Icon(
                        Icons.refresh,
                        color: NVSColors.neonMint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildQuantumMetrics(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuantumMetrics() {
    return Row(
      children: <Widget>[
        _buildMetric('CLUSTERS', '${12}', NVSColors.neonMint),
        const SizedBox(width: 16),
        _buildMetric('USERS', '${247}', NVSColors.neonBlue),
        const SizedBox(width: 16),
        _buildMetric('SYNC RATE', '98.7%', NVSColors.neonPurple),
        const SizedBox(width: 16),
        _buildMetric('LATENCY', '3ms', NVSColors.neonYellow),
      ],
    );
  }

  Widget _buildMetric(String label, String value, Color color) {
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
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontFamily: 'MagdaCleanMono',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
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

  Widget _buildMetacityInterface() {
    return Stack(
      children: <Widget>[
        // Main quantum metacity visualization
        Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: QuantumMetacityView(
              width: 380,
              height: 380,
              onClusterTap: _selectCluster,
            ),
          ),
        ),

        // Data overlay panel
        if (showDataOverlay && selectedCluster != null)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: _buildClusterDataPanel(selectedCluster!),
          ),

        // Quantum field controls
        Positioned(
          top: 20,
          right: 20,
          child: _buildQuantumControls(),
        ),

        // Live data stream indicator
        Positioned(
          top: 20,
          left: 20,
          child: _buildDataStreamIndicator(),
        ),
      ],
    );
  }

  Widget _buildQuantumControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NVSColors.neonMint.withOpacity(0.3)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NVSColors.neonMint.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'QUANTUM FIELD',
            style: TextStyle(
              color: NVSColors.neonMint,
              fontSize: 10,
              fontFamily: 'MagdaCleanMono',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildControlButton('AMPLIFY', Icons.zoom_in, _amplifyField),
          const SizedBox(height: 8),
          _buildControlButton(
            'FILTER',
            Icons.filter_alt,
            _filterClusters,
          ),
          const SizedBox(height: 8),
          _buildControlButton('SCAN', Icons.radar, _scanField),
        ],
      ),
    );
  }

  Widget _buildControlButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: NVSColors.neonMint.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: NVSColors.neonMint.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, color: NVSColors.neonMint, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: NVSColors.neonMint,
                fontSize: 8,
                fontFamily: 'MagdaCleanMono',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataStreamIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NVSColors.neonMint.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (BuildContext context, Widget? child) {
              return Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: NVSColors.neonMint,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color:
                          NVSColors.neonMint.withOpacity(_pulseAnimation.value),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          const Text(
            'LIVE STREAM',
            style: TextStyle(
              color: NVSColors.neonMint,
              fontSize: 10,
              fontFamily: 'MagdaCleanMono',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClusterDataPanel(UserCluster cluster) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cluster.auraColor.withOpacity(0.5)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: cluster.auraColor.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: cluster.auraColor,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: cluster.auraColor.withOpacity(0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'CLUSTER ${cluster.id.toUpperCase()}',
                  style: TextStyle(
                    color: cluster.auraColor,
                    fontSize: 16,
                    fontFamily: 'MagdaCleanMono',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => selectedCluster = null),
                icon: const Icon(
                  Icons.close,
                  color: NVSColors.textSecondary,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              _buildDataField('USERS', '${cluster.userCount}'),
              const SizedBox(width: 16),
              _buildDataField('DENSITY', '${(cluster.density * 100).toInt()}%'),
              const SizedBox(width: 16),
              _buildDataField('AURA', cluster.aura.toUpperCase()),
            ],
          ),
          if (cluster.dominantTags.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: cluster.dominantTags
                  .map(
                    (String tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: cluster.auraColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag.toUpperCase(),
                        style: TextStyle(
                          color: cluster.auraColor,
                          fontSize: 8,
                          fontFamily: 'MagdaCleanMono',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDataField(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: NVSColors.textSecondary,
              fontSize: 10,
              fontFamily: 'MagdaCleanMono',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: NVSColors.textPrimary,
              fontSize: 14,
              fontFamily: 'MagdaCleanMono',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _selectCluster(UserCluster cluster) {
    setState(() {
      selectedCluster = cluster;
    });
  }

  void _toggleDataOverlay() {
    setState(() {
      showDataOverlay = !showDataOverlay;
    });
  }

  void _refreshMetacity() {
    // Force refresh of the quantum metacity data
    ref.invalidate(metacityDataProvider);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refreshing quantum field matrix...'),
        backgroundColor: NVSColors.neonMint,
      ),
    );
  }

  void _amplifyField() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Amplifying quantum field resonance...'),
        backgroundColor: NVSColors.neonMint,
      ),
    );
  }

  void _filterClusters() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Applying quantum filters...'),
        backgroundColor: NVSColors.neonBlue,
      ),
    );
  }

  void _scanField() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Initiating deep field scan...'),
        backgroundColor: NVSColors.neonPurple,
      ),
    );
  }
}
