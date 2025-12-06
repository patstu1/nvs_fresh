import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/glitch_onboarding_screen.dart';
import '../../../auth/presentation/genesis_scan_view.dart';

// Facetec keys via dart-define; when missing, we keep user on the scanner
const String _facetecProductionKey = String.fromEnvironment('FACETEC_PRODUCTION_KEY');
const String _facetecDeviceKeyId = String.fromEnvironment('FACETEC_DEVICE_KEY_IDENTIFIER');

class OnboardingEntryPage extends StatelessWidget {
  const OnboardingEntryPage({super.key});

  Future<void> _complete(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasOnboarded', true);
    if (context.mounted) {
      context.go('/now');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlitchOnboardingScreen(
      onFinished: () async {
        final bool hasKeys =
            _facetecProductionKey.trim().isNotEmpty && _facetecDeviceKeyId.trim().isNotEmpty;

        if (hasKeys) {
          // Launch FaceTec enrollment step; only proceed on success
          final Map<String, bool>? result = await Navigator.of(context).push<Map<String, bool>>(
            MaterialPageRoute<Map<String, bool>>(
              builder: (BuildContext ctx) => const GenesisScanView(isEnrollment: true),
            ),
          );

          final Map<String, bool> r = result ?? const <String, bool>{};
          final bool enrolled = (r['success'] ?? false) && (r['enrolled'] ?? false);
          if (enrolled) {
            await _complete(context);
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('face scan not completed')),
              );
            }
          }
          return;
        }

        // No keys yet: inform and keep user on the onboarding scanner screen
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('face scan keys missing')),
          );
        }
      },
    );
  }
}
