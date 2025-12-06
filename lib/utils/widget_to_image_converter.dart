// packages/core/lib/utils/widget_to_image_converter.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

class WidgetToImageConverter {
  static Future<Uint8List> capture(Widget widget, BuildContext context) async {
    final controller = ScreenshotController();
    // We must wrap the widget in a MaterialApp to provide context
    final image = await controller.captureFromWidget(
      MaterialApp(
        home: Scaffold(body: widget),
        debugShowCheckedModeBanner: false,
      ),
      delay: const Duration(milliseconds: 50), // Allow time for render
    );
    return image;
  }
}
