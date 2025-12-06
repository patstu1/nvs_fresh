// lib/navigation/quantum_main_navigation.dart
// Quantum-Enhanced Main Navigation for NVS 2027+ Architecture
// Bio-responsive navigation with real-time sync monitoring

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/quantum_providers.dart';
import '../core/theme/quantum_design_tokens.dart';
import '../core/models/app_types.dart';
import '../core/services/quantum_auth_sync_service.dart' show SectionSyncState;
import '../features/grid/presentation/pages/grid_main_view.dart';
import '../features/now/presentation/views/now_view_working.dart';
import '../features/connect/presentation/pages/ai_connect_view.dart';
import '../features/connect/presentation/pages/bio_neural_sync_view.dart';
import '../features/live/presentation/pages/room_view.dart';
import '../features/messages/presentation/pages/simple_messages_page.dart';
import '../features/search/presentation/pages/basic_search_page.dart';
import '../features/profile/presentation/pages/simple_profile_page.dart';
import '../features/auth/presentation/genesis_scan_view.dart';

/// Quantum Main Navigation - Enterprise-grade navigation with bio-responsiveness
class QuantumMainNavigation extends ConsumerStatefulWidget {
  const QuantumMainNavigation({super.key});

  @override
  ConsumerState<QuantumMainNavigation> createState() => _QuantumMainNavigationState();
}

