// lib/core/router/routes/home_routes.dart
import 'package:bloc_template/features/home/presentation/pages/home_page.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> homeRoutes = [
  GoRoute(
    path: '/home',
    name: 'home',
    builder: (context, state) => const HomePage(),
  ),
];
