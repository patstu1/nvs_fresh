// packages/grid/lib/presentation/components/profile_info.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/theme/nvs_colors.dart';

/// Renders the text information overlay on the tile
/// Uses Bell Gothic Bold for names and Magda Clean Mono for status/distance
/// Implements breathing animation on name text and digital counter for distance
class ProfileInfo extends StatefulWidget {
  final String name;
  final String status;
  final int distance;
  final bool isEcho;

  const ProfileInfo({
    super.key,
    required this.name,
    required this.status,
    required this.distance,
    this.isEcho = false,
  });

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _counterController;
  late Animation<double> _breathingAnimation;
  late Animation<int> _counterAnimation;

  int _displayDistance = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _animateDistanceCounter();
  }

  void _setupAnimations() {
    // Breathing animation for name text
    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _breathingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut));

    // Start breathing animation if not echo
    if (!widget.isEcho) {
      _breathingController.repeat(reverse: true);
    }

    // Counter animation for distance
    _counterController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  void _animateDistanceCounter() {
    _counterAnimation = IntTween(
      begin: 0,
      end: widget.distance,
    ).animate(CurvedAnimation(parent: _counterController, curve: Curves.easeOut));

    _counterAnimation.addListener(() {
      setState(() {
        _displayDistance = _counterAnimation.value;
      });
    });

    // Start counter animation with delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _counterController.forward();
      }
    });
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _counterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            NVSColors.pureBlack.withOpacity(0.8),
            NVSColors.pureBlack.withOpacity(0.4),
            Colors.transparent,
          ],
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Name (no breathing effect on text per spec)
          Text(
            widget.name.toUpperCase(),
            style: _getNameStyle(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Status and distance row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status
              Text(widget.status.toUpperCase(), style: _getStatusStyle()),

              // Distance with counter animation
              Text('${_displayDistance}m', style: _getDistanceStyle()),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _getNameStyle() {
    return TextStyle(
      fontFamily: 'BellGothic', // Bell Gothic Bold
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: widget.isEcho ? NVSColors.secondaryText.withOpacity(0.6) : NVSColors.ultraLightMint,
      shadows: widget.isEcho
          ? null
          : [
              Shadow(
                color: NVSColors.primaryNeonMint.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
    );
  }

  TextStyle _getStatusStyle() {
    Color statusColor;
    switch (widget.status.toLowerCase()) {
      case 'online':
        statusColor = NVSColors.primaryNeonMint;
        break;
      case 'offline':
        statusColor = NVSColors.secondaryText;
        break;
      case 'echo':
        statusColor = NVSColors.secondaryText.withOpacity(0.6);
        break;
      default:
        statusColor = NVSColors.turquoiseNeon;
    }

    return TextStyle(
      fontFamily: 'MagdaCleanMono', // Magda Clean Mono
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: statusColor,
      letterSpacing: 0.5,
    );
  }

  TextStyle _getDistanceStyle() {
    return TextStyle(
      fontFamily: 'MagdaCleanMono', // Magda Clean Mono
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: widget.isEcho ? NVSColors.secondaryText.withOpacity(0.6) : NVSColors.secondaryText,
      letterSpacing: 0.5,
    );
  }
}
