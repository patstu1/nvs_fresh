import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import '../data/models/now_location.dart';

class NowService {
  static final NowService _instance = NowService._internal();
  factory NowService() => _instance;
  NowService._internal();

  final StreamController<List<NowLocation>> _locationsController =
      StreamController<List<NowLocation>>.broadcast();

  final List<NowLocation> _activeLocations = [];
  final Map<String, Timer> _expirationTimers = {};

  // Privacy and security settings
  bool _isIncognitoMode = false;
  bool _useAdvancedEncryption = true;
  bool _enableProxyRouting = true;
  bool _maskLocationData = true;

  // Stream for location updates
  Stream<List<NowLocation>> get locationsStream => _locationsController.stream;

  // Get current user location with privacy protection
  Future<Position?> getCurrentLocation({bool highAccuracy = true}) async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get location with privacy protection
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy:
            highAccuracy ? LocationAccuracy.high : LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );

      // Apply privacy masking if enabled
      if (_maskLocationData) {
        position = _maskLocationPosition(position);
      }

      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  // Mask location for privacy
  Position _maskLocationPosition(Position position) {
    // Add random noise to coordinates for privacy
    final random = Random();
    final latNoise = (random.nextDouble() - 0.5) * 0.001; // ~100m noise
    final lngNoise = (random.nextDouble() - 0.5) * 0.001;

    return Position(
      latitude: position.latitude + latNoise,
      longitude: position.longitude + lngNoise,
      timestamp: position.timestamp,
      accuracy: position.accuracy,
      altitude: position.altitude,
      heading: position.heading,
      speed: position.speed,
      speedAccuracy: position.speedAccuracy,
      altitudeAccuracy: position.altitudeAccuracy,
      headingAccuracy: position.headingAccuracy,
    );
  }

  // Create a new anonymous location
  Future<NowLocation?> createAnonymousLocation({
    double? latitude,
    double? longitude,
    LocationType type = LocationType.private,
    Duration? duration,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Get current location if not provided
      Position? position;
      if (latitude == null || longitude == null) {
        position = await getCurrentLocation();
        if (position == null) return null;
        latitude = position.latitude;
        longitude = position.longitude;
      }

      // Create anonymous location
      final location = NowLocation.createAnonymous(
        latitude: latitude,
        longitude: longitude,
        type: type,
        duration: duration,
      );

      // Add to active locations
      _activeLocations.add(location);
      _notifyLocationUpdate();

      // Set expiration timer if duration is specified
      if (duration != null) {
        _setExpirationTimer(location.id, duration);
      }

      return location;
    } catch (e) {
      print('Error creating anonymous location: $e');
      return null;
    }
  }

  // Create a private location with custom settings
  Future<NowLocation?> createPrivateLocation({
    required double latitude,
    required double longitude,
    String? customName,
    PrivacyLevel privacyLevel = PrivacyLevel.high,
    AnonymitySettings? anonymitySettings,
    Map<String, dynamic>? metadata,
    Duration? duration,
  }) async {
    try {
      final location = NowLocation.createPrivate(
        latitude: latitude,
        longitude: longitude,
        customName: customName,
        privacyLevel: privacyLevel,
        anonymitySettings: anonymitySettings,
        metadata: metadata,
        duration: duration,
      );

      // Add to active locations
      _activeLocations.add(location);
      _notifyLocationUpdate();

      // Set expiration timer if duration is specified
      if (duration != null) {
        _setExpirationTimer(location.id, duration);
      }

      return location;
    } catch (e) {
      print('Error creating private location: $e');
      return null;
    }
  }

  // Get nearby locations with privacy filtering
  Future<List<NowLocation>> getNearbyLocations({
    required double latitude,
    required double longitude,
    double radiusInMeters = 1000,
    PrivacyLevel? minimumPrivacyLevel,
    bool includeExpired = false,
  }) async {
    try {
      List<NowLocation> nearbyLocations = [];

      for (final location in _activeLocations) {
        // Skip expired locations unless requested
        if (!includeExpired && location.isExpired) continue;

        // Check privacy level filter
        if (minimumPrivacyLevel != null) {
          if (location.privacyLevel.index < minimumPrivacyLevel.index) continue;
        }

        // Calculate distance
        final distance = Geolocator.distanceBetween(
          latitude,
          longitude,
          location.latitude,
          location.longitude,
        );

        // Check if within radius
        if (distance <= radiusInMeters) {
          // Apply privacy filtering based on location settings
          final filteredLocation = _applyPrivacyFilter(location);
          nearbyLocations.add(filteredLocation);
        }
      }

      // Sort by distance
      nearbyLocations.sort((a, b) {
        final distanceA = Geolocator.distanceBetween(
          latitude,
          longitude,
          a.latitude,
          a.longitude,
        );
        final distanceB = Geolocator.distanceBetween(
          latitude,
          longitude,
          b.latitude,
          b.longitude,
        );
        return distanceA.compareTo(distanceB);
      });

      return nearbyLocations;
    } catch (e) {
      print('Error getting nearby locations: $e');
      return [];
    }
  }

  // Apply privacy filtering to location
  NowLocation _applyPrivacyFilter(NowLocation location) {
    if (!location.anonymitySettings.hideLocation) {
      return location;
    }

    // Apply location masking for privacy
    final random = Random();
    final latNoise = (random.nextDouble() - 0.5) * 0.002; // ~200m noise
    final lngNoise = (random.nextDouble() - 0.5) * 0.002;

    return location.copyWith(
      latitude: location.latitude + latNoise,
      longitude: location.longitude + lngNoise,
    );
  }

  // Update location privacy settings
  Future<bool> updateLocationPrivacy({
    required String locationId,
    PrivacyLevel? privacyLevel,
    AnonymitySettings? anonymitySettings,
  }) async {
    try {
      final index = _activeLocations.indexWhere((loc) => loc.id == locationId);
      if (index == -1) return false;

      final location = _activeLocations[index];
      final updatedLocation = location.copyWith(
        privacyLevel: privacyLevel,
        anonymitySettings: anonymitySettings,
      );

      _activeLocations[index] = updatedLocation;
      _notifyLocationUpdate();

      return true;
    } catch (e) {
      print('Error updating location privacy: $e');
      return false;
    }
  }

  // Delete location
  Future<bool> deleteLocation(String locationId) async {
    try {
      final index = _activeLocations.indexWhere((loc) => loc.id == locationId);
      if (index == -1) return false;

      _activeLocations.removeAt(index);

      // Cancel expiration timer if exists
      _expirationTimers[locationId]?.cancel();
      _expirationTimers.remove(locationId);

      _notifyLocationUpdate();
      return true;
    } catch (e) {
      print('Error deleting location: $e');
      return false;
    }
  }

  // Set expiration timer for location
  void _setExpirationTimer(String locationId, Duration duration) {
    // Cancel existing timer if any
    _expirationTimers[locationId]?.cancel();

    // Set new timer
    _expirationTimers[locationId] = Timer(duration, () {
      _expireLocation(locationId);
    });
  }

  // Expire location
  void _expireLocation(String locationId) {
    final index = _activeLocations.indexWhere((loc) => loc.id == locationId);
    if (index != -1) {
      final location = _activeLocations[index];
      final expiredLocation = location.copyWith(isActive: false);
      _activeLocations[index] = expiredLocation;

      // Remove from active locations after a delay
      Timer(const Duration(minutes: 5), () {
        _activeLocations.removeWhere((loc) => loc.id == locationId);
        _notifyLocationUpdate();
      });
    }

    _expirationTimers.remove(locationId);
    _notifyLocationUpdate();
  }

  // Notify location updates
  void _notifyLocationUpdate() {
    final activeLocations =
        _activeLocations.where((loc) => loc.isActive).toList();
    _locationsController.add(activeLocations);
  }

  // Toggle incognito mode
  void toggleIncognitoMode() {
    _isIncognitoMode = !_isIncognitoMode;
    if (_isIncognitoMode) {
      _enableAdvancedPrivacy();
    } else {
      _disableAdvancedPrivacy();
    }
  }

  // Enable advanced privacy features
  void _enableAdvancedPrivacy() {
    _useAdvancedEncryption = true;
    _enableProxyRouting = true;
    _maskLocationData = true;
  }

  // Disable advanced privacy features
  void _disableAdvancedPrivacy() {
    _useAdvancedEncryption = false;
    _enableProxyRouting = false;
    _maskLocationData = false;
  }

  // Get privacy status
  Map<String, bool> getPrivacyStatus() {
    return {
      'incognitoMode': _isIncognitoMode,
      'advancedEncryption': _useAdvancedEncryption,
      'proxyRouting': _enableProxyRouting,
      'locationMasking': _maskLocationData,
    };
  }

  // Get location statistics
  Map<String, dynamic> getLocationStats() {
    final totalLocations = _activeLocations.length;
    final activeLocations =
        _activeLocations.where((loc) => loc.isActive).length;
    final anonymousLocations = _activeLocations
        .where((loc) => loc.privacyLevel == PrivacyLevel.maximum)
        .length;
    final privateLocations = _activeLocations
        .where((loc) => loc.type == LocationType.private)
        .length;

    return {
      'totalLocations': totalLocations,
      'activeLocations': activeLocations,
      'anonymousLocations': anonymousLocations,
      'privateLocations': privateLocations,
      'expiredLocations': totalLocations - activeLocations,
    };
  }

  // Clear all locations
  void clearAllLocations() {
    // Cancel all timers
    for (final timer in _expirationTimers.values) {
      timer.cancel();
    }
    _expirationTimers.clear();

    // Clear locations
    _activeLocations.clear();
    _notifyLocationUpdate();
  }

  // Get locations by type
  List<NowLocation> getLocationsByType(LocationType type) {
    return _activeLocations
        .where((loc) => loc.type == type && loc.isActive)
        .toList();
  }

  // Get locations by privacy level
  List<NowLocation> getLocationsByPrivacyLevel(PrivacyLevel level) {
    return _activeLocations
        .where((loc) => loc.privacyLevel == level && loc.isActive)
        .toList();
  }

  // Search locations by metadata
  List<NowLocation> searchLocations(Map<String, dynamic> searchCriteria) {
    return _activeLocations.where((location) {
      for (final entry in searchCriteria.entries) {
        if (location.metadata[entry.key] != entry.value) {
          return false;
        }
      }
      return location.isActive;
    }).toList();
  }

  // Dispose resources
  void dispose() {
    for (final timer in _expirationTimers.values) {
      timer.cancel();
    }
    _expirationTimers.clear();
    _locationsController.close();
  }
}
