import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(lightTheme);

  /// Loads previously saved theme or system default
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkTheme') ?? false;
    emit(isDark ? darkTheme : lightTheme);
  }

  /// Toggles theme and saves to local storage
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isCurrentlyDark = state.brightness == Brightness.dark;
    final newTheme = isCurrentlyDark ? lightTheme : darkTheme;

    await prefs.setBool('isDarkTheme', !isCurrentlyDark);
    emit(newTheme);
  }
}
