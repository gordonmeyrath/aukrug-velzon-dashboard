import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

import '../domain/user_verification.dart';
import '../../../core/util/production_logger.dart';

/// Service für Geolokalisierungs-basierte Bewohner-Verifikation
/// Überwacht 7 Nächte lang den Standort zwischen 00:00-04:00 Uhr
/// Verifikation erfolgreich wenn 4/7 Nächte an der angegebenen Adresse
class LocationVerificationService {
  static const String _locationChecksPrefix = 'location_checks_';
  static const String _trackingSummaryPrefix = 'tracking_summary_';
  static const Duration _trackingPeriod = Duration(days: 7);
  static const int _requiredSuccessfulNights = 4;
  static const double _maxDistanceMeters = 100.0; // 100m Radius um die Adresse

  // Überwachungszeit: Mitternacht bis 4 Uhr morgens
  static const int _startHour = 0; // 00:00
  static const int _endHour = 4; // 04:00

  final StreamController<LocationTrackingSummary> _trackingController =
      StreamController<LocationTrackingSummary>.broadcast();

  Stream<LocationTrackingSummary> get trackingStream =>
      _trackingController.stream;

  /// Startet die 7-tägige Geolokalisierungs-Überwachung
  Future<void> startLocationTracking({
    required String verificationId,
    required double targetLatitude,
    required double targetLongitude,
  }) async {
    try {
      ProductionLogger.i(
        '🌍 Starting location tracking for verification: $verificationId',
      );

      // 1. Prüfe Standortberechtigung
      final permission = await _checkLocationPermission();
      if (!permission) {
        throw LocationVerificationException(
          'Standortberechtigung nicht erteilt',
        );
      }

      // 2. Erstelle Tracking-Zusammenfassung
      final summary = LocationTrackingSummary(
        verificationId: verificationId,
        trackingStarted: DateTime.now(),
        trackingEnded: DateTime.now().add(_trackingPeriod),
        totalNights: 0,
        successfulNights: 0,
        requiredNights: _requiredSuccessfulNights,
        thresholdMet: false,
        checks: [],
        statistics: {
          'target_latitude': targetLatitude,
          'target_longitude': targetLongitude,
          'max_distance_meters': _maxDistanceMeters,
          'tracking_hours': '$_startHour:00-$_endHour:00',
          'required_success_rate': '$_requiredSuccessfulNights/7',
        },
      );

      await _saveTrackingSummary(summary);

      // 3. Registriere Background-Task für nächtliche Checks
      await _scheduleNightlyLocationChecks(
        verificationId,
        targetLatitude,
        targetLongitude,
      );

      _trackingController.add(summary);
      ProductionLogger.i('✅ Location tracking started successfully');
    } catch (e) {
      ProductionLogger.e('❌ Error starting location tracking');
      rethrow;
    }
  }

