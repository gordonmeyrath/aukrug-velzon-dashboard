import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/color_extensions.dart';
import '../../../events/domain/event.dart';
import '../../../places/domain/place.dart';
import '../../../reports/domain/report.dart';
import '../../../reports/presentation/status_colors.dart';

/// Factory for creating map markers for different types of content
class MapMarkerFactory {
  static const double _markerSize = 40.0;
  static const double _selectedMarkerSize = 50.0;

  /// Create a marker for a place
  static Marker createPlaceMarker(
    Place place, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return Marker(
      point: LatLng(place.latitude, place.longitude),
      width: isSelected ? _selectedMarkerSize : _markerSize,
      height: isSelected ? _selectedMarkerSize : _markerSize,
      alignment: Alignment.center,
      child: _PlaceMarker(place: place, isSelected: isSelected, onTap: onTap),
    );
  }

  /// Create a marker for an event
  static Marker createEventMarker(
    Event event, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    // Only create marker if event has coordinates
    if (event.latitude == null || event.longitude == null) {
      throw ArgumentError('Event must have latitude and longitude for marker');
    }

    return Marker(
      point: LatLng(event.latitude!, event.longitude!),
      width: isSelected ? _selectedMarkerSize : _markerSize,
      height: isSelected ? _selectedMarkerSize : _markerSize,
      alignment: Alignment.center,
      child: _EventMarker(event: event, isSelected: isSelected, onTap: onTap),
    );
  }

  /// Create a marker for a report
  static Marker createReportMarker(
    Report report, {
    bool isSelected = false,
    VoidCallback? onTap,
  DateTime? lastFullSyncAt,
  }) {
    return Marker(
      point: LatLng(report.location.latitude, report.location.longitude),
      width: isSelected ? _selectedMarkerSize : _markerSize,
      height: isSelected ? _selectedMarkerSize : _markerSize,
      alignment: Alignment.center,
      child: _ReportMarker(
        report: report,
        isSelected: isSelected,
        onTap: onTap,
    lastFullSyncAt: lastFullSyncAt,
      ),
    );
  }

  /// Create a generic location marker
  static Marker createLocationMarker(
    LatLng location, {
    String? label,
    Color? color,
    IconData? icon,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return Marker(
      point: location,
      width: isSelected ? _selectedMarkerSize : _markerSize,
      height: isSelected ? _selectedMarkerSize : _markerSize,
      alignment: Alignment.center,
      child: _GenericMarker(
        label: label,
        color: color ?? Colors.red,
        icon: icon ?? Icons.place,
        isSelected: isSelected,
        onTap: onTap,
      ),
    );
  }
}

/// Marker widget for places
class _PlaceMarker extends StatelessWidget {
  const _PlaceMarker({
    required this.place,
    required this.isSelected,
    this.onTap,
  });

  final Place place;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _getPlaceCategoryColor(place.category),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.white,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.alphaFrac(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          _getPlaceCategoryIcon(place.category),
          color: Colors.white,
          size: isSelected ? 24 : 20,
        ),
      ),
    );
  }

  Color _getPlaceCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'dining':
        return Colors.orange;
      case 'accommodation':
        return Colors.blue;
      case 'nature':
        return Colors.green;
      case 'services':
        return Colors.purple;
      case 'shopping':
        return Colors.pink;
      default:
        return Colors.red;
    }
  }

  IconData _getPlaceCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'dining':
        return Icons.restaurant;
      case 'accommodation':
        return Icons.hotel;
      case 'nature':
        return Icons.park;
      case 'services':
        return Icons.business;
      case 'shopping':
        return Icons.shopping_bag;
      default:
        return Icons.place;
    }
  }
}

/// Marker widget for events
class _EventMarker extends StatelessWidget {
  const _EventMarker({
    required this.event,
    required this.isSelected,
    this.onTap,
  });

  final Event event;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _getEventCategoryColor(event.category),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.white,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.alphaFrac(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          _getEventCategoryIcon(event.category),
          color: Colors.white,
          size: isSelected ? 24 : 20,
        ),
      ),
    );
  }

  Color _getEventCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'festival':
        return Colors.deepOrange;
      case 'sport':
        return Colors.blue;
      case 'culture':
        return Colors.purple;
      case 'family':
        return Colors.green;
      case 'education':
        return Colors.indigo;
      case 'business':
        return Colors.grey;
      default:
        return Colors.red;
    }
  }

  IconData _getEventCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'festival':
        return Icons.celebration;
      case 'sport':
        return Icons.sports_soccer;
      case 'culture':
        return Icons.theater_comedy;
      case 'family':
        return Icons.family_restroom;
      case 'education':
        return Icons.school;
      case 'business':
        return Icons.business;
      default:
        return Icons.event;
    }
  }
}

/// Marker widget for reports
class _ReportMarker extends StatelessWidget {
  const _ReportMarker({
    required this.report,
    required this.isSelected,
    this.onTap,
  this.lastFullSyncAt,
  });

  final Report report;
  final bool isSelected;
  final VoidCallback? onTap;
  final DateTime? lastFullSyncAt;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
  final changed = report.updatedAt ?? report.submittedAt;
  final isFresh = changed != null && lastFullSyncAt != null && changed.isAfter(lastFullSyncAt!);
  return Semantics(
      label: 'Meldung ${report.title}',
      hint:
          'Status ${report.status.displayName}, Priorität ${report.priority.displayName}',
      button: true,
      onTap: onTap,
  child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
    if (isFresh)
      _PulsingHalo(color: scheme.secondary.withOpacity(0.6)),
            Container(
              decoration: BoxDecoration(
                color: colorForReportStatus(scheme, report.status),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? scheme.primary : Colors.white,
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.alphaFrac(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _getReportCategoryIcon(report.category),
                color: Colors.white,
                size: isSelected ? 24 : 20,
              ),
            ),
            // Prioritäts-Punkt rechts oben
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: colorForReportPriority(scheme, report.priority),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getReportCategoryIcon(ReportCategory category) {
    switch (category) {
      case ReportCategory.roadsTraffic:
        return Icons.directions_car;
      case ReportCategory.publicLighting:
        return Icons.lightbulb;
      case ReportCategory.wasteManagement:
        return Icons.delete;
      case ReportCategory.parksGreenSpaces:
        return Icons.park;
      case ReportCategory.waterDrainage:
        return Icons.water_drop;
      case ReportCategory.publicFacilities:
        return Icons.domain;
      case ReportCategory.vandalism:
        return Icons.report_problem;
      case ReportCategory.environmental:
        return Icons.eco;
      case ReportCategory.accessibility:
        return Icons.accessible;
      case ReportCategory.other:
        return Icons.help_outline;
    }
  }
}

/// Generic marker widget
class _GenericMarker extends StatelessWidget {
  const _GenericMarker({
    this.label,
    required this.color,
    required this.icon,
    required this.isSelected,
    this.onTap,
  });

  final String? label;
  final Color color;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.white,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.alphaFrac(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: isSelected ? 24 : 20),
      ),
    );
  }
}

class _PulsingHalo extends StatefulWidget {
  final Color color;
  const _PulsingHalo({required this.color});
  @override
  State<_PulsingHalo> createState() => _PulsingHaloState();
}

class _PulsingHaloState extends State<_PulsingHalo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final scale = 1.0 + (_ctrl.value * 0.8);
        final opacity = (1 - _ctrl.value).clamp(0.0, 1.0);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withOpacity(0.25 * opacity),
            ),
          ),
        );
      },
    );
  }
}
