import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Erstellt einen Gordon Meyrath Test-Benutzer für die Demo
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🔧 Erstelle Gordon Meyrath Test-Benutzer...');
  
  try {
    final prefs = await SharedPreferences.getInstance();
    
    // Test-Benutzer-Daten erstellen
    final gordonUser = {
      'id': 'gordon_dev_001',
      'email': 'gordonmeyrath@aukrug.de',
      'displayName': 'Gordon Meyrath',
      'isAnonymous': false,
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 5))
          .toIso8601String(),
      'lastLoginAt': DateTime.now().toIso8601String(),
      'preferences': {
        'language': 'de',
        'themeMode': 'system',
        'enableNotifications': true,
      },
      'privacySettings': {
        'consentToLocationProcessing': true,
        'consentToPhotoProcessing': true,
        'consentToAnalytics': true,
        'allowReportSubmission': true,
        'allowLocationTracking': true,
        'consentGivenAt': DateTime.now()
            .subtract(const Duration(days: 5))
            .toIso8601String(),
      },
      'isDeveloper': true,
    };
    
    // Benutzer in SharedPreferences speichern
    await prefs.setString('current_user', jsonEncode(gordonUser));
    
    // Demo-Passwort hashen (demo123)
    const password = 'demo123';
    final hashedPassword = 'demo_hash_${password}_gordon';
    await prefs.setString('pwd_gordon_dev_001', hashedPassword);
    
    // Session-Token erstellen
    final sessionToken = 'session_gordon_${DateTime.now().millisecondsSinceEpoch}';
    await prefs.setString('session_token', sessionToken);
    await prefs.setInt('session_expires', 
        DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch);
    
    print('✅ Gordon Meyrath Test-Benutzer erfolgreich erstellt!');
    print('📧 Email: gordonmeyrath@aukrug.de');
    print('🔑 Passwort: demo123');
    print('👤 Name: Gordon Meyrath');
    print('🆔 ID: gordon_dev_001');
    print('');
    print('🚀 Starte jetzt die Flutter App...');
    
  } catch (e) {
    print('❌ Fehler beim Erstellen des Test-Benutzers: $e');
  }
}
