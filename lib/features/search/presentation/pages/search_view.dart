import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class SearchViewWidget extends StatelessWidget {
  const SearchViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: NVSColors.cardBackground.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: NVSColors.ultraLightMint.withValues(alpha: 0.6),
                width: 2,
              ),
              boxShadow: NVSColors.mintGlow,
            ),
            child: const Column(
              children: <Widget>[
                Icon(
                  Icons.search,
                  color: NVSColors.ultraLightMint,
                  size: 64,
                ),
                SizedBox(height: 16),
                Text(
                  'search',
                  style: TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    color: NVSColors.ultraLightMint,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    shadows: NVSColors.mintTextShadow,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'discover new connections',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    color: NVSColors.secondaryText,
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
