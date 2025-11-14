// lib/features/auth/presentation/pages/login_page.dart
import 'package:bloc_template/features/auth/bloc/auth_bloc.dart';
import 'package:bloc_template/features/auth/bloc/auth_event.dart';
import 'package:bloc_template/features/auth/bloc/auth_state.dart';
import 'package:bloc_template/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailCtl.text = 'john@mail.com';
    _passCtl.text = 'changeme';
  }

  void _onLoginPressed() {
    context.read<AuthBloc>().add(
      LoginRequested(
        email: _emailCtl.text.trim(),
        password: _passCtl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.loginTitle)),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/home');
          } else if (state is AuthFailure &&
              state.emailError == null &&
              state.passwordError == null) {
            // show only general failure message (like invalid credentials)
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              String? emailError;
              String? passwordError;
              bool isLoading = false;

              if (state is AuthFailure) {
                emailError = state.emailError;
                passwordError = state.passwordError;
              } else if (state is AuthLoading) {
                isLoading = true;
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text(AppStrings.loginSubtitle, style: AppTextStyles.body),
                    const SizedBox(height: 16),

                    /// Email Field
                    TextField(
                      controller: _emailCtl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: AppStrings.email,
                        errorText: emailError,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// Password Field
                    TextField(
                      controller: _passCtl,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: AppStrings.password,
                        errorText: passwordError,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// Login Button
                    PrimaryButton(
                      onPressed: isLoading ? null : _onLoginPressed,
                      text: isLoading ? 'Logging in...' : 'Login',
                    ),
                    const SizedBox(height: 12),

                    /// Signup Navigation
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () => context.go('/signup'),
                        child: const Text(AppStrings.createAnAccount),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
