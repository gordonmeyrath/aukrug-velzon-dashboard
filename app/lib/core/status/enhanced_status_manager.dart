import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/reports/domain/report.dart';
import '../util/production_logger.dart';

/// Enhanced report status management with intelligent workflows and automation
class EnhancedReportStatusManager {
  static const Duration _statusUpdateInterval = Duration(minutes: 15);
  static const Duration _notificationDelay = Duration(seconds: 2);

  final Map<int, ReportStatusWorkflow> _activeWorkflows = {};
  final Map<int, Timer> _statusTimers = {};
  final List<StatusChangeListener> _listeners = [];

  /// Initialize status manager with background monitoring
  void initialize() {
    // Start periodic status checking
    Timer.periodic(_statusUpdateInterval, (_) => _checkAllReportsStatus());

    ProductionLogger.i(
      'Enhanced report status manager initialized',
      tag: 'STATUS_MANAGER',
    );
  }

  /// Register a status change listener
  void addStatusChangeListener(StatusChangeListener listener) {
    _listeners.add(listener);
  }

  /// Remove a status change listener
  void removeStatusChangeListener(StatusChangeListener listener) {
    _listeners.remove(listener);
  }

  /// Start a status workflow for a report
  Future<void> startWorkflow(
    Report report, {
    StatusWorkflowType? customType,
  }) async {
    final workflowType = customType ?? _determineWorkflowType(report);

    final workflow = ReportStatusWorkflow(
      reportId: report.id,
      type: workflowType,
      currentStatus: report.status,
      startTime: DateTime.now(),
      estimatedSteps: _getWorkflowSteps(workflowType),
    );

    _activeWorkflows[report.id] = workflow;

    ProductionLogger.i(
      'Started workflow ${workflowType.name} for report ${report.id}',
      tag: 'STATUS_WORKFLOW',
    );

    // Notify listeners
    _notifyListeners(
      StatusChangeEvent(
        reportId: report.id,
        oldStatus: report.status,
        newStatus: report.status,
        eventType: StatusEventType.workflowStarted,
        workflow: workflow,
      ),
    );

    // Start automated progression if applicable
    if (workflowType.isAutomated) {
      _scheduleAutomaticProgression(report.id);
    }
  }

  /// Update report status with intelligent validation
  Future<StatusUpdateResult> updateStatus(
    int reportId,
    ReportStatus newStatus, {
    String? reason,
    Map<String, dynamic>? metadata,
    bool bypassValidation = false,
  }) async {
    final workflow = _activeWorkflows[reportId];
    final oldStatus = workflow?.currentStatus ?? ReportStatus.submitted;

    // Validate status transition
    if (!bypassValidation) {
      final validationResult = _validateStatusTransition(oldStatus, newStatus);
      if (!validationResult.isValid) {
        return StatusUpdateResult(
          success: false,
          error: validationResult.error,
          suggestedStatus: validationResult.suggestedAlternative,
        );
      }
    }

    // Update workflow
    if (workflow != null) {
      workflow.currentStatus = newStatus;
      workflow.updateHistory.add(
        StatusUpdateRecord(
          fromStatus: oldStatus,
          toStatus: newStatus,
          timestamp: DateTime.now(),
          reason: reason,
          metadata: metadata,
        ),
      );

      // Calculate progress
      workflow.progressPercentage = _calculateProgress(workflow);

      // Check if workflow is complete
      if (_isWorkflowComplete(workflow)) {
        workflow.completedAt = DateTime.now();
        _activeWorkflows.remove(reportId);
        _statusTimers[reportId]?.cancel();
        _statusTimers.remove(reportId);
      }
    }

    // Log status change
    ProductionLogger.i(
      'Status updated for report $reportId: ${oldStatus.name} -> ${newStatus.name}',
      tag: 'STATUS_UPDATE',
    );

    // Create status change event
    final event = StatusChangeEvent(
      reportId: reportId,
      oldStatus: oldStatus,
      newStatus: newStatus,
      eventType: StatusEventType.statusChanged,
      reason: reason,
      metadata: metadata,
      workflow: workflow,
    );

    // Notify listeners with delay for smooth UX
    Timer(_notificationDelay, () => _notifyListeners(event));

    // Schedule next automatic step if applicable
    if (workflow != null &&
        workflow.type.isAutomated &&
        !_isWorkflowComplete(workflow)) {
      _scheduleAutomaticProgression(reportId);
    }

    return StatusUpdateResult(success: true);
  }

