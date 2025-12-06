import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class NvsLogo extends StatelessWidget {
  const NvsLogo({super.key, this.size = 40, this.letterSpacing = 12, this.showGlow = true});

  final double size;
  final double letterSpacing;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    final Text text = Text(
      'NVS',
      textScaleFactor: 1,
      style: TextStyle(
        fontFamily: 'BellGothic',
        fontSize: size,
        height: 1,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w900,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size * 0.14
          ..color = Colors.black.withOpacity(.9),
      ),
    );

    final Text fill = Text(
      'NVS',
      textScaleFactor: 1,
      style: TextStyle(
        fontFamily: 'BellGothic',
        fontSize: size,
        height: 1,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
    );

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        if (showGlow) ...<Widget>[
          Text(
            'NVS',
            textScaleFactor: 1,
            style: TextStyle(
              fontFamily: 'BellGothic',
              fontSize: size,
              height: 1,
              letterSpacing: letterSpacing,
              fontWeight: FontWeight.w900,
              foreground: Paint()
                ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 3)
                ..style = PaintingStyle.stroke
                ..strokeWidth = size * 0.12
                ..color = Colors.black.withOpacity(.65),
            ),
          ),
          Text(
            'NVS',
            textScaleFactor: 1,
            style: TextStyle(
              fontFamily: 'BellGothic',
              fontSize: size,
              height: 1,
              letterSpacing: letterSpacing,
              fontWeight: FontWeight.w900,
              color: Colors.white.withOpacity(.85),
            ),
          ),
        ],
        text,
        fill,
      ],
    );
  }
}
