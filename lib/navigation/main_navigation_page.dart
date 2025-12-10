import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/nvs_colors.dart';

// Main feature screens
import '../features/meatmarket/presentation/pages/meat_market_grid.dart';
import '../features/tradeblock/presentation/pages/tradeblock_map.dart';
import '../features/connect/presentation/pages/connect_ai_dashboard_full.dart' show ConnectAIDashboardFull;
import '../features/lookout/presentation/pages/lookout_camera_setup.dart';
import '../features/messenger/presentation/universal_messenger_view.dart'
    show UniversalMessengerView;
import '../features/search/presentation/views/search_view.dart';
import '../features/profile/presentation/views/profile_view.dart' show ProfileView;
// Removed mock imports; derive connect target from real users if needed
// import '../features/connect/data/connect_ai_service.dart' as connect_ai; // not needed for dashboard entry

/// Main navigation page that coordinates all primary app sections
/// Uses the production-ready UI components and maintains state
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    HapticFeedback.selectionClick();
  }

  List<Widget> get _screens => <Widget>[
    const MeatMarketGrid(),                // 0: MEAT MARKET - Full grid with Vision mode
    const TradeBlockMap(),                 // 1: TRADEBLOCK - Real-time cruising map
    const ConnectAIDashboardFull(),        // 2: CONNECT - AI Dashboard with NVS hologram
    const LookoutCameraSetup(),            // 3: LOOKOUT - Video rooms
    const UniversalMessengerView(),        // 4: MESSAGES
    const SearchViewWidget(),              // 5: SEARCH
    const ProfileView(),                   // 6: PROFILE
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: SafeArea(child: IndexedStack(index: _currentIndex, children: _screens)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        backgroundColor: NVSColors.pureBlack,
        selectedItemColor: NVSColors.primaryLightMint,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 9,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'MEAT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'TRADEBLOCK',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'CONNECT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye),
            label: 'LOOKOUT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'MSGS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'SEARCH',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }
}

class _GlowAssetIcon extends StatefulWidget {
  const _GlowAssetIcon({required this.assetPath, required this.isActive});
  final String assetPath;
  final bool isActive;

  @override
  State<_GlowAssetIcon> createState() => _GlowAssetIconState();
}

class _GlowAssetIconState extends State<_GlowAssetIcon> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final bool glow = widget.isActive || _hover;
    const double iconSize = 28; // uniform symbol size (active == inactive)
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (widget.isActive)
              Container(
                width: iconSize + 10,
                height: iconSize + 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: NVSColors.primaryLightMint.withValues(alpha: 0.6),
                    width: 1.2,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: NVSColors.turquoiseNeon.withValues(alpha: 0.35),
                      blurRadius: 10,
                      spreadRadius: 0.6,
                    ),
                  ],
                ),
              ),
            DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: glow
                    ? <BoxShadow>[
                        BoxShadow(
                          color: NVSColors.ultraLightMint.withValues(alpha: 0.55),
                          blurRadius: 8,
                          spreadRadius: 1.0,
                        ),
                      ]
                    : null,
              ),
              child: Image.asset(
                widget.assetPath,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowMaterialIcon extends StatefulWidget {
  const _GlowMaterialIcon({required this.icon, required this.isActive});
  final IconData icon;
  final bool isActive;

  @override
  State<_GlowMaterialIcon> createState() => _GlowMaterialIconState();
}

class _GlowMaterialIconState extends State<_GlowMaterialIcon> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final bool glow = widget.isActive || _hover;
    const double baseSize = 28;
    const double activeSize = 32;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: glow ? activeSize : baseSize,
        height: glow ? activeSize : baseSize,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (widget.isActive)
              Container(
                width: activeSize + 10,
                height: activeSize + 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: NVSColors.primaryLightMint.withValues(alpha: 0.6),
                    width: 1.2,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: NVSColors.turquoiseNeon.withValues(alpha: 0.35),
                      blurRadius: 10,
                      spreadRadius: 0.6,
                    ),
                  ],
                ),
              ),
            DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: glow
                    ? <BoxShadow>[
                        BoxShadow(
                          color: NVSColors.ultraLightMint.withValues(alpha: 0.55),
                          blurRadius: 8,
                          spreadRadius: 1.0,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                widget.icon,
                color: glow ? NVSColors.ultraLightMint : Colors.white24,
                size: glow ? activeSize : baseSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

