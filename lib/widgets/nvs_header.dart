import 'package:flutter/material.dart';
import '../theme/nvs_colors.dart';
import 'nvs_logo.dart';

class NvsHeader extends StatelessWidget {
  final String sectionLabel;
  final Alignment labelAlign;
  const NvsHeader({super.key, required this.sectionLabel, this.labelAlign = Alignment.topLeft});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: NvsLogo(size: 22, letterSpacing: 8),
          ),
        ),
        Align(
          alignment: labelAlign,
          child: Padding(
            padding: const EdgeInsets.only(top: 14, left: 14, right: 14),
            child: Text(
              sectionLabel.toUpperCase(),
              style: TextStyle(
                fontFamily: 'MagdaCleanMono',
                fontSize: 11,
                letterSpacing: 2,
                color: nvsPrimary.withOpacity(.85),
                shadows: <Shadow>[Shadow(color: nvsMint.withOpacity(.6), blurRadius: 8)],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
