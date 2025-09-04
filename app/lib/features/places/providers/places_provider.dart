import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/place.dart';
import '../data/places_repository.dart';

part 'places_provider.g.dart';

@riverpod
Future<List<Place>> places(PlacesRef ref) async {
  final repository = ref.watch(placesRepositoryProvider);
  return repository.getPlaces();
}

@riverpod
PlacesRepository placesRepository(PlacesRepositoryRef ref) {
  return PlacesRepository();
}