  /// Get enhanced status information for a report
  EnhancedStatusInfo getStatusInfo(int reportId) {
    final workflow = _activeWorkflows[reportId];

    return EnhancedStatusInfo(
      currentStatus: workflow?.currentStatus ?? ReportStatus.submitted,
      workflow: workflow,
      nextPossibleStatuses: _getNextPossibleStatuses(
        workflow?.currentStatus ?? ReportStatus.submitted,
      ),
      estimatedCompletion: _estimateCompletion(workflow),
      statusHistory: workflow?.updateHistory ?? [],
      isAutomated: workflow?.type.isAutomated ?? false,
    );
  }

  /// Get all reports with active workflows
  List<ReportStatusWorkflow> getActiveWorkflows() {
    return _activeWorkflows.values.toList();
  }

  /// Cancel a workflow
  void cancelWorkflow(int reportId, {String? reason}) {
    final workflow = _activeWorkflows.remove(reportId);
    _statusTimers[reportId]?.cancel();
    _statusTimers.remove(reportId);

    if (workflow != null) {
      ProductionLogger.i(
        'Cancelled workflow for report $reportId: $reason',
        tag: 'STATUS_WORKFLOW',
      );

      _notifyListeners(
        StatusChangeEvent(
          reportId: reportId,
          oldStatus: workflow.currentStatus,
          newStatus: workflow.currentStatus,
          eventType: StatusEventType.workflowCancelled,
          reason: reason,
          workflow: workflow,
        ),
      );
    }
  }

  /// Determine appropriate workflow type based on report characteristics
  StatusWorkflowType _determineWorkflowType(Report report) {
    switch (report.category) {
      case ReportCategory.roadsTraffic:
        return report.priority == ReportPriority.urgent
            ? StatusWorkflowType.urgentInfrastructure
            : StatusWorkflowType.standardInfrastructure;

      case ReportCategory.publicLighting:
        return StatusWorkflowType.maintenance;

      case ReportCategory.wasteManagement:
        return StatusWorkflowType.serviceRequest;

      case ReportCategory.vandalism:
        return StatusWorkflowType.investigation;

      case ReportCategory.environmental:
        return report.priority == ReportPriority.urgent
            ? StatusWorkflowType.urgentEnvironmental
            : StatusWorkflowType.standardEnvironmental;

      default:
        return StatusWorkflowType.standard;
    }
  }

  /// Get workflow steps for a given type
  List<WorkflowStep> _getWorkflowSteps(StatusWorkflowType type) {
    switch (type) {
      case StatusWorkflowType.standard:
        return [
          WorkflowStep(
            ReportStatus.submitted,
            'Eingereicht',
            isOptional: false,
          ),
          WorkflowStep(ReportStatus.received, 'Erhalten', isOptional: false),
          WorkflowStep(
            ReportStatus.inProgress,
            'In Bearbeitung',
            isOptional: false,
          ),
          WorkflowStep(ReportStatus.resolved, 'Behoben', isOptional: false),
          WorkflowStep(ReportStatus.closed, 'Geschlossen', isOptional: true),
        ];

      case StatusWorkflowType.urgentInfrastructure:
        return [
          WorkflowStep(
            ReportStatus.submitted,
            'Eingereicht',
            isOptional: false,
          ),
          WorkflowStep(ReportStatus.received, 'Priorisiert', isOptional: false),
          WorkflowStep(
            ReportStatus.inProgress,
            'Sofortmaßnahmen',
            isOptional: false,
          ),
          WorkflowStep(ReportStatus.resolved, 'Behoben', isOptional: false),
        ];

      case StatusWorkflowType.investigation:
        return [
          WorkflowStep(
            ReportStatus.submitted,
            'Eingereicht',
            isOptional: false,
          ),
          WorkflowStep(ReportStatus.received, 'Validiert', isOptional: false),
          WorkflowStep(
            ReportStatus.inProgress,
            'Untersuchung',
            isOptional: false,
          ),
          WorkflowStep(
            ReportStatus.resolved,
            'Abgeschlossen',
            isOptional: false,
          ),
        ];

      case StatusWorkflowType.maintenance:
        return [
          WorkflowStep(ReportStatus.submitted, 'Gemeldet', isOptional: false),
          WorkflowStep(ReportStatus.received, 'Terminiert', isOptional: false),
          WorkflowStep(
            ReportStatus.inProgress,
            'Wartung läuft',
            isOptional: false,
          ),
          WorkflowStep(ReportStatus.resolved, 'Repariert', isOptional: false),
        ];

      case StatusWorkflowType.serviceRequest:
        return [
          WorkflowStep(
            ReportStatus.submitted,
            'Angefordert',
            isOptional: false,
          ),
          WorkflowStep(ReportStatus.received, 'Geplant', isOptional: false),
          WorkflowStep(
            ReportStatus.inProgress,
            'Service läuft',
            isOptional: false,
          ),
          WorkflowStep(ReportStatus.resolved, 'Erledigt', isOptional: false),
        ];

      case StatusWorkflowType.standardInfrastructure:
      case StatusWorkflowType.standardEnvironmental:
      case StatusWorkflowType.urgentEnvironmental:
        return _getWorkflowSteps(StatusWorkflowType.standard);
    }
  }

