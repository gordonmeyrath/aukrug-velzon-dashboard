#!/usr/bin/env dart

import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  print('🚀 Erstelle Gordon Demo-Benutzer...');
  
  try {
    // SharedPreferences initialisieren
    final prefs = await SharedPreferences.getInstance();
    
    // Gordon Demo-Benutzer Daten
    const String userId = 'gordon-demo-001';
    const String username = 'gordonmeyrath';
    const String email = 'gordonmeyrath@aukrug.de';
    const String hashedPassword = 'demo123_hashed'; // Demo-Hash
    const String displayName = 'Gordon Meyrath';
    const String role = 'developer';
    const String sessionToken = 'gordon_session_token_demo_12345';
    
    // Benutzer-Authentifizierung setzen
    await prefs.setBool('user_authenticated', true);
    await prefs.setString('current_user_id', userId);
    await prefs.setString('session_token', sessionToken);
    await prefs.setInt('login_timestamp', DateTime.now().millisecondsSinceEpoch);
    
    // Benutzer-Profil Daten setzen
    await prefs.setString('user_$userId.id', userId);
    await prefs.setString('user_$userId.username', username);
    await prefs.setString('user_$userId.email', email);
    await prefs.setString('user_$userId.displayName', displayName);
    await prefs.setString('user_$userId.role', role);
    await prefs.setString('user_$userId.hashedPassword', hashedPassword);
    
    // DSGVO Einstellungen (Demo-konforme Standardwerte)
    await prefs.setBool('privacy_analytics_consent', false); // Opt-out Analytics
    await prefs.setBool('privacy_notifications_consent', true); // Opt-in Notifications
    await prefs.setBool('privacy_location_consent', true); // Location für Maps
    
    // App-Konfiguration
    await prefs.setString('selected_audience', 'residents'); // Developer = Residents
    await prefs.setBool('onboarding_completed', true);
    await prefs.setBool('terms_accepted', true);
    await prefs.setInt('terms_accepted_timestamp', DateTime.now().millisecondsSinceEpoch);
    
    print('✅ Gordon Demo-Benutzer erfolgreich erstellt!');
    print('📧 Email: $email');
    print('🔑 Passwort: demo123');
    print('👤 Rolle: $role');
    print('🎯 Zielgruppe: Einwohner (residents)');
    print('🔒 DSGVO-konforme Einstellungen gesetzt');
    print('');
    print('🎉 Du kannst dich jetzt in der App mit den obigen Daten anmelden!');
    
  } catch (e) {
    print('❌ Fehler beim Erstellen des Demo-Benutzers: $e');
    exit(1);
  }
}
