import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth_service.dart';
import '../../domain/user.dart';

/// State für Privacy Settings Page
class PrivacySettingsState {
  final User? user;
  final bool loading;
  final String? error;

  const PrivacySettingsState({
    required this.user,
    required this.loading,
    this.error,
  });

  PrivacySettingsState copyWith({User? user, bool? loading, String? error}) =>
      PrivacySettingsState(
        user: user ?? this.user,
        loading: loading ?? this.loading,
        error: error,
      );

  static const initial = PrivacySettingsState(user: null, loading: true);
}

class PrivacySettingsController extends StateNotifier<PrivacySettingsState> {
  final Ref ref;

  PrivacySettingsController(this.ref) : super(PrivacySettingsState.initial) {
    _load();
  }

  Future<void> _load() async {
    try {
      final user = await ref.read(authServiceProvider).getCurrentUser();
      state = state.copyWith(user: user, loading: false, error: null);
    } catch (e) {
      state = state.copyWith(loading: false, error: 'Fehler beim Laden');
    }
  }

  Future<void> reload() => _load();

  /// Generische Update-Methode für bool / enum Felder
  Future<bool> updateSetting(String key, dynamic value) async {
    final user = state.user;
    if (user == null) return false;
    try {
      final current = user.privacySettings;
      final updated = _mapUpdate(current, key, value);
      final saved = await ref
          .read(authServiceProvider)
          .updateUserProfile(
            user: user,
            privacySettings: updated.copyWith(
              consentGivenAt: updated.consentGivenAt ?? DateTime.now(),
            ),
          );
      if (saved != null) {
        state = state.copyWith(user: saved, error: null);
        return true;
      }
    } catch (e) {
      debugPrint('Privacy update error: $e');
    }
    return false;
  }

  PrivacySettings _mapUpdate(PrivacySettings s, String key, dynamic value) {
    switch (key) {
      case 'consentToLocationProcessing':
        return s.copyWith(consentToLocationProcessing: value as bool);
      case 'consentToPhotoProcessing':
        return s.copyWith(consentToPhotoProcessing: value as bool);
      case 'allowEmailContact':
        return s.copyWith(allowEmailContact: value as bool);
      case 'allowPhoneContact':
        return s.copyWith(allowPhoneContact: value as bool);
      case 'allowLocationTracking':
        return s.copyWith(allowLocationTracking: value as bool);
      case 'allowUsageAnalytics':
        return s.copyWith(allowUsageAnalytics: value as bool);
      case 'allowPersonalization':
        return s.copyWith(allowPersonalization: value as bool);
      case 'autoDeleteOldReports':
        return s.copyWith(autoDeleteOldReports: value as bool);
      case 'anonymizeOldData':
        return s.copyWith(anonymizeOldData: value as bool);
      case 'dataRetentionPeriod':
        return s.copyWith(dataRetentionPeriod: value as DataRetentionPeriod);
      default:
        return s;
    }
  }

  Future<bool> requestExport() async {
    final user = state.user;
    if (user == null) return false;
    try {
      final export = await ref
          .read(authServiceProvider)
          .exportUserData(user.id);
      if (export != null) {
        // Mark timestamp
        final updated = user.copyWith(
          privacySettings: user.privacySettings.copyWith(
            lastDataExportRequest: DateTime.now(),
          ),
        );
        await ref
            .read(authServiceProvider)
            .updateUserProfile(
              user: updated,
              privacySettings: updated.privacySettings,
            );
        state = state.copyWith(user: updated);
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// Gibt (success, navigateAway) zurück. navigateAway wenn Account gelöscht.
  Future<(bool, bool)> requestDeletion({required bool fullDeletion}) async {
    final user = state.user;
    if (user == null) return (false, false);
    try {
      final ok = await ref
          .read(authServiceProvider)
          .deleteUserData(user.id, fullDeletion: fullDeletion);
      if (ok) {
        if (fullDeletion) {
          state = state.copyWith(user: null);
          return (true, true);
        } else {
          final updated = await ref.read(authServiceProvider).getCurrentUser();
          state = state.copyWith(user: updated);
          return (true, false);
        }
      }
    } catch (_) {}
    return (false, false);
  }
}

final privacySettingsControllerProvider =
    StateNotifierProvider<PrivacySettingsController, PrivacySettingsState>((
      ref,
    ) {
      return PrivacySettingsController(ref);
    });
