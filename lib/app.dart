// lib/app.dart
import 'package:bloc_template/core/services/connectivity_service.dart';
import 'package:bloc_template/features/auth/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/router/app_router.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/light_theme.dart';
import 'core/theme/dark_theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/home/bloc/home_bloc.dart';
import 'core/services/notification_service.dart';
import 'core/services/dynamic_link_service.dart';
import 'core/utils/logger.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _getIt = GetIt.instance;
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _initializeAsyncServices();
  }

  Future<void> _initializeAsyncServices() async {
    try {
      final notificationService = _getIt<NotificationService>();
      await notificationService.init();

      final dynamicLinkService = _getIt<DynamicLinkService>();
      await dynamicLinkService.init();

      Logger.info('Async services initialized successfully.');
    } catch (e, st) {
      Logger.error(
        'Async service initialization failed',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => _getIt<AuthBloc>()..add(AppStarted()),
        ),
        BlocProvider<HomeBloc>(create: (_) => _getIt<HomeBloc>()),
        BlocProvider<ConnectivityBloc>(
          create: (_) => ConnectivityBloc(_getIt<ConnectivityService>()),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => _getIt<ThemeCubit>()..loadTheme(),
        ),
      ],
      child: BlocListener<ConnectivityBloc, ConnectivityStatus>(
        listener: (context, state) {
          if (state == ConnectivityStatus.disconnected) {
            rootScaffoldMessengerKey.currentState?.showSnackBar(
              const SnackBar(
                content: Text('No internet connection'),
                backgroundColor: Colors.red,
                duration: Duration(days: 1), // persist until reconnected
              ),
            );
          } else {
            rootScaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          }
        },
        child: BlocBuilder<ThemeCubit, ThemeData>(
          builder: (context, theme) {
            return MaterialApp.router(
              scaffoldMessengerKey: rootScaffoldMessengerKey,
              debugShowCheckedModeBanner: false,
              title: 'MyDogApp',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: theme.brightness == Brightness.dark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              routerConfig: router,
            );
          },
        ),
      ),
    );
  }
}
