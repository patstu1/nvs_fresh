import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nvs/theme/nvs_colors.dart';

class NeonMarkerFactory {
  static BitmapDescriptor? _single;
  static final Map<int, BitmapDescriptor> _clusterCache = <int, BitmapDescriptor>{};

  static BitmapDescriptor single() => _single ??= BitmapDescriptor.fromBytes(_paintSingle());
  static BitmapDescriptor cluster(int count) =>
      _clusterCache[count] ??= BitmapDescriptor.fromBytes(_paintCluster(count));

  static List<int> _paintSingle({double size = 56}) {
    final ui.PictureRecorder rec = ui.PictureRecorder();
    final Canvas c = Canvas(rec, Rect.fromLTWH(0, 0, size, size));
    final Offset o = Offset(size / 2, size / 2);

    final Paint outer = Paint()
      ..color = nvsCyan.withOpacity(.25)
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 18);
    final Paint inner = Paint()
      ..color = nvsMint.withOpacity(.85)
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 6);
    final Paint core = Paint()..color = nvsPrimary;

    c.drawCircle(o, size * 0.38, outer);
    c.drawCircle(o, size * 0.22, inner);
    c.drawCircle(o, size * 0.08, core);

    final ui.Image img = rec.endRecording().toImageSync(size.toInt(), size.toInt());
    return _imageBytes(img);
  }

  static List<int> _paintCluster(int count, {double size = 72}) {
    final ui.PictureRecorder rec = ui.PictureRecorder();
    final Canvas c = Canvas(rec, Rect.fromLTWH(0, 0, size, size));
    final Offset o = Offset(size / 2, size / 2);

    final Paint glow = Paint()
      ..color = nvsCyan.withOpacity(.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 18);
    c.drawCircle(o, size * 0.34, glow);

    final Paint ring = Paint()
      ..color = nvsMint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    c.drawCircle(o, size * 0.34, ring);

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '$count',
        style: TextStyle(
          fontFamily: 'MagdaCleanMono',
          fontWeight: FontWeight.w900,
          fontSize: size * 0.32,
          color: nvsPrimary,
          shadows: <Shadow>[Shadow(color: nvsMint.withOpacity(.7), blurRadius: 10)],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(c, o - Offset(textPainter.width / 2, textPainter.height / 2));

    final ui.Image img = rec.endRecording().toImageSync(size.toInt(), size.toInt());
    return _imageBytes(img);
  }

  static List<int> _imageBytes(ui.Image image) {
    final ByteData? data = image.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List() ?? Uint8List(0);
  }
}
