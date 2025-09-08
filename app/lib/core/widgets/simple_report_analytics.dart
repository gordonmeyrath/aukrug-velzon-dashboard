import 'package:flutter/material.dart';

import '../../../features/reports/domain/report.dart';

/// Simple report analytics widget with basic insights
class SimpleReportAnalytics extends StatelessWidget {
  final List<Report> reports;

  const SimpleReportAnalytics({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewCard(context),
          const SizedBox(height: 16),
          _buildCategoryCard(context),
          const SizedBox(height: 16),
          _buildStatusCard(context),
          const SizedBox(height: 16),
          _buildPriorityCard(context),
          const SizedBox(height: 16),
          _buildInsightsCard(context),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(BuildContext context) {
    final totalReports = reports.length;
    final activeReports = reports
        .where(
          (r) =>
              r.status != ReportStatus.resolved &&
              r.status != ReportStatus.closed,
        )
        .length;
    final resolvedReports = reports
        .where((r) => r.status == ReportStatus.resolved)
        .length;
    final averageResolutionRate = totalReports > 0
        ? (resolvedReports / totalReports * 100)
        : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Übersicht',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
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
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Aktiv',
                    activeReports.toString(),
                    Icons.pending_actions,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Gelöst',
                    resolvedReports.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Erfolgsrate',
                    '${averageResolutionRate.toStringAsFixed(1)}%',
                    Icons.trending_up,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context) {
    final categoryData = <ReportCategory, int>{};

    for (final category in ReportCategory.values) {
      categoryData[category] = reports
          .where((r) => r.category == category)
          .length;
    }

    final totalReports = reports.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kategorien',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...categoryData.entries
                .where((entry) => entry.value > 0)
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _buildProgressBar(
                      context,
                      entry.key.displayName,
                      entry.value,
                      totalReports,
                      _getCategoryColor(entry.key),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final statusData = <ReportStatus, int>{};

    for (final status in ReportStatus.values) {
      statusData[status] = reports.where((r) => r.status == status).length;
    }

    final totalReports = reports.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...statusData.entries
                .where((entry) => entry.value > 0)
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _buildProgressBar(
                      context,
                      entry.key.displayName,
                      entry.value,
                      totalReports,
                      _getStatusColor(entry.key),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityCard(BuildContext context) {
    final priorityData = <ReportPriority, int>{};

    for (final priority in ReportPriority.values) {
      priorityData[priority] = reports
          .where((r) => r.priority == priority)
          .length;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prioritäten',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...priorityData.entries
                .where((entry) => entry.value > 0)
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getPriorityColor(entry.key),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(entry.key.displayName)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(
                              entry.key,
                            ).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${entry.value}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getPriorityColor(entry.key),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(
    BuildContext context,
    String label,
    int count,
    int total,
    Color color,
  ) {
    final percentage = total > 0 ? (count / total) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ),
            Text(
              '$count (${(percentage * 100).toStringAsFixed(1)}%)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildInsightsCard(BuildContext context) {
    final insights = _generateInsights();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Erkenntnisse',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...insights.map(
              (insight) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(insight.icon, color: insight.color, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        insight.text,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<AnalyticsInsight> _generateInsights() {
    final insights = <AnalyticsInsight>[];

    if (reports.isEmpty) {
      insights.add(
        AnalyticsInsight(
          text: 'Keine Meldungen vorhanden',
          icon: Icons.info,
          color: Colors.grey,
        ),
      );
      return insights;
    }

    // Most common category
    final categoryCount = <ReportCategory, int>{};
    for (final report in reports) {
      categoryCount[report.category] =
          (categoryCount[report.category] ?? 0) + 1;
    }

    if (categoryCount.isNotEmpty) {
      final mostCommon = categoryCount.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      insights.add(
        AnalyticsInsight(
          text:
              'Häufigste Kategorie: ${mostCommon.key.displayName} (${mostCommon.value} Meldungen)',
          icon: Icons.trending_up,
          color: Colors.blue,
        ),
      );
    }

    // Active reports warning
    final activeCount = reports
        .where(
          (r) =>
              r.status != ReportStatus.resolved &&
              r.status != ReportStatus.closed,
        )
        .length;

    if (activeCount > reports.length * 0.5) {
      insights.add(
        AnalyticsInsight(
          text:
              'Hohe Anzahl aktiver Meldungen ($activeCount) - Bearbeitung priorisieren',
          icon: Icons.warning,
          color: Colors.orange,
        ),
      );
    }

    // Urgent priority count
    final urgentCount = reports
        .where((r) => r.priority == ReportPriority.urgent)
        .length;
    if (urgentCount > 0) {
      insights.add(
        AnalyticsInsight(
          text:
              '$urgentCount dringende Meldungen erfordern sofortige Aufmerksamkeit',
          icon: Icons.priority_high,
          color: Colors.red,
        ),
      );
    }

    // Success rate
    final resolvedCount = reports
        .where((r) => r.status == ReportStatus.resolved)
        .length;
    final successRate = reports.isNotEmpty
        ? (resolvedCount / reports.length * 100)
        : 0.0;

    if (successRate >= 80) {
      insights.add(
        AnalyticsInsight(
          text: 'Sehr gute Erfolgsrate von ${successRate.toStringAsFixed(1)}%',
          icon: Icons.emoji_events,
          color: Colors.green,
        ),
      );
    } else if (successRate < 50) {
      insights.add(
        AnalyticsInsight(
          text:
              'Niedrige Erfolgsrate von ${successRate.toStringAsFixed(1)}% - Verbesserung erforderlich',
          icon: Icons.trending_down,
          color: Colors.red,
        ),
      );
    }

    // Photo attachment rate
    final photoCount = reports
        .where((r) => r.imageUrls != null && r.imageUrls!.isNotEmpty)
        .length;
    final photoRate = (photoCount / reports.length * 100);

    if (photoRate > 70) {
      insights.add(
        AnalyticsInsight(
          text:
              'Gute Foto-Quote von ${photoRate.toStringAsFixed(1)}% unterstützt schnelle Bearbeitung',
          icon: Icons.camera_alt,
          color: Colors.green,
        ),
      );
    }

    return insights;
  }

  Color _getCategoryColor(ReportCategory category) {
    switch (category) {
      case ReportCategory.roadsTraffic:
        return Colors.blue;
      case ReportCategory.publicLighting:
        return Colors.yellow;
      case ReportCategory.wasteManagement:
        return Colors.brown;
      case ReportCategory.parksGreenSpaces:
        return Colors.green;
      case ReportCategory.waterDrainage:
        return Colors.lightBlue;
      case ReportCategory.publicFacilities:
        return Colors.orange;
      case ReportCategory.vandalism:
        return Colors.red;
      case ReportCategory.environmental:
        return Colors.teal;
      case ReportCategory.accessibility:
        return Colors.purple;
      case ReportCategory.other:
        return Colors.grey;
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
}

class AnalyticsInsight {
  final String text;
  final IconData icon;
  final Color color;

  AnalyticsInsight({
    required this.text,
    required this.icon,
    required this.color,
  });
}
