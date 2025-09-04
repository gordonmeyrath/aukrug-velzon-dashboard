import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/services/location_service.dart';
import '../domain/place.dart';
import 'places_provider.dart';

/// Provider for places near user's current location
final nearbyPlacesProvider = FutureProvider.family<List<PlaceWithDistance>, double>((ref, radiusKm) async {
  final placesAsync = await ref.watch(placesProvider.future);
  final userLocation = await ref.watch(currentLocationProvider.future);
  
  if (userLocation == null) {
    return [];
  }
  
  final locationService = ref.read(locationServiceProvider);
  final radiusMeters = radiusKm * 1000;
  
  final nearbyPlaces = <PlaceWithDistance>[];
  
  for (final place in placesAsync) {
    final distance = locationService.getDistanceBetween(
      userLocation,
      LatLng(place.latitude, place.longitude),
    );
    
    if (distance <= radiusMeters) {
      nearbyPlaces.add(PlaceWithDistance(
        place: place,
        distance: distance,
        userLocation: userLocation,
      ));
    }
  }
  
  // Sort by distance
  nearbyPlaces.sort((a, b) => a.distance.compareTo(b.distance));
  
  return nearbyPlaces;
});

/// Provider for closest place to user
final closestPlaceProvider = FutureProvider<PlaceWithDistance?>((ref) async {
  final nearbyPlaces = await ref.watch(nearbyPlacesProvider(10.0).future); // 10km radius
  return nearbyPlaces.isEmpty ? null : nearbyPlaces.first;
});

/// Class combining a place with its distance from user
class PlaceWithDistance {
  final Place place;
  final double distance; // in meters
  final LatLng userLocation;
  
  const PlaceWithDistance({
    required this.place,
    required this.distance,
    required this.userLocation,
  });
  
  /// Get distance formatted as string
  String get formattedDistance {
    if (distance < 1000) {
      return '${distance.round()}m';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)}km';
    }
  }
  
  /// Get walking time estimate (assuming 5 km/h)
  String get walkingTime {
    final walkingSpeedKmh = 5.0;
    final distanceKm = distance / 1000;
    final timeHours = distanceKm / walkingSpeedKmh;
    final timeMinutes = (timeHours * 60).round();
    
    if (timeMinutes < 60) {
      return '${timeMinutes}min zu Fuß';
    } else {
      final hours = timeMinutes ~/ 60;
      final minutes = timeMinutes % 60;
      return '${hours}h ${minutes}min zu Fuß';
    }
  }
}
