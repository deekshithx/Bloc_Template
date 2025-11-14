// lib/core/router/app_router.dart
import 'package:bloc_template/core/router/routes/profile_routes.dart';
import 'package:go_router/go_router.dart';
import 'routes/auth_routes.dart';
import 'routes/home_routes.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [...authRoutes, ...homeRoutes, ...profileRoutes],
  redirect: (context, state) =>
      null, // We'll use per-request async guard below if needed.
  refreshListenable: null,
  // Note: go_router supports synchronous redirect or async redirect via redirectAsync (in newer versions).
  // We'll instead rely on using an auth guard inside route-level redirect when needed or call AuthGuard.redirect
);
