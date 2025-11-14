// lib/core/router/routes/home_routes.dart
import 'package:bloc_template/features/profile/presentation/pages/profile_page.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> profileRoutes = [
  GoRoute(
    path: '/profile',
    name: 'profile',
    builder: (context, state) => const ProfilePage(),
  ),
];
