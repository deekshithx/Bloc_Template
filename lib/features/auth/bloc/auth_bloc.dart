// lib/features/auth/bloc/auth_bloc.dart
import 'package:bloc_template/core/api/api_client.dart';
import 'package:bloc_template/features/auth/domain/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.getCurrentUser();
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthUnauthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      final email = event.email.trim();
      final password = event.password.trim();

      if (email.isEmpty || password.isEmpty) {
        emit(
          AuthFailure(
            message: 'Validation error',
            emailError: 'Email cannot be empty',
            passwordError: 'Password cannot be empty',
          ),
        );
        return;
      }

      final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
      if (!emailRegex.hasMatch(email)) {
        emit(
          AuthFailure(
            message: 'Validation error',
            emailError: 'Please enter a valid email address',
          ),
        );
        return;
      }

      if (password.length < 6) {
        emit(
          AuthFailure(
            message: 'Validation error',
            passwordError: 'Password must be at least 6 characters',
          ),
        );
        return;
      }

      emit(AuthLoading());
      try {
        final user = await repository.login(email: email, password: password);
        emit(AuthAuthenticated(user));
      } on UnauthorizedException {
        emit(AuthFailure(message: 'Invalid credentials.'));
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });

    on<SignupRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // if signup returns token similarly to login, repository.login may be reused
        await repository.logout(); // ensure clean state (optional)
        final user = await repository.login(
          email: event.email,
          password: event.password,
        );
        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });

    on<RefreshUser>((event, emit) async {
      final current = state;
      emit(AuthLoading());
      try {
        final user = await repository.getCurrentUser();
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        // fallback to previous state or emit failure
        if (current is AuthAuthenticated) {
          emit(current);
        } else {
          emit(AuthUnauthenticated());
        }
      }
    });

    on<LoggedOut>((event, emit) async {
      await repository.logout();
      emit(AuthUnauthenticated());
    });
  }
}
