// lib/features/home/data/home_repository_impl.dart
import 'package:bloc_template/features/home/data/home_api.dart';
import 'package:bloc_template/features/home/domain/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeApi homeApi;

  HomeRepositoryImpl({required this.homeApi});

  @override
  Future<String> fetchRandomDogImage() {
    return homeApi.fetchRandomDogImage();
  }
}
