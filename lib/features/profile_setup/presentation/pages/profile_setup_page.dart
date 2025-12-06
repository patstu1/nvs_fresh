import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nvs/core/models/app_types.dart';
import 'package:nvs/core/theme/quantum_design_tokens.dart';
import '../../../../core/widgets/quantum_glow_engine.dart';
import '../../../../core/providers/quantum_providers.dart';

class ProfileSetupPage extends ConsumerWidget {
  const ProfileSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<dynamic> performanceMetrics = ref.watch(performanceMetricsProvider);
    final bool shouldEnableGlow = ref.watch(shouldEnableGlowEffectsProvider);
    final BioResponsiveThemeData? bioThemeData = ref.watch(bioResponsiveThemeProvider);

    return Scaffold(
      backgroundColor: QuantumDesignTokens.pureBlack,
      appBar: AppBar(
        title: const Text(
          'QUANTUM PROFILE SETUP',
          style: TextStyle(
            color: QuantumDesignTokens.neonMint,
            fontWeight: FontWeight.bold,
            fontFamily: QuantumDesignTokens.fontPrimary,
          ),
        ),
        backgroundColor: QuantumDesignTokens.pureBlack,
        elevation: 0,
        iconTheme: const IconThemeData(color: QuantumDesignTokens.neonMint),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.person_add,
                size: 64,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                'Complete Your Profile',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Add photos, bio, and preferences to help others discover you.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.secondaryTextColor,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Complete Setup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
