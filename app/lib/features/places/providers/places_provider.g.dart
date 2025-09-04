// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'places_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$placesHash() => r'd27f55db40331db8b354a31986531adb68be92fb';

/// See also [places].
@ProviderFor(places)
final placesProvider = AutoDisposeFutureProvider<List<Place>>.internal(
  places,
  name: r'placesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$placesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlacesRef = AutoDisposeFutureProviderRef<List<Place>>;
String _$placesRepositoryHash() => r'e8edae0f8b2a49a016e1acb97f326077e92d422e';

/// See also [placesRepository].
@ProviderFor(placesRepository)
final placesRepositoryProvider = AutoDisposeProvider<PlacesRepository>.internal(
  placesRepository,
  name: r'placesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$placesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PlacesRepositoryRef = AutoDisposeProviderRef<PlacesRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
