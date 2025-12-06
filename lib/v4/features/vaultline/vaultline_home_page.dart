import 'package:flutter/material.dart';

import '../../core/v4_dependencies.dart';

class VaultlineHomePage extends StatelessWidget {
  const VaultlineHomePage({super.key});

  static const List<Map<String, String>> _categories = <Map<String, String>>[
    <String, String>{'name': 'Local Trade', 'members': '213 online'},
    <String, String>{'name': 'Kink / Fetish', 'members': '154 online'},
    <String, String>{'name': 'Travel + Visitors', 'members': '78 online'},
    <String, String>{'name': 'Wellness / Care', 'members': '64 online'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSPalette.surfaceDark,
      appBar: AppBar(
        title: const Text('VAULTLINE'),
        backgroundColor: NVSPalette.surfaceDark,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, String> category = _categories[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: NVSPalette.surfaceDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: NVSPalette.mediumGray),
            ),
            child: ListTile(
              leading: const Icon(Icons.shield_moon, color: NVSPalette.neonLime),
              title: Text(category['name'] ?? ''),
              subtitle: Text(
                category['members'] ?? '',
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