  /// Führt einen einzelnen Standort-Check durch (wird vom Background-Task aufgerufen)
  Future<LocationCheck> performLocationCheck({
    required String verificationId,
    required double targetLatitude,
    required double targetLongitude,
  }) async {
    try {
      ProductionLogger.i('📍 Performing location check for: $verificationId');

      // 1. Hole aktuelle Position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 30),
      );

      // 2. Berechne Entfernung zur Zieladresse
      final distance = Geolocator.distanceBetween(
        targetLatitude,
        targetLongitude,
        position.latitude,
        position.longitude,
      );

      // 3. Prüfe ob in erlaubtem Radius
      final isAtAddress = distance <= _maxDistanceMeters;

      // 4. Erstelle Location-Check
      final locationCheck = LocationCheck(
        id: _generateLocationCheckId(),
        verificationId: verificationId,
        checkTime: DateTime.now(),
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        isAtAddress: isAtAddress,
        distanceToAddress: distance,
        metadata: {
          'altitude': position.altitude,
          'speed': position.speed,
          'heading': position.heading,
          'timestamp': position.timestamp.millisecondsSinceEpoch,
          'check_hour': DateTime.now().hour,
        },
      );

      // 5. Speichere Check
      await _saveLocationCheck(locationCheck);

      // 6. Aktualisiere Tracking-Zusammenfassung
      await _updateTrackingSummary(verificationId, locationCheck);

      ProductionLogger.i(
        '✅ Location check completed: ${isAtAddress ? "SUCCESS" : "FAILED"} - Distance: ${distance.toStringAsFixed(1)}m',
      );

      return locationCheck;
    } catch (e) {
      ProductionLogger.e('❌ Error performing location check');
      rethrow;
    }
  }

  /// Prüft ob die Verifikation erfolgreich war (4/7 Nächte)
  Future<bool> checkVerificationThreshold(String verificationId) async {
    try {
      final summary = await getTrackingSummary(verificationId);
      if (summary == null) return false;

      final successfulNights = summary.checks
          .where((check) => check.isAtAddress)
          .length;

      final thresholdMet = successfulNights >= _requiredSuccessfulNights;

      ProductionLogger.i(
        '🎯 Verification threshold check: $successfulNights/$_requiredSuccessfulNights nights successful',
      );

      return thresholdMet;
    } catch (e) {
      ProductionLogger.e('Error checking verification threshold');
      return false;
    }
  }

  /// Holt die Tracking-Zusammenfassung für eine Verifikation
  Future<LocationTrackingSummary?> getTrackingSummary(
    String verificationId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_trackingSummaryPrefix$verificationId';
      final jsonString = prefs.getString(key);

      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return LocationTrackingSummary.fromJson(json);
      }

      return null;
    } catch (e) {
      ProductionLogger.e('Error getting tracking summary');
      return null;
    }
  }

  /// Holt alle Location-Checks für eine Verifikation
  Future<List<LocationCheck>> getLocationChecks(String verificationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_locationChecksPrefix$verificationId';
      final jsonString = prefs.getString(key);

      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList
            .map((json) => LocationCheck.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      ProductionLogger.e('Error getting location checks');
      return [];
    }
  }

  /// Beendet die Standort-Überwachung
  Future<void> stopLocationTracking(String verificationId) async {
    try {
      ProductionLogger.i('🛑 Stopping location tracking for: $verificationId');

      // Entferne geplante Background-Tasks
      await Workmanager().cancelByUniqueName(verificationId);

      // Aktualisiere Summary
      final summary = await getTrackingSummary(verificationId);
      if (summary != null) {
        final updatedSummary = summary.copyWith(trackingEnded: DateTime.now());
        await _saveTrackingSummary(updatedSummary);
        _trackingController.add(updatedSummary);
      }

      ProductionLogger.i('✅ Location tracking stopped successfully');
    } catch (e) {
      ProductionLogger.e('Error stopping location tracking');
    }
  }

  /// Private Methoden

  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<void> _scheduleNightlyLocationChecks(
    String verificationId,
    double targetLat,
    double targetLng,
  ) async {
    // Registriere 7 tägliche Tasks (eine für jeden Abend)
    for (int day = 0; day < 7; day++) {
      final checkTime = DateTime.now().add(Duration(days: day));
      final taskName = '${verificationId}_day_$day';

      await Workmanager().registerOneOffTask(
        taskName,
        'locationCheck',
        initialDelay: _calculateDelayUntilNightCheck(checkTime),
        inputData: {
          'verificationId': verificationId,
          'targetLatitude': targetLat,
          'targetLongitude': targetLng,
          'day': day,
        },
      );
    }
  }

  Duration _calculateDelayUntilNightCheck(DateTime targetDate) {
    // Berechne Verzögerung bis zur nächsten Prüfzeit (2:00 Uhr nachts)
    final targetTime = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      2, // 2:00 Uhr
      0,
      0,
    );

    final now = DateTime.now();
    if (targetTime.isBefore(now)) {
      // Falls die Zeit bereits vorbei ist, prüfe am nächsten Tag
      return targetTime.add(Duration(days: 1)).difference(now);
    }

    return targetTime.difference(now);
  }

  Future<void> _saveLocationCheck(LocationCheck check) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_locationChecksPrefix${check.verificationId}';

      // Lade bestehende Checks
      List<LocationCheck> checks = await getLocationChecks(
        check.verificationId,
      );
      checks.add(check);

      // Speichere aktualisierte Liste
      final jsonString = jsonEncode(checks.map((c) => c.toJson()).toList());
      await prefs.setString(key, jsonString);
    } catch (e) {
      ProductionLogger.e('Error saving location check');
    }
  }

  Future<void> _saveTrackingSummary(LocationTrackingSummary summary) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_trackingSummaryPrefix${summary.verificationId}';
      final jsonString = jsonEncode(summary.toJson());
      await prefs.setString(key, jsonString);
    } catch (e) {
      ProductionLogger.e('Error saving tracking summary');
    }
  }

  Future<void> _updateTrackingSummary(
    String verificationId,
    LocationCheck newCheck,
  ) async {
    try {
      final summary = await getTrackingSummary(verificationId);
      if (summary == null) return;

      final allChecks = await getLocationChecks(verificationId);
      final successfulNights = allChecks
          .where((check) => check.isAtAddress)
          .length;
      final thresholdMet = successfulNights >= _requiredSuccessfulNights;

      final updatedSummary = summary.copyWith(
        totalNights: allChecks.length,
        successfulNights: successfulNights,
        thresholdMet: thresholdMet,
        checks: allChecks,
        statistics: {
          ...summary.statistics,
          'last_check': newCheck.checkTime.toIso8601String(),
          'last_check_success': newCheck.isAtAddress,
          'last_distance': newCheck.distanceToAddress,
          'verification_progress':
              '$successfulNights/$_requiredSuccessfulNights',
        },
      );

      await _saveTrackingSummary(updatedSummary);
      _trackingController.add(updatedSummary);
    } catch (e) {
      ProductionLogger.e('Error updating tracking summary');
    }
  }

  String _generateLocationCheckId() {
    return 'location_${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(6)}';
  }

  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(
      length,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  /// Prüft ob wir uns in der Überwachungszeit befinden (00:00-04:00)
  bool isWithinTrackingHours() {
    final now = DateTime.now();
    final hour = now.hour;
    return hour >= _startHour && hour < _endHour;
  }

  /// Cleanup
  void dispose() {
    _trackingController.close();
  }
}

/// Custom Exception für Location-Verification-Fehler
class LocationVerificationException implements Exception {
  final String message;
  LocationVerificationException(this.message);

  @override
  String toString() => 'LocationVerificationException: $message';
}
