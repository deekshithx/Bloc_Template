// lib/features/home/presentation/pages/home_page.dart
import 'package:bloc_template/core/theme/theme_cubit.dart';
import 'package:bloc_template/features/auth/bloc/auth_bloc.dart';
import 'package:bloc_template/features/auth/bloc/auth_event.dart';
import 'package:bloc_template/features/home/bloc/home_bloc.dart';
import 'package:bloc_template/features/home/bloc/home_event.dart';
import 'package:bloc_template/features/home/bloc/home_state.dart';
import 'package:bloc_template/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _fetch() => context.read<HomeBloc>().add(FetchRandomDog());

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
        leading: IconButton(
          onPressed: () {
            context.push('/profile');
          },
          icon: Icon(Icons.person),
        ),
        actions: [
          IconButton(
            icon: Icon(
              context.read<ThemeCubit>().state.brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: 'Toggle Theme',
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
          IconButton(
            onPressed: () {
              // simple logout using AuthBloc if available
              context.read<AuthBloc>().add(LoggedOut());
              context.go('/login'); // or navigate to profile/logout flow
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const CircularProgressIndicator();
            } else if (state is HomeLoaded) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(state.imageUrl, height: 300, fit: BoxFit.cover),
                  const SizedBox(height: 16),
                  PrimaryButton(onPressed: _fetch, text: 'Another dog'),
                ],
              );
            } else if (state is HomeError) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 12),
                  PrimaryButton(onPressed: _fetch, text: 'Retry'),
                ],
              );
            }
            // initial state
            return PrimaryButton(onPressed: _fetch, text: 'Load dog');
          },
        ),
      ),
    );
  }
}
