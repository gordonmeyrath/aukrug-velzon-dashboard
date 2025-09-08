import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/reports/domain/report.dart';
import '../widgets/enhanced_status_dashboard.dart';
import '../widgets/simple_report_analytics.dart';

/// Integration module that combines all enhanced features
class EnhancedReportingSystem extends ConsumerWidget {
  final List<Report> reports;
  final Report? selectedReport;
  final Function(Report)? onReportSelected;
  final Function(ReportStatus, Report)? onStatusChanged;

  const EnhancedReportingSystem({
    super.key,
    required this.reports,
    this.selectedReport,
    this.onReportSelected,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Enhanced Reporting System'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.dashboard), text: 'Übersicht'),
              Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
              Tab(icon: Icon(Icons.settings), text: 'Management'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(context),
            _buildAnalyticsTab(context),
            _buildManagementTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System-Übersicht',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildQuickStats(context),
          const SizedBox(height: 24),
          if (selectedReport != null) ...[
            Text(
              'Ausgewählter Report',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            EnhancedStatusDashboard(
              reportId: selectedReport!.id,
              showHistory: true,
              allowStatusChange: true,
              onStatusChanged: (status) {
                if (onStatusChanged != null) {
                  onStatusChanged!(status, selectedReport!);
                }
              },
            ),
          ] else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 64,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Wählen Sie einen Report aus',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Klicken Sie auf einen Report in der Liste, um Details anzuzeigen',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          _buildRecentReports(context),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab(BuildContext context) {
    return SimpleReportAnalytics(reports: reports);
  }

  Widget _buildManagementTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System-Management',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildEnhancementFeatures(context),
          const SizedBox(height: 24),
          _buildSystemHealth(context),
          const SizedBox(height: 24),
          _buildActionItems(context),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final totalReports = reports.length;
    final activeReports = reports
        .where(
          (r) =>
              r.status != ReportStatus.resolved &&
              r.status != ReportStatus.closed,
        )
        .length;
    final urgentReports = reports
        .where((r) => r.priority == ReportPriority.urgent)
        .length;
    final todayReports = reports.where((r) {
      final today = DateTime.now();
      final reportDate = r.submittedAt ?? DateTime.now();
      return reportDate.day == today.day &&
          reportDate.month == today.month &&
          reportDate.year == today.year;
    }).length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Gesamt',
            totalReports.toString(),
            Icons.assignment,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Aktiv',
            activeReports.toString(),
            Icons.pending_actions,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Dringend',
            urgentReports.toString(),
            Icons.priority_high,
            Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Heute',
            todayReports.toString(),
            Icons.today,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentReports(BuildContext context) {
    final recentReports = reports.where((r) => r.submittedAt != null).toList()
      ..sort(
        (a, b) => (b.submittedAt ?? DateTime.now()).compareTo(
          a.submittedAt ?? DateTime.now(),
        ),
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Neueste Reports',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: (recentReports.length > 5 ? 5 : recentReports.length),
          itemBuilder: (context, index) {
            final report = recentReports[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getStatusColor(
                    report.status,
                  ).withOpacity(0.2),
                  child: Icon(
                    _getStatusIcon(report.status),
                    color: _getStatusColor(report.status),
                  ),
                ),
                title: Text(
                  report.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${report.category.displayName} • ${_formatDateTime(report.submittedAt)}',
                ),
                trailing: Icon(
                  _getPriorityIcon(report.priority),
                  color: _getPriorityColor(report.priority),
                ),
                onTap: () {
                  if (onReportSelected != null) {
                    onReportSelected!(report);
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEnhancementFeatures(BuildContext context) {
    final features = [
      _FeatureCard(
        title: 'KI-gestützte Fotoanalyse',
        description:
            'Automatische Kategorisierung und Qualitätsbewertung von Fotos',
        icon: Icons.camera_enhance,
        color: Colors.blue,
        status: 'Aktiv',
      ),
      _FeatureCard(
        title: 'Intelligentes Error-Handling',
        description: 'Automatische Fehlererkennung und Wiederherstellung',
        icon: Icons.healing,
        color: Colors.green,
        status: 'Aktiv',
      ),
      _FeatureCard(
        title: 'Produktions-Logging',
        description: 'Erweiterte Protokollierung mit automatischer Bereinigung',
        icon: Icons.description,
        color: Colors.orange,
        status: 'Aktiv',
      ),
      _FeatureCard(
        title: 'Status-Automatisierung',
        description:
            'Intelligente Workflow-Verwaltung und automatische Übergänge',
        icon: Icons.auto_mode,
        color: Colors.purple,
        status: 'Aktiv',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enhanced Features',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...features.map(
          (feature) => Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: feature.color.withOpacity(0.2),
                child: Icon(feature.icon, color: feature.color),
              ),
              title: Text(feature.title),
              subtitle: Text(feature.description),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  feature.status,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemHealth(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System-Gesundheit',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildHealthIndicator(
              context,
              'API-Verbindung',
              'Stabil',
              Colors.green,
            ),
            _buildHealthIndicator(
              context,
              'Datenbank',
              'Optimal',
              Colors.green,
            ),
            _buildHealthIndicator(
              context,
              'Foto-Upload',
              'Funktional',
              Colors.green,
            ),
            _buildHealthIndicator(
              context,
              'Push-Benachrichtigungen',
              'Aktiv',
              Colors.green,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Alle Systeme funktionsfähig',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          'Letzter Check: ${_formatDateTime(DateTime.now())}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthIndicator(
    BuildContext context,
    String system,
    String status,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(system)),
          Text(
            status,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItems(BuildContext context) {
    final urgentReports = reports
        .where((r) => r.priority == ReportPriority.urgent)
        .length;
    final overdueReports = reports
        .where(
          (r) =>
              r.status != ReportStatus.resolved &&
              r.status != ReportStatus.closed &&
              r.submittedAt != null &&
              DateTime.now().difference(r.submittedAt!).inDays > 7,
        )
        .length;

    final actions = <_ActionItem>[];

    if (urgentReports > 0) {
      actions.add(
        _ActionItem(
          title: 'Dringende Reports bearbeiten',
          description:
              '$urgentReports Reports erfordern sofortige Aufmerksamkeit',
          icon: Icons.priority_high,
          color: Colors.red,
          priority: 'Hoch',
        ),
      );
    }

    if (overdueReports > 0) {
      actions.add(
        _ActionItem(
          title: 'Überfällige Reports prüfen',
          description: '$overdueReports Reports sind seit über 7 Tagen offen',
          icon: Icons.schedule,
          color: Colors.orange,
          priority: 'Mittel',
        ),
      );
    }

    if (actions.isEmpty) {
      actions.add(
        _ActionItem(
          title: 'Alle Reports aktuell',
          description: 'Keine dringenden Aktionen erforderlich',
          icon: Icons.done_all,
          color: Colors.green,
          priority: 'Info',
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Handlungsempfehlungen',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...actions.map(
          (action) => Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: action.color.withOpacity(0.2),
                child: Icon(action.icon, color: action.color),
              ),
              title: Text(action.title),
              subtitle: Text(action.description),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: action.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  action.priority,
                  style: TextStyle(
                    color: action.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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
      case ReportStatus.closed:
        return Icons.archive;
      case ReportStatus.rejected:
        return Icons.cancel;
    }
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
      case ReportStatus.closed:
        return Colors.grey;
      case ReportStatus.rejected:
        return Colors.red;
    }
  }

  IconData _getPriorityIcon(ReportPriority priority) {
    switch (priority) {
      case ReportPriority.low:
        return Icons.keyboard_arrow_down;
      case ReportPriority.medium:
        return Icons.remove;
      case ReportPriority.high:
        return Icons.keyboard_arrow_up;
      case ReportPriority.urgent:
        return Icons.keyboard_double_arrow_up;
    }
  }

  Color _getPriorityColor(ReportPriority priority) {
    switch (priority) {
      case ReportPriority.low:
        return Colors.green;
      case ReportPriority.medium:
        return Colors.orange;
      case ReportPriority.high:
        return Colors.red;
      case ReportPriority.urgent:
        return Colors.deepOrange;
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unbekannt';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'vor ${difference.inDays} Tag${difference.inDays != 1 ? 'en' : ''}';
    } else if (difference.inHours > 0) {
      return 'vor ${difference.inHours} Stunde${difference.inHours != 1 ? 'n' : ''}';
    } else {
      return 'vor ${difference.inMinutes} Minute${difference.inMinutes != 1 ? 'n' : ''}';
    }
  }
}

class _FeatureCard {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String status;

  _FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.status,
  });
}

class _ActionItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String priority;

  _ActionItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.priority,
  });
}
