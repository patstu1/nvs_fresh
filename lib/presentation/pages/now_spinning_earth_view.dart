import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../widgets/spinning_earth_widget.dart';

class NowSpinningEarthView extends StatelessWidget {
  const NowSpinningEarthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                'NOW',
                style: NvsTextStyles.display.copyWith(
                  fontSize: 32,
                  letterSpacing: 8,
                ),
              ),
            ),

            // Main content area with spinning earth
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive sizing based on available space
                  final maxSize = constraints.maxWidth * 0.6;
                  final earthSize = maxSize > 250 ? 200.0 : (maxSize - 50).toDouble();
                  
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Spinning Earth Widget
                            SpinningEarthWidget(
                              size: earthSize,
                              onTap: () {
                                // TODO: Implement zoom to user location
                                _showLocationMessage(context);
                              },
                            ),

                            SizedBox(height: constraints.maxHeight * 0.05),

                            // Location status text
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'CONNECTING TO YOUR LOCATION',
                                style: NvsTextStyles.body.copyWith(
                                  fontSize: 14,
                                  letterSpacing: 2,
                                  color: NVSColors.turquoiseNeon,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Subtitle
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Tap the earth to zoom in',
                                style: NvsTextStyles.body.copyWith(
                                  fontSize: 12,
                                  color: NVSColors.primaryNeonMint.withValues(alpha: 0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom hint text
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Real-time location mapping coming soon',
                style: NvsTextStyles.label.copyWith(
                  color: NVSColors.primaryNeonMint.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NVSColors.pureBlack,
        title: Text(
          'Location Feature',
          style: NvsTextStyles.heading.copyWith(color: NVSColors.turquoiseNeon),
        ),
        content: Text(
          'The zoom-to-location feature will be implemented next. This will connect to your real-time location and show nearby users.',
          style: NvsTextStyles.body.copyWith(color: NVSColors.primaryNeonMint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'GOT IT',
              style: NvsTextStyles.button.copyWith(
                color: NVSColors.turquoiseNeon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
