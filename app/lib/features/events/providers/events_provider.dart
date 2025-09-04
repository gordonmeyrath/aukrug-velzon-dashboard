import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/event.dart';
import '../data/events_repository.dart';

part 'events_provider.g.dart';

@riverpod
Future<List<Event>> events(EventsRef ref) async {
  final repository = ref.watch(eventsRepositoryProvider);
  return repository.getEvents();
}

@riverpod
Future<List<Event>> upcomingEvents(UpcomingEventsRef ref) async {
  final repository = ref.watch(eventsRepositoryProvider);
  return repository.getUpcomingEvents();
}

@riverpod
EventsRepository eventsRepository(EventsRepositoryRef ref) {
  return EventsRepository();
}
