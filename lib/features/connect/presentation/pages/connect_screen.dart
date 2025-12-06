import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'package:fl_chart/fl_chart.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  Widget glowingRingAvatar(String imgPath, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: <Color>[
            NVSColors.primaryGlow.withValues(alpha: 0.8),
            NVSColors.avocadoGreen,
          ],
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: CircleAvatar(
        backgroundColor: NVSColors.cardBackground,
        radius: size / 2 - 4,
        child: Text(
          'A',
          style: TextStyle(
            color: NVSColors.primaryGlow,
            fontSize: size / 3,
            fontWeight: FontWeight.bold,
            fontFamily: 'MagdaCleanMono',
          ),
        ),
      ),
    );
  }

  Widget sharedDonut() {
    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          PieChart(
            PieChartData(
              sections: <dynamic>[
                PieChartSectionData(
                  color: NVSColors.primaryGlow,
                  value: 32,
                  showTitle: false,
                  radius: 24,
                ),
                PieChartSectionData(
                  color: NVSColors.avocadoGreen,
                  value: 28,
                  showTitle: false,
                  radius: 24,
                ),
                PieChartSectionData(
                  color: NVSColors.electricBlue,
                  value: 40,
                  showTitle: false,
                  radius: 24,
                ),
              ],
              centerSpaceRadius: 40,
              sectionsSpace: 4,
              startDegreeOffset: -90,
            ),
          ),
          const Text(
            '89.2%',
            style: TextStyle(
              color: NVSColors.primaryGlow,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'MagdaCleanMono',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: <Widget>[
              const Text(
                'AI Connection Analysis',
                style: TextStyle(
                  color: NVSColors.primaryGlow,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MagdaCleanMono',
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      glowingRingAvatar('', 70),
                      const SizedBox(height: 8),
                      const Text(
                        'You',
                        style: TextStyle(
                          color: NVSColors.ultraLightMint,
                          fontSize: 14,
                          fontFamily: 'MagdaCleanMono',
                        ),
                      ),
                    ],
                  ),
                  sharedDonut(),
                  Column(
                    children: <Widget>[
                      glowingRingAvatar('', 70),
                      const SizedBox(height: 8),
                      const Text(
                        'Match',
                        style: TextStyle(
                          color: NVSColors.ultraLightMint,
                          fontSize: 14,
                          fontFamily: 'MagdaCleanMono',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: NVSColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: NVSColors.primaryGlow.withValues(alpha: 0.6),
                    width: 2,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: NVSColors.primaryGlow.withValues(alpha: 0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Column(
                  children: <Widget>[
                    Text('♾️', style: TextStyle(fontSize: 48)),
                    SizedBox(height: 16),
                    Text(
                      'High Compatibility',
                      style: TextStyle(
                        color: NVSColors.primaryGlow,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MagdaCleanMono',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'AI analysis shows strong potential connection based on social data, interests, and interaction patterns.',
                      style: TextStyle(
                        color: NVSColors.ultraLightMint,
                        fontSize: 14,
                        fontFamily: 'MagdaCleanMono',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NVSColors.primaryGlow,
                    foregroundColor: NVSColors.pureBlack,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'CONNECT NOW',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'MagdaCleanMono',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
