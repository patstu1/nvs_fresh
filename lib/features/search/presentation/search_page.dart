import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      appBar: AppBar(
        title: const Text('Search', style: TextStyle(color: NVSColors.neonMint)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Search Screen - Your search implementation goes here',
          style: TextStyle(color: NVSColors.neonMint, fontSize: 18),
        ),
      ),
    );
  }
}
