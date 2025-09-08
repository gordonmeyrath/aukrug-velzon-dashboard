import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/color_extensions.dart';
import '../../../localization/app_localizations.dart';
import '../../map/presentation/widgets/aukrug_map.dart';
import '../../map/presentation/widgets/map_marker_factory.dart';
import '../domain/event.dart';
import '../providers/events_provider.dart';

/// Map view of all events in Aukrug
class EventsMapPage extends ConsumerStatefulWidget {
  const EventsMapPage({super.key});

  @override
  ConsumerState<EventsMapPage> createState() => _EventsMapPageState();
}

class _EventsMapPageState extends ConsumerState<EventsMapPage> {
  Event? _selectedEvent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.events),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Zurück zur Liste',
          ),
        ],
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Fehler beim Laden der Events',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(error.toString()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(eventsProvider),
                child: const Text('Erneut versuchen'),
              ),
            ],
          ),
        ),
        data: (events) {
          // Filter events that have coordinates
          final eventsWithLocation = events
              .where(
                (event) => event.latitude != null && event.longitude != null,
              )
              .toList();

          if (eventsWithLocation.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Keine Events mit Standortinformationen gefunden',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          final markers = eventsWithLocation
              .map(
                (event) => MapMarkerFactory.createEventMarker(
                  event,
                  isSelected: _selectedEvent?.id == event.id,
                  onTap: () => _onMarkerTap(event),
                ),
              )
              .toList();

          return Stack(
            children: [
              AukrugMap(
                markers: markers,
                showUserLocation: true,
                onMarkerTap: (marker) {
                  // Find event for this marker
                  final markerIndex = markers.indexOf(marker);
                  if (markerIndex >= 0 &&
                      markerIndex < eventsWithLocation.length) {
                    _onMarkerTap(eventsWithLocation[markerIndex]);
                  }
                },
              ),

              // Selected event detail card
              if (_selectedEvent != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: _EventDetailCard(
                    event: _selectedEvent!,
                    onClose: () => setState(() => _selectedEvent = null),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _onMarkerTap(Event event) {
    setState(() {
      _selectedEvent = _selectedEvent?.id == event.id ? null : event;
    });
  }
}

/// Detail card for selected event on map
class _EventDetailCard extends StatelessWidget {
  const _EventDetailCard({required this.event, required this.onClose});

  final Event event;
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
                    event.title,
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

            if (event.category != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.alphaFrac(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  event.category!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 8),
            Text(
              event.description,
              style: theme.textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _formatEventDate(event),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),

            if (event.location != null) ...[
              const SizedBox(height: 4),
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
                      event.location!,
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
                if (event.price != null && event.price! > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${event.price!.toStringAsFixed(2)}€',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.alphaFrac(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Kostenlos',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                FilledButton.icon(
                  onPressed: () {
                    // TODO: Navigate to event detail page
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

  String _formatEventDate(Event event) {
    final now = DateTime.now();
    final startDate = event.startDate;

    if (startDate.year == now.year &&
        startDate.month == now.month &&
        startDate.day == now.day) {
      return 'Heute, ${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}';
    }

    return '${startDate.day}.${startDate.month}.${startDate.year}, ${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}';
  }
}
