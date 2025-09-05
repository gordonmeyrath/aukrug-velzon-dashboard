import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/services/location_service.dart';

/// Interactive map widget for displaying Aukrug locations
///
/// Displays places, events, and other points of interest on an OpenStreetMap
/// base layer with support for markers, user location, and zoom controls.
class AukrugMap extends ConsumerStatefulWidget {
  const AukrugMap({
    super.key,
    this.center,
    this.zoom = 13.0,
    this.markers = const [],
    this.showUserLocation = false,
    this.onMapTap,
    this.onMarkerTap,
    this.height,
  });

  /// Initial center position of the map (defaults to Aukrug center)
  final LatLng? center;

  /// Initial zoom level
  final double zoom;

  /// List of markers to display on the map
  final List<Marker> markers;

  /// Whether to show user's current location
  final bool showUserLocation;

  /// Callback when map is tapped
  final void Function(LatLng)? onMapTap;

  /// Callback when a marker is tapped
  final void Function(Marker)? onMarkerTap;

  /// Fixed height for the map (if null, expands to parent)
  final double? height;

  @override
  ConsumerState<AukrugMap> createState() => _AukrugMapState();
}

class _AukrugMapState extends ConsumerState<AukrugMap> {
  late final MapController _mapController;

  // Aukrug center coordinates (approximate)
  static const LatLng _aukrugCenter = LatLng(54.1333, 9.8833);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch user location if enabled
    final userLocationAsync = widget.showUserLocation
        ? ref.watch(currentLocationProvider(LocationAccuracyLevel.medium))
        : const AsyncValue.data(null);

    Widget mapWidget = FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: widget.center ?? _aukrugCenter,
        initialZoom: widget.zoom,
        minZoom: 10.0,
        maxZoom: 18.0,
        onTap: widget.onMapTap != null
            ? (tapPosition, latLng) => widget.onMapTap!(latLng)
            : null,
        // Bounds for Aukrug area to prevent excessive panning
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(
            const LatLng(54.05, 9.7), // Southwest
            const LatLng(54.22, 10.0), // Northeast
          ),
        ),
      ),
      children: [
        // OpenStreetMap tile layer
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.aukrug.app',
          maxZoom: 18,
          tileProvider: NetworkTileProvider(),
        ),

        // Markers layer
        if (widget.markers.isNotEmpty)
          MarkerLayer(
            markers: widget.markers.map((marker) {
              return Marker(
                point: marker.point,
                width: marker.width,
                height: marker.height,
                alignment: marker.alignment,
                child: GestureDetector(
                  onTap: widget.onMarkerTap != null
                      ? () => widget.onMarkerTap!(marker)
                      : null,
                  child: marker.child,
                ),
              );
            }).toList(),
          ),

        // User location marker
        if (widget.showUserLocation)
          userLocationAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (userLocation) {
              if (userLocation == null) return const SizedBox.shrink();

              return MarkerLayer(
                markers: [
                  Marker(
                    point: userLocation,
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );

    // Wrap in container with height if specified
    if (widget.height != null) {
      mapWidget = SizedBox(height: widget.height, child: mapWidget);
    }

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          mapWidget,

          // Map controls
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                // Zoom in button
                _MapControlButton(
                  icon: Icons.add,
                  onTap: () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom + 1,
                  ),
                  backgroundColor: colorScheme.surface,
                  foregroundColor: colorScheme.onSurface,
                ),

                const SizedBox(height: 8),

                // Zoom out button
                _MapControlButton(
                  icon: Icons.remove,
                  onTap: () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom - 1,
                  ),
                  backgroundColor: colorScheme.surface,
                  foregroundColor: colorScheme.onSurface,
                ),

                const SizedBox(height: 8),

                // Center on Aukrug button
                _MapControlButton(
                  icon: Icons.home,
                  onTap: () => _mapController.move(_aukrugCenter, 13.0),
                  backgroundColor: colorScheme.surface,
                  foregroundColor: colorScheme.onSurface,
                ),

                // My location button (only if location is enabled)
                if (widget.showUserLocation) ...[
                  const SizedBox(height: 8),
                  _MapControlButton(
                    icon: Icons.my_location,
                    onTap: () async {
                      final location = await ref.read(
                        currentLocationProvider(
                          LocationAccuracyLevel.high,
                        ).future,
                      );
                      if (location != null) {
                        _mapController.move(location, 16.0);
                      }
                    },
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom control button for map interactions
class _MapControlButton extends StatelessWidget {
  const _MapControlButton({
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 20, color: foregroundColor),
          ),
        ),
      ),
    );
  }
}
