import 'package:flutter/material.dart';

import '../../core/v4_dependencies.dart';

class TradeblockHomePage extends StatelessWidget {
  const TradeblockHomePage({super.key});

  static const List<Map<String, String>> _nearbyEvents = <Map<String, String>>[
    <String, String>{'name': 'Synthwave Exchange', 'distance': '0.4 mi'},
    <String, String>{'name': 'Mutual Aid Bazaar', 'distance': '1.2 mi'},
    <String, String>{'name': 'Afterhours Relay', 'distance': '2.1 mi'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSPalette.surfaceDark,
      appBar: AppBar(
        title: const Text('TRADEBLOCK'),
        backgroundColor: NVSPalette.surfaceDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            _HeroPanel(),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: NVSPalette.surfaceDark,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: NVSPalette.mediumGray),
                ),
                child: const Center(
                  child: Text(
                    'Neon globe / 3D map coming soon',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Nearby Events',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            ..._nearbyEvents.map((Map<String, String> event) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: NVSPalette.surfaceDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: NVSPalette.mediumGray),
                ),
                child: ListTile(
                  title: Text(event['name'] ?? ''),
                  subtitle: Text(
                    'Within ${(event['distance'])}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: NVSPalette.lightGray),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: <Color>[
            NVSPalette.neonLime.withValues(alpha: 0.2),
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
          Text(
            'NEON TRADE NETWORK',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(letterSpacing: 1.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Live clusters, barter signals, and encrypted commerce flows appear here. Plug into the Tradeblock to see who is moving product nearby.',
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
