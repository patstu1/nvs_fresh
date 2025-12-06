
// lib/features/profile_setup/presentation/pages/profile_setup_start.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/profile_setup_controller.dart';
import 'profile_info_form.dart';

class ProfileSetupStart extends ConsumerStatefulWidget {
  const ProfileSetupStart({super.key});

  @override
  ConsumerState<ProfileSetupStart> createState() => _ProfileSetupStartState();
}

class _ProfileSetupStartState extends ConsumerState<ProfileSetupStart> {
  final TextEditingController _nameController = TextEditingController();

  void _next() {
    final String name = _nameController.text.trim();
    if (name.isNotEmpty) {
      ref.read(profileSetupProvider.notifier).update(displayName: name);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileInfoForm()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Welcome',
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: 'MagdaCleanMono',
                  color: Color(0xFFB2FFD6),
                ),),
            const SizedBox(height: 20),
            const Text('Let’s create your NVS identity.',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'TradeGothic',
                    color: Colors.white70,),),
            const SizedBox(height: 60),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              cursorColor: const Color(0xFFB2FFD6),
              decoration: InputDecoration(
                hintText: 'Enter display name',
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _next(),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCCFF33),
                  foregroundColor: Colors.black,
                ),
                child: const Text('Let’s Go'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
