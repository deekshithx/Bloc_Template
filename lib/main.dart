// lib/main.dart
import 'package:bloc_template/app.dart';
import 'package:flutter/material.dart';
import 'core/di.dart';
import 'features/auth/auth_module.dart';
import 'features/home/home_module.dart';
import 'core/utils/logger.dart';
// import 'package:firebase_core/firebase_core.dart'; // uncomment if using Firebase

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // If using Firebase services (FCM, Dynamic Links, etc.), uncomment:
    // await Firebase.initializeApp();

    await initDi();
    await initAuthModule();
    await initHomeModule();

    runApp(const MyApp());
  } catch (e, st) {
    Logger.error('App initialization failed', error: e, stackTrace: st);
  }
}
