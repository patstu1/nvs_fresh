package com.nvs.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Register NVS custom bridges

        // Register biometric bridge for Health Connect + wearable integration
        flutterEngine.plugins.add(BiometricBridge())

        // Register haptic bridge for advanced vibration patterns
        flutterEngine.plugins.add(HapticBridge())
    }
}
