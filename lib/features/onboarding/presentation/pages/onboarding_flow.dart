import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nvs/features/onboarding/presentation/pages/onboarding_screen.dart';

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  void _handleOnboardingComplete() {
    context.go('/main');
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(onComplete: _handleOnboardingComplete);
  }
}
