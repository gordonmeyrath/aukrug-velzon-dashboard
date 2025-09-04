import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Location service for managing GPS functionality
class LocationService {
  /// Check if location services are enabled and permissions are granted
  Future<bool> isLocationAvailable() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Get current user location
  Future<LatLng?> getCurrentLocation() async {
    try {
      if (!await isLocationAvailable()) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      // Location service error
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

  /// Check if user is within Aukrug municipality bounds
  bool isWithinAukrug(LatLng location) {
    // Aukrug approximate bounds
    const double northBound = 54.22;
    const double southBound = 54.05;
    const double eastBound = 10.0;
    const double westBound = 9.7;

    return location.latitude >= southBound &&
           location.latitude <= northBound &&
           location.longitude >= westBound &&
           location.longitude <= eastBound;
  }

  /// Start location stream for real-time updates
  Stream<LatLng> getLocationStream() async* {
    if (!await isLocationAvailable()) {
      return;
    }

    await for (Position position in Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    )) {
      yield LatLng(position.latitude, position.longitude);
    }
  }
}

/// Provider for LocationService
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// Provider for current user location
final currentLocationProvider = FutureProvider<LatLng?>((ref) async {
  final locationService = ref.read(locationServiceProvider);
  return await locationService.getCurrentLocation();
});

/// Provider for location permission status
final locationPermissionProvider = FutureProvider<bool>((ref) async {
  final locationService = ref.read(locationServiceProvider);
  return await locationService.isLocationAvailable();
});

/// Provider for real-time location stream
final locationStreamProvider = StreamProvider<LatLng?>((ref) async* {
  final locationService = ref.read(locationServiceProvider);
  
  try {
    await for (LatLng location in locationService.getLocationStream()) {
      yield location;
    }
  } catch (e) {
    yield null;
  }
});
