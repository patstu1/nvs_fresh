import 'package:flutter/material.dart';

import '../../core/v4_dependencies.dart';

class ConnectHomePageV4 extends StatelessWidget {
  const ConnectHomePageV4({super.key});

  static const List<Map<String, String>> _modules = <Map<String, String>>[
    <String, String>{'title': 'Your AI Twin', 'detail': 'Calibration synced 2h ago'},
    <String, String>{'title': 'Today\'s compatibility scan', 'detail': '6 signals above 92%'},
    <String, String>{'title': 'Recent matches', 'detail': '3 new intros pending'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSPalette.surfaceDark,
      appBar: AppBar(
        title: const Text('CONNECT'),
        backgroundColor: NVSPalette.surfaceDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _HologramPanel(),
            const SizedBox(height: 20),
            ..._modules.map(
              (Map<String, String> module) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: NVSPalette.surfaceDark,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: NVSPalette.mediumGray),
                ),
                child: ListTile(
                  leading: const Icon(Icons.auto_awesome, color: NVSPalette.neonLime),
                  title: Text(module['title'] ?? ''),
                  subtitle: Text(
                    module['detail'] ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: NVSPalette.lightGray),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HologramPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: <Color>[
            NVSPalette.neonLime.withValues(alpha: 0.3),
            NVSPalette.surfaceDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: NVSPalette.mediumGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      NVSPalette.neonLime,
                      NVSPalette.surfaceDark,
                    ],
                  ),
                ),
                child: const Icon(Icons.face_retouching_natural, size: 48),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'AI HOLOGRAM LINK',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(letterSpacing: 1.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Run scans, share presence data, and let your AI twin broker the next meaningful connection. Full automation hooks arrive in Phase C.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: NVSPalette.lightGray),
          ),
        ],
      ),
    );
  }
}
