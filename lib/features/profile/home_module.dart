// lib/features/home/home_module.dart
import 'package:bloc_template/features/profile/data/profile_api.dart';
import 'package:get_it/get_it.dart';
import '../../core/api/api_client.dart';
import 'data/profile_repository_impl.dart';
import 'bloc/profile_bloc.dart';
import 'domain/profile_repository.dart';

Future<void> initProfileModule() async {
  final getIt = GetIt.instance;
  if (getIt.isRegistered<ProfileRepository>()) return;

  final apiClient = getIt<ApiClient>();
  final profileApi = ProfileApi(apiClient: apiClient);
  getIt.registerFactory<ProfileApi>(() => profileApi);

  final repo = ProfileRepositoryImpl(profileApi: profileApi);
  getIt.registerLazySingleton<ProfileRepository>(() => repo);

  getIt.registerFactory(
    () => ProfileBloc(repository: getIt<ProfileRepository>()),
  );
}
