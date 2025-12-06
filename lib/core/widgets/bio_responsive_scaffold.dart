import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/core/providers/quantum_providers.dart';
import 'package:nvs/core/theme/quantum_design_tokens.dart';
import 'package:nvs/meatup_core.dart';

class BioResponsiveScaffold extends ConsumerWidget {
  const BioResponsiveScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.extendBody = false,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool extendBody;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bioTheme = ref.watch(bioResponsiveThemeProvider);
    final Color baseColor = backgroundColor ?? NVSColors.pureBlack;
    final Color accentColor = bioTheme != null
        ? QuantumDesignTokens.getBioResponsiveColor(bioTheme.arousalLevel)
        : NVSColors.primaryLightMint;

    return Scaffold(
      appBar: appBar,
      backgroundColor: baseColor,
      extendBody: extendBody,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              baseColor,
              accentColor.withValues(alpha: 0.08),
            ],
          ),
        ),
        child: body,
      ),
    );
  }
}






