// lib/features/auth/presentation/pages/signup_page.dart
import 'package:bloc_template/features/auth/bloc/auth_bloc.dart';
import 'package:bloc_template/features/auth/bloc/auth_event.dart';
import 'package:bloc_template/features/auth/bloc/auth_state.dart';
import 'package:bloc_template/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  void _onSignupPressed() {
    context.read<AuthBloc>().add(
      SignupRequested(
        email: _emailCtl.text.trim(),
        password: _passCtl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/home');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _emailCtl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passCtl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return PrimaryButton(
                    onPressed: state is AuthLoading ? null : _onSignupPressed,
                    text: state is AuthLoading ? 'Signing up...' : 'Sign up',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
