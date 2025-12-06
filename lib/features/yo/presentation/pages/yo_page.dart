import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/core/theme/nvs_colors.dart';

class YoPage extends ConsumerWidget {
  const YoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      appBar: AppBar(
        title: const Text(
          'YO',
          style: TextStyle(
            color: NVSColors.ultraLightMint,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: NVSColors.pureBlack,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.favorite,
              size: 64,
              color: NVSColors.ultraLightMint,
            ),
            SizedBox(height: 16),
            Text(
              'YO',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: NVSColors.ultraLightMint,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Send a YO to someone special',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
