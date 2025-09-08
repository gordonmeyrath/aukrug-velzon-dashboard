import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/color_extensions.dart';
import '../../../core/services/demo_content_service.dart';
import '../../auth/presentation/widgets/user_profile_widget.dart';

/// Demo Reports List Page mit DSGVO-konformen Demo-Daten
class DemoReportsListPage extends ConsumerWidget {
  const DemoReportsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DemoBanner(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meldungen'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => _showUserProfile(context),
            ),
          ],
        ),
        body: Column(
          children: [
            // Demo Status Banner
            const DemoStatusWidget(),

            // Reports List
            Expanded(
              child: ListView.builder(
                itemCount: DemoContentService.demoReports.length,
                itemBuilder: (context, index) {
                  final report = DemoContentService.demoReports[index];
                  return _buildReportCard(context, report);
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showCreateReportDemo(context),
          icon: const Icon(Icons.add),
          label: const Text('Neue Meldung'),
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, Map<String, dynamic> report) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(report['status']),
          child: Icon(
            _getCategoryIcon(report['category']),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          report['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              report['description'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    report['location']['address'],
                    style: theme.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(
                    report['status'],
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: _getStatusColor(
                    report['status'],
                  ).alphaFrac(0.2),
                  side: BorderSide(
                    color: _getStatusColor(report['status']),
                    width: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    report['priority'],
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: _getPriorityColor(
                    report['priority'],
                  ).alphaFrac(0.2),
                  side: BorderSide(
                    color: _getPriorityColor(report['priority']),
                    width: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _showReportDetails(context, report),
        isThreeLine: true,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'offen':
        return Colors.orange;
      case 'in_bearbeitung':
        return Colors.blue;
      case 'erledigt':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'niedrig':
        return Colors.green;
      case 'mittel':
        return Colors.orange;
      case 'hoch':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'straßenschäden':
        return Icons.construction;
      case 'beleuchtung':
        return Icons.lightbulb;
      case 'umwelt':
        return Icons.nature;
      case 'verkehr':
        return Icons.traffic;
      case 'sicherheit':
        return Icons.security;
      default:
        return Icons.report_problem;
    }
  }

  void _showReportDetails(BuildContext context, Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(report['title']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Kategorie: ${report['category']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(report['description']),
              const SizedBox(height: 16),
              Text(
                'Status: ${report['status']}',
                style: TextStyle(
                  color: _getStatusColor(report['status']),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Priorität: ${report['priority']}',
                style: TextStyle(
                  color: _getPriorityColor(report['priority']),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 4),
                  Expanded(child: Text(report['location']['address'])),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.alphaFrac(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Dies ist eine Demo-Meldung mit Beispieldaten.',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  void _showCreateReportDemo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Demo-Modus'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.science, size: 48, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              'In der Demo-Version können keine echten Meldungen erstellt werden.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.alphaFrac(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.security, color: Colors.green, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'DSGVO-Compliance',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Die echte App würde hier eine vollständig DSGVO-konforme Eingabemaske für neue Meldungen zeigen, inklusive expliziter Einwilligungen für GPS und Fotos.',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Verstanden'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/privacy-settings');
            },
            child: const Text('Privacy-Einstellungen'),
          ),
        ],
      ),
    );
  }

  void _showUserProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserProfileWidget(),
            SizedBox(height: 16),
            DemoPrivacyNotice(),
          ],
        ),
      ),
    );
  }
}
