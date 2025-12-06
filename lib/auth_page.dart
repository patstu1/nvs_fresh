import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth Page')),
      body: const Center(child: Text('AuthPage placeholder — wire actual login here')),
    );
  }
}
