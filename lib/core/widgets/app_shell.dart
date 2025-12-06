// lib/core/widgets/app_shell.dart
import 'package:flutter/material.dart';
import 'nvs_bottom_navigation.dart';
import '../../features/messenger/presentation/universal_messenger_view.dart';

class AppShell extends StatefulWidget {
  const AppShell({required this.child, super.key});
  final Widget child;

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with SingleTickerProviderStateMixin {
  late AnimationController _messengerController;

  @override
  void initState() {
    super.initState();
    _messengerController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _messengerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        // Control the animation based on swipe delta
        // Only respond to right-to-left swipes from the right edge
        if (details.globalPosition.dx > MediaQuery.of(context).size.width * 0.9) {
          final double delta = -details.primaryDelta! / MediaQuery.of(context).size.width;
          _messengerController.value = (_messengerController.value + delta).clamp(0.0, 1.0);
        }
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        // Snap open or closed based on velocity and position
        if (_messengerController.value < 0.5) {
          _messengerController.reverse();
        } else {
          _messengerController.forward();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // The content of the current screen (MEATUP, NOW, etc.)
            widget.child,

            // The custom navigation bar floats above the content
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: NvsBottomNavigation(),
            ),

            // The Messenger View, animated off-screen by default
            AnimatedBuilder(
              animation: _messengerController,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: Offset(
                    MediaQuery.of(context).size.width * (1.0 - _messengerController.value),
                    0,
                  ),
                  child: child,
                );
              },
              child: const UniversalMessengerView(),
            ),
          ],
        ),
      ),
    );
  }
}
