// lib/core/storage/local_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _onboardKey = 'onboard_done';
  static const _darkModeKey = 'dark_mode';

  late final SharedPreferences _prefs;

  LocalStorage();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get onboardDone => _prefs.getBool(_onboardKey) ?? false;
  set onboardDone(bool v) => _prefs.setBool(_onboardKey, v);

  bool get darkMode => _prefs.getBool(_darkModeKey) ?? false;
  set darkMode(bool v) => _prefs.setBool(_darkModeKey, v);
}
