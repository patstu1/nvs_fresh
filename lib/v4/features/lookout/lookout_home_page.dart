import 'package:flutter/material.dart';

import '../../core/v4_dependencies.dart';

class LookoutHomePage extends StatelessWidget {
  const LookoutHomePage({super.key});

  static const List<Map<String, String>> _globalRooms = <Map<String, String>>[
    <String, String>{'name': 'Skybridge HQ', 'count': '128 live'},
    <String, String>{'name': 'Transmitter Alley', 'count': '54 live'},
    <String, String>{'name': 'Coven Room', 'count': '33 live'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSPalette.surfaceDark,
      appBar: AppBar(
        title: const Text('LOOKOUT LIVE'),
        backgroundColor: NVSPalette.surfaceDark,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _PersonalRoomCard(),
          const SizedBox(height: 16),
          Text(
            'Global Rooms',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ..._globalRooms.map(
            (Map<String, String> room) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: NVSPalette.surfaceDark,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: NVSPalette.mediumGray),
              ),
              child: ListTile(
                leading: const Icon(Icons.wifi_tethering, color: NVSPalette.neonLime),
                title: Text(room['name'] ?? ''),
                subtitle: Text(
                  room['count'] ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: NVSPalette.lightGray),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonalRoomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: NVSPalette.surfaceDark,
        border: Border.all(color: NVSPalette.mediumGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Your Personal Room',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Spin up a LiveKit session, invite your vaultline, and track biometrics in real time. This panel will host the session control soon.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: NVSPalette.lightGray),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('PREP ROOM'),
          ),
        ],
      ),
    );
  }
}
