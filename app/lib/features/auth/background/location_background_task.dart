import 'package:workmanager/workmanager.dart';

import '../../../core/util/production_logger.dart';
import '../services/location_verification_service.dart';

/// Background-Task Handler für nächtliche Geolokalisierungs-Checks
/// Wird zwischen 00:00-04:00 Uhr von Workmanager aufgerufen
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      ProductionLogger.i('🌙 Background location check started: $task');

      switch (task) {
        case 'locationCheck':
          return await _performLocationCheck(inputData);
        default:
          ProductionLogger.w('Unknown background task: $task');
          return false;
      }
    } catch (e) {
      ProductionLogger.e('❌ Background task failed: $task - $e');
      return false;
    }
  });
}

/// Führt den nächtlichen Standort-Check durch
Future<bool> _performLocationCheck(Map<String, dynamic>? inputData) async {
  try {
    if (inputData == null) {
      ProductionLogger.e('No input data for location check');
      return false;
    }

    final verificationId = inputData['verificationId'] as String?;
    final targetLatitude = inputData['targetLatitude'] as double?;
    final targetLongitude = inputData['targetLongitude'] as double?;
    final day = inputData['day'] as int?;

    if (verificationId == null ||
        targetLatitude == null ||
        targetLongitude == null) {
      ProductionLogger.e('Missing required location check parameters');
      return false;
    }

    // Prüfe ob wir in der richtigen Zeitspanne sind (00:00-04:00)
    final locationService = LocationVerificationService();
    if (!locationService.isWithinTrackingHours()) {
      ProductionLogger.i('⏰ Not within tracking hours, skipping check');
      return true; // Task war erfolgreich, aber außerhalb der Zeit
    }

    // Führe Standort-Check durch
    final locationCheck = await locationService.performLocationCheck(
      verificationId: verificationId,
      targetLatitude: targetLatitude,
      targetLongitude: targetLongitude,
    );

    ProductionLogger.i(
      '✅ Background location check completed for day $day: ${locationCheck.isAtAddress ? "SUCCESS" : "FAILED"}',
    );

    // Prüfe ob Verifikations-Schwellenwert erreicht wurde
    final thresholdMet = await locationService.checkVerificationThreshold(
      verificationId,
    );
    if (thresholdMet) {
      ProductionLogger.i(
        '🎯 Verification threshold met! User can be verified.',
      );
      // Hier könnte ein Event ausgelöst werden um die Verifikation abzuschließen
    }

    return true;
  } catch (e) {
    ProductionLogger.e('❌ Location check failed: $e');
    return false;
  }
}