class _QuantumMainNavigationState extends ConsumerState<QuantumMainNavigation>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _glowController;
  late AnimationController _syncController;
  late Animation<double> _glowAnimation;
  late Animation<double> _syncAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Glow animation for bio-responsive feedback
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Sync indicator animation
    _syncController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _syncAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _syncController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _glowController.dispose();
    _syncController.dispose();
    super.dispose();
  }

  // Core NVS screens - maintains exact same functionality
  late final List<Widget> _screens = <Widget>[
    const NVSGridView(), // MEATUP
    const NowViewWorking(), // NOW
    const AIConnectView(), // CONNECT
    const RoomView(roomId: 'main'), // LIVE
  ];

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    // Update current section in providers
    final AppSection section = _indexToSection(index);
    ref.read(currentAppSectionProvider.notifier).state = section;

    // Smooth page transition
    _pageController.animateToPage(
      index,
      duration: QuantumDesignTokens.durationNormal,
      curve: QuantumDesignTokens.curveQuantumEase,
    );

    // Trigger section sync
    _triggerSectionSync(section);
  }

  AppSection _indexToSection(int index) {
    switch (index) {
      case 0:
        return AppSection.grid;
      case 1:
        return AppSection.now;
      case 2:
        return AppSection.connect;
      case 3:
        return AppSection.live;
      default:
        return AppSection.grid;
    }
  }

  void _triggerSectionSync(AppSection section) {
    // TODO: Implement proper section sync when types are unified
    debugPrint('Section sync triggered for: ${section.displayName}');
    // final authService = ref.read(quantumAuthSyncServiceProvider);
    // authService.syncSection(section).catchError((Object e) {
    //   debugPrint('Section sync failed: $e');
    // });
  }

  @override
  Widget build(BuildContext context) {
    final bool isAuthenticated = ref.watch(isAuthenticatedProvider);
    final ProfileSyncInfo profileSyncStatus = ref.watch(profileSyncStatusProvider);
    final Map<AppSection, SectionSyncState> sectionSyncStatus =
        ref.watch(sectionSyncStatusProvider);
    final BioResponsiveThemeData? bioThemeData = ref.watch(bioResponsiveThemeProvider);

    // Show authentication flow if not authenticated
    if (!isAuthenticated) {
      return _buildAuthenticationFlow();
    }

    return Scaffold(
      backgroundColor: QuantumDesignTokens.pureBlack,
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });

          final AppSection section = _indexToSection(index);
          ref.read(currentAppSectionProvider.notifier).state = section;
        },
        children: _screens,
      ),
      bottomNavigationBar: _buildQuantumBottomNav(
        profileSyncStatus: profileSyncStatus,
        sectionSyncStatus: sectionSyncStatus,
        bioThemeData: bioThemeData,
      ),
      floatingActionButton: _buildQuantumFAB(
        profileSyncStatus: profileSyncStatus,
        bioThemeData: bioThemeData,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildAuthenticationFlow() {
    return Scaffold(
      backgroundColor: QuantumDesignTokens.pureBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Quantum NVS Logo with glow effect
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: QuantumDesignTokens.primaryGradient,
                boxShadow: QuantumDesignTokens.mintGlowMedium,
              ),
              child: const Icon(
                Icons.flash_on,
                size: 60,
                color: QuantumDesignTokens.pureBlack,
              ),
            ),

            const SizedBox(height: QuantumDesignTokens.spaceXL),

            Text(
              'Meatup',
              style: QuantumDesignTokens.createQuantumTextStyle(
                fontSize: QuantumDesignTokens.fontGiga,
                fontWeight: QuantumDesignTokens.weightBlack,
                glowIntensity: 0.8,
              ),
            ),

            const SizedBox(height: QuantumDesignTokens.spaceMD),

            const Text(
              'Neural Vector Social • 2027',
              style: TextStyle(
                fontFamily: QuantumDesignTokens.fontSecondary, // MagdaCleanMono
                fontSize: QuantumDesignTokens.fontMicro,
                color: QuantumDesignTokens.textTertiary,
                letterSpacing: QuantumDesignTokens.letterSpacingExtraWide,
                fontWeight: QuantumDesignTokens.weightRegular,
              ),
            ),

            const SizedBox(height: QuantumDesignTokens.spaceGiga),

            // Authentication methods
            const SizedBox(height: QuantumDesignTokens.spaceLG),

            // Face scan authentication button
            _buildQuantumAuthButton(
              label: 'GENESIS SCAN',
              subtitle: 'Facial Recognition Login',
              icon: Icons.face_retouching_natural,
              onPressed: _handleFaceScanAuth,
              isPrimary: true,
            ),

            const SizedBox(height: QuantumDesignTokens.spaceMD),

            // Enrollment button for new users
            _buildQuantumAuthButton(
              label: 'FIRST TIME',
              subtitle: 'Genesis Enrollment',
              icon: Icons.add_reaction_outlined,
              onPressed: _handleGenesisEnrollment,
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantumBottomNav({
    required ProfileSyncInfo profileSyncStatus,
    required Map<AppSection, SectionSyncState> sectionSyncStatus,
    BioResponsiveThemeData? bioThemeData,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            QuantumDesignTokens.pureBlack.withValues(alpha: 0.95),
            QuantumDesignTokens.pureBlack,
          ],
        ),
        border: const Border(
          top: BorderSide(
            color: QuantumDesignTokens.neonMint,
            width: 0.5,
          ),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: QuantumDesignTokens.neonMint.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(
            horizontal: QuantumDesignTokens.spaceLG,
            vertical: QuantumDesignTokens.spaceSM,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildQuantumNavItem(
                index: 0,
                label: 'MEATUP',
                icon: Icons.widgets, // More quantum/grid-like
                isActive: _currentIndex == 0,
                syncStatus: sectionSyncStatus[AppSection.grid],
                bioThemeData: bioThemeData,
              ),
              _buildQuantumNavItem(
                index: 1,
                label: 'NOW',
                icon: Icons.radar, // More appropriate for live map
                isActive: _currentIndex == 1,
                syncStatus: sectionSyncStatus[AppSection.now],
                bioThemeData: bioThemeData,
              ),
              const SizedBox(width: 60), // Space for Quantum FAB
              _buildQuantumNavItem(
                index: 2,
                label: 'CONNECT',
                icon: Icons.psychology, // Brain/neural symbol
                isActive: _currentIndex == 2,
                syncStatus: sectionSyncStatus[AppSection.connect],
                bioThemeData: bioThemeData,
              ),
              _buildQuantumNavItem(
                index: 3,
                label: 'LIVE',
                icon: Icons.visibility, // Watching eye symbol
                isActive: _currentIndex == 3,
                syncStatus: sectionSyncStatus[AppSection.live],
                bioThemeData: bioThemeData,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantumNavItem({
    required int index,
    required String label,
    required IconData icon,
    required bool isActive,
    SectionSyncState? syncStatus,
    BioResponsiveThemeData? bioThemeData,
  }) {
    final Color color = isActive
        ? (bioThemeData?.isRealTime == true
            ? QuantumDesignTokens.getBioResponsiveColor(
                bioThemeData!.arousalLevel,
              )
            : QuantumDesignTokens.neonMint)
        : QuantumDesignTokens.textTertiary;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (BuildContext context, Widget? child) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: QuantumDesignTokens.spaceSM,
              vertical: QuantumDesignTokens.spaceXS,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(QuantumDesignTokens.radiusMD),
              border: isActive
                  ? Border.all(
                      color: color.withValues(alpha: 0.4),
                      width: 1.5,
                    )
                  : null,
              // Enhanced quantum glow effects for active items
              boxShadow: isActive
                  ? <BoxShadow>[
                      // Inner glow
                      BoxShadow(
                        color: color.withValues(alpha: _glowAnimation.value * 0.6),
                        blurRadius: 12,
                      ),
                      // Outer glow for bio-responsive mode
                      if (bioThemeData?.isRealTime == true)
                        BoxShadow(
                          color: color.withValues(
                            alpha: _glowAnimation.value * 0.3,
                          ),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      // Ambient mint glow
                      BoxShadow(
                        color: QuantumDesignTokens.neonMint
                            .withValues(alpha: _glowAnimation.value * 0.2),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    // Enhanced icon with quantum glow
                    Container(
                      padding: const EdgeInsets.all(QuantumDesignTokens.spaceXS),
                      decoration: isActive
                          ? BoxDecoration(
                              shape: BoxShape.circle,
                              color: color.withValues(alpha: 0.1),
                              border: Border.all(
                                color: color.withValues(alpha: 0.2),
                                width: 0.5,
                              ),
                            )
                          : null,
                      child: Icon(
                        icon,
                        color: color,
                        size: QuantumDesignTokens.iconMD,
                        shadows: isActive
                            ? <Shadow>[
                                Shadow(
                                  color: color.withValues(
                                    alpha: _glowAnimation.value * 0.8,
                                  ),
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                    ),

                    // Enhanced sync indicator with pulsing effect
                    if (syncStatus?.requiresSync == true)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: AnimatedBuilder(
                          animation: _syncAnimation,
                          builder: (BuildContext context, Widget? child) {
                            return Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: QuantumDesignTokens.cyberOrange,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: QuantumDesignTokens.cyberOrange.withValues(
                                      alpha: _syncAnimation.value * 0.8,
                                    ),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.sync,
                                  size: 6,
                                  color: QuantumDesignTokens.pureBlack,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: QuantumDesignTokens.spaceXXS),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: QuantumDesignTokens.fontPrimary,
                    fontSize: QuantumDesignTokens.fontNano,
                    fontWeight: isActive
                        ? QuantumDesignTokens.weightBold
                        : QuantumDesignTokens.weightRegular,
                    color: color,
                    letterSpacing: QuantumDesignTokens.letterSpacingWide,
                    shadows: isActive
                        ? <Shadow>[
                            Shadow(
                              color: color.withValues(
                                alpha: _glowAnimation.value * 0.6,
                              ),
                              blurRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuantumFAB({
    required ProfileSyncInfo profileSyncStatus,
    BioResponsiveThemeData? bioThemeData,
  }) {
    final Color fabColor = bioThemeData?.isRealTime == true
        ? QuantumDesignTokens.getBioResponsiveColor(bioThemeData!.arousalLevel)
        : QuantumDesignTokens.neonMint;

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (BuildContext context, Widget? child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: fabColor.withValues(alpha: _glowAnimation.value * 0.6),
                blurRadius: 16,
                spreadRadius: 4,
              ),
              BoxShadow(
                color: fabColor.withValues(alpha: _glowAnimation.value * 0.3),
                blurRadius: 32,
                spreadRadius: 8,
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: _showQuantumMenu,
            backgroundColor: fabColor,
            foregroundColor: QuantumDesignTokens.pureBlack,
            elevation: 0,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                const Icon(Icons.add, size: 28),

                // Profile sync indicator
                if (profileSyncStatus.isProfileSyncing)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: AnimatedBuilder(
                      animation: _syncAnimation,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.rotate(
                          angle: _syncAnimation.value * 2 * 3.14159,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1.5,
                              ),
                            ),
                            child: const CircularProgressIndicator(
                              strokeWidth: 1,
                              valueColor: AlwaysStoppedAnimation(
                                QuantumDesignTokens.pureBlack,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showQuantumMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: QuantumDesignTokens.cardBackground,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(QuantumDesignTokens.radiusXL),
          ),
          border: Border.all(
            color: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
          ),
          boxShadow: QuantumDesignTokens.mintGlowMedium,
        ),
        child: Column(
          children: <Widget>[
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(
                vertical: QuantumDesignTokens.spaceMD,
              ),
              decoration: BoxDecoration(
                color: QuantumDesignTokens.neonMint.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Menu items
            _buildMenuTile(
              icon: Icons.message_outlined,
              title: 'MESSAGES',
              onTap: () {
                Navigator.pop(context);
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const SimpleMessagesPage(),
                  ),
                );
              },
            ),

            _buildMenuTile(
              icon: Icons.search_outlined,
              title: 'SEARCH',
              onTap: () {
                Navigator.pop(context);
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const BasicSearchPage(),
                  ),
                );
              },
            ),

            _buildMenuTile(
              icon: Icons.psychology,
              title: 'BIOMETRIC SYNC',
              onTap: () {
                Navigator.pop(context);
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const BioNeuralSyncView(),
                  ),
                );
              },
            ),

            _buildMenuTile(
              icon: Icons.person_outline,
              title: 'PROFILE',
              onTap: () {
                Navigator.pop(context);
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const SimpleProfilePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: QuantumDesignTokens.neonMint,
        size: QuantumDesignTokens.iconLG,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: QuantumDesignTokens.fontPrimary,
          fontSize: QuantumDesignTokens.fontMD,
          fontWeight: QuantumDesignTokens.weightBold,
          color: QuantumDesignTokens.textPrimary,
          letterSpacing: QuantumDesignTokens.letterSpacingWide,
        ),
      ),
      onTap: onTap,
      hoverColor: QuantumDesignTokens.neonMint.withValues(alpha: 0.1),
    );
  }

  /// Build quantum-styled authentication button
  Widget _buildQuantumAuthButton({
    required String label,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    final Color color =
        isPrimary ? QuantumDesignTokens.neonMint : QuantumDesignTokens.turquoiseNeon;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: QuantumDesignTokens.spaceLG),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: color,
          padding: const EdgeInsets.all(QuantumDesignTokens.spaceLG),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(QuantumDesignTokens.radiusLG),
            side: BorderSide(color: color.withValues(alpha: 0.5)),
          ),
          elevation: 0,
        ),
        child: Column(
          children: <Widget>[
            Icon(icon, size: QuantumDesignTokens.iconXL, color: color),
            const SizedBox(height: QuantumDesignTokens.spaceSM),
            Text(
              label,
              style: QuantumDesignTokens.createQuantumTextStyle(
                fontSize: QuantumDesignTokens.fontLG,
                fontWeight: QuantumDesignTokens.weightBold,
                enableGlow: isPrimary,
                glowIntensity: 0.6,
              ).copyWith(color: color),
            ),
            const SizedBox(height: QuantumDesignTokens.spaceXS),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: QuantumDesignTokens.fontSecondary,
                fontSize: QuantumDesignTokens.fontSM,
                color: color.withValues(alpha: 0.7),
                letterSpacing: QuantumDesignTokens.letterSpacingWide,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle face scan authentication
  Future<void> _handleFaceScanAuth() async {
    try {
      debugPrint('🔐 Initiating Genesis Face Scan Authentication');

      final Map<String, dynamic>? result = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute<Map<String, dynamic>>(
          builder: (BuildContext context) => const GenesisScanView(isEnrollment: false),
        ),
      );

      if (result != null && result['success'] == true) {
        if (result['authenticated'] == true) {
          debugPrint('✅ Face scan authentication successful');
          // The isAuthenticatedProvider should update automatically
          // Navigation will rebuild and show main app
        } else {
          _showAuthError('Authentication failed. Please try again.');
        }
      }
    } catch (e) {
      debugPrint('❌ Face scan authentication error: $e');
      _showAuthError('Face scan error: ${e.toString()}');
    }
  }

  /// Handle Genesis enrollment for new users
  Future<void> _handleGenesisEnrollment() async {
    try {
      debugPrint('🔐 Initiating Genesis Enrollment');

      final Map<String, dynamic>? result = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute<Map<String, dynamic>>(
          builder: (BuildContext context) => const GenesisScanView(isEnrollment: true),
        ),
      );

      if (result != null && result['success'] == true) {
        if (result['enrolled'] == true) {
          debugPrint('✅ Genesis enrollment successful');
          // After enrollment, proceed to authentication
          await _handleFaceScanAuth();
        } else {
          _showAuthError('Enrollment failed. Please try again.');
        }
      }
    } catch (e) {
      debugPrint('❌ Genesis enrollment error: $e');
      _showAuthError('Enrollment error: ${e.toString()}');
    }
  }

  /// Show authentication error message
  void _showAuthError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: QuantumDesignTokens.cyberOrange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(QuantumDesignTokens.radiusMD),
          ),
        ),
      );
    }
  }
}
