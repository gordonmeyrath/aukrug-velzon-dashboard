import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/permissions.dart';

/// Guard für Community-Routen. Liefert Redirect-Pfad oder null.
String? communityRouteRedirect(Ref ref, GoRouterState state) {
  final allowed = ref.read(canAccessCommunityProvider);
  if (!allowed) {
    return '/community/locked';
  }
  return null;
}
