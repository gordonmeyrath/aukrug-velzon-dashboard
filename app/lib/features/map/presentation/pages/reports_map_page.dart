import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/color_extensions.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../reports/domain/report.dart';
import '../../../reports/presentation/reports_provider.dart';
import '../widgets/aukrug_map.dart';
import '../widgets/map_marker_factory.dart';

/// Page showing all reports on an interactive map
class ReportsMapPage extends ConsumerStatefulWidget {
  const ReportsMapPage({super.key});

  @override
  ConsumerState<ReportsMapPage> createState() => _ReportsMapPageState();
}

class _ReportsMapPageState extends ConsumerState<ReportsMapPage> {
  Report? _selectedReport;
  ReportCategory? _filterCategory;
  ReportStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(allReportsProvider);

    return AppScaffold(
      title: 'Meldungen Karte',
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: _showFilterDialog,
        ),
      ],
      body: Column(
        children: [
          // Filter status bar
          if (_filterCategory != null || _filterStatus != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Row(
                children: [
                  const Icon(Icons.filter_list, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      children: [
                        if (_filterCategory != null)
                          Chip(
                            label: Text(_filterCategory!.displayName),
                            onDeleted: () {
                              setState(() {
                                _filterCategory = null;
                              });
                            },
                          ),
                        if (_filterStatus != null)
                          Chip(
                            label: Text(_filterStatus!.displayName),
                            onDeleted: () {
                              setState(() {
                                _filterStatus = null;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _filterCategory = null;
                        _filterStatus = null;
                      });
                    },
                    child: const Text('Alle Filter löschen'),
                  ),
                ],
              ),
            ),

          // Map
          Expanded(
            child: reportsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Fehler beim Laden der Meldungen',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              data: (reports) {
                // Apply filters
                final filteredReports = reports.where((report) {
                  if (_filterCategory != null &&
                      report.category != _filterCategory) {
                    return false;
                  }
                  if (_filterStatus != null && report.status != _filterStatus) {
                    return false;
                  }
                  return true;
                }).toList();

                // Create markers
                final markers = filteredReports.map((report) {
                  return MapMarkerFactory.createReportMarker(
                    report,
                    isSelected: _selectedReport?.id == report.id,
                    onTap: () {
                      setState(() {
                        _selectedReport = report;
                      });
                      _showReportDetails(report);
                    },
                  );
                }).toList();

                return Stack(
                  children: [
                    AukrugMap(
                      markers: markers,
                      showUserLocation: true,
                      onMapTap: (latLng) {
                        setState(() {
                          _selectedReport = null;
                        });
                      },
                    ),

                    // Legend
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Legende',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 8),
                              _LegendItem(
                                color: Colors.blue,
                                label: 'Neu/In Bearbeitung',
                              ),
                              _LegendItem(
                                color: Colors.orange,
                                label: 'In Bearbeitung',
                              ),
                              _LegendItem(
                                color: Colors.green,
                                label: 'Erledigt',
                              ),
                              _LegendItem(
                                color: Colors.red,
                                label: 'Abgelehnt',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Stats card
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Meldungen',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${filteredReports.length} von ${reports.length}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/resident/report');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kategorie', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              DropdownButtonFormField<ReportCategory?>(
                value: _filterCategory,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: [
                  const DropdownMenuItem<ReportCategory?>(
                    value: null,
                    child: Text('Alle Kategorien'),
                  ),
                  ...ReportCategory.values.map((category) {
                    return DropdownMenuItem<ReportCategory?>(
                      value: category,
                      child: Text(category.displayName),
                    );
                  }),
                ],
                onChanged: (value) {
                  setDialogState(() {
                    _filterCategory = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              Text('Status', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              DropdownButtonFormField<ReportStatus?>(
                value: _filterStatus,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: [
                  const DropdownMenuItem<ReportStatus?>(
                    value: null,
                    child: Text('Alle Status'),
                  ),
                  ...ReportStatus.values.map((status) {
                    return DropdownMenuItem<ReportStatus?>(
                      value: status,
                      child: Text(status.displayName),
                    );
                  }),
                ],
                onChanged: (value) {
                  setDialogState(() {
                    _filterStatus = value;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                // Values are already set in the dialog
              });
              Navigator.of(context).pop();
            },
            child: const Text('Anwenden'),
          ),
        ],
      ),
    );
  }

  void _showReportDetails(Report report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getStatusColor(report.status),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getCategoryIcon(report.category),
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                report.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                report.category.displayName,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              report.status,
                            ).alphaFrac(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            report.status.displayName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _getStatusColor(report.status),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Description
                    Text(
                      'Beschreibung',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 16),

                    // Location
                    Text(
                      'Standort',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            report.location.address ??
                                'Kein Standort angegeben',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pushNamed(context, '/resident/reports');
                            },
                            icon: const Icon(Icons.list),
                            label: const Text('Alle Meldungen'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pushNamed(context, '/resident/report');
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Neue Meldung'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.submitted:
      case ReportStatus.received:
        return Colors.blue;
      case ReportStatus.inProgress:
        return Colors.orange;
      case ReportStatus.resolved:
      case ReportStatus.closed:
        return Colors.green;
      case ReportStatus.rejected:
        return Colors.red;
    }
  }

  IconData _getCategoryIcon(ReportCategory category) {
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

/// Legend item widget
class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
