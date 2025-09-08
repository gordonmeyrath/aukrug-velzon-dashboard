import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/reports/domain/report.dart';
import '../status/enhanced_status_manager.dart';

/// Enhanced status dashboard widget with intelligent insights
class EnhancedStatusDashboard extends ConsumerStatefulWidget {
  final int reportId;
  final bool showHistory;
  final bool allowStatusChange;
  final Function(ReportStatus)? onStatusChanged;

  const EnhancedStatusDashboard({
    super.key,
    required this.reportId,
    this.showHistory = true,
    this.allowStatusChange = false,
    this.onStatusChanged,
  });

  @override
  ConsumerState<EnhancedStatusDashboard> createState() =>
      _EnhancedStatusDashboardState();
}

class _EnhancedStatusDashboardState
    extends ConsumerState<EnhancedStatusDashboard>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusManager = ref.watch(enhancedStatusManagerProvider);
    final statusInfo = statusManager.getStatusInfo(widget.reportId);

    // Animate progress when workflow is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (statusInfo.workflow != null) {
        _progressController.animateTo(statusInfo.workflow!.progressPercentage);
      }
    });

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(statusInfo),
            const SizedBox(height: 16),
            _buildProgressSection(statusInfo),
            if (statusInfo.workflow != null) ...[
              const SizedBox(height: 16),
              _buildWorkflowVisualization(statusInfo.workflow!),
            ],
            if (statusInfo.estimatedCompletion != null) ...[
              const SizedBox(height: 12),
              _buildEstimatedCompletion(statusInfo.estimatedCompletion!),
            ],
            if (widget.allowStatusChange) ...[
              const SizedBox(height: 16),
              _buildStatusActions(statusInfo),
            ],
            if (widget.showHistory && statusInfo.statusHistory.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildStatusHistory(statusInfo.statusHistory),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(EnhancedStatusInfo statusInfo) {
    return Row(
      children: [
        _buildStatusIcon(statusInfo.currentStatus, statusInfo.isAutomated),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                statusInfo.currentStatus.displayName,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (statusInfo.workflow != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _getWorkflowTypeDisplayName(statusInfo.workflow!.type),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (statusInfo.isAutomated) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Automatisch',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
        _buildStatusChip(statusInfo.currentStatus),
      ],
    );
  }

  Widget _buildStatusIcon(ReportStatus status, bool isAutomated) {
    final icon = _getStatusIcon(status);
    final color = _getStatusColor(status);

    Widget iconWidget = Icon(icon, color: color, size: 32);

    if (isAutomated && _isActiveStatus(status)) {
      iconWidget = AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _pulseAnimation.value, child: child);
        },
        child: iconWidget,
      );
    }

    return iconWidget;
  }

  Widget _buildProgressSection(EnhancedStatusInfo statusInfo) {
    final progress = statusInfo.workflow?.progressPercentage ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Fortschritt',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return LinearProgressIndicator(
              value: _progressAnimation.value * progress,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getStatusColor(statusInfo.currentStatus),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWorkflowVisualization(ReportStatusWorkflow workflow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workflow-Schritte',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: workflow.estimatedSteps.length,
            itemBuilder: (context, index) {
              final step = workflow.estimatedSteps[index];
              final isCompleted = _isStepCompleted(step, workflow);
              final isCurrent = step.status == workflow.currentStatus;

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _buildWorkflowStep(step, isCompleted, isCurrent),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWorkflowStep(
    WorkflowStep step,
    bool isCompleted,
    bool isCurrent,
  ) {
    Color color;
    IconData icon;

    if (isCompleted) {
      color = Colors.green;
      icon = Icons.check_circle;
    } else if (isCurrent) {
      color = Theme.of(context).colorScheme.primary;
      icon = Icons.radio_button_checked;
    } else {
      color = Theme.of(context).colorScheme.outline;
      icon = Icons.radio_button_unchecked;
    }

    Widget stepWidget = Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          step.displayName,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
        if (step.isOptional) ...[
          const SizedBox(height: 2),
          Text(
            'Optional',
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );

    if (isCurrent && _isActiveStatus(step.status)) {
      stepWidget = AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _pulseAnimation.value, child: child);
        },
        child: stepWidget,
      );
    }

    return SizedBox(width: 80, child: stepWidget);
  }

  Widget _buildEstimatedCompletion(DateTime estimatedCompletion) {
    final now = DateTime.now();
    final difference = estimatedCompletion.difference(now);
    final isOverdue = difference.isNegative;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOverdue
            ? Theme.of(context).colorScheme.errorContainer
            : Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isOverdue ? Icons.schedule_rounded : Icons.schedule,
            color: isOverdue
                ? Theme.of(context).colorScheme.onErrorContainer
                : Theme.of(context).colorScheme.onPrimaryContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isOverdue
                  ? 'Überfällig seit ${_formatDuration(difference.abs())}'
                  : 'Geschätzte Fertigstellung in ${_formatDuration(difference)}',
              style: TextStyle(
                color: isOverdue
                    ? Theme.of(context).colorScheme.onErrorContainer
                    : Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusActions(EnhancedStatusInfo statusInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mögliche Aktionen',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: statusInfo.nextPossibleStatuses.map((status) {
            return ActionChip(
              label: Text(status.displayName),
              avatar: Icon(_getStatusIcon(status), size: 16),
              onPressed: () {
                if (widget.onStatusChanged != null) {
                  widget.onStatusChanged!(status);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusHistory(List<StatusUpdateRecord> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verlauf',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...history.reversed.take(3).map((record) => _buildHistoryItem(record)),
        if (history.length > 3)
          TextButton(
            onPressed: () => _showFullHistory(history),
            child: Text('Alle ${history.length} Einträge anzeigen'),
          ),
      ],
    );
  }

  Widget _buildHistoryItem(StatusUpdateRecord record) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(record.toStatus),
            size: 16,
            color: _getStatusColor(record.toStatus),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${record.fromStatus.displayName} → ${record.toStatus.displayName}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                if (record.reason != null)
                  Text(
                    record.reason!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            _formatTimestamp(record.timestamp),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ReportStatus status) {
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
          fontWeight: FontWeight.w600,
          color: _getStatusColor(status),
        ),
      ),
    );
  }

  bool _isStepCompleted(WorkflowStep step, ReportStatusWorkflow workflow) {
    final stepIndex = workflow.estimatedSteps.indexOf(step);
    final currentIndex = workflow.estimatedSteps.indexWhere(
      (s) => s.status == workflow.currentStatus,
    );
    return stepIndex < currentIndex;
  }

  bool _isActiveStatus(ReportStatus status) {
    return status == ReportStatus.inProgress || status == ReportStatus.received;
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

  String _getWorkflowTypeDisplayName(StatusWorkflowType type) {
    switch (type) {
      case StatusWorkflowType.standard:
        return 'Standard-Workflow';
      case StatusWorkflowType.urgentInfrastructure:
        return 'Dringende Infrastruktur';
      case StatusWorkflowType.standardInfrastructure:
        return 'Standard-Infrastruktur';
      case StatusWorkflowType.investigation:
        return 'Untersuchung';
      case StatusWorkflowType.maintenance:
        return 'Wartung';
      case StatusWorkflowType.serviceRequest:
        return 'Service-Anfrage';
      case StatusWorkflowType.standardEnvironmental:
        return 'Standard-Umwelt';
      case StatusWorkflowType.urgentEnvironmental:
        return 'Dringende Umwelt';
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} Tag${duration.inDays != 1 ? 'e' : ''}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} Stunde${duration.inHours != 1 ? 'n' : ''}';
    } else {
      return '${duration.inMinutes} Minute${duration.inMinutes != 1 ? 'n' : ''}';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return 'vor ${difference.inDays} Tag${difference.inDays != 1 ? 'en' : ''}';
    } else if (difference.inHours > 0) {
      return 'vor ${difference.inHours} Stunde${difference.inHours != 1 ? 'n' : ''}';
    } else {
      return 'vor ${difference.inMinutes} Minute${difference.inMinutes != 1 ? 'n' : ''}';
    }
  }

  void _showFullHistory(List<StatusUpdateRecord> history) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Vollständiger Status-Verlauf',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildHistoryItem(
                        history.reversed.toList()[index],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
