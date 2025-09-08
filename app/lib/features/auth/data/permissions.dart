import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/feature_flags.dart';
import 'auth_service.dart';

/// Provider für Community-Zugriff (jetzt auch für nicht eingeloggte Benutzer)
final canAccessCommunityProvider = Provider<bool>((ref) {
  // Community ist jetzt für alle zugänglich, unabhängig vom Login-Status
  return featureFlags.isEnabled('FEATURE_FEED');
});

/// Provider für Community-Schreibberechtigungen (nur für eingeloggte Benutzer)
final canWriteInCommunityProvider = Provider<bool>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  final user = userAsync.asData?.value;
  if (user == null || user.isAnonymous) {
    return false;
  }
  return featureFlags.isEnabled('FEATURE_FEED');
});
