import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../localization/app_localizations.dart';
import '../domain/place.dart';
import '../providers/places_provider.dart';
import 'nearby_places_page.dart';
import 'places_map_page.dart';

class PlacesListPage extends ConsumerWidget {
  const PlacesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final placesAsync = ref.watch(placesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.places),
        actions: [
          IconButton(
            icon: const Icon(Icons.near_me),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const NearbyPlacesPage()),
              );
            },
            tooltip: 'In meiner Nähe',
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PlacesMapPage()),
              );
            },
            tooltip: 'Kartenansicht',
          ),
        ],
      ),
      body: placesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading places', // l10n.error_loading_places,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(placesProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (places) {
          if (places.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.place_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No places found', // l10n.no_places_found,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return PlaceListTile(place: place);
            },
          );
        },
      ),
    );
  }
}

class PlaceListTile extends StatelessWidget {
  const PlaceListTile({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            _getCategoryIcon(place.category),
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        title: Text(place.name, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(
          place.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navigate to place detail
          // TODO: Implement place detail navigation
        },
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case 'nature':
        return Icons.park;
      case 'restaurant':
        return Icons.restaurant;
      case 'hotel':
      case 'accommodation':
        return Icons.hotel;
      case 'shopping':
        return Icons.shopping_bag;
      case 'culture':
      case 'historic':
        return Icons.museum;
      case 'sport':
      case 'attraction':
        return Icons.sports_soccer;
      case 'service':
        return Icons.business;
      default:
        return Icons.place;
    }
  }
}
