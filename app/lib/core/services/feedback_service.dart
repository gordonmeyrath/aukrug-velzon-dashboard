import 'package:flutter/material.dart';

/// Zentrale UI-Feedback Utility (Snackbars etc.) um Context-Zugriffe zu bündeln.
class FeedbackService {
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, Colors.green);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, Colors.red);
  }

  static void _show(BuildContext context, String message, Color bg) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.showSnackBar(
      SnackBar(content: Text(message), backgroundColor: bg),
    );
  }
}
