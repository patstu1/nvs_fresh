// lib/features/live/presentation/living_lens.dart

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LivingLens extends StatefulWidget {
  const LivingLens({super.key});
  @override
  _LivingLensState createState() => _LivingLensState();
}

class _LivingLensState extends State<LivingLens> {
  SMINumber? _lookX;
  SMINumber? _lookY;

  void _onRiveInit(Artboard artboard) {
    final StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'LookMachine');
    if (controller != null) {
      artboard.addController(controller);
      _lookX = controller.findInput<double>('lookX') as SMINumber?;
      _lookY = controller.findInput<double>('lookY') as SMINumber?;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        // Update the Rive state machine inputs based on touch position
        if (_lookX != null && context.size != null) {
          _lookX!.value =
              (details.localPosition.dx / context.size!.width) * 100;
        }
        if (_lookY != null && context.size != null) {
          _lookY!.value =
              (details.localPosition.dy / context.size!.height) * 100;
        }
      },
      child: RiveAnimation.asset(
        'assets/animations/living_lens.riv', // Your Rive file
        onInit: _onRiveInit,
        fit: BoxFit.contain,
      ),
    );
  }
}
