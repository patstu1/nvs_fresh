import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

// Import our custom widgets here as we build them
// import 'package:nvs/features/connect/presentation/widgets/compatibility_gauge.dart';
// import 'package:nvs/features/connect/presentation/widgets/split_face_header.dart';

class DossierView extends StatelessWidget {
  const DossierView({required this.matchId, super.key});
  final String matchId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'INTEL BRIEFING',
          style: TextStyle(color: NVSColors.secondaryText, letterSpacing: 3),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Layer 1: The Header
            // TODO: Build SplitFaceHeader widget
            // This will contain the two avatars merged, surrounded by the glowing rings.
            Container(
              height: 200,
              color: NVSColors.dividerColor,
              child: const Center(
                child: Text(
                  'Split Face Header Placeholder',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Layer 2: The Core Compatibility Gauge
            // TODO: Build CompatibilityGauge widget
            Container(
              height: 150,
              color: NVSColors.dividerColor,
              child: const Center(
                child: Text(
                  '92.0% Gauge Placeholder',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Layer 3: Shared Interests / Tag Overlap
            const Text(
              'SHARED INTERESTS',
              style: TextStyle(
                color: NVSColors.secondaryText,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            // TODO: Build custom bar chart widget
            Container(
              height: 100,
              color: NVSColors.dividerColor,
              child: const Center(
                child: Text(
                  'Bar Chart Placeholder',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Layer 4: Call to Action
            // TODO: Build a custom, glowing button
            ElevatedButton(
              onPressed: () {},
              child: const Text('MESSAGE NOW'),
            ),
          ],
        ),
      ),
    );
  }
}
