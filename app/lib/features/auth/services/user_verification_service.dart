import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/util/production_logger.dart';
import '../domain/user_verification.dart';
import 'consent_management_service.dart';
import 'location_verification_service.dart';

/// DSGVO-konformer User Verification Service
/// Implementiert Privacy-by-Design und Datenschutz by Default
/// Erweitert um Geolokalisierungs-basierte Verifikation
class UserVerificationService {
  static const String _storagePrefix = 'verification_';
  static const String _auditPrefix = 'audit_';
  static const Duration _verificationTimeout = Duration(days: 7);

  final ConsentManagementService _consentService;
  final LocationVerificationService _locationService;

  // Stream Controllers für reaktive Updates
  final StreamController<ResidentVerification> _verificationController =
      StreamController<ResidentVerification>.broadcast();
  final StreamController<List<VerificationAuditEntry>> _auditController =
      StreamController<List<VerificationAuditEntry>>.broadcast();

  UserVerificationService({
    ConsentManagementService? consentService,
    LocationVerificationService? locationService,
  }) : _consentService = consentService ?? ConsentManagementService(),
       _locationService = locationService ?? LocationVerificationService();

  // Streams für UI-Updates
  Stream<ResidentVerification> get verificationStream =>
      _verificationController.stream;
  Stream<List<VerificationAuditEntry>> get auditStream =>
      _auditController.stream;

  /// Initiiert Bewohner-Verifikationsprozess mit DSGVO-konformer Einwilligung
  Future<ResidentVerification> startResidentVerification({
    required String userId,
    required String fullName,
    required String address,
    required String zipCode,
    required String city,
    String? phoneNumber,
    String? documentType,
    String? documentNumber,
    String? additionalInfo,
    double? latitude,
    double? longitude,
  }) async {
    try {
      ProductionLogger.i('🏠 Starting resident verification for user: $userId');

      // 1. Prüfe bestehende Verifikation
      final existingVerification = await getVerificationStatus(userId);
      if (existingVerification != null &&
          existingVerification.status == VerificationStatus.verified) {
        throw VerificationException('User bereits verifiziert');
      }

      // 2. Erstelle Einwilligungsnachweis
      final consentHash = _generateConsentHash(userId, fullName, address);
      final consentGivenAt = DateTime.now();

      // 3. Erstelle temporäre Verifikationsdaten
      final temporaryData = TemporaryVerificationData(
        fullName: fullName,
        address: address,
        zipCode: zipCode,
        city: city,
        phoneNumber: phoneNumber,
        documentType: documentType,
        documentNumber: documentNumber,
        additionalInfo: additionalInfo,
        latitude: latitude,
        longitude: longitude,
        createdAt: DateTime.now(),
        scheduledDeletionAt: DateTime.now().add(_verificationTimeout),
        consentHash: consentHash,
        consentGivenAt: consentGivenAt,
      );

      // 4. Erstelle Verifikationsantrag
      final verification = ResidentVerification(
        id: _generateVerificationId(),
        userId: userId,
        status: latitude != null && longitude != null
            ? VerificationStatus
                  .locationTracking // Start Geolokalisierung
            : VerificationStatus.pending, // Standard-Prozess ohne Standort
        submittedAt: DateTime.now(),
        dataWillBeDeletedAt: DateTime.now().add(_verificationTimeout),
        temporaryData: temporaryData,
        auditTrail: [
          VerificationAuditEntry(
            id: _generateAuditId(),
            timestamp: DateTime.now(),
            action: VerificationAction.submitted,
            performedBy: userId,
            reason: 'Resident verification initiated',
          ),
        ],
      );

      // 5. Speichere Verifikation lokal
      await _saveVerification(verification);

      // 6. Starte Geolokalisierungs-Überwachung (falls Koordinaten vorhanden)
      if (latitude != null && longitude != null) {
        await _startLocationVerification(
          verification.id,
          latitude,
          longitude,
          userId,
        );
      }

      // 7. Plane automatische Datenlöschung
      _scheduleDataDeletion(verification.id, _verificationTimeout);

      // 8. Audit Log
      await _addAuditEntry(
        verification.id,
        VerificationAuditEntry(
          id: _generateAuditId(),
          timestamp: DateTime.now(),
          action: latitude != null && longitude != null
              ? VerificationAction.locationTrackingStarted
              : VerificationAction.submitted,
          performedBy: userId,
          reason: latitude != null && longitude != null
              ? 'Location tracking started for 7-day verification'
              : 'Verification request submitted with GDPR consent',
          metadata: {
            'data_retention_days': _verificationTimeout.inDays,
            'consent_hash': consentHash,
            'has_location': latitude != null && longitude != null,
            'location_verification': latitude != null && longitude != null,
          },
        ),
      );

      _verificationController.add(verification);
      ProductionLogger.i('✅ Verification request created: ${verification.id}');

      return verification;
    } catch (e, stackTrace) {
      ProductionLogger.e('❌ Error starting verification');
      rethrow;
    }
  }

