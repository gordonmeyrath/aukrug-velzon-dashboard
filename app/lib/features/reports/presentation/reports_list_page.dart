import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/report.dart';
import 'reports_provider.dart';

/// Helper extension to get icons for report categories
extension ReportCategoryExtension on ReportCategory {
  IconData get icon {
    switch (this) {
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

class ReportsListPage extends ConsumerStatefulWidget {
  const ReportsListPage({super.key});

  @override
  ConsumerState<ReportsListPage> createState() => _ReportsListPageState();
}

class _ReportsListPageState extends ConsumerState<ReportsListPage> {
  final _searchController = TextEditingController();
  ReportCategory? _selectedCategory;
  ReportStatus? _selectedStatus;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(reportsSearchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meldungen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.pushNamed(context, '/resident/reports/map');
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/resident/report');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Meldungen durchsuchen',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _performSearch();
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      _performSearch();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Filter Row
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<ReportCategory>(
                          decoration: const InputDecoration(
                            labelText: 'Kategorie',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedCategory,
                          items: [
                            const DropdownMenuItem<ReportCategory>(
                              value: null,
                              child: Text('Alle Kategorien'),
                            ),
                            ...ReportCategory.values.map((category) {
                              return DropdownMenuItem<ReportCategory>(
                                value: category,
                                child: Row(
                                  children: [
                                    Icon(category.icon, size: 16),
                                    const SizedBox(width: 8),
                                    Text(category.displayName),
                                  ],
                                ),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                            _performSearch();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<ReportStatus>(
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedStatus,
                          items: [
                            const DropdownMenuItem<ReportStatus>(
                              value: null,
                              child: Text('Alle Status'),
                            ),
                            ...ReportStatus.values.map((status) {
                              return DropdownMenuItem<ReportStatus>(
                                value: status,
                                child: Row(
                                  children: [
                                    Icon(_getStatusIcon(status), size: 16),
                                    const SizedBox(width: 8),
                                    Text(status.displayName),
                                  ],
                                ),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value;
                            });
                            _performSearch();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Reports List
          Expanded(
            child: reportsAsync.when(
              data: (reports) {
                if (reports.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Keine Meldungen gefunden',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Versuchen Sie andere Suchkriterien oder erstellen Sie eine neue Meldung.',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return ReportCard(
                      report: report,
                      onTap: () {
                        _showReportDetails(context, report);
                      },
                    );
                  },
                );
              },
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
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(reportsSearchProvider);
                      },
                      child: const Text('Erneut versuchen'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch() {
    final notifier = ref.read(reportsSearchProvider.notifier);
    notifier.search(
      _searchController.text,
      category: _selectedCategory,
      status: _selectedStatus,
    );
  }

  IconData _getStatusIcon(ReportStatus status) {
    switch (status) {
      case ReportStatus.submitted:
        return Icons.send;
      case ReportStatus.received:
        return Icons.visibility;
      case ReportStatus.inProgress:
        return Icons.build;
      case ReportStatus.resolved:
        return Icons.check_circle;
      case ReportStatus.rejected:
        return Icons.cancel;
      case ReportStatus.closed:
        return Icons.archive;
    }
  }

  void _showReportDetails(BuildContext context, Report report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => ReportDetailsSheet(
          report: report,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

/// Widget for displaying a report card in the list
class ReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback? onTap;

  const ReportCard({super.key, required this.report, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    report.category.icon,
                    size: 20,
                    color: _getCategoryColor(report.category),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      report.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _StatusChip(status: report.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                report.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      report.location.address ?? 'Kein Standort angegeben',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (report.submittedAt != null) ...[
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(report.submittedAt!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(ReportCategory category) {
    switch (category) {
      case ReportCategory.roadsTraffic:
        return Colors.blue;
      case ReportCategory.publicLighting:
        return Colors.amber;
      case ReportCategory.wasteManagement:
        return Colors.brown;
      case ReportCategory.parksGreenSpaces:
        return Colors.green;
      case ReportCategory.waterDrainage:
        return Colors.cyan;
      case ReportCategory.publicFacilities:
        return Colors.purple;
      case ReportCategory.vandalism:
        return Colors.red;
      case ReportCategory.environmental:
        return Colors.teal;
      case ReportCategory.accessibility:
        return Colors.orange;
      case ReportCategory.other:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Heute';
    } else if (difference.inDays == 1) {
      return 'Gestern';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} Tage';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}

/// Widget for displaying report status as a chip
class _StatusChip extends StatelessWidget {
  final ReportStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _getStatusColor(status),
        ),
      ),
    );
  }

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.submitted:
        return Colors.blue;
      case ReportStatus.received:
        return Colors.orange;
      case ReportStatus.inProgress:
        return Colors.purple;
      case ReportStatus.resolved:
        return Colors.green;
      case ReportStatus.rejected:
        return Colors.red;
      case ReportStatus.closed:
        return Colors.grey;
    }
  }
}

/// Bottom sheet for displaying report details
class ReportDetailsSheet extends StatelessWidget {
  final Report report;
  final ScrollController scrollController;

  const ReportDetailsSheet({
    super.key,
    required this.report,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    Icon(
                      report.category.icon,
                      size: 24,
                      color: _getCategoryColor(report.category),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        report.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _StatusChip(status: report.status),

                const SizedBox(height: 24),

                // Description
                Text(
                  'Beschreibung',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  report.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 24),

                // Location
                Text(
                  'Standort',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        report.location.address ?? 'Kein Standort angegeben',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Details
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DetailRow('Kategorie', report.category.displayName),
                        const SizedBox(height: 8),
                        _DetailRow('Priorität', report.priority.displayName),
                        const SizedBox(height: 8),
                        _DetailRow('Status', report.status.displayName),
                        if (report.submittedAt != null) ...[
                          const SizedBox(height: 8),
                          _DetailRow(
                            'Eingereicht',
                            _formatDateTime(report.submittedAt!),
                          ),
                        ],
                        if (report.referenceNumber != null) ...[
                          const SizedBox(height: 8),
                          _DetailRow('Referenznummer', report.referenceNumber!),
                        ],
                      ],
                    ),
                  ),
                ),

                // Municipal Response
                if (report.municipalityResponse != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Antwort der Verwaltung',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.municipalityResponse!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (report.responseAt != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Antwort vom ${_formatDateTime(report.responseAt!)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(ReportCategory category) {
    switch (category) {
      case ReportCategory.roadsTraffic:
        return Colors.blue;
      case ReportCategory.publicLighting:
        return Colors.amber;
      case ReportCategory.wasteManagement:
        return Colors.brown;
      case ReportCategory.parksGreenSpaces:
        return Colors.green;
      case ReportCategory.waterDrainage:
        return Colors.cyan;
      case ReportCategory.publicFacilities:
        return Colors.purple;
      case ReportCategory.vandalism:
        return Colors.red;
      case ReportCategory.environmental:
        return Colors.teal;
      case ReportCategory.accessibility:
        return Colors.orange;
      case ReportCategory.other:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}.${date.month}.${date.year} um ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} Uhr';
  }
}

/// Helper widget for detail rows
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
