import 'dart:async';
import 'package:flutter/material.dart'; // For Offset
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class GazeService {
  final StreamController<Offset> _gazeStreamController =
      StreamController.broadcast();
  Stream<Offset> get gazeStream => _gazeStreamController.stream;

  CameraController? _cameraController;
  Interpreter? _interpreter;
  bool _isProcessing = false;

  Future<void> init() async {
    // Initialize your TensorFlow Lite model from TinyTracker here.
    // Start the camera feed and the gaze detection inference loop.
    try {
      // Load the TinyTracker model
      _interpreter = await Interpreter.fromAsset(
        'assets/models/TinyTrackerS.tflite',
      );
      print("TinyTracker model loaded successfully");

      // Initialize camera
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      print("Camera initialized successfully");

      print("GazeService Initialized. Camera permission granted.");
    } catch (e) {
      print("Error initializing GazeService: $e");
    }
  }

  void startStreamingGazeData() {
    if (_cameraController == null || _interpreter == null) {
      print("Cannot start streaming - services not initialized");
      return;
    }

    // Start image stream from camera
    _cameraController!.startImageStream((CameraImage image) {
      if (!_isProcessing) {
        _isProcessing = true;
        _processFrame(image);
      }
    });

    print("Gaze data streaming started.");
  }

  Future<void> _processFrame(CameraImage cameraImage) async {
    try {
      // Convert camera image to format suitable for TensorFlow Lite
      final inputImage = _convertCameraImage(cameraImage);
      if (inputImage == null) return;

      // Resize to model input size (typically 224x224 for TinyTracker)
      final resizedImage = img.copyResize(inputImage, width: 224, height: 224);

      // Normalize pixel values to [0, 1]
      final input = _imageToFloatList(resizedImage);

      // Prepare output tensor - properly structured 2D list
      var output = List.generate(1, (_) => List.filled(2, 0.0));

      // Run inference
      _interpreter!.run([input], {0: output});

      // Extract gaze coordinates (normalized to [0, 1])
      final gazeX = output[0][0];
      final gazeY = output[0][1];

      // Convert to screen coordinates (assuming full screen)
      // You may need to adjust this based on your specific use case
      final screenGaze = Offset(gazeX, gazeY);

      // Add to stream
      _gazeStreamController.add(screenGaze);

      // Debug output
      print(
        "Gaze coordinates: (${gazeX.toStringAsFixed(3)}, ${gazeY.toStringAsFixed(3)})",
      );
    } catch (e) {
      print("Error processing frame: $e");
    } finally {
      _isProcessing = false;
    }
  }

  img.Image? _convertCameraImage(CameraImage cameraImage) {
    try {
      if (cameraImage.format.group == ImageFormatGroup.yuv420) {
        return _convertYUV420ToImage(cameraImage);
      } else if (cameraImage.format.group == ImageFormatGroup.bgra8888) {
        return _convertBGRA8888ToImage(cameraImage);
      }
    } catch (e) {
      print("Error converting camera image: $e");
    }
    return null;
  }

  img.Image _convertYUV420ToImage(CameraImage cameraImage) {
    final int width = cameraImage.width;
    final int height = cameraImage.height;

    final int yPlaneSize = width * height;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int yIndex = y * width + x;
        final int uvIndex = (y ~/ 2) * (width ~/ 2) + (x ~/ 2);

        final int yValue = cameraImage.planes[0].bytes[yIndex];
        final int uValue = cameraImage.planes[1].bytes[uvIndex * uvPixelStride];
        final int vValue = cameraImage.planes[2].bytes[uvIndex * uvPixelStride];

        // Convert YUV to RGB
        final int r = (yValue + 1.402 * (vValue - 128)).round().clamp(0, 255);
        final int g =
            (yValue - 0.344136 * (uValue - 128) - 0.714136 * (vValue - 128))
                .round()
                .clamp(0, 255);
        final int b = (yValue + 1.772 * (uValue - 128)).round().clamp(0, 255);

        image.setPixelRgb(x, y, r, g, b);
      }
    }

    return image;
  }

  img.Image _convertBGRA8888ToImage(CameraImage cameraImage) {
    final bytes = cameraImage.planes[0].bytes;
    return img.Image.fromBytes(
      width: cameraImage.width,
      height: cameraImage.height,
      bytes: bytes.buffer,
      format: img.Format.uint8,
    );
  }

  List<List<List<List<double>>>> _imageToFloatList(img.Image image) {
    final input = List.generate(
      1,
      (i) => List.generate(
        224,
        (j) => List.generate(224, (k) => List.generate(3, (l) => 0.0)),
      ),
    );

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = image.getPixel(x, y);
        input[0][y][x][0] = pixel.r / 255.0; // Red
        input[0][y][x][1] = pixel.g / 255.0; // Green
        input[0][y][x][2] = pixel.b / 255.0; // Blue
      }
    }

    return input;
  }

  void dispose() {
    _cameraController?.dispose();
    _interpreter?.close();
    _gazeStreamController.close();
  }
}
