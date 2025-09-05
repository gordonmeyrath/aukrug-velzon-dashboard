import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/user.dart';

/// DSGVO-konformer Authentication Service
/// Implementiert lokale Authentifizierung mit Privacy by Design
class AuthService {
  static const String _userKey = 'aukrug_user';
  static const String _sessionKey = 'aukrug_session';
  static const String _dataRetentionKey = 'aukrug_data_retention';

  /// Anonyme Benutzer-Registrierung (DSGVO-konform ohne Personenbezug)
  Future<User?> registerAnonymous() async {
    try {
      final user = User(
        id: _generateSecureUserId(),
        email: '', // Leer für anonyme Nutzer
        isAnonymous: true,
        createdAt: DateTime.now(),
        preferences: const UserPreferences(),
        privacySettings: const PrivacySettings(
          // Nur essenzielle Verarbeitung erlaubt
          allowReportSubmission: true,
          consentGivenAt: null, // Kein Consent erforderlich für anonyme Nutzung
        ),
      );

      await _storeUserLocally(user);
      await _createSession(user.id);
      await _logPrivacyEvent('anonymous_registration', user.id);

      return user;
    } catch (e) {
      debugPrint('Error registering anonymous user: $e');
      return null;
    }
  }

  /// E-Mail-basierte Registrierung mit expliziter DSGVO-Einwilligung
  Future<User?> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
    String? phone,
    required PrivacySettings privacySettings,
  }) async {
    try {
      // Validierung der Einwilligung
      if (!_validatePrivacyConsent(privacySettings)) {
        throw Exception('Unvollständige Privacy-Einwilligung');
      }

      final hashedPassword = _hashPassword(password);
      final user = User(
        id: _generateSecureUserId(),
        email: email,
        displayName: displayName,
        phone: phone,
        isAnonymous: false,
        createdAt: DateTime.now(),
        preferences: const UserPreferences(),
        privacySettings: privacySettings.copyWith(
          consentGivenAt: DateTime.now(),
        ),
      );

      // Lokale Speicherung der Credentials (gehashed)
      await _storeUserLocally(user);
      await _storePasswordHash(user.id, hashedPassword);
      await _createSession(user.id);
      await _scheduleDataRetention(user);
      await _logPrivacyEvent('email_registration', user.id);

      return user;
    } catch (e) {
      debugPrint('Error registering user with email: $e');
      return null;
    }
  }

  /// Sichere lokale Anmeldung
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _getUserByEmail(email);
      if (user == null) return null;

      final storedPasswordHash = await _getPasswordHash(user.id);
      if (storedPasswordHash == null) return null;

      if (!_verifyPassword(password, storedPasswordHash)) return null;

      // Session erstellen und letzten Login aktualisieren
      await _createSession(user.id);
      final updatedUser = user.copyWith(lastLoginAt: DateTime.now());
      await _storeUserLocally(updatedUser);
      await _logPrivacyEvent('sign_in', user.id);

      return updatedUser;
    } catch (e) {
      debugPrint('Error signing in: $e');
      return null;
    }
  }

  /// Sichere Abmeldung mit Session-Bereinigung
  Future<void> signOut() async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser != null) {
        await _logPrivacyEvent('sign_out', currentUser.id);
      }

      await _clearSession();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  /// Aktuellen Benutzer abrufen
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson == null) return null;

      final user = User.fromJson(jsonDecode(userJson));
      
      // Session-Validierung
      final isSessionValid = await _isSessionValid(user.id);
      if (!isSessionValid) {
        await signOut();
        return null;
      }

      return user;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  /// Benutzer-Profil aktualisieren mit Privacy-Validierung
  Future<User?> updateUserProfile({
    required User user,
    String? displayName,
    String? phone,
    UserPreferences? preferences,
    PrivacySettings? privacySettings,
  }) async {
    try {
      // Validierung der Privacy-Änderungen
      if (privacySettings != null) {
        if (!_validatePrivacyConsent(privacySettings)) {
          throw Exception('Ungültige Privacy-Einstellungen');
        }
        await _logPrivacyEvent('privacy_settings_updated', user.id);
      }

      final updatedUser = user.copyWith(
        displayName: displayName ?? user.displayName,
        phone: phone ?? user.phone,
        preferences: preferences ?? user.preferences,
        privacySettings: privacySettings ?? user.privacySettings,
      );

      await _storeUserLocally(updatedUser);
      await _logPrivacyEvent('profile_updated', user.id);

      return updatedUser;
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      return null;
    }
  }

  /// DSGVO-konforme Benutzerdaten-Export (Artikel 20)
  Future<UserDataExport?> exportUserData(String userId) async {
    try {
      final user = await getCurrentUser();
      if (user == null || user.id != userId) return null;

      // Alle Benutzerdaten sammeln
      final reports = await _getUserReports(userId);
      final preferences = user.preferences.toJson();
      final privacySettings = user.privacySettings.toJson();

      final export = UserDataExport(
        userId: userId,
        exportedAt: DateTime.now(),
        userData: user.toJson(),
        reports: reports,
        preferences: preferences,
        privacySettings: privacySettings,
        exportFormat: 'JSON',
      );

      // Export-Request loggen für DSGVO-Compliance
      await _logPrivacyEvent('data_export_requested', userId);
      
      // Update des letzten Export-Datums
      final updatedPrivacySettings = user.privacySettings.copyWith(
        lastDataExportRequest: DateTime.now(),
      );
      await updateUserProfile(
        user: user,
        privacySettings: updatedPrivacySettings,
      );

      return export;
    } catch (e) {
      debugPrint('Error exporting user data: $e');
      return null;
    }
  }

  /// DSGVO-konforme Datenlöschung (Artikel 17 - "Recht auf Vergessenwerden")
  Future<bool> deleteUserData(String userId, {bool fullDeletion = false}) async {
    try {
      final user = await getCurrentUser();
      if (user == null || user.id != userId) return false;

      await _logPrivacyEvent('data_deletion_requested', userId);

      if (fullDeletion) {
        // Vollständige Löschung aller Daten
        await _deleteAllUserData(userId);
        await _logPrivacyEvent('full_data_deletion_completed', userId);
      } else {
        // Anonymisierung der Daten (Report-Daten bleiben für Gemeinde-Zwecke)
        await _anonymizeUserData(userId);
        await _logPrivacyEvent('data_anonymization_completed', userId);
      }

      return true;
    } catch (e) {
      debugPrint('Error deleting user data: $e');
      return false;
    }
  }

  /// Privacy-Einstellungen validieren
  bool _validatePrivacyConsent(PrivacySettings settings) {
    // Mindestanforderung: Erlaubnis für Report-Submission
    if (!settings.allowReportSubmission) {
      return false;
    }

    // Wenn Location-Processing gewünscht, muss Consent gegeben werden
    if (settings.allowLocationTracking && !settings.consentToLocationProcessing) {
      return false;
    }

    // Wenn Photo-Processing gewünscht, muss Consent gegeben werden
    if (settings.consentToPhotoProcessing) {
      // Zusätzliche Validierung könnte hier erfolgen
    }

    return true;
  }

  /// Sichere User-ID generieren
  String _generateSecureUserId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (i) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  /// Password hashing mit Salt
  String _hashPassword(String password) {
    final salt = _generateSalt();
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return '${digest.toString()}:$salt';
  }

  /// Salt generieren
  String _generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  /// Password verification
  bool _verifyPassword(String password, String hashedPassword) {
    final parts = hashedPassword.split(':');
    if (parts.length != 2) return false;

    final hash = parts[0];
    final salt = parts[1];
    
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    
    return hash == digest.toString();
  }

  /// Lokale User-Speicherung
  Future<void> _storeUserLocally(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  /// Password-Hash speichern (sicher getrennt von User-Daten)
  Future<void> _storePasswordHash(String userId, String hashedPassword) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pwd_$userId', hashedPassword);
  }

  /// Password-Hash abrufen
  Future<String?> _getPasswordHash(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pwd_$userId');
  }

  /// User by email finden
  Future<User?> _getUserByEmail(String email) async {
    final user = await getCurrentUser();
    if (user?.email == email) return user;
    return null; // In einer echten App würde hier eine Datenbank-Suche erfolgen
  }

  /// Session erstellen
  Future<void> _createSession(String userId) async {
    final session = UserSession(
      sessionId: _generateSecureUserId(),
      userId: userId,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
      isActive: true,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode(session.toJson()));
  }

  /// Session validieren
  Future<bool> _isSessionValid(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = prefs.getString(_sessionKey);
      if (sessionJson == null) return false;

      final session = UserSession.fromJson(jsonDecode(sessionJson));
      
      return session.userId == userId && 
             session.isActive && 
             session.expiresAt.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  /// Session löschen
  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  /// Privacy-Events für DSGVO-Compliance loggen
  Future<void> _logPrivacyEvent(String event, String userId) async {
    // In einer Produktions-App würden hier strukturierte Logs erstellt
    debugPrint('Privacy Event: $event for user $userId at ${DateTime.now()}');
  }

  /// Data Retention Schedule
  Future<void> _scheduleDataRetention(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final retentionDate = DateTime.now().add(user.privacySettings.dataRetentionPeriod.duration);
    await prefs.setString('${_dataRetentionKey}_${user.id}', retentionDate.toIso8601String());
  }

  /// User Reports abrufen (Placeholder)
  Future<List<Map<String, dynamic>>> _getUserReports(String userId) async {
    // Hier würden in einer echten App die Reports aus der Datenbank abgerufen
    return [];
  }

  /// Vollständige Datenlöschung
  Future<void> _deleteAllUserData(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_sessionKey);
    await prefs.remove('pwd_$userId');
    await prefs.remove('${_dataRetentionKey}_$userId');
    // Reports und andere User-Daten löschen würde hier erfolgen
  }

  /// Daten anonymisieren
  Future<void> _anonymizeUserData(String userId) async {
    final user = await getCurrentUser();
    if (user == null) return;

    final anonymizedUser = user.copyWith(
      email: 'anonymized@local',
      displayName: null,
      phone: null,
      isAnonymous: true,
      privacySettings: user.privacySettings.copyWith(
        lastDataDeletionRequest: DateTime.now(),
      ),
    );

    await _storeUserLocally(anonymizedUser);
    
    // Password-Hash löschen
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pwd_$userId');
  }
}

/// Provider für AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Provider für aktuellen User
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authService = ref.read(authServiceProvider);
  return await authService.getCurrentUser();
});

/// Provider für Authentication-Status
final authStateProvider = StreamProvider<User?>((ref) async* {
  final authService = ref.read(authServiceProvider);
  
  // Initial state
  yield await authService.getCurrentUser();
  
  // Hier könnte ein Stream für Real-time Updates implementiert werden
  // Für lokale Auth reicht der FutureProvider meist aus
});

/// Provider für Privacy-Compliance-Check
final privacyComplianceProvider = FutureProvider<bool>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return true; // Anonyme Nutzung ist compliant
  
  final settings = user.privacySettings;
  
  // Prüfung der DSGVO-Compliance
  if (settings.consentGivenAt == null && !user.isAnonymous) {
    return false; // Consent erforderlich für nicht-anonyme Nutzer
  }
  
  // Prüfung der Data Retention
  if (settings.dataRetentionPeriod == DataRetentionPeriod.custom) {
    // Hier würde geprüft werden, ob custom period gültig ist
  }
  
  return true;
});
