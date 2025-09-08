import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/color_extensions.dart';
import '../../../localization/app_localizations.dart';
import '../../map/presentation/widgets/aukrug_map.dart';
import '../../map/presentation/widgets/map_marker_factory.dart';
import '../domain/place.dart';
import '../providers/places_provider.dart';

/// Map view of all places in Aukrug
class PlacesMapPage extends ConsumerStatefulWidget {
  const PlacesMapPage({super.key});

  @override
  ConsumerState<PlacesMapPage> createState() => _PlacesMapPageState();
}

class _PlacesMapPageState extends ConsumerState<PlacesMapPage> {
  Place? _selectedPlace;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final placesAsync = ref.watch(placesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.places),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Zurück zur Liste',
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
                'Fehler beim Laden der Orte',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(error.toString()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(placesProvider),
                child: const Text('Erneut versuchen'),
              ),
            ],
          ),
        ),
        data: (places) {
          final markers = places
              .map(
                (place) => MapMarkerFactory.createPlaceMarker(
                  place,
                  isSelected: _selectedPlace?.id == place.id,
                  onTap: () => _onMarkerTap(place),
                ),
              )
              .toList();

          return Stack(
            children: [
              AukrugMap(
                markers: markers,
                showUserLocation: true,
                onMarkerTap: (marker) {
                  // Find place for this marker
                  final markerIndex = markers.indexOf(marker);
                  if (markerIndex >= 0 && markerIndex < places.length) {
                    _onMarkerTap(places[markerIndex]);
                  }
                },
              ),

              // Selected place detail card
              if (_selectedPlace != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: _PlaceDetailCard(
                    place: _selectedPlace!,
                    onClose: () => setState(() => _selectedPlace = null),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _onMarkerTap(Place place) {
    setState(() {
      _selectedPlace = _selectedPlace?.id == place.id ? null : place;
    });
  }
}

/// Detail card for selected place on map
class _PlaceDetailCard extends StatelessWidget {
  const _PlaceDetailCard({required this.place, required this.onClose});

  final Place place;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            if (place.category != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.alphaFrac(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  place.category!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 8),
            Text(
              place.description,
              style: theme.textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            if (place.address != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      place.address!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (place.phone != null)
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Launch phone dialer
                    },
                    icon: const Icon(Icons.phone, size: 16),
                    label: const Text('Anrufen'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),

                if (place.website != null)
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Launch website
                    },
                    icon: const Icon(Icons.language, size: 16),
                    label: const Text('Website'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),

                FilledButton.icon(
                  onPressed: () {
                    // TODO: Navigate to place detail page
                  },
                  icon: const Icon(Icons.info, size: 16),
                  label: const Text('Details'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
