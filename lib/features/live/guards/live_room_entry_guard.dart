// lib/features/live/presentation/widgets/live_room_entry_guard.dart

import 'package:flutter/material.dart';

class LiveRoomEntryGuard extends StatefulWidget {
  const LiveRoomEntryGuard({
    required this.requiredPin,
    required this.onAccessGranted,
    super.key,
  });
  final String requiredPin;
  final VoidCallback onAccessGranted;

  @override
  State<LiveRoomEntryGuard> createState() => _LiveRoomEntryGuardState();
}

class _LiveRoomEntryGuardState extends State<LiveRoomEntryGuard> {
  final TextEditingController _pinController = TextEditingController();
  String? _error;

  void _checkPin() {
    if (_pinController.text.trim() == widget.requiredPin) {
      widget.onAccessGranted();
    } else {
      setState(() {
        _error = 'Wrong PIN';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.95),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Room Locked',
              style: TextStyle(
                color: Color(0xFFB2FFD6),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter PIN',
                hintStyle: const TextStyle(color: Colors.white24),
                errorText: _error,
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _checkPin(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCCFF33),
                foregroundColor: Colors.black,
              ),
              onPressed: _checkPin,
              child: const Text('Enter'),
            ),
          ],
        ),
      ),
    );
  }
}
