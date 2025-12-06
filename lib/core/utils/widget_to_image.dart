// lib/core/utils/widget_to_image.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

/// Utility class to handle widget-to-image conversion for map markers
/// This is the "black magic" that converts Flutter widgets to raw image data
/// for Mapbox integration in the NOW section
class WidgetToImageConverter {
  /// Captures a widget and converts it to raw image bytes
  /// This allows us to use custom Flutter widgets as map markers
  static Future<Uint8List> capture(Widget widget, BuildContext context) async {
    final ScreenshotController screenshotController = ScreenshotController();
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    // Wrap the widget in a clean scaffold to render it off-screen
    final Uint8List image = await screenshotController.captureFromWidget(
      MediaQuery(
        data: mediaQuery,
        child: Material(
          color: Colors.transparent,
          child: RepaintBoundary(child: widget),
        ),
      ),
      delay: const Duration(
        milliseconds: 200,
      ), // Allow time for animations/renders
      targetSize: const Size(120, 140), // Fixed size for consistent markers
      pixelRatio: 3.0, // High DPI for crisp markers
    );
    return image;
  }

  /// Captures multiple widgets in parallel for better performance
  static Future<List<Uint8List>> captureMultiple(
    List<Widget> widgets,
    BuildContext context,
  ) async {
    final Iterable<Future<Uint8List>> futures =
        widgets.map((Widget widget) => capture(widget, context));
    return Future.wait(futures);
  }
}
