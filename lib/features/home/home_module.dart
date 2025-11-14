// lib/features/home/home_module.dart
import 'package:bloc_template/features/home/data/home_api.dart';
import 'package:get_it/get_it.dart';
import '../../core/api/api_client.dart';
import 'data/home_repository_impl.dart';
import 'bloc/home_bloc.dart';
import 'domain/home_repository.dart';

Future<void> initHomeModule() async {
  final getIt = GetIt.instance;
  if (getIt.isRegistered<HomeRepository>()) return;

  final apiClient = getIt<ApiClient>();
  final homeApi = HomeApi(apiClient: apiClient);
  getIt.registerLazySingleton<HomeApi>(() => homeApi);

  final repo = HomeRepositoryImpl(homeApi: homeApi);
  getIt.registerLazySingleton<HomeRepository>(() => repo);

  getIt.registerFactory(() => HomeBloc(repository: getIt<HomeRepository>()));
}
