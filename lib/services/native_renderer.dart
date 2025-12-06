// packages/core/lib/services/native_renderer.dart
import 'dart:ffi';

// Define the function signatures from our C++ bridge.
typedef InitRendererNative = Void Function(Int64 viewId);
typedef InitRendererDart = void Function(int viewId);
typedef RenderFrameNative = Void Function();
typedef RenderFrameDart = void Function();

class NativeRenderer {
  late DynamicLibrary _library;
  late InitRendererDart _initRenderer;
  late RenderFrameDart _renderFrame;

  NativeRenderer() {
    _library = DynamicLibrary.process();

    final initRendererPtr = _library.lookup<NativeFunction<InitRendererNative>>(
      'initialize_renderer',
    );
    _initRenderer = initRendererPtr.asFunction<InitRendererDart>();

    final renderFramePtr = _library.lookup<NativeFunction<RenderFrameNative>>(
      'render_frame',
    );
    _renderFrame = renderFramePtr.asFunction<RenderFrameDart>();
  }

  void initialize(int viewId) => _initRenderer(viewId);
  void render() => _renderFrame();
}
