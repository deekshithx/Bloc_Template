// lib/features/auth/presentation/pages/splash_page.dart
import 'package:bloc_template/features/auth/bloc/auth_bloc.dart';
import 'package:bloc_template/features/auth/bloc/auth_event.dart';
import 'package:bloc_template/features/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Trigger AppStarted to let AuthBloc check token and user
    Future.microtask(() => context.read<AuthBloc>().add(AppStarted()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/home');
          } else if (state is AuthUnauthenticated) {
            context.go('/login');
          }
        },
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
