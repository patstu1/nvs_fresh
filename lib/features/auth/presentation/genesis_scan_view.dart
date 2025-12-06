// lib/features/auth/presentation/genesis_scan_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenesisScanView extends ConsumerStatefulWidget {
  // true for onboarding, false for login
  const GenesisScanView({required this.isEnrollment, super.key});
  final bool isEnrollment;

  @override
  ConsumerState<GenesisScanView> createState() => _GenesisScanViewState();
}

class _GenesisScanViewState extends ConsumerState<GenesisScanView> with TickerProviderStateMixin {
  static const MethodChannel platform = MethodChannel('nvs/facetec');
  bool _isScanning = false;

  late AnimationController _scanController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeFaceTec();
  }

  void _setupAnimations() {
    _scanController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _initializeFaceTec() async {
    try {
      await platform.invokeMethod('initialize', <String, String>{
        'productionKey': 'YOUR_FACETEC_PRODUCTION_KEY', // Replace with actual key
        'deviceKeyIdentifier': 'nvs_production_device_key',
      });
    } on PlatformException catch (e) {
      print('Failed to initialize FaceTec: ${e.message}');
    }
  }

  Future<void> _startScan() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
    });

    // Start scan animation
    _scanController.repeat();

    try {
      if (widget.isEnrollment) {
        // Launch the enrollment flow
        final result = await platform.invokeMethod('enrollment', <String, String>{
          'userIdentifier': 'user_${DateTime.now().millisecondsSinceEpoch}',
        });

        if (result['success'] == true) {
          // SUCCESS: The faceScan is the encrypted 3D data
          final String faceScanData = result['faceScan'] as String;
          final String auditTrailImage = result['auditTrailImage'] as String;

          // Send this to backend to store the Genesis Template
          await _storeGenesisTemplate(faceScanData, auditTrailImage);

          // Navigate to next onboarding step
          if (mounted) {
            Navigator.of(context).pop(<String, bool>{'success': true, 'enrolled': true});
          }
        } else {
          _handleScanFailure(
            result['message'] as String? ?? 'Enrollment failed',
          );
        }
      } else {
        // Launch the authentication flow
        final result = await platform.invokeMethod('authenticate', <String, String>{
          'userIdentifier': 'current_user', // Replace with actual user ID
        });

        if (result['success'] == true) {
          // SUCCESS: Send this new faceScan to backend for comparison
          final String faceScanData = result['faceScan'] as String;
          final bool isAuthenticated = await _verifyLoginScan(faceScanData);

          if (mounted) {
            Navigator.of(context).pop(<String, bool>{
              'success': true,
              'authenticated': isAuthenticated,
            });
          }
        } else {
          _handleScanFailure(
            result['message'] as String? ?? 'Authentication failed',
          );
        }
      }
    } on PlatformException catch (e) {
      _handleScanFailure(e.message ?? 'Scan failed');
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
        _scanController.stop();
        _scanController.reset();
      }
    }
  }

  Future<void> _storeGenesisTemplate(
    String faceScanData,
    String auditTrail,
  ) async {
    // TODO: Implement GraphQL mutation to store Genesis template
    print('Storing Genesis template: $faceScanData');
  }

  Future<bool> _verifyLoginScan(String faceScanData) async {
    // TODO: Implement GraphQL mutation to verify login scan
    print('Verifying login scan: $faceScanData');
    return true; // Placeholder
  }

  void _handleScanFailure(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scan failed: $message'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.black,
              Colors.cyan.withOpacity(0.1),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Genesis Logo/Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.cyan, width: 2),
                    gradient: RadialGradient(
                      colors: <Color>[
                        Colors.cyan.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.face_retouching_natural,
                    size: 60,
                    color: Colors.cyan,
                  ),
                ),

                const SizedBox(height: 40),

                // Title
                Text(
                  'GENESIS VERIFICATION',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                ),

                const SizedBox(height: 20),

                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    widget.isEnrollment
                        ? 'This scan creates your secure, private identity key.\nIt ensures you are real and protects your account.'
                        : 'Verify your identity to log in.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Scan Button
                Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
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
                  child: ElevatedButton(
                    onPressed: _isScanning ? null : _startScan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: _isScanning
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'BEGIN SCAN',
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

                // Security Notice
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
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
                          'Military-grade 3D facial geometry. Your data is encrypted and never stored as images.',
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
      ),
    );
  }
}
