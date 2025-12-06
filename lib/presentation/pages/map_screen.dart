// packages/now/lib/presentation/pages/map_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nvs/meatup_core.dart';
import '../widgets/metacity_view.dart';
import '../../services/map_websocket_service.dart';

/// MapScreen - Container for The Map experience
/// Handles authentication, permissions, and renders the MetacityView
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with WidgetsBindingObserver {
  bool _hasLocationPermission = false;
  bool _isCheckingPermissions = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeMap();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _handleAppResumed();
        break;
      case AppLifecycleState.paused:
        _handleAppPaused();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        _handleAppDetached();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  Future<void> _initializeMap() async {
    // Check authentication first
    final authService = ref.read(authServiceProvider);
    final isAuthenticated = await authService.isAuthenticated();

    if (!isAuthenticated) {
      _showAuthenticationRequired();
      return;
    }

    // Check location permissions
    await _checkLocationPermissions();

    if (_hasLocationPermission) {
      await _connectToMapService();
    }

    setState(() {
      _isCheckingPermissions = false;
      _isInitialized = true;
    });
  }

  Future<void> _checkLocationPermissions() async {
    try {
      final status = await Permission.location.status;

      if (status.isGranted) {
        setState(() => _hasLocationPermission = true);
        return;
      }

      if (status.isDenied) {
        final result = await Permission.location.request();
        setState(() => _hasLocationPermission = result.isGranted);
        return;
      }

      if (status.isPermanentlyDenied) {
        _showPermissionDeniedDialog();
        return;
      }
    } catch (e) {
      print('Error checking location permissions: $e');
      setState(() => _hasLocationPermission = false);
    }
  }

  Future<void> _connectToMapService() async {
    try {
      final authService = ref.read(authServiceProvider);
      final token = await authService.getAccessToken();

      final mapService = ref.read(mapWebSocketServiceProvider);
      await mapService.connect(authToken: token);
    } catch (e) {
      print('Error connecting to map service: $e');
      _showConnectionError();
    }
  }

  void _handleAppResumed() {
    if (_isInitialized && !_hasLocationPermission) {
      _checkLocationPermissions();
    }

    // Reconnect to map service if needed
    final connectionState = ref.read(mapConnectionStateProvider).value;
    if (connectionState == WebSocketConnectionState.disconnected) {
      _connectToMapService();
    }
  }

  void _handleAppPaused() {
    // Optionally pause location updates to save battery
  }

  void _handleAppDetached() {
    // Disconnect from map service
    final mapService = ref.read(mapWebSocketServiceProvider);
    mapService.disconnect();
  }

  void _showAuthenticationRequired() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AuthRequiredDialog(
        onSignIn: () {
          Navigator.pop(context);
          // Navigate to sign in
          // context.push('/auth/signin');
        },
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PermissionDeniedDialog(
        onOpenSettings: () async {
          Navigator.pop(context);
          await openAppSettings();
        },
        onContinueWithoutLocation: () {
          Navigator.pop(context);
          setState(() {
            _hasLocationPermission = false;
            _isInitialized = true;
          });
        },
      ),
    );
  }

  void _showConnectionError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Failed to connect to The Map. Check your connection.',
          style: NvsTextStyles.body.copyWith(color: Colors.white),
        ),
        backgroundColor: NVSColors.errorColor,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _connectToMapService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingPermissions) {
      return _buildLoadingScreen();
    }

    if (!_isInitialized) {
      return _buildErrorScreen();
    }

    return const MetacityView();
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: NVSColors.ultraLightMint,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'ENTERING THE MAP',
              style: NvsTextStyles.display.copyWith(
                fontSize: 24,
                color: NVSColors.ultraLightMint,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Initializing reality protocols...',
              style: NvsTextStyles.body.copyWith(
                color: NVSColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: NVSColors.errorColor),
              const SizedBox(height: 24),
              Text(
                'MAP UNAVAILABLE',
                style: NvsTextStyles.display.copyWith(
                  fontSize: 24,
                  color: NVSColors.errorColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Unable to initialize The Map. Please check your connection and permissions.',
                style: NvsTextStyles.body.copyWith(
                  color: NVSColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isCheckingPermissions = true;
                    _isInitialized = false;
                  });
                  _initializeMap();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: NVSColors.ultraLightMint.withOpacity(0.2),
                  foregroundColor: NVSColors.ultraLightMint,
                  side: BorderSide(color: NVSColors.ultraLightMint),
                ),
                child: Text(
                  'RETRY',
                  style: NvsTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dialog for authentication required
class _AuthRequiredDialog extends StatelessWidget {
  final VoidCallback onSignIn;

  const _AuthRequiredDialog({required this.onSignIn});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: NVSColors.cardBackground,
      title: Text(
        'Authentication Required',
        style: NvsTextStyles.heading.copyWith(color: NVSColors.ultraLightMint),
      ),
      content: Text(
        'You must be signed in to access The Map.',
        style: NvsTextStyles.body.copyWith(color: NVSColors.secondaryText),
      ),
      actions: [
        TextButton(
          onPressed: onSignIn,
          child: Text(
            'SIGN IN',
            style: NvsTextStyles.body.copyWith(
              color: NVSColors.ultraLightMint,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

/// Dialog for location permission denied
class _PermissionDeniedDialog extends StatelessWidget {
  final VoidCallback onOpenSettings;
  final VoidCallback onContinueWithoutLocation;

  const _PermissionDeniedDialog({
    required this.onOpenSettings,
    required this.onContinueWithoutLocation,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: NVSColors.cardBackground,
      title: Text(
        'Location Permission Required',
        style: NvsTextStyles.heading.copyWith(color: NVSColors.ultraLightMint),
      ),
      content: Text(
        'The Map requires location access to show nearby users and enable location-based features.',
        style: NvsTextStyles.body.copyWith(color: NVSColors.secondaryText),
      ),
      actions: [
        TextButton(
          onPressed: onContinueWithoutLocation,
          child: Text(
            'CONTINUE WITHOUT',
            style: NvsTextStyles.body.copyWith(color: NVSColors.secondaryText),
          ),
        ),
        TextButton(
          onPressed: onOpenSettings,
          child: Text(
            'OPEN SETTINGS',
            style: NvsTextStyles.body.copyWith(
              color: NVSColors.ultraLightMint,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}








