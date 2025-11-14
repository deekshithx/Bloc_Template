// lib/features/home/presentation/routes.dart
import 'package:go_router/go_router.dart';
import 'pages/home_page.dart';

List<GoRoute> homeFeatureRoutes() {
  return [
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
  ];
}
