import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nvs/meatup_core.dart';

class NVSUniversalToolbar extends StatefulWidget {
  const NVSUniversalToolbar({
    required this.currentIndex,
    required this.onTabChanged,
    super.key,
  });
  final int currentIndex;
  final Function(int) onTabChanged;

  @override
  State<NVSUniversalToolbar> createState() => _NVSUniversalToolbarState();
}

class _NVSUniversalToolbarState extends State<NVSUniversalToolbar> with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  int? _pressedIcon;
  int? _hoveredIcon;
  String? _displayedFunction;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _handleIconPress(int index) {
    setState(() {
      _pressedIcon = index;
    });

    // Visual feedback
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _pressedIcon = null;
        });
      }
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Handle navigation
    widget.onTabChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Top turquoise line
        Container(
          height: 1,
          color: const Color(0xFF2E8B8B),
        ),

        DecoratedBox(
          decoration: const BoxDecoration(
            color: NVSColors.pureBlack,
          ),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Icon row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // 1. Jockstrap - Grid/Home
                        _buildToolbarIcon(
                          index: 0,
                          assetPath: 'assets/icons/jockstrap.png',
                          label: 'Grid',
                          function: 'Browse profiles',
                          color: const Color(
                            0xFFE9FFF9,
                          ), // Much lighter ultra-light mint
                        ),

                        const SizedBox(width: 20),

                        // 2. Now - Globe emoji
                        _buildToolbarIcon(
                          index: 1,
                          emoji: '🌍',
                          label: 'Now',
                          function: "See who's active",
                          color: NVSColors.primaryGlow,
                        ),

                        const SizedBox(width: 20),

                        // 3. Connect - Infinity emoji
                        _buildToolbarIcon(
                          index: 2,
                          emoji: '♾️',
                          label: 'Connect',
                          function: 'Find connections',
                          color: NVSColors.primaryGlow,
                        ),

                        const SizedBox(width: 20),

                        // 4. Live - TV emoji
                        _buildToolbarIcon(
                          index: 3,
                          emoji: '📺',
                          label: 'Live',
                          function: 'Live streaming',
                          color: NVSColors.primaryGlow,
                        ),

                        const SizedBox(width: 20),

                        // 5. Messages - Chat emoji
                        _buildToolbarIcon(
                          index: 4,
                          emoji: '💬',
                          label: 'Messages',
                          function: 'Chat & connect',
                          color: NVSColors.primaryGlow,
                        ),

                        const SizedBox(width: 20),

                        // 6. Search - Magnifying glass emoji
                        _buildToolbarIcon(
                          index: 5,
                          emoji: '🔍',
                          label: 'Search',
                          function: 'Explore & filter',
                          color: NVSColors.primaryGlow,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bottom turquoise line
        Container(
          height: 1,
          color: const Color(0xFF2E8B8B),
        ),
      ],
    );
  }

  Widget _buildToolbarIcon({
    required int index,
    required String label,
    required String function,
    required Color color,
    IconData? icon,
    String? assetPath,
    String? emoji,
  }) {
    final bool isActive = widget.currentIndex == index;
    final bool isPressed = _pressedIcon == index;
    final bool isHovered = _hoveredIcon == index;

    return MouseRegion(
      onEnter: (_) => setState(() {
        _hoveredIcon = index;
        _displayedFunction = function;
      }),
      onExit: (_) => setState(() {
        _hoveredIcon = null;
        _displayedFunction = null;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() {
          _pressedIcon = index;
          _displayedFunction = function;
        }),
        onTapUp: (_) => _handleIconPress(index),
        onTapCancel: () => setState(() {
          _pressedIcon = null;
          _displayedFunction = null;
        }),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isActive
                    ? color.withValues(alpha: 0.2)
                    : (isPressed ? color.withValues(alpha: 0.1) : Colors.transparent),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive
                      ? color
                      : (isPressed ? color.withValues(alpha: 0.6) : color.withValues(alpha: 0.3)),
                  width: isActive ? 2 : 1,
                ),
                boxShadow: isActive
                    ? <BoxShadow>[
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: color.withValues(alpha: 0.2),
                          blurRadius: 24,
                        ),
                      ]
                    : isPressed
                        ? <BoxShadow>[
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
              ),
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (BuildContext context, Widget? child) {
                  return AnimatedScale(
                    scale: isPressed ? 1.2 : (isActive ? 1.1 : 1.0),
                    duration: const Duration(milliseconds: 200),
                    child: assetPath != null
                        ? Image.asset(
                            assetPath,
                            width: isActive ? 32 : 28,
                            height: isActive ? 32 : 28,
                            // Do not set color here for jockstrap
                          )
                        : emoji != null
                            ? Text(
                                emoji,
                                style: TextStyle(
                                  fontSize: isActive ? 28 : 24,
                                  shadows: isActive
                                      ? <Shadow>[
                                          Shadow(
                                            color: color.withValues(
                                              alpha: _glowAnimation.value,
                                            ),
                                            blurRadius: 12,
                                          ),
                                          Shadow(
                                            color: color.withValues(alpha: 0.6),
                                            blurRadius: 6,
                                          ),
                                        ]
                                      : <Shadow>[
                                          Shadow(
                                            color: color.withValues(alpha: 0.5),
                                            blurRadius: 4,
                                          ),
                                        ],
                                ),
                              )
                            : Icon(
                                icon,
                                color: color,
                                size: isActive ? 28 : 24,
                                shadows: isActive
                                    ? <Shadow>[
                                        Shadow(
                                          color: color.withValues(
                                            alpha: _glowAnimation.value,
                                          ),
                                          blurRadius: 12,
                                        ),
                                        Shadow(
                                          color: color.withValues(alpha: 0.6),
                                          blurRadius: 6,
                                        ),
                                      ]
                                    : <Shadow>[
                                        Shadow(
                                          color: color.withValues(alpha: 0.5),
                                          blurRadius: 4,
                                        ),
                                      ],
                              ),
                  );
                },
              ),
            ),
            if (isActive || isHovered)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    shadows: <Shadow>[
                      Shadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
