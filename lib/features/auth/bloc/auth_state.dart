// lib/features/auth/bloc/auth_state.dart
import 'package:equatable/equatable.dart';
import '../domain/models/user.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  final String? emailError;
  final String? passwordError;

  AuthFailure({required this.message, this.emailError, this.passwordError});

  @override
  List<Object?> get props => [message, emailError, passwordError];
}
