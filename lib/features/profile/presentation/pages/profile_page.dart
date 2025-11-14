// lib/features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/bloc/auth_state.dart';
import '../../../auth/bloc/auth_event.dart';
import '../../../auth/domain/models/user.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    void refreshProfile() {
      context.read<AuthBloc>().add(RefreshUser());
    }

    void logout() {
      context.read<AuthBloc>().add(LoggedOut());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        actions: [
          IconButton(
            onPressed: refreshProfile,
            icon: const Icon(Icons.restart_alt_outlined),
            tooltip: 'Refresh Profile',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              final User user = state.user;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 8),
                  Text(user.name, style: AppTextStyles.body),
                  const SizedBox(height: 16),
                  Text(AppStrings.email, style: AppTextStyles.titleMedium),
                  const SizedBox(height: 8),
                  Text(user.email, style: AppTextStyles.body),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: logout,
                    icon: const Icon(Icons.exit_to_app),
                    label: const Text('Logout'),
                  ),
                ],
              );
            } else if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              // Not authenticated — redirect to login
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.go('/login');
              });
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
