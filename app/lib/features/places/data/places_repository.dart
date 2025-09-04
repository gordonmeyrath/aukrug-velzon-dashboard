import 'dart:convert';
import 'package:flutter/services.dart';

import '../domain/place.dart';

class PlacesRepository {
  /// Get places from fixtures (offline-first approach)
  Future<List<Place>> getPlaces() async {
    try {
      // Load from fixtures first
      final String response = await rootBundle.loadString('assets/fixtures/places.json');
      final data = json.decode(response) as Map<String, dynamic>;
      
      final List<dynamic> placesJson = data['places'] ?? [];
      return placesJson.map((json) => Place.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      // Return empty list if loading fails
      return [];
    }
  }

  /// Get a specific place by ID
  Future<Place?> getPlace(int id) async {
    final places = await getPlaces();
    try {
      return places.firstWhere((place) => place.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search places by query
  Future<List<Place>> searchPlaces(String query) async {
    final places = await getPlaces();
    final lowerQuery = query.toLowerCase();
    
    return places.where((place) {
      return place.name.toLowerCase().contains(lowerQuery) ||
             place.description.toLowerCase().contains(lowerQuery) ||
             (place.tags?.any((tag) => tag.toLowerCase().contains(lowerQuery)) ?? false);
    }).toList();
  }

  /// Filter places by category
  Future<List<Place>> getPlacesByCategory(String category) async {
    final places = await getPlaces();
    return places.where((place) => place.category == category).toList();
  }
}
