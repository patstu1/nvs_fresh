import 'package:flutter/material.dart';
// Fixed invalid external import; use a simple Scaffold only in this module

class GridScreenMain extends StatelessWidget {
  const GridScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('GRID', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
      ),
      body: const Center(child: Text('Grid package screen')), // Keep package self-contained
    );
  }
}
