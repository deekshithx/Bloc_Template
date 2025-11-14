// lib/features/auth/domain/auth_repository.dart
import 'package:bloc_template/features/auth/domain/models/user.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});
  Future<void> logout();
  Future<User?> getCurrentUser();
}
