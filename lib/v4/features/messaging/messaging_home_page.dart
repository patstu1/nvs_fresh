import 'package:flutter/material.dart';

import '../../core/v4_dependencies.dart';

class MessagingHomePage extends StatelessWidget {
  const MessagingHomePage({super.key});

  static const List<Map<String, String>> _threads = <Map<String, String>>[
    <String, String>{'name': 'Nova (Vaultline)', 'snippet': 'Ping me once you\'re inside.'},
    <String, String>{'name': 'Trade Net', 'snippet': 'Drop location and we\'ll deploy.'},
    <String, String>{'name': 'Vault Council', 'snippet': 'Briefing uploaded to vault.'},
    <String, String>{'name': 'Holo Concierge', 'snippet': 'Your AI twin synced new matches.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSPalette.surfaceDark,
      appBar: AppBar(
        title: const Text('MESSAGES'),
        backgroundColor: NVSPalette.surfaceDark,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _threads.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (BuildContext context, int index) {
          final Map<String, String> thread = _threads[index];
          return Container(
            decoration: BoxDecoration(
              color: NVSPalette.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: NVSPalette.mediumGray),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: NVSPalette.chromeGray,
                child: Text(
                  (thread['name'] ?? 'N')[0],
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: NVSPalette.mint),
                ),
              ),
              title: Text(thread['name'] ?? ''),
              subtitle: Text(
                thread['snippet'] ?? '',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: NVSPalette.lightGray),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ),
          );
        },
      ),
    );
  }
}
