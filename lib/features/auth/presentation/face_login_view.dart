// lib/features/auth/presentation/face_login_view.dart

import 'package:flutter/material.dart';
import 'package:nvs/features/auth/presentation/genesis_scan_view.dart';

class FaceLoginView extends StatelessWidget {
  const FaceLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.black,
              Colors.cyan.withOpacity(0.1),
              Colors.purple.withOpacity(0.1),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Text(
                      'SECURE LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Face ID Icon
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.cyan, width: 3),
                          gradient: RadialGradient(
                            colors: <Color>[
                              Colors.cyan.withOpacity(0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.face_retouching_natural,
                          size: 80,
                          color: Colors.cyan,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Title
                      const Text(
                        'GENESIS AUTHENTICATION',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Subtitle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Military-grade biometric security.\nYour face is your password.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Face Scan Button
                      Container(
                        width: 250,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: <Color>[Colors.cyan, Colors.blue],
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.cyan.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => _startFaceScan(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: const Icon(
                            Icons.face_retouching_natural,
                            color: Colors.white,
                            size: 24,
                          ),
                          label: const Text(
                            'SCAN TO LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Alternative login option
                      TextButton(
                        onPressed: () {
                          // Navigate to traditional login
                        },
                        child: Text(
                          'Use traditional login instead',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Security info footer
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[700]!),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.security,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your biometric data is encrypted and processed locally. NVS never stores or transmits facial images.',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startFaceScan(BuildContext context) async {
    try {
      final Map<String, dynamic>? result =
          await Navigator.of(context).push<Map<String, dynamic>>(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              const GenesisScanView(isEnrollment: false),
        ),
      );

      if (result != null && result['success'] == true) {
        if (result['authenticated'] == true) {
          // Navigate to main app
          Navigator.of(context).pushReplacementNamed('/main');
        } else {
          // Show authentication failed message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Authentication failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
