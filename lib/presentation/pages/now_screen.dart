import 'package:flutter/material.dart';
import 'now_main_view.dart';

class NowScreen extends StatelessWidget {
  const NowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Now', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
      ),
      body: const NowViewWidget(),
    );
  }
}
