// lib/features/home/data/home_repository_impl.dart
import 'package:bloc_template/features/profile/data/profile_api.dart';
import 'package:bloc_template/features/profile/domain/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApi profileApi;

  ProfileRepositoryImpl({required this.profileApi});

  // @override
  // Future<String> fetchRandomDogImage() {
  //   return profileApi.fetchRandomDogImage();
  // }
}