  /// Validate if status transition is allowed
  StatusValidationResult _validateStatusTransition(
    ReportStatus from,
    ReportStatus to,
  ) {
    final allowedTransitions = <ReportStatus, List<ReportStatus>>{
      ReportStatus.submitted: [ReportStatus.received, ReportStatus.rejected],
      ReportStatus.received: [ReportStatus.inProgress, ReportStatus.rejected],
      ReportStatus.inProgress: [ReportStatus.resolved, ReportStatus.rejected],
      ReportStatus.resolved: [
        ReportStatus.closed,
        ReportStatus.inProgress,
      ], // Allow reopening
      ReportStatus.closed: [],
      ReportStatus.rejected: [ReportStatus.received], // Allow reconsideration
    };

    final allowed = allowedTransitions[from] ?? [];

    if (allowed.contains(to)) {
      return StatusValidationResult(isValid: true);
    }

    // Suggest alternative if direct transition isn't allowed
    ReportStatus? suggestion;
    if (from == ReportStatus.submitted && to == ReportStatus.inProgress) {
      suggestion = ReportStatus.received;
    } else if (from == ReportStatus.received && to == ReportStatus.resolved) {
      suggestion = ReportStatus.inProgress;
    }

    return StatusValidationResult(
      isValid: false,
      error:
          'Direkter Übergang von ${from.displayName} zu ${to.displayName} nicht erlaubt',
      suggestedAlternative: suggestion,
    );
  }

  /// Get next possible statuses from current status
  List<ReportStatus> _getNextPossibleStatuses(ReportStatus currentStatus) {
    final transitions = <ReportStatus, List<ReportStatus>>{
      ReportStatus.submitted: [ReportStatus.received, ReportStatus.rejected],
      ReportStatus.received: [ReportStatus.inProgress, ReportStatus.rejected],
      ReportStatus.inProgress: [ReportStatus.resolved, ReportStatus.rejected],
      ReportStatus.resolved: [ReportStatus.closed, ReportStatus.inProgress],
      ReportStatus.closed: [],
      ReportStatus.rejected: [ReportStatus.received],
    };

    return transitions[currentStatus] ?? [];
  }

  /// Calculate workflow progress percentage
  double _calculateProgress(ReportStatusWorkflow workflow) {
    final steps = workflow.estimatedSteps;
    final currentIndex = steps.indexWhere(
      (step) => step.status == workflow.currentStatus,
    );

    if (currentIndex == -1) return 0.0;

    return (currentIndex + 1) / steps.length;
  }

  /// Check if workflow is complete
  bool _isWorkflowComplete(ReportStatusWorkflow workflow) {
    return workflow.currentStatus == ReportStatus.closed ||
        workflow.currentStatus == ReportStatus.resolved;
  }

  /// Estimate completion time based on workflow progress
  DateTime? _estimateCompletion(ReportStatusWorkflow? workflow) {
    if (workflow == null) return null;

    final elapsed = DateTime.now().difference(workflow.startTime);
    final progress = workflow.progressPercentage;

    if (progress <= 0) return null;

    final estimatedTotal = elapsed.inMilliseconds / progress;
    return workflow.startTime.add(
      Duration(milliseconds: estimatedTotal.round()),
    );
  }

