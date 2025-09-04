import 'dart:convert';
import 'package:flutter/services.dart';

import '../domain/event.dart';

class EventsRepository {
  /// Get events from fixtures (offline-first approach)
  Future<List<Event>> getEvents() async {
    try {
      // Load from fixtures first
      final String response = await rootBundle.loadString('assets/fixtures/events.json');
      final data = json.decode(response) as Map<String, dynamic>;
      
      final List<dynamic> eventsJson = data['events'] ?? [];
      return eventsJson.map((json) => Event.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      // Return empty list if loading fails
      return [];
    }
  }

  /// Get events filtered by date range
  Future<List<Event>> getEventsByDateRange(DateTime start, DateTime end) async {
    final events = await getEvents();
    return events.where((event) {
      return event.startDate.isAfter(start.subtract(const Duration(days: 1))) &&
             event.startDate.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  /// Get upcoming events (next 30 days)
  Future<List<Event>> getUpcomingEvents() async {
    final now = DateTime.now();
    final thirtyDaysFromNow = now.add(const Duration(days: 30));
    return getEventsByDateRange(now, thirtyDaysFromNow);
  }

  /// Get events by category
  Future<List<Event>> getEventsByCategory(String category) async {
    final events = await getEvents();
    return events.where((event) => event.category == category).toList();
  }

  /// Search events by query
  Future<List<Event>> searchEvents(String query) async {
    final events = await getEvents();
    final lowerQuery = query.toLowerCase();
    
    return events.where((event) {
      return event.title.toLowerCase().contains(lowerQuery) ||
             event.description.toLowerCase().contains(lowerQuery) ||
             (event.organizer?.toLowerCase().contains(lowerQuery) ?? false) ||
             (event.tags?.any((tag) => tag.toLowerCase().contains(lowerQuery)) ?? false);
    }).toList();
  }

  /// Get a specific event by ID
  Future<Event?> getEvent(int id) async {
    final events = await getEvents();
    try {
      return events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }
}
