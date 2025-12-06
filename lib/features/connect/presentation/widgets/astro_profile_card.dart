import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

// An enum to define the elemental types for clarity
enum AstrologicalElement { fire, earth, air, water }

class AstroProfileCard extends StatelessWidget {
  const AstroProfileCard({
    required this.name,
    required this.sunSign,
    required this.moonSign,
    required this.risingSign,
    required this.element,
    super.key,
  });
  final String name;
  final String sunSign;
  final String moonSign;
  final String risingSign;
  final AstrologicalElement element;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // The Living Aura background
          CustomPaint(
            size: Size.infinite,
            painter: _AuraPainter(element: element),
          ),
          // The Data Dossier
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                name,
                style: const TextStyle(
                  color: NVSColors.secondaryText,
                  fontSize: 16,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 40),
              _buildSign('SUN', sunSign),
              _buildSign('MOON', moonSign),
              _buildSign('RISING', risingSign),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSign(String title, String sign) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: NVSColors.primaryNeonMint.withValues(alpha: 0.7),
              fontSize: 14,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sign,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.w100,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuraPainter extends CustomPainter {
  _AuraPainter({required this.element});
  final AstrologicalElement element;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Define colors for each element
    final Map<AstrologicalElement, List<Color>> elementColors = <AstrologicalElement, List<Color>>{
      AstrologicalElement.fire: <Color>[
        Colors.red.withValues(alpha: 0.3),
        Colors.orange.withValues(alpha: 0.1),
      ],
      AstrologicalElement.water: <Color>[
        NVSColors.primaryNeonMint.withValues(alpha: 0.3),
        Colors.blue.withValues(alpha: 0.1),
      ],
      AstrologicalElement.air: <Color>[
        Colors.yellow.withValues(alpha: 0.2),
        Colors.white.withValues(alpha: 0.1),
      ],
      AstrologicalElement.earth: <Color>[
        NVSColors.avocadoGreen.withValues(alpha: 0.3),
        Colors.brown.withValues(alpha: 0.2),
      ],
    };

    final List<Color> colors = elementColors[element]!;

    // We draw multiple circles with different radii and blur to create a soft, smoky effect
    final Paint paint1 = Paint()
      ..shader = RadialGradient(colors: colors)
          .createShader(Rect.fromCircle(center: center, radius: size.width * 0.6))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);

    final Paint paint2 = Paint()
      ..color = colors.last.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 120);

    canvas.drawCircle(center, size.width * 0.5, paint1);
    canvas.drawCircle(center, size.width * 0.6, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
