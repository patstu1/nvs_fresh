// lib/features/placeholder/placeholder_view.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart'; // The one true core import

class PlaceholderView extends StatelessWidget {
  const PlaceholderView({required this.pageName, super.key});
  final String pageName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We use our perfect, custom logo as the app bar title.
      appBar: AppBar(
        title: const NvsLogo(),
        backgroundColor: NVSColors.pureBlack,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          '$pageName\nComing Soon.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
