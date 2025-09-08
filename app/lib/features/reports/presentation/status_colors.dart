import 'package:flutter/material.dart';

import '../domain/report.dart';

/// Zentrale Farbzuordnung für Report-Status basierend auf aktuellem ColorScheme
Color colorForReportStatus(ColorScheme scheme, ReportStatus status) {
  switch (status) {
    case ReportStatus.submitted:
      return scheme.outlineVariant;
    case ReportStatus.received:
      return scheme.primaryContainer;
    case ReportStatus.inProgress:
      return scheme.tertiary;
    case ReportStatus.resolved:
      return scheme.secondary;
    case ReportStatus.closed:
      return scheme.outline;
    case ReportStatus.rejected:
      return scheme.error;
  }
}

/// Farbzuordnung für Priorität – anpassbar für Barrierefreiheit
Color colorForReportPriority(ColorScheme scheme, ReportPriority priority) {
  switch (priority) {
    case ReportPriority.low:
      return scheme.outlineVariant;
    case ReportPriority.medium:
      return scheme.secondaryContainer;
    case ReportPriority.high:
      return scheme.tertiaryContainer;
    case ReportPriority.urgent:
      return scheme.error;
  }
}
