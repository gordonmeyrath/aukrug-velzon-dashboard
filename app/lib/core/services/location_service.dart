import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Location accuracy level for different use cases
enum LocationAccuracyLevel {
  low,      // For general location, less battery usage
  medium,   // For map viewing
  high,     // For precise location selection
  best,     // For navigation and reporting
}

/// Location service status
enum LocationServiceStatus {
  unknown,
  disabled,
  permissionDenied,
  permissionDeniedForever,
  available,
}

/// Enhanced location service for managing GPS functionality
class LocationService {
  /// Check location service status and permissions
  Future<LocationServiceStatus> getLocationStatus() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationServiceStatus.disabled;
    }

    // Check permissions
    LocationPermission permission = await Geolocator.checkPermission();
    
    switch (permission) {
      case LocationPermission.denied:
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationServiceStatus.permissionDenied;
        }
        break;
      case LocationPermission.deniedForever:
        return LocationServiceStatus.permissionDeniedForever;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return LocationServiceStatus.available;
      case LocationPermission.unableToDetermine:
        return LocationServiceStatus.unknown;
    }

    return LocationServiceStatus.available;
  }

  /// Check if location services are available (legacy method for backward compatibility)
  Future<bool> isLocationAvailable() async {
    final status = await getLocationStatus();
    return status == LocationServiceStatus.available;
  }

  /// Get current user location with specified accuracy
  Future<LatLng?> getCurrentLocation({
    LocationAccuracyLevel accuracy = LocationAccuracyLevel.high,
    Duration timeLimit = const Duration(seconds: 15),
  }) async {
    try {
      final status = await getLocationStatus();
      if (status != LocationServiceStatus.available) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: _getGeolocatorAccuracy(accuracy),
        timeLimit: timeLimit,
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      // Location service error - could be timeout, permission denied, etc.
      return null;
    }
  }

  /// Get last known location (faster but potentially less accurate)
  Future<LatLng?> getLastKnownLocation() async {
    try {
      final status = await getLocationStatus();
      if (status != LocationServiceStatus.available) {
        return null;
      }

      Position? position = await Geolocator.getLastKnownPosition();
      if (position == null) {
        // Fall back to current location if no last known position
        return await getCurrentLocation(accuracy: LocationAccuracyLevel.medium);
      }

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      return null;
    }
  }

  /// Get distance between two points in meters
  double getDistanceBetween(LatLng from, LatLng to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  /// Calculate bearing from one point to another in degrees
  double getBearingBetween(LatLng from, LatLng to) {
    return Geolocator.bearingBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  /// Check if user is within Aukrug municipality bounds
  bool isWithinAukrug(LatLng location) {
    // Aukrug approximate bounds (more precise boundaries)
    const double northBound = 54.22;
    const double southBound = 54.05;
    const double eastBound = 10.0;
    const double westBound = 9.7;

    return location.latitude >= southBound &&
        location.latitude <= northBound &&
        location.longitude >= westBound &&
        location.longitude <= eastBound;
  }

  /// Get distance to Aukrug center if outside bounds
  double? getDistanceToAukrug(LatLng location) {
    if (isWithinAukrug(location)) {
      return null; // Already within Aukrug
    }

    // Aukrug center coordinates (approximately)
    const LatLng aukrugCenter = LatLng(54.135, 9.85);
    return getDistanceBetween(location, aukrugCenter);
  }

  /// Start location stream for real-time updates
  Stream<LatLng> getLocationStream({
    LocationAccuracyLevel accuracy = LocationAccuracyLevel.medium,
    int distanceFilter = 10, // Update every X meters
  }) async* {
    final status = await getLocationStatus();
    if (status != LocationServiceStatus.available) {
      return;
    }

    await for (Position position in Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: _getGeolocatorAccuracy(accuracy),
        distanceFilter: distanceFilter,
      ),
    )) {
      yield LatLng(position.latitude, position.longitude);
    }
  }

  /// Check location settings and prompt user to enable if needed
  Future<bool> checkAndRequestLocationSettings() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, request user to enable it
      return await Geolocator.openLocationSettings();
    }
    return true;
  }

  /// Convert our accuracy level to Geolocator accuracy
  LocationAccuracy _getGeolocatorAccuracy(LocationAccuracyLevel level) {
    switch (level) {
      case LocationAccuracyLevel.low:
        return LocationAccuracy.low;
      case LocationAccuracyLevel.medium:
        return LocationAccuracy.medium;
      case LocationAccuracyLevel.high:
        return LocationAccuracy.high;
      case LocationAccuracyLevel.best:
        return LocationAccuracy.best;
    }
  }
}

/// Provider for LocationService
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// Provider for location service status
final locationStatusProvider = FutureProvider<LocationServiceStatus>((ref) async {
  final locationService = ref.read(locationServiceProvider);
  return await locationService.getLocationStatus();
});

/// Provider for current user location with configurable accuracy
final currentLocationProvider = FutureProvider.family<LatLng?, LocationAccuracyLevel>((ref, accuracy) async {
  final locationService = ref.read(locationServiceProvider);
  return await locationService.getCurrentLocation(accuracy: accuracy);
});

/// Provider for last known location (faster alternative)
final lastKnownLocationProvider = FutureProvider<LatLng?>((ref) async {
  final locationService = ref.read(locationServiceProvider);
  return await locationService.getLastKnownLocation();
});

/// Provider for location permission status (legacy compatibility)
final locationPermissionProvider = FutureProvider<bool>((ref) async {
  final locationService = ref.read(locationServiceProvider);
  return await locationService.isLocationAvailable();
});

/// Provider for real-time location stream with configurable accuracy
final locationStreamProvider = StreamProvider.family<LatLng?, LocationAccuracyLevel>((ref, accuracy) async* {
  final locationService = ref.read(locationServiceProvider);

  try {
    await for (LatLng location in locationService.getLocationStream(accuracy: accuracy)) {
      yield location;
    }
  } catch (e) {
    yield null;
  }
});

/// Provider to check if current location is within Aukrug
final isWithinAukrugProvider = FutureProvider<bool?>((ref) async {
  final locationService = ref.read(locationServiceProvider);
  final currentLocation = await ref.read(lastKnownLocationProvider.future);
  
  if (currentLocation == null) return null;
  
  return locationService.isWithinAukrug(currentLocation);
});

/// Provider for distance to Aukrug center (if outside bounds)
final distanceToAukrugProvider = FutureProvider<double?>((ref) async {
  final locationService = ref.read(locationServiceProvider);
  final currentLocation = await ref.read(lastKnownLocationProvider.future);
  
  if (currentLocation == null) return null;
  
  return locationService.getDistanceToAukrug(currentLocation);
});
