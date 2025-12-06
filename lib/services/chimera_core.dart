// packages/core/lib/services/chimera_core.dart
import 'package:nvs/services/gaze_service.dart';
import 'package:nvs/services/haptic_service.dart';
import 'package:nvs/services/audio_service.dart'; // Import the audio service

class ChimeraCore {
  static final ChimeraCore _instance = ChimeraCore._internal();
  factory ChimeraCore() => _instance;
  ChimeraCore._internal();

  final GazeService gaze = GazeService();
  final HapticService haptics = HapticService();
  final AudioService audio =
      AudioService(); // Add the missing audio service instance

  Future<void> initialize() async {
    print("ChimeraCore waking up...");
    await haptics.init();
    await gaze.init();
    await audio.init(); // Initialize the audio service
    gaze.startStreamingGazeData();
    print("ChimeraCore is now fully operational. The machine is alive.");
  }
}
