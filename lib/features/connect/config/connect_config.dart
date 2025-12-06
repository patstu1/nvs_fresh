// Connect feature configuration

enum MatchScope { regionOnly, worldwide }

class ConnectConfig {
  // Voice output: true = on-device TTS, false = pre-recorded/remote
  static const bool useOnDeviceTts = true;

  // Default discovery scope for matches
  static const MatchScope defaultMatchScope = MatchScope.worldwide;
}
