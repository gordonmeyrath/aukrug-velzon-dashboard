// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventsHash() => r'eb445759e22d5ae12f6c80f0d16461c56106c6df';

/// See also [events].
@ProviderFor(events)
final eventsProvider = AutoDisposeFutureProvider<List<Event>>.internal(
  events,
  name: r'eventsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$eventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EventsRef = AutoDisposeFutureProviderRef<List<Event>>;
String _$upcomingEventsHash() => r'a6e3d997a665ce02911f33dd24c5b197bc2d94e0';

/// See also [upcomingEvents].
@ProviderFor(upcomingEvents)
final upcomingEventsProvider = AutoDisposeFutureProvider<List<Event>>.internal(
  upcomingEvents,
  name: r'upcomingEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$upcomingEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UpcomingEventsRef = AutoDisposeFutureProviderRef<List<Event>>;
String _$eventsRepositoryHash() => r'b30ee26924f9e33e3741f554c84a0fe50c63303f';

/// See also [eventsRepository].
@ProviderFor(eventsRepository)
final eventsRepositoryProvider = AutoDisposeProvider<EventsRepository>.internal(
  eventsRepository,
  name: r'eventsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EventsRepositoryRef = AutoDisposeProviderRef<EventsRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
