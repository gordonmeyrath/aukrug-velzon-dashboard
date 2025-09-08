import 'package:flutter/services.dart';

/// Service für haptisches Feedback bei App-Events
class HapticFeedbackService {
  /// Feedback für neue Inhalte (sanft)
  static Future<void> onNewContent() async {
    await HapticFeedback.lightImpact();
  }

  /// Feedback für wichtige Updates (medium)
  static Future<void> onImportantUpdate() async {
    await HapticFeedback.mediumImpact();
  }

  /// Feedback für kritische Events (stark)
  static Future<void> onCriticalEvent() async {
    await HapticFeedback.heavyImpact();
  }

  /// Feedback für Erfolg (Vibration Pattern)
  static Future<void> onSuccess() async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();
  }

  /// Feedback für Fehler
  static Future<void> onError() async {
    await HapticFeedback.vibrate();
  }

  /// Feedback für Interaktion (Selection)
  static Future<void> onSelection() async {
    await HapticFeedback.selectionClick();
  }
}
