// lib/core/router/guards/auth_guard.dart
import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';
import '../../di.dart';
import '../../storage/secure_storage.dart';

class AuthGuard {
  /// This redirect is called by go_router on navigation.
  /// It checks secure storage for an auth token.
  static Future<String?> redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final secureStorage = getIt<SecureStorage>();
    final token = await secureStorage.readAuthToken();
    final loggedIn = token != null && token.isNotEmpty;

    // go_router v13+ uses state.uri instead of state.location
    final currentPath = state.uri.path.toString();

    final loggingIn =
        currentPath == '/login' ||
        currentPath == '/signup' ||
        currentPath == '/splash';

    if (!loggedIn && !loggingIn) return '/login';
    if (loggedIn && (currentPath == '/login' || currentPath == '/signup')) {
      return '/home';
    }
    return null;
  }
}
