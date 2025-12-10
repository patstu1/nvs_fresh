import 'package:flutter/material.dart';

/// NVS mint (extra light, ultra light neon mint)
const Color nvsMint = Color(0xFFE2FFF4);

/// App-wide breathing animation duration
const Duration nvsBreathDuration = Duration(milliseconds: 3600);

/// Berlin Beachouse Radio stream
const String berlinBeachouseUrl =
    'https://stream.berlinbeachouse.radio/stream'; // replace with your final stream

/// LiveKit endpoints via --dart-define
const String liveKitWssUrl =
    String.fromEnvironment('LIVEKIT_URL', defaultValue: 'wss://your-livekit.example.com');
const String tokenEndpoint = String.fromEnvironment('LIVEKIT_TOKEN_ENDPOINT',
    defaultValue: 'https://api.yourdomain.com/v1/livekit/token',);

