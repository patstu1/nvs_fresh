import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/theme/nvs_colors.dart';

class PremiumTile extends StatefulWidget {
  const PremiumTile({required this.child, this.onTap, super.key});
  final Widget child;
  final VoidCallback? onTap;

  @override
  State<PremiumTile> createState() => _PremiumTileState();
}

class _PremiumTileState extends State<PremiumTile> with SingleTickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breath;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      duration: const Duration(milliseconds: 3800),
      vsync: this,
    )..repeat(reverse: true);
    _breath = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _breath,
        builder: (BuildContext context, Widget? child) {
          final double t = _breath.value;
          final double borderWidth = 2.2 + t * 0.8 + (_pressed ? 0.6 : 0.0);
          final List<BoxShadow> glow = [
            BoxShadow(
              color: NVSColors.primaryLightMint.withValues(alpha: 0.55),
              blurRadius: 12 + 8 * t,
              spreadRadius: 2 + 1.5 * t,
            ),
            BoxShadow(
              color: NVSColors.primaryNeonMint.withValues(alpha: 0.18),
              blurRadius: 20 + 10 * t,
              spreadRadius: 2 + 1 * t,
            ),
          ];

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: NVSColors.primaryLightMint,
                width: borderWidth,
              ),
              boxShadow: glow,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  NVSColors.cardBackground,
                  NVSColors.cardBackground.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}