  /// Schedule automatic status progression
  void _scheduleAutomaticProgression(int reportId) {
    _statusTimers[reportId]?.cancel();

    final workflow = _activeWorkflows[reportId];
    if (workflow == null) return;

    final nextStatus = _getNextAutomaticStatus(workflow);
    if (nextStatus == null) return;

    final delay = _getAutomaticProgressionDelay(workflow);

    _statusTimers[reportId] = Timer(delay, () {
      updateStatus(
        reportId,
        nextStatus,
        reason: 'Automatische Progression',
        metadata: {'automated': true},
      );
    });
  }

  /// Get next automatic status for workflow
  ReportStatus? _getNextAutomaticStatus(ReportStatusWorkflow workflow) {
    switch (workflow.currentStatus) {
      case ReportStatus.submitted:
        return ReportStatus.received;
      case ReportStatus.received:
        return workflow.type == StatusWorkflowType.serviceRequest
            ? ReportStatus.inProgress
            : null;
      default:
        return null;
    }
  }

  /// Get delay for automatic progression
  Duration _getAutomaticProgressionDelay(ReportStatusWorkflow workflow) {
    switch (workflow.type) {
      case StatusWorkflowType.urgentInfrastructure:
      case StatusWorkflowType.urgentEnvironmental:
        return const Duration(minutes: 5);
      case StatusWorkflowType.serviceRequest:
        return const Duration(minutes: 30);
      default:
        return const Duration(hours: 2);
    }
  }

  /// Check status of all active reports
  void _checkAllReportsStatus() {
    ProductionLogger.d(
      'Checking status of ${_activeWorkflows.length} active workflows',
      tag: 'STATUS_CHECK',
    );

    for (final workflow in _activeWorkflows.values) {
      _checkWorkflowHealth(workflow);
    }
  }

  /// Check health of individual workflow
  void _checkWorkflowHealth(ReportStatusWorkflow workflow) {
    final now = DateTime.now();
    final elapsed = now.difference(workflow.startTime);

    // Check for stalled workflows
    if (elapsed > const Duration(days: 7) &&
        workflow.currentStatus != ReportStatus.resolved) {
      ProductionLogger.w(
        'Workflow ${workflow.reportId} has been active for ${elapsed.inDays} days',
        tag: 'WORKFLOW_HEALTH',
      );

      // Notify about stalled workflow
      _notifyListeners(
        StatusChangeEvent(
          reportId: workflow.reportId,
          oldStatus: workflow.currentStatus,
          newStatus: workflow.currentStatus,
          eventType: StatusEventType.workflowStalled,
          workflow: workflow,
        ),
      );
    }
  }

  /// Notify all listeners about status change
  void _notifyListeners(StatusChangeEvent event) {
    for (final listener in _listeners) {
      try {
        listener.onStatusChange(event);
      } catch (e) {
        ProductionLogger.e(
          'Error in status change listener',
          error: e,
          tag: 'STATUS_LISTENER',
        );
      }
    }
  }

  /// Get workflow statistics
  WorkflowStatistics getStatistics() {
    final active = _activeWorkflows.length;
    final byType = <StatusWorkflowType, int>{};
    final byStatus = <ReportStatus, int>{};

    for (final workflow in _activeWorkflows.values) {
      byType[workflow.type] = (byType[workflow.type] ?? 0) + 1;
      byStatus[workflow.currentStatus] =
          (byStatus[workflow.currentStatus] ?? 0) + 1;
    }

    return WorkflowStatistics(
      activeWorkflows: active,
      byType: byType,
      byStatus: byStatus,
    );
  }

  /// Dispose resources
  void dispose() {
    for (final timer in _statusTimers.values) {
      timer.cancel();
    }
    _statusTimers.clear();
    _activeWorkflows.clear();
    _listeners.clear();

    ProductionLogger.i(
      'Enhanced report status manager disposed',
      tag: 'STATUS_MANAGER',
    );
  }
}

