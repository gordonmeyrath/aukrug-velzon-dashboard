import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/color_extensions.dart';
import '../providers/nearby_places_provider.dart';

/// Page showing places near user's current location
class NearbyPlacesPage extends ConsumerStatefulWidget {
  const NearbyPlacesPage({super.key});

  @override
  ConsumerState<NearbyPlacesPage> createState() => _NearbyPlacesPageState();
}

class _NearbyPlacesPageState extends ConsumerState<NearbyPlacesPage> {
  double _selectedRadius = 2.0; // Default 2km radius

  @override
  Widget build(BuildContext context) {
    final nearbyPlacesAsync = ref.watch(nearbyPlacesProvider(_selectedRadius));

    return Scaffold(
      appBar: AppBar(
        title: const Text('In meiner Nähe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(nearbyPlacesProvider(_selectedRadius)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Radius selector
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.alphaFrac(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suchradius: ${_selectedRadius.toStringAsFixed(1)}km',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Slider(
                  value: _selectedRadius,
                  min: 0.5,
                  max: 10.0,
                  divisions: 19, // 0.5km steps
                  onChanged: (value) {
                    setState(() {
                      _selectedRadius = value;
                    });
                  },
                ),
              ],
            ),
          ),

          // Places list
          Expanded(
            child: nearbyPlacesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) {
                String errorMessage = 'Fehler beim Laden der Orte';
                if (error.toString().contains('location')) {
                  errorMessage =
                      'Standort nicht verfügbar. Bitte aktivieren Sie GPS und erteilen Sie die Berechtigung.';
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off,
                        size: 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            ref.refresh(nearbyPlacesProvider(_selectedRadius)),
                        child: const Text('Erneut versuchen'),
                      ),
                    ],
                  ),
                );
              },
              data: (nearbyPlaces) {
                if (nearbyPlaces.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Keine Orte in der Nähe gefunden',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Versuchen Sie einen größeren Suchradius',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: nearbyPlaces.length,
                  itemBuilder: (context, index) {
                    final placeWithDistance = nearbyPlaces[index];
                    return _NearbyPlaceCard(
                      placeWithDistance: placeWithDistance,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Card widget for displaying a nearby place
class _NearbyPlaceCard extends StatelessWidget {
  const _NearbyPlaceCard({required this.placeWithDistance});

  final PlaceWithDistance placeWithDistance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final place = placeWithDistance.place;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    place.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    placeWithDistance.formattedDistance,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            if (place.category != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  place.category!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 8),
            Text(
              place.description,
              style: theme.textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.directions_walk,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  placeWithDistance.walkingTime,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),

                TextButton.icon(
                  onPressed: () {
                    // TODO: Open in navigation app
                  },
                  icon: const Icon(Icons.directions, size: 16),
                  label: const Text('Route'),
                ),

                TextButton.icon(
                  onPressed: () {
                    // TODO: Navigate to place details
                  },
                  icon: const Icon(Icons.info, size: 16),
                  label: const Text('Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
