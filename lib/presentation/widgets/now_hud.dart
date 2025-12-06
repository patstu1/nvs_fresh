import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

// We add the new color to our palette. The color of a live signal.
// We can move this to NVSColors later.
const Color LIVE_SIGNAL_ORANGE = Color(0xFFFFA500);

class NowHud extends StatelessWidget {
  final VoidCallback onRecenter;
  final bool isBroadcasting;
  final ValueChanged<bool> onToggleBroadcast;
  final VoidCallback onOpenNexus; // The new button to open the main menu

  const NowHud({
    super.key,
    required this.onRecenter,
    required this.isBroadcasting,
    required this.onToggleBroadcast,
    required this.onOpenNexus,
  });

  @override
  Widget build(BuildContext context) {
    // We use a Stack to place our holographic nodes with precision.
    return Stack(
      children: [
        // Top-Right Node: The Nexus / Command Deck
        Positioned(
          top: 60,
          right: 20,
          child: _buildActionNode(
            icon: Icons.grid_view_sharp, // A sharp, architectural icon
            onTap: onOpenNexus,
          ),
        ),

        // Bottom-Left Node: The Recenter Button
        Positioned(
          bottom: 30,
          left: 20,
          child: _buildActionNode(icon: Icons.my_location, onTap: onRecenter),
        ),

        // Bottom-Right Node: The Broadcast Toggle
        Positioned(bottom: 30, right: 20, child: _buildBroadcastToggle()),
      ],
    );
  }

  // This is our new, sharp, holographic button style
  Widget _buildActionNode({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4), // Sharp, but not dangerously so
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: NVSColors.pureBlack.withOpacity(0.3),
              border: Border.all(
                color: NVSColors.dividerColor.withOpacity(0.5),
              ),
            ),
            child: Icon(icon, color: NVSColors.secondaryText, size: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildBroadcastToggle() {
    final Color activeColor = isBroadcasting
        ? LIVE_SIGNAL_ORANGE
        : NVSColors.secondaryText;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: InkWell(
          onTap: () => onToggleBroadcast(!isBroadcasting),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: NVSColors.pureBlack.withOpacity(0.3),
              border: Border.all(color: activeColor.withOpacity(0.5)),
              boxShadow: [
                // The glow is now the color of life
                BoxShadow(
                  color: activeColor,
                  blurRadius: isBroadcasting ? 12 : 0,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  isBroadcasting ? Icons.sensors : Icons.sensors_off,
                  color: activeColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  isBroadcasting ? "BROADCASTING" : "GHOST",
                  style: TextStyle(
                    color: activeColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
