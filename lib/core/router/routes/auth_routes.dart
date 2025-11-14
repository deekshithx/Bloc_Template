// lib/core/router/routes/auth_routes.dart
import 'package:bloc_template/features/auth/presentation/pages/login_page.dart';
import 'package:bloc_template/features/auth/presentation/pages/signup_page.dart';
import 'package:bloc_template/features/auth/presentation/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> authRoutes = [
  GoRoute(
    path: '/splash',
    name: 'splash',
    builder: (context, state) => const SplashPage(),
  ),
  GoRoute(
    path: '/login',
    name: 'login',
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: '/signup',
    name: 'signup',
    builder: (context, state) => const SignupPage(),
  ),
];
