import 'package:flutter/services.dart';

class AudioService {
  bool _isInitialized = false;

  Future<void> init() async {
    _isInitialized = true;
    print("AudioService Initialized. Ready to play sounds.");
  }

  Future<void> playSound(String soundFile) async {
    if (!_isInitialized) {
      print("AudioService not initialized!");
      return;
    }

    try {
      // Use system sound for now - can be upgraded later with audioplayers
      await SystemSound.play(SystemSoundType.click);
      print("AUDIO PLAY: $soundFile (using system sound)");
    } catch (e) {
      print("Error playing sound $soundFile: $e");
    }
  }

  Future<void> playYoSound() async {
    await playSound('yo-sound.mp3');
  }

  void dispose() {
    // No cleanup needed for system sounds
  }
}
