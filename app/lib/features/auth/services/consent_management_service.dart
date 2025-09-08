import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/util/production_logger.dart';
import '../domain/user_verification.dart';

/// DSGVO-konformer Consent Management Service
/// Verwaltet granulare Einwilligungen und Privacy-Einstellungen
class ConsentManagementService {
  static const String _consentPrefix = 'consent_';
  static const String _consentHistoryPrefix = 'consent_history_';
  static const Duration _consentValidityPeriod = Duration(days: 365); // 1 Jahr

  // Stream Controller für Consent-Updates
  final StreamController<DataProcessingConsent> _consentController =
      StreamController<DataProcessingConsent>.broadcast();

  ConsentManagementService();

  // Stream für UI-Updates
  Stream<DataProcessingConsent> get consentStream => _consentController.stream;

  /// Speichert neue Einwilligung mit Audit-Trail
  Future<DataProcessingConsent> saveConsent({
    required String userId,
    required ConsentType consentType,
    required bool granted,
    required ConsentSource source,
    String? purpose,
    String? legalBasis,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      ProductionLogger.i(
        '📋 Saving consent for user: $userId, type: $consentType, granted: $granted',
      );

      final now = DateTime.now();
      final consent = DataProcessingConsent(
        id: _generateConsentId(),
        userId: userId,
        consentType: consentType,
        granted: granted,
        grantedAt: now,
        source: source,
        purpose: purpose ?? 'User consent for ${consentType.name}',
        legalBasis: legalBasis ?? 'User consent (GDPR Art. 6(1)(a))',
        validUntil: now.add(_consentValidityPeriod),
        ipAddress: await _getCurrentIpAddress(),
        userAgent: await _getUserAgent(),
        consentVersion: '1.0',
        metadata: metadata ?? {},
        auditTrail: [
          ConsentAuditEntry(
            id: _generateAuditId(),
            timestamp: now,
            action: granted ? ConsentAction.granted : ConsentAction.withdrawn,
            source: source,
            metadata: {
              'consent_type': consentType.name,
              'legal_basis': legalBasis,
              'purpose': purpose,
            },
          ),
        ],
      );

      // Speichere Einwilligung
      await _saveConsentRecord(consent);

      // Speichere in Historie
      await _addToConsentHistory(consent);

      _consentController.add(consent);
      ProductionLogger.i('✅ Consent saved: ${consent.id}');

      return consent;
    } catch (e, stackTrace) {
      ProductionLogger.e('Error saving consent');
      rethrow;
    }
  }

  /// Ruft aktuelle Einwilligung für einen spezifischen Typ ab
  Future<DataProcessingConsent?> getConsent(
    String userId,
    ConsentType consentType,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_consentPrefix${userId}_${consentType.name}';
      final jsonString = prefs.getString(key);

      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final consent = DataProcessingConsent.fromJson(json);

        // Prüfe Gültigkeit
        if (consent.validUntil.isAfter(DateTime.now())) {
          return consent;
        } else {
          ProductionLogger.i(
            '⚠️ Consent expired for user: $userId, type: $consentType',
          );
          return null;
        }
      }

