import 'package:flutter/material.dart';

import '../navigation/v4_root_shell.dart';
import 'v4_dependencies.dart';

class V4AppShell extends StatelessWidget {
  const V4AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: QuantumTheme.quantumDark,
      home: const V4RootShell(),
    );
  }
}
