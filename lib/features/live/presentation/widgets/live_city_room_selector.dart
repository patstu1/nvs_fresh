// lib/features/live/presentation/pages/live_city_room_selector.dart

import 'package:flutter/material.dart';
import 'live_room_view.dart';

class LiveCityRoomSelector extends StatelessWidget {
  const LiveCityRoomSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> cities = <Map<String, String>>[
      <String, String>{'emoji': '🗽', 'name': 'NYC'},
      <String, String>{'emoji': '🪩', 'name': 'Berlin'},
      <String, String>{'emoji': '🌴', 'name': 'Los Angeles'},
      <String, String>{'emoji': '🐉', 'name': 'Tokyo'},
      <String, String>{'emoji': '🔥', 'name': 'Mexico City'},
    ];

    final List<String> demoAvatars = <String>[
      'assets/avatars/axel.png',
      'assets/avatars/dante.png',
      'assets/avatars/luca.png',
      'assets/avatars/kai.png',
      'assets/avatars/anon.png',
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Explore Global Rooms',
          style: TextStyle(color: Color(0xFFB2FFD6), fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        itemCount: cities.length,
        separatorBuilder: (_, __) => const Divider(color: Colors.white10),
        itemBuilder: (BuildContext context, int index) {
          final Map<String, String> city = cities[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            leading: Text(city['emoji']!, style: const TextStyle(fontSize: 26)),
            title: Text(
              city['name']!,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LiveRoomView(
                    roomTitle: city['name']!,
                    userAvatars: demoAvatars,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
