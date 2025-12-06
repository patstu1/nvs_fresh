// package:nvs/widgets/nvs_layout.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class NVSLayout extends StatelessWidget {
  const NVSLayout({
    required this.title,
    required this.child,
    super.key,
    this.actions,
    this.padding = const EdgeInsets.fromLTRB(28, 60, 28, 30),
    this.showBackButton = true,
    this.onBackPressed,
  });
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final EdgeInsetsGeometry padding;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: <Widget>[
                if (showBackButton && Navigator.canPop(context))
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: NVSColors.avocadoGreen,
                      size: 20,
                    ),
                    onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                  ),
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 400),
                    style: const TextStyle(
                      fontFamily: 'MagdaClean',
                      fontSize: 22,
                      color: NVSColors.ultraLightMint,
                      letterSpacing: 0.8,
                      shadows: NVSColors.mintTextShadow,
                    ),
                    child: Text(
                      title,
                      textAlign: showBackButton && Navigator.canPop(context)
                          ? TextAlign.left
                          : TextAlign.center,
                    ),
                  ),
                ),
                if (actions != null) ...actions!,
              ],
            ),
          ),
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              NVSColors.pureBlack,
              NVSColors.cardBackground.withValues(alpha: 0.3),
              NVSColors.pureBlack,
            ],
            stops: const <double>[0.0, 0.5, 1.0],
          ),
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
