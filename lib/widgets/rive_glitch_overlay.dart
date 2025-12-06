import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveGlitchOverlay extends StatelessWidget {
  const RiveGlitchOverlay({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        const RiveAnimation.asset(
          'assets/rive/glitch_overlay.riv',
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