      return null;
    } catch (e, stackTrace) {
      ProductionLogger.e('Error getting consent');
      return null;
    }
  }

  /// Prüft ob spezifische Einwilligung vorliegt und gültig ist
  Future<bool> hasValidConsent(String userId, ConsentType consentType) async {
    final consent = await getConsent(userId, consentType);
    return consent?.granted == true &&
        consent!.validUntil.isAfter(DateTime.now());
  }

  /// Widerruft eine Einwilligung
  Future<void> withdrawConsent({
    required String userId,
    required ConsentType consentType,
    required ConsentSource source,
    String? reason,
  }) async {
    try {
      ProductionLogger.i(
        '🚫 Withdrawing consent for user: $userId, type: $consentType',
      );

      final existingConsent = await getConsent(userId, consentType);
      if (existingConsent == null) {
        throw ConsentException('No consent found to withdraw');
      }

      final auditEntry = ConsentAuditEntry(
        id: _generateAuditId(),
        timestamp: DateTime.now(),
        action: ConsentAction.withdrawn,
        source: source,
        metadata: {
          'withdrawal_reason': reason,
          'previous_consent_id': existingConsent.id,
        },
      );

      final withdrawnConsent = existingConsent.copyWith(
        granted: false,
        withdrawnAt: DateTime.now(),
        auditTrail: [...existingConsent.auditTrail, auditEntry],
      );

      await _saveConsentRecord(withdrawnConsent);
      await _addToConsentHistory(withdrawnConsent);

      _consentController.add(withdrawnConsent);
      ProductionLogger.i('✅ Consent withdrawn: ${withdrawnConsent.id}');
    } catch (e, stackTrace) {
      ProductionLogger.e('❌ Error withdrawing consent');
      rethrow;
    }
  }

  /// Ruft alle Einwilligungen für einen User ab
  Future<List<DataProcessingConsent>> getAllConsents(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final consents = <DataProcessingConsent>[];

      for (final key in keys) {
        if (key.startsWith('$_consentPrefix$userId')) {
          final jsonString = prefs.getString(key);
          if (jsonString != null) {
            final json = jsonDecode(jsonString) as Map<String, dynamic>;
            final consent = DataProcessingConsent.fromJson(json);
            consents.add(consent);
          }
        }
      }

      return consents;
    } catch (e, stackTrace) {
      ProductionLogger.e('Error getting all consents');
      return [];
    }
  }

  /// Erneuert abgelaufene Einwilligungen
  Future<DataProcessingConsent> renewConsent({
    required String userId,
    required ConsentType consentType,
    required ConsentSource source,
    String? reason,
  }) async {
    try {
      ProductionLogger.i(
        '🔄 Renewing consent for user: $userId, type: $consentType',
      );

      final existingConsent = await getConsent(userId, consentType);
      if (existingConsent == null) {
        throw ConsentException('No existing consent found to renew');
      }

      final auditEntry = ConsentAuditEntry(
        id: _generateAuditId(),
        timestamp: DateTime.now(),
        action: ConsentAction.renewed,
        source: source,
        metadata: {
          'renewal_reason': reason,
          'previous_consent_id': existingConsent.id,
          'previous_valid_until': existingConsent.validUntil.toIso8601String(),
        },
      );

      final renewedConsent = existingConsent.copyWith(
        grantedAt: DateTime.now(),
        validUntil: DateTime.now().add(_consentValidityPeriod),
        auditTrail: [...existingConsent.auditTrail, auditEntry],
      );

      await _saveConsentRecord(renewedConsent);
      await _addToConsentHistory(renewedConsent);

      _consentController.add(renewedConsent);
      ProductionLogger.i('✅ Consent renewed: ${renewedConsent.id}');

      return renewedConsent;
    } catch (e, stackTrace) {
      ProductionLogger.e('❌ Error renewing consent');
      rethrow;
    }
  }

  /// Exportiert alle Consent-Daten für DSGVO-Anfragen
  Future<Map<String, dynamic>> exportConsentData(String userId) async {
    try {
      ProductionLogger.i('📄 Exporting consent data for user: $userId');

      final consents = await getAllConsents(userId);
      final consentHistory = await _getConsentHistory(userId);

      final exportData = {
        'user_id': userId,
        'export_date': DateTime.now().toIso8601String(),
        'total_consents': consents.length,
        'active_consents': consents
            .where((c) => c.granted && c.validUntil.isAfter(DateTime.now()))
            .length,
        'consents': consents
            .map(
              (consent) => {
                'id': consent.id,
                'type': consent.consentType.name,
                'granted': consent.granted,
                'granted_at': consent.grantedAt.toIso8601String(),
                'valid_until': consent.validUntil.toIso8601String(),
                'withdrawn_at': consent.withdrawnAt?.toIso8601String(),
                'source': consent.source.name,
                'purpose': consent.purpose,
                'legal_basis': consent.legalBasis,
                'version': consent.consentVersion,
                'audit_trail': consent.auditTrail
                    .map(
                      (audit) => {
                        'timestamp': audit.timestamp.toIso8601String(),
                        'action': audit.action.name,
                        'source': audit.source.name,
                      },
                    )
                    .toList(),
              },
            )
            .toList(),
        'consent_history': consentHistory,
      };

      return exportData;
    } catch (e, stackTrace) {
      ProductionLogger.e('❌ Error exporting consent data');
      return {'error': 'Export failed'};
    }
  }

  /// Löscht alle Consent-Daten für einen User (DSGVO-Recht auf Löschung)
  Future<void> deleteAllConsentData(String userId) async {
    try {
      ProductionLogger.i('🗑️ Deleting all consent data for user: $userId');

      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      // Lösche alle Consent-Records
      for (final key in keys) {
        if (key.startsWith('$_consentPrefix$userId') ||
            key.startsWith('$_consentHistoryPrefix$userId')) {
          await prefs.remove(key);
        }
      }

      ProductionLogger.i('✅ All consent data deleted for user: $userId');
    } catch (e, stackTrace) {
      ProductionLogger.e('❌ Error deleting consent data');
      rethrow;
    }
  }

  /// Prüft ob Einwilligungen bald ablaufen (30 Tage vorher)
  Future<List<DataProcessingConsent>> getExpiringConsents(String userId) async {
    try {
      final consents = await getAllConsents(userId);
      final expirationThreshold = DateTime.now().add(const Duration(days: 30));

      return consents
          .where(
            (consent) =>
                consent.granted &&
                consent.validUntil.isBefore(expirationThreshold) &&
                consent.validUntil.isAfter(DateTime.now()),
          )
          .toList();
    } catch (e, stackTrace) {
      ProductionLogger.e('Error getting expiring consents');
      return [];
    }
  }

  /// Private Helper Methods

  Future<void> _saveConsentRecord(DataProcessingConsent consent) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_consentPrefix${consent.userId}_${consent.consentType.name}';
    final jsonString = jsonEncode(consent.toJson());
    await prefs.setString(key, jsonString);
  }

  Future<void> _addToConsentHistory(DataProcessingConsent consent) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_consentHistoryPrefix${consent.userId}';

      List<Map<String, dynamic>> history = [];
      final existingJson = prefs.getString(key);
      if (existingJson != null) {
        final List<dynamic> existingList = jsonDecode(existingJson);
        history = existingList.cast<Map<String, dynamic>>();
      }

      history.add({
        'consent_id': consent.id,
        'type': consent.consentType.name,
        'granted': consent.granted,
        'timestamp': DateTime.now().toIso8601String(),
        'action': consent.granted ? 'granted' : 'withdrawn',
      });

      // Behalte nur die letzten 100 Einträge
      if (history.length > 100) {
        history = history.sublist(history.length - 100);
      }

      final jsonString = jsonEncode(history);
      await prefs.setString(key, jsonString);
    } catch (e) {
      ProductionLogger.e('Error adding to consent history');
    }
  }

  Future<List<Map<String, dynamic>>> _getConsentHistory(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_consentHistoryPrefix$userId';
      final jsonString = prefs.getString(key);

      if (jsonString != null) {
        final List<dynamic> list = jsonDecode(jsonString);
        return list.cast<Map<String, dynamic>>();
      }

      return [];
    } catch (e) {
      ProductionLogger.e('Error getting consent history');
      return [];
    }
  }

  Future<String> _getCurrentIpAddress() async {
    // In einer echten App würde hier die IP-Adresse ermittelt
    return 'localhost'; // Placeholder
  }

  Future<String> _getUserAgent() async {
    // In einer echten App würde hier der User-Agent ermittelt
    return 'Flutter App'; // Placeholder
  }

  String _generateConsentId() {
    return 'consent_${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(8)}';
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

  /// Dispose resources
  void dispose() {
    _consentController.close();
  }
}

/// Custom exception für Consent-Fehler
class ConsentException implements Exception {
  final String message;
  ConsentException(this.message);

  @override
  String toString() => 'ConsentException: $message';
}