  /// Ruft aktuellen Verifikationsstatus ab
  Future<ResidentVerification?> getVerificationStatus(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_storagePrefix}user_$userId';
      final jsonString = prefs.getString(key);

      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return ResidentVerification.fromJson(json);
      }

      return null;
    } catch (e, stackTrace) {
      ProductionLogger.e('Error getting verification status');
      return null;
    }
  }

  /// Aktualisiert Verifikationsstatus (Admin-Funktion)
  Future<void> updateVerificationStatus({
    required String verificationId,
    required VerificationStatus newStatus,
    required String performedBy,
    String? reason,
    String? adminNotes,
  }) async {
    try {
      ProductionLogger.i(
        '📝 Updating verification status: $verificationId -> $newStatus',
      );

      final verification = await _getVerificationById(verificationId);
      if (verification == null) {
        throw VerificationException('Verification not found: $verificationId');
      }

      // Audit-Eintrag erstellen
      final auditEntry = VerificationAuditEntry(
        id: _generateAuditId(),
        timestamp: DateTime.now(),
        action: _mapStatusToAction(newStatus),
        performedBy: performedBy,
        reason: reason,
        metadata: {
          'previous_status': verification.status.name,
          'new_status': newStatus.name,
        },
      );

      // Updated verification
      final updatedVerification = verification.copyWith(
        status: newStatus,
        verifiedAt: newStatus == VerificationStatus.verified
            ? DateTime.now()
            : null,
        adminNotes: adminNotes,
        auditTrail: [...verification.auditTrail, auditEntry],
      );

      // Bei Verifikation: Temporäre Daten löschen
      if (newStatus == VerificationStatus.verified) {
        await _deleteTemporaryData(updatedVerification);
      }

      await _saveVerification(updatedVerification);
      await _addAuditEntry(verificationId, auditEntry);

      _verificationController.add(updatedVerification);
      ProductionLogger.i('✅ Verification status updated: $verificationId');
    } catch (e, stackTrace) {
      ProductionLogger.e('❌ Error updating verification status');
      rethrow;
    }
  }

  /// Prüft ob User ein verifizierter Bewohner ist
  Future<bool> isVerifiedResident(String userId) async {
    final verification = await getVerificationStatus(userId);
    return verification?.status == VerificationStatus.verified;
  }

  /// Löscht temporäre Verifikationsdaten nach erfolgter Verifikation
  Future<void> _deleteTemporaryData(ResidentVerification verification) async {
    try {
      ProductionLogger.i(
        '🗑️ Deleting temporary verification data: ${verification.id}',
      );

      // Erstelle Verifikation ohne temporäre Daten
      final cleanedVerification = verification.copyWith(
        temporaryData: null,
        status: VerificationStatus.dataDeleted,
      );

      await _saveVerification(cleanedVerification);

      // Audit-Log für Datenlöschung
      await _addAuditEntry(
        verification.id,
        VerificationAuditEntry(
          id: _generateAuditId(),
          timestamp: DateTime.now(),
          action: VerificationAction.dataDeleted,
          performedBy: 'system',
          reason:
              'Temporary data deleted after successful verification (GDPR compliance)',
          metadata: {
            'data_deleted_at': DateTime.now().toIso8601String(),
            'retention_period_expired': false,
          },
        ),
      );

      ProductionLogger.i('✅ Temporary verification data deleted');
    } catch (e, stackTrace) {
      ProductionLogger.e('❌ Error deleting temporary data');
      rethrow;
    }
  }

  /// Plant automatische Datenlöschung nach Ablauf der Aufbewahrungszeit
  void _scheduleDataDeletion(String verificationId, Duration delay) {
    Timer(delay, () async {
      try {
        ProductionLogger.i(
          '⏰ Scheduled data deletion triggered: $verificationId',
        );

        final verification = await _getVerificationById(verificationId);
        if (verification != null &&
            verification.status != VerificationStatus.verified &&
            verification.temporaryData != null) {
          // Automatische Löschung unverarbeiteter Daten
          await _deleteTemporaryData(
            verification.copyWith(status: VerificationStatus.expired),
          );

          ProductionLogger.i(
            '✅ Expired verification data automatically deleted',
          );
        }
      } catch (e, stackTrace) {
        ProductionLogger.e('❌ Error in scheduled data deletion');
      }
    });
  }

  /// Ruft alle Audit-Einträge für eine Verifikation ab
  Future<List<VerificationAuditEntry>> getAuditTrail(
    String verificationId,
  ) async {
    try {
      final verification = await _getVerificationById(verificationId);
      return verification?.auditTrail ?? [];
    } catch (e, stackTrace) {
      ProductionLogger.e('Error getting audit trail');
      return [];
    }
  }

  /// Exportiert alle Verifikationsdaten für DSGVO-Anfragen
  Future<Map<String, dynamic>> exportVerificationData(String userId) async {
    try {
      ProductionLogger.i('📄 Exporting verification data for user: $userId');

      final verification = await getVerificationStatus(userId);
      if (verification == null) {
        return {'error': 'No verification data found'};
      }

      // Exportiere nur nicht-sensible Daten
      final exportData = {
        'verification_id': verification.id,
        'status': verification.status.name,
        'submitted_at': verification.submittedAt.toIso8601String(),
        'verified_at': verification.verifiedAt?.toIso8601String(),
        'has_temporary_data': verification.temporaryData != null,
        'audit_trail': verification.auditTrail
            .map(
              (entry) => {
                'timestamp': entry.timestamp.toIso8601String(),
                'action': entry.action.name,
                'performed_by': entry.performedBy,
                'reason': entry.reason,
              },
            )
            .toList(),
      };

      // Audit-Log für Datenexport
      await _addAuditEntry(
        verification.id,
        VerificationAuditEntry(
          id: _generateAuditId(),
          timestamp: DateTime.now(),
          action: VerificationAction.additionalInfoProvided, // Reuse for export
          performedBy: userId,
          reason: 'GDPR data export requested',
          metadata: {
            'export_type': 'verification_data',
            'exported_at': DateTime.now().toIso8601String(),
          },
        ),
      );

      return exportData;
    } catch (e, stackTrace) {
      ProductionLogger.e('❌ Error exporting verification data');
      return {'error': 'Export failed'};
    }
  }

  /// Löscht alle Verifikationsdaten für einen User (DSGVO-Recht auf Löschung)
  Future<void> deleteAllVerificationData(String userId) async {
    try {
      ProductionLogger.i(
        '🗑️ Deleting all verification data for user: $userId',
      );

      final prefs = await SharedPreferences.getInstance();
      final key = '${_storagePrefix}user_$userId';

      // Erstelle finalen Audit-Eintrag vor Löschung
      final verification = await getVerificationStatus(userId);
      if (verification != null) {
        await _addAuditEntry(
          verification.id,
          VerificationAuditEntry(
            id: _generateAuditId(),
            timestamp: DateTime.now(),
            action: VerificationAction.dataDeleted,
            performedBy: userId,
            reason: 'GDPR right to erasure - user requested data deletion',
            metadata: {
              'deletion_type': 'complete_erasure',
              'deleted_at': DateTime.now().toIso8601String(),
            },
          ),
        );
      }

      // Lösche Verifikationsdaten
      await prefs.remove(key);

      // Lösche Audit-Logs (falls separat gespeichert)
      final auditKey = '${_auditPrefix}verification_${verification?.id}';
      await prefs.remove(auditKey);

      ProductionLogger.i('✅ All verification data deleted for user: $userId');
    } catch (e, stackTrace) {
      ProductionLogger.e('❌ Error deleting verification data');
      rethrow;
    }
  }

  /// Private Helper Methods

  Future<void> _saveVerification(ResidentVerification verification) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_storagePrefix}user_${verification.userId}';
    final jsonString = jsonEncode(verification.toJson());
    await prefs.setString(key, jsonString);
  }

  Future<ResidentVerification?> _getVerificationById(
    String verificationId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (final key in keys) {
        if (key.startsWith(_storagePrefix)) {
          final jsonString = prefs.getString(key);
          if (jsonString != null) {
            final json = jsonDecode(jsonString) as Map<String, dynamic>;
            final verification = ResidentVerification.fromJson(json);
            if (verification.id == verificationId) {
              return verification;
            }
          }
        }
      }

      return null;
    } catch (e) {
      ProductionLogger.e('Error getting verification by ID');
      return null;
    }
  }

  Future<void> _addAuditEntry(
    String verificationId,
    VerificationAuditEntry entry,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_auditPrefix}verification_$verificationId';

      List<VerificationAuditEntry> auditTrail = [];
      final existingJson = prefs.getString(key);
      if (existingJson != null) {
        final List<dynamic> existingList = jsonDecode(existingJson);
        auditTrail = existingList
            .map(
              (item) =>
                  VerificationAuditEntry.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }

      auditTrail.add(entry);

      final jsonString = jsonEncode(auditTrail.map((e) => e.toJson()).toList());
      await prefs.setString(key, jsonString);

      _auditController.add(auditTrail);
    } catch (e) {
      ProductionLogger.e('Error adding audit entry');
    }
  }

  String _generateVerificationId() {
    return 'verification_${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(8)}';
  }

  String _generateAuditId() {
    return 'audit_${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(6)}';
  }

  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(
      length,
      (index) =>
          chars[(DateTime.now().millisecondsSinceEpoch + index) % chars.length],
    ).join();
  }

  String _generateConsentHash(String userId, String fullName, String address) {
    final consentData =
        '$userId|$fullName|$address|${DateTime.now().millisecondsSinceEpoch}';
    return consentData.hashCode.toString();
  }

  VerificationAction _mapStatusToAction(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.verified:
        return VerificationAction.approved;
      case VerificationStatus.rejected:
        return VerificationAction.rejected;
      case VerificationStatus.locationTracking:
        return VerificationAction.locationTrackingStarted;
      case VerificationStatus.inReview:
        return VerificationAction.reviewed;
      case VerificationStatus.additionalInfoRequired:
        return VerificationAction.additionalInfoRequested;
      case VerificationStatus.dataDeleted:
        return VerificationAction.dataDeleted;
      default:
        return VerificationAction.reviewed;
    }
  }

  /// Startet die Geolokalisierungs-Überwachung für 7 Tage
  Future<void> _startLocationVerification(
    String verificationId,
    double latitude,
    double longitude,
    String userId,
  ) async {
    try {
      ProductionLogger.i(
        '🌍 Starting location verification for: $verificationId',
      );

      // Starte 7-tägige Standort-Überwachung
      await _locationService.startLocationTracking(
        verificationId: verificationId,
        targetLatitude: latitude,
        targetLongitude: longitude,
      );

      // Audit-Eintrag für Standort-Tracking
      await _addAuditEntry(
        verificationId,
        VerificationAuditEntry(
          id: _generateAuditId(),
          timestamp: DateTime.now(),
          action: VerificationAction.locationTrackingStarted,
          performedBy: userId,
          reason: '7-day location tracking initiated for resident verification',
          metadata: {
            'target_latitude': latitude,
            'target_longitude': longitude,
            'tracking_duration_days': 7,
            'required_successful_nights': 4,
          },
        ),
      );

      ProductionLogger.i('✅ Location verification started successfully');
    } catch (e) {
      ProductionLogger.e('❌ Failed to start location verification: $e');
      throw VerificationException('Failed to start location verification: $e');
    }
  }

  /// Prüft nächtlich den Verifikationsstatus und schließt Verifikation ab
  Future<void> checkLocationVerificationProgress(String verificationId) async {
    try {
      final verification = await getVerificationStatus(
        verificationId.split('_')[1],
      ); // Extract userId
      if (verification == null ||
          verification.status != VerificationStatus.locationTracking) {
        return;
      }

      // Prüfe ob Schwellenwert erreicht wurde (4/7 Nächte)
      final thresholdMet = await _locationService.checkVerificationThreshold(
        verificationId,
      );

      if (thresholdMet) {
        await _completeLocationVerification(verification, verificationId);
      } else {
        // Prüfe ob die 7 Tage abgelaufen sind
        final summary = await _locationService.getTrackingSummary(
          verificationId,
        );
        if (summary != null && DateTime.now().isAfter(summary.trackingEnded)) {
          await _failLocationVerification(verification, verificationId);
        }
      }
    } catch (e) {
      ProductionLogger.e('Error checking location verification progress: $e');
    }
  }

  /// Schließt erfolgreiche Standort-Verifikation ab
  Future<void> _completeLocationVerification(
    ResidentVerification verification,
    String verificationId,
  ) async {
    try {
      // Aktualisiere Status auf verifiziert
      await updateVerificationStatus(
        verificationId: verification.id,
        newStatus: VerificationStatus.verified,
        reason:
            'Location verification successful - 4/7 nights at registered address',
        performedBy: 'system',
      );

      // Stoppe Standort-Überwachung
      await _locationService.stopLocationTracking(verificationId);

      // Hole finale Statistiken
      final summary = await _locationService.getTrackingSummary(verificationId);

      // Audit-Eintrag für erfolgreiche Verifikation
      await _addAuditEntry(
        verification.id,
        VerificationAuditEntry(
          id: _generateAuditId(),
          timestamp: DateTime.now(),
          action: VerificationAction.verificationThresholdMet,
          performedBy: 'system',
          reason:
              'Resident verification completed successfully through location tracking',
          metadata: {
            'successful_nights': summary?.successfulNights ?? 0,
            'total_nights': summary?.totalNights ?? 0,
            'verification_method': 'geolocation_tracking',
          },
        ),
      );

      ProductionLogger.i('🎯 Location verification completed successfully');
    } catch (e) {
      ProductionLogger.e('Error completing location verification: $e');
    }
  }

  /// Beendet fehlgeschlagene Standort-Verifikation
  Future<void> _failLocationVerification(
    ResidentVerification verification,
    String verificationId,
  ) async {
    try {
      // Aktualisiere Status auf abgelehnt
      await updateVerificationStatus(
        verificationId: verification.id,
        newStatus: VerificationStatus.rejected,
        reason:
            'Location verification failed - insufficient nights at registered address',
        performedBy: 'system',
      );

      // Stoppe Standort-Überwachung
      await _locationService.stopLocationTracking(verificationId);

      // Hole finale Statistiken
      final summary = await _locationService.getTrackingSummary(verificationId);

      // Audit-Eintrag für fehlgeschlagene Verifikation
      await _addAuditEntry(
        verification.id,
        VerificationAuditEntry(
          id: _generateAuditId(),
          timestamp: DateTime.now(),
          action: VerificationAction.rejected,
          performedBy: 'system',
          reason:
              'Resident verification failed - did not meet location requirements',
          metadata: {
            'successful_nights': summary?.successfulNights ?? 0,
            'total_nights': summary?.totalNights ?? 0,
            'required_nights': 4,
            'verification_method': 'geolocation_tracking',
          },
        ),
      );

      ProductionLogger.i('❌ Location verification failed');
    } catch (e) {
      ProductionLogger.e('Error failing location verification: $e');
    }
  }

  /// Holt Standort-Tracking Zusammenfassung
  Future<LocationTrackingSummary?> getLocationTrackingSummary(
    String verificationId,
  ) async {
    return await _locationService.getTrackingSummary(verificationId);
  }

  /// Dispose resources
  void dispose() {
    _verificationController.close();
    _auditController.close();
    _locationService.dispose();
  }
}

/// Custom exception für Verification-Fehler
class VerificationException implements Exception {
  final String message;
  VerificationException(this.message);

  @override
  String toString() => 'VerificationException: $message';
}
