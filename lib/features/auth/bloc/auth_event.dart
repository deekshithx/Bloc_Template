// lib/features/auth/bloc/auth_event.dart
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignupRequested extends AuthEvent {
  final String email;
  final String password;

  SignupRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RefreshUser extends AuthEvent {}

class LoggedOut extends AuthEvent {}
