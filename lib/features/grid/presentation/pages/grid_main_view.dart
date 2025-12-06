import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/core/models/app_types.dart';
import 'package:nvs/core/theme/quantum_design_tokens.dart';
import '../../../../core/providers/quantum_providers.dart';
import '../../domain/models/grid_user_model.dart';
import '../../../../shared/widgets/section_label.dart';

/// Main Grid view for browsing user profiles
/// Features neon glow effects and cyberpunk styling
class NVSGridView extends ConsumerStatefulWidget {
  const NVSGridView({super.key});

  @override
  ConsumerState<NVSGridView> createState() => _NVSGridViewState();
}

class _NVSGridViewState extends ConsumerState<NVSGridView> with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<dynamic> performanceMetrics = ref.watch(performanceMetricsProvider);
    final bool shouldEnableGlow = ref.watch(shouldEnableGlowEffectsProvider);
    final BioResponsiveThemeData? bioThemeData = ref.watch(bioResponsiveThemeProvider);

    // Use simple mock data for now - TODO: Replace with quantum user profiles
    final List<GridUserModel> users = <GridUserModel>[
      GridUserModel(
        id: '1',
        displayName: 'ALEX',
        distance: '2.1 km',
      ),
      GridUserModel(
        id: '2',
        displayName: 'JORDAN',
        distance: '3.5 km',
      ),
      GridUserModel(
        id: '3',
        displayName: 'NOVA',
        distance: '1.8 km',
      ),
      GridUserModel(
        id: '4',
        displayName: 'PIXEL',
        distance: '4.2 km',
      ),
    ];

    return Scaffold(
      backgroundColor: QuantumDesignTokens.pureBlack,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                // Enhanced MEATUP Header
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Main MEATUP title with enhanced styling
                        AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (BuildContext context, Widget? child) {
                            return Row(
                              children: <Widget>[
                                // Cyberpunk bracket decoration
                                Container(
                                  width: 4,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: QuantumDesignTokens.neonMint,
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: QuantumDesignTokens.neonMint.withValues(
                                          alpha: _glowAnimation.value * 0.6,
                                        ),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // MEATUP text
                                Expanded(
                                  child: Text(
                                    'MEATUP',
                                    style: TextStyle(
                                      fontFamily: 'BellGothic',
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: QuantumDesignTokens.ultraLightMint,
                                      letterSpacing: 2.0,
                                      shadows: <Shadow>[
                                        Shadow(
                                          color: QuantumDesignTokens.neonMint.withValues(
                                            alpha: _glowAnimation.value * 0.8,
                                          ),
                                          blurRadius: 12,
                                        ),
                                        Shadow(
                                          color: QuantumDesignTokens.avocadoGreen.withValues(
                                            alpha: _glowAnimation.value * 0.4,
                                          ),
                                          blurRadius: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Filter/Settings button with enhanced styling
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: QuantumDesignTokens.cardBackground,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: QuantumDesignTokens.neonMint.withValues(alpha: 0.5),
                                      width: 2,
                                    ),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.tune,
                                      color: QuantumDesignTokens.neonMint,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      _showQuantumFilters(context);
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        // Subtitle with cyberpunk flair
                        const Text(
                          'CONNECT • EXPLORE • TRADE ENERGY',
                          style: TextStyle(
                            fontFamily: 'MagdaCleanMono',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: QuantumDesignTokens.softGray,
                            letterSpacing: 3.0,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Decorative line with glow
                        AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (BuildContext context, Widget? child) {
                            return Container(
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.transparent,
                                    QuantumDesignTokens.neonMint.withValues(
                                      alpha: _glowAnimation.value * 0.6,
                                    ),
                                    QuantumDesignTokens.neonMint.withValues(
                                      alpha: _glowAnimation.value * 0.8,
                                    ),
                                    QuantumDesignTokens.neonMint.withValues(
                                      alpha: _glowAnimation.value * 0.6,
                                    ),
                                    Colors.transparent,
                                  ],
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: QuantumDesignTokens.neonMint.withValues(
                                      alpha: _glowAnimation.value * 0.4,
                                    ),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Enhanced Stats Bar with Cyberpunk Design
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      // Dark background with subtle pattern
                      color: const Color(0xFF0A0A0A),
                      borderRadius: BorderRadius.circular(20),

                      // Thick neon border
                      border: Border.all(
                        color: QuantumDesignTokens.neonMint,
                        width: 3,
                      ),

                      // Enhanced glow effects
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: QuantumDesignTokens.avocadoGreen.withValues(alpha: 0.2),
                          blurRadius: 25,
                        ),
                      ],
                    ),
                    child: Row(
                      children: <Widget>[
                        // Network status indicator
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: QuantumDesignTokens.neonMint,
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: QuantumDesignTokens.neonMint.withValues(alpha: 0.6),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Network status text
                        const Flexible(
                          child: Text(
                            'NETWORK:',
                            style: TextStyle(
                              fontFamily: 'MagdaCleanMono',
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: QuantumDesignTokens.softGray,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Flexible(
                          child: Text(
                            'ACTIVE',
                            style: TextStyle(
                              fontFamily: 'MagdaCleanMono',
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: QuantumDesignTokens.neonMint,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Stats with enhanced styling - reduced spacing
                        _buildEnhancedStatItem('ONLINE', '${users.length}'),
                        const SizedBox(width: 12),
                        _buildEnhancedStatItem(
                          'NEARBY',
                          '${(users.length * 0.7).round()}',
                        ),
                        const SizedBox(width: 12),
                        _buildEnhancedStatItem(
                          'ACTIVE',
                          '${(users.length * 0.4).round()}',
                        ),
                      ],
                    ),
                  ),
                ),

                // NVS Logo Video
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Center(
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: QuantumDesignTokens.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'QUANTUM LOGO',
                            style: TextStyle(
                              color: QuantumDesignTokens.neonMint,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // User Grid with Enhanced Layout
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 COLUMNS instead of 2
                      childAspectRatio: 0.75, // SMALLER aspect ratio for smaller boxes
                      crossAxisSpacing: 12, // LESS spacing for tighter grid
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return _buildEnhancedUserCard(users[index], index);
                      },
                      childCount: users.length,
                    ),
                  ),
                ),

                // Bottom padding for navigation
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),

            // Section Label
            const SectionLabel(
              sectionName: 'MEATUP',
              glowColor: QuantumDesignTokens.avocadoGreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedStatItem(String label, String value) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            fontFamily: 'BellGothic',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: QuantumDesignTokens.ultraLightMint,
            shadows: <Shadow>[
              Shadow(
                color: QuantumDesignTokens.neonMint.withValues(alpha: 0.6),
                blurRadius: 6,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: QuantumDesignTokens.softGray,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedUserCard(GridUserModel user, int index) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (BuildContext context, Widget? child) {
        final double delayedGlow = (_glowAnimation.value + (index * 0.1)) % 1.0;
        final bool isOnline = index % 3 == 0; // Simulate online status
        final bool hasNewMessage = index % 5 == 0; // Simulate new messages

        final bool shouldEnableGlow = ref.watch(shouldEnableGlowEffectsProvider);

        return GestureDetector(
          onTap: () {
            // Navigate to quantum profile analysis
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Viewing ${user.displayName}'s profile"),
                backgroundColor: QuantumDesignTokens.cardBackground,
              ),
            );
          },
          child: QuantumGlowContainer(
            enableGlow: shouldEnableGlow,
            child: DecoratedBox(
              decoration: BoxDecoration(
                // Dark cyberpunk background
                color: const Color(0xFF0A0A0A),
                borderRadius: BorderRadius.circular(20),

                // THICK NEON BORDER - This is the key enhancement
                border: Border.all(
                  color: isOnline
                      ? QuantumDesignTokens.neonMint
                      : QuantumDesignTokens.ultraLightMint.withValues(alpha: 0.6),
                  width: 3.0, // Much thicker border
                ),

                // Enhanced glow effects
                boxShadow: <BoxShadow>[
                  // Inner glow
                  BoxShadow(
                    color: (isOnline
                            ? QuantumDesignTokens.neonMint
                            : QuantumDesignTokens.ultraLightMint)
                        .withValues(alpha: delayedGlow * 0.4),
                    blurRadius: 8,
                    spreadRadius: -2,
                  ),
                  // Outer glow
                  BoxShadow(
                    color: (isOnline
                            ? QuantumDesignTokens.neonMint
                            : QuantumDesignTokens.ultraLightMint)
                        .withValues(alpha: delayedGlow * 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                  // Ambient glow
                  BoxShadow(
                    color: QuantumDesignTokens.avocadoGreen.withValues(alpha: delayedGlow * 0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: <Widget>[
                  // Main content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Profile Image with enhanced styling
                      Expanded(
                        flex: 4,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: QuantumDesignTokens.pureBlack.withValues(alpha: 0.8),
                                blurRadius: 4,
                                spreadRadius: -1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: _buildEnhancedProfileAvatar(user.displayName),
                          ),
                        ),
                      ),

                      // User Info Section with enhanced typography
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(6, 0, 6, 4),
                          child: ClipRect(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                // Name with glow effect
                                Flexible(
                                  child: Text(
                                    user.displayName,
                                    style: TextStyle(
                                      fontFamily: 'BellGothic',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: QuantumDesignTokens.ultraLightMint,
                                      shadows: <Shadow>[
                                        Shadow(
                                          color:
                                              QuantumDesignTokens.neonMint.withValues(alpha: 0.6),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                // Location with icon
                                Flexible(
                                  child: Row(
                                    children: <Widget>[
                                      const Icon(
                                        Icons.location_on,
                                        size: 10,
                                        color: QuantumDesignTokens.softGray,
                                      ),
                                      const SizedBox(width: 3),
                                      Expanded(
                                        child: Text(
                                          user.distance,
                                          style: const TextStyle(
                                            fontFamily: 'MagdaCleanMono',
                                            fontSize: 9,
                                            color: QuantumDesignTokens.softGray,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Status indicator
                                Flexible(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: isOnline
                                              ? QuantumDesignTokens.neonMint
                                              : QuantumDesignTokens.softGray,
                                          shape: BoxShape.circle,
                                          boxShadow: isOnline
                                              ? <BoxShadow>[
                                                  BoxShadow(
                                                    color: QuantumDesignTokens.neonMint
                                                        .withValues(alpha: 0.6),
                                                    blurRadius: 4,
                                                    spreadRadius: 1,
                                                  ),
                                                ]
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        isOnline ? 'ONLINE' : 'OFFLINE',
                                        style: TextStyle(
                                          fontFamily: 'MagdaCleanMono',
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          color: isOnline
                                              ? QuantumDesignTokens.neonMint
                                              : QuantumDesignTokens.softGray,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // New message indicator
                  if (hasNewMessage)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF4444),
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2,
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: const Color(0xFFFF4444).withValues(alpha: 0.6),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedProfileAvatar(String name) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
            QuantumDesignTokens.avocadoGreen.withValues(alpha: 0.2),
            QuantumDesignTokens.ultraLightMint.withValues(alpha: 0.1),
          ],
        ),
        border: Border.all(
          color: QuantumDesignTokens.neonMint.withValues(alpha: 0.4),
        ),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            fontFamily: 'BellGothic',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: QuantumDesignTokens.ultraLightMint,
            shadows: <Shadow>[
              Shadow(
                color: QuantumDesignTokens.neonMint.withValues(alpha: 0.8),
                blurRadius: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuantumFilters(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: QuantumDesignTokens.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Quantum Filters',
              style: TextStyle(
                fontFamily: 'BellGothic',
                fontSize: 24,
                color: QuantumDesignTokens.neonMint,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildFilterOption('Distance Range', '0-50km'),
            _buildFilterOption('Age Range', '18-99'),
            _buildFilterOption('Online Status', 'All'),
            _buildFilterOption('Quantum Compatibility', '>75%'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: QuantumDesignTokens.neonMint,
                  foregroundColor: QuantumDesignTokens.pureBlack,
                ),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: QuantumDesignTokens.white,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: QuantumDesignTokens.neonMint,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
