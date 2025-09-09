import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'lib/features/auth/domain/user.dart';
import 'lib/features/auth/data/auth_service.dart';
import 'lib/core/services/demo_content_service.dart';

/// Script zum Erstellen eines Gordon Meyrath Demo-Benutzers
/// Führe dieses Script aus bevor du die App startest
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🔧 Erstelle Gordon Meyrath Demo-Benutzer...');
  
  try {
    // Demo-Benutzer-Daten laden
    final gordonData = DemoContentService.getGordonDemoUser();
    
    // User-Objekt erstellen
    final user = User.fromJson(gordonData);
    
    // SharedPreferences initialisieren
    final prefs = await SharedPreferences.getInstance();
    
    // Benutzer lokal speichern
    await prefs.setString('current_user', jsonEncode(user.toJson()));
    
    // Demo-Passwort hashen und speichern (Passwort: "demo123")
    const demoPassword = "demo123";
    final hashedPassword = _hashPassword(demoPassword);
    await prefs.setString('pwd_${user.id}', hashedPassword);
    
    // Session erstellen
    final sessionToken = _generateSessionToken();
    await prefs.setString('session_token', sessionToken);
    await prefs.setInt('session_expires', 
        DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch);
    
    print('✅ Gordon Meyrath Demo-Benutzer erfolgreich erstellt!');
    print('📧 Email: ${user.email}');
    print('🔑 Passwort: demo123');
    print('👤 Name: ${user.displayName}');
    print('🆔 ID: ${user.id}');
    print('');
    print('🚀 Du kannst jetzt die App starten und dich einloggen!');
    
  } catch (e) {
    print('❌ Fehler beim Erstellen des Benutzers: $e');
  }
}

/// Einfacher SHA-256 Hash für Demo-Zwecke
String _hashPassword(String password) {
  // Vereinfachter Hash für Demo-Zwecke
  // In der echten App würde hier eine sichere Hash-Funktion verwendet
  return 'demo_hash_${password.hashCode}_${DateTime.now().millisecondsSinceEpoch}';
}

/// Session Token generieren
String _generateSessionToken() {
  return 'demo_session_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
}
