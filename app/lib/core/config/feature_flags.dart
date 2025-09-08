import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

/// Zentrale Verwaltung von Feature Flags (BuddyBoss-Parität)
/// Flags werden einmalig aus .env geladen (eager) – später optional remote override.
class FeatureFlags {
  static final FeatureFlags _instance = FeatureFlags._internal();
  factory FeatureFlags() => _instance;
  FeatureFlags._internal();

  final Map<String, bool> _flags = {};
  bool _initialized = false;

  Future<void> init({String fileName = '.env'}) async {
    if (_initialized) return;
    try {
      final file = File(fileName);
      if (await file.exists()) {
        final lines = await file.readAsLines();
        for (final l in lines) {
          final line = l.trim();
          if (line.isEmpty || line.startsWith('#')) continue;
          final eq = line.indexOf('=');
          if (eq == -1) continue;
          final key = line.substring(0, eq).trim();
          final value = line.substring(eq + 1).trim();
          if (key.startsWith('FEATURE_')) {
            _flags[key] = value.toLowerCase() == 'true';
          }
        }
      }
      _initialized = true;
    } catch (e) {
      debugPrint('FeatureFlags init error: $e');
    }
  }

  bool isEnabled(String key) => _flags[key] ?? false;

  Map<String, bool> snapshot() => Map.unmodifiable(_flags);
}

final featureFlags = FeatureFlags();
