import 'dart:ui' as ui;

/// Centralized loader for fragment shaders to avoid hardcoded asset paths.
class ShaderLoader {
  // Load compiled shader assets from the same path as declared under flutter: shaders:
  static const String _root = 'assets/shaders/';

  static Future<ui.FragmentProgram> load(String fileName) async {
    final String assetPath = '$_root$fileName';
    return ui.FragmentProgram.fromAsset(assetPath);
  }
}
