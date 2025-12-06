import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../../../../core/theme/nvs_colors.dart' show NVSFonts;

class SearchViewWidget extends StatelessWidget {
  const SearchViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: NVSColors.pureBlack,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'search',
                style: TextStyle(
                  fontFamily: NVSFonts.secondary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: NVSColors.ultraLightMint,
                  shadows: NVSColors.mintTextShadow,
                ),
              ),
              const SizedBox(height: 20),

              // Search bar
              DecoratedBox(
                decoration: BoxDecoration(
                  color: NVSColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: NVSColors.dividerColor),
                ),
                child: const TextField(
                  style: TextStyle(fontFamily: NVSFonts.secondary, color: NVSColors.ultraLightMint),
                  decoration: InputDecoration(
                    hintText: 'search for connections…',
                    hintStyle: TextStyle(
                      fontFamily: NVSFonts.secondary,
                      color: NVSColors.secondaryText,
                    ),
                    prefixIcon: Icon(Icons.search, color: NVSColors.turquoiseNeon),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.search, size: 80, color: NVSColors.secondaryText),
                      SizedBox(height: 20),
                      Text(
                        'discovery and filters',
                        style: TextStyle(
                          fontFamily: NVSFonts.secondary,
                          fontSize: 18,
                          color: NVSColors.ultraLightMint,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "find exactly what you're looking for",
                        style: TextStyle(
                          fontFamily: NVSFonts.secondary,
                          fontSize: 14,
                          color: NVSColors.secondaryText,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
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
