import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/auth_service.dart';

/// StateNotifier zur Verwaltung und Persistenz des ThemeMode.
/// Speichert die Einstellung in den UserPreferences (falls eingeloggt),
/// ansonsten nur in-memory (Fallback auf system bei nächstem Start).
class ThemeModeState extends StateNotifier<ThemeMode> {
  final Ref ref;
  ThemeModeState(this.ref) : super(ThemeMode.system) {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final user = await ref.read(authServiceProvider).getCurrentUser();
    if (user != null) {
      state = user.preferences.themeMode;
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    if (state == mode) return;
    state = mode;
    final user = await ref.read(authServiceProvider).getCurrentUser();
    if (user != null) {
      await ref
          .read(authServiceProvider)
          .updateUserProfile(
            user: user,
            preferences: user.preferences.copyWith(themeMode: mode),
          );
    }
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeState, ThemeMode>(
  (ref) => ThemeModeState(ref),
);
