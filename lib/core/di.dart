// lib/core/di.dart
import 'package:bloc_template/core/theme/theme_cubit.dart';
import 'package:get_it/get_it.dart';
import 'storage/local_storage.dart';
import 'storage/secure_storage.dart';
import 'api/api_client.dart';
import 'services/connectivity_service.dart';
import 'services/notification_service.dart';
import 'services/dynamic_link_service.dart';

final GetIt getIt = GetIt.instance;

const String _baseUrl = 'https://api.escuelajs.co';

Future<void> initDi() async {
  // Local preferences
  final localStorage = LocalStorage();
  await localStorage.init();
  getIt.registerSingleton<LocalStorage>(localStorage);

  // Secure storage
  final secureStorage = SecureStorage();
  getIt.registerSingleton<SecureStorage>(secureStorage);

  // Api client
  final apiClient = ApiClient(baseUrl: _baseUrl, securedStorage: secureStorage);
  getIt.registerSingleton<ApiClient>(apiClient);

  // Services
  getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  getIt.registerLazySingleton<DynamicLinkService>(() => DynamicLinkService());

  // Theme Cubit
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  // NOTE:
  // Register feature-specific repositories, blocs etc. in the feature module
  // files (for example: features/auth/auth_module.dart) so feature code
  // controls its own DI registration and can import domain types.
}
