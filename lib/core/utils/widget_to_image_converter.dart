import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Utility class to convert Flutter widgets to image data for Mapbox symbols
class WidgetToImageConverter {
  /// Converts a Flutter widget to Uint8List image data
  ///
  /// This is essential for Mapbox integration as native maps cannot render
  /// Flutter widgets directly. The widget is rendered to an image buffer
  /// and returned as bytes suitable for Mapbox symbol images.
  static Future<Uint8List> widgetToImage({
    required Widget widget,
    double pixelRatio = 3.0,
    Size? size,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      // Create a RepaintBoundary to capture the widget
      final RepaintBoundary repaintBoundary = RepaintBoundary(
        child: ColoredBox(
          color: Colors.transparent,
          child: widget,
        ),
      );

      // Create a temporary widget tree for rendering
      final RenderRepaintBoundary renderRepaintBoundary = RenderRepaintBoundary();

      // Create the widget binding and render tree
      final PipelineOwner pipelineOwner = PipelineOwner();
      final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());

      final RenderObjectToWidgetElement<RenderBox> rootElement = RenderObjectToWidgetAdapter<RenderBox>(
        container: renderRepaintBoundary,
        child: repaintBoundary,
      ).createElement();

      // Build the widget tree
      buildOwner.buildScope(rootElement);

      // Set up rendering pipeline
      pipelineOwner.rootNode = renderRepaintBoundary;
      rootElement.mount(null, null);

      // Determine size - use provided size or let widget determine
      final ui.Size resolvedSize = size ?? const Size(40, 40);

      // Layout the render tree
      renderRepaintBoundary.layout(BoxConstraints.tight(resolvedSize));

      // Force a frame to ensure everything is rendered
      pipelineOwner.flushLayout();
      pipelineOwner.flushCompositingBits();
      pipelineOwner.flushPaint();

      // Capture the image
      final ui.Image image = await renderRepaintBoundary.toImage(pixelRatio: pixelRatio);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      // Clean up
      rootElement.unmount();
      image.dispose();

      return byteData!.buffer.asUint8List();
    } catch (e) {
      throw WidgetConversionException('Failed to convert widget to image: $e');
    }
  }

  /// Simplified method specifically for PresenceMarker widgets
  static Future<Uint8List> presenceMarkerToImage({
    required Widget presenceMarker,
    double pixelRatio = 3.0,
  }) async {
    return widgetToImage(
      widget: presenceMarker,
      pixelRatio: pixelRatio,
      size: const Size(40, 40), // Standard marker size
    );
  }

  /// Batch convert multiple widgets for performance
  static Future<List<Uint8List>> batchConvertWidgets({
    required List<Widget> widgets,
    double pixelRatio = 3.0,
    Size? size,
  }) async {
    final List<Uint8List> images = <Uint8List>[];

    for (final Widget widget in widgets) {
      final Uint8List imageData = await widgetToImage(
        widget: widget,
        pixelRatio: pixelRatio,
        size: size,
      );
      images.add(imageData);
    }

    return images;
  }
}

/// Custom exception for widget conversion errors
class WidgetConversionException implements Exception {

  const WidgetConversionException(this.message);
  final String message;

  @override
  String toString() => 'WidgetConversionException: $message';
}
