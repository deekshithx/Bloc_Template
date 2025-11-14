// lib/features/auth/auth_module.dart
import 'package:get_it/get_it.dart';
import '../../core/api/api_client.dart';
import '../../core/storage/secure_storage.dart';
import 'data/auth_api.dart';
import 'data/auth_repository_impl.dart';
import 'bloc/auth_bloc.dart';
import 'domain/auth_repository.dart';

Future<void> initAuthModule() async {
  final getIt = GetIt.instance;

  // if already registered, skip
  if (getIt.isRegistered<AuthRepository>()) return;

  final apiClient = getIt<ApiClient>();
  final secureStorage = getIt<SecureStorage>();

  final authApi = AuthApi(apiClient: apiClient);
  getIt.registerLazySingleton<AuthApi>(() => authApi);

  final authRepo = AuthRepositoryImpl(
    authApi: authApi,
    secureStorage: secureStorage,
    apiClient: apiClient,
  );
  getIt.registerLazySingleton<AuthRepository>(() => authRepo);

  // AuthBloc registration: create new bloc when requested
  getIt.registerFactory(() => AuthBloc(repository: getIt<AuthRepository>()));
}