/// Workflow types with different automation levels
enum StatusWorkflowType {
  standard(isAutomated: false),
  urgentInfrastructure(isAutomated: true),
  standardInfrastructure(isAutomated: false),
  investigation(isAutomated: false),
  maintenance(isAutomated: true),
  serviceRequest(isAutomated: true),
  standardEnvironmental(isAutomated: false),
  urgentEnvironmental(isAutomated: true);

  const StatusWorkflowType({required this.isAutomated});

  final bool isAutomated;
}

/// Status change event types
enum StatusEventType {
  statusChanged,
  workflowStarted,
  workflowCompleted,
  workflowCancelled,
  workflowStalled,
}

/// Workflow step definition
class WorkflowStep {
  final ReportStatus status;
  final String displayName;
  final bool isOptional;

  WorkflowStep(this.status, this.displayName, {this.isOptional = false});
}

/// Report status workflow tracker
class ReportStatusWorkflow {
  final int reportId;
  final StatusWorkflowType type;
  final DateTime startTime;
  final List<WorkflowStep> estimatedSteps;

  ReportStatus currentStatus;
  DateTime? completedAt;
  double progressPercentage = 0.0;
  List<StatusUpdateRecord> updateHistory = [];

  ReportStatusWorkflow({
    required this.reportId,
    required this.type,
    required this.currentStatus,
    required this.startTime,
    required this.estimatedSteps,
  });

  Duration get duration =>
      (completedAt ?? DateTime.now()).difference(startTime);
  bool get isCompleted => completedAt != null;

  WorkflowStep? get currentStep {
    return estimatedSteps.cast<WorkflowStep?>().firstWhere(
      (step) => step?.status == currentStatus,
      orElse: () => null,
    );
  }
}

/// Status update record for history tracking
class StatusUpdateRecord {
  final ReportStatus fromStatus;
  final ReportStatus toStatus;
  final DateTime timestamp;
  final String? reason;
  final Map<String, dynamic>? metadata;

  StatusUpdateRecord({
    required this.fromStatus,
    required this.toStatus,
    required this.timestamp,
    this.reason,
    this.metadata,
  });
}

/// Enhanced status information
class EnhancedStatusInfo {
  final ReportStatus currentStatus;
  final ReportStatusWorkflow? workflow;
  final List<ReportStatus> nextPossibleStatuses;
  final DateTime? estimatedCompletion;
  final List<StatusUpdateRecord> statusHistory;
  final bool isAutomated;

  EnhancedStatusInfo({
    required this.currentStatus,
    this.workflow,
    required this.nextPossibleStatuses,
    this.estimatedCompletion,
    required this.statusHistory,
    required this.isAutomated,
  });
}

/// Status update result
class StatusUpdateResult {
  final bool success;
  final String? error;
  final ReportStatus? suggestedStatus;

  StatusUpdateResult({required this.success, this.error, this.suggestedStatus});
}

/// Status validation result
class StatusValidationResult {
  final bool isValid;
  final String? error;
  final ReportStatus? suggestedAlternative;

  StatusValidationResult({
    required this.isValid,
    this.error,
    this.suggestedAlternative,
  });
}

/// Status change event
class StatusChangeEvent {
  final int reportId;
  final ReportStatus oldStatus;
  final ReportStatus newStatus;
  final StatusEventType eventType;
  final String? reason;
  final Map<String, dynamic>? metadata;
  final ReportStatusWorkflow? workflow;

  StatusChangeEvent({
    required this.reportId,
    required this.oldStatus,
    required this.newStatus,
    required this.eventType,
    this.reason,
    this.metadata,
    this.workflow,
  });
}

/// Status change listener interface
abstract class StatusChangeListener {
  void onStatusChange(StatusChangeEvent event);
}

/// Workflow statistics
class WorkflowStatistics {
  final int activeWorkflows;
  final Map<StatusWorkflowType, int> byType;
  final Map<ReportStatus, int> byStatus;

  WorkflowStatistics({
    required this.activeWorkflows,
    required this.byType,
    required this.byStatus,
  });
}

/// Provider for enhanced status manager
final enhancedStatusManagerProvider =
    StateProvider<EnhancedReportStatusManager>((ref) {
      final manager = EnhancedReportStatusManager();
      manager.initialize();

      ref.onDispose(() => manager.dispose());

      return manager;
    });
