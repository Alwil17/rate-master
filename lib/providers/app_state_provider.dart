import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider with ChangeNotifier {
  late SharedPreferences sharedPreferences;

  String _locale = "fr";
  String _appVersion = "1.0.0";
  bool _isDarkMode = false;

  // Getters
  String get locale => _locale;
  String get appVersion => _appVersion;
  bool get isDarkMode => _isDarkMode;


  // Initialize SharedPreferences
  AppStateProvider(this.sharedPreferences);

  // Generic methods for storing data in SharedPreferences
  Future<void> _setString(String key, String value) async {
    await sharedPreferences.setString(key, value);
    notifyListeners();
  }
  Future<void> _setBool(String key, bool value) async {
    await sharedPreferences.setBool(key, value);
    notifyListeners();
  }

  // Load preferences from SharedPreferences at startup
  Future<void> loadPreferences() async {
    // Use jsonDecode for user data stored in SharedPreferences
    _locale = sharedPreferences.getString(_kLocale) ?? "fr";
    _isDarkMode = sharedPreferences.getBool(_kTheme) ?? false;

    // Get app version
    PackageInfo info = await PackageInfo.fromPlatform();
    _appVersion = info.version;

    notifyListeners();
  }

  // Load preferences from SharedPreferences at startup
  Future<void> clear() async {
    // Use jsonDecode for user data stored in SharedPreferences
    await sharedPreferences.clear();

    notifyListeners();
  }

  set locale(String state) {
    _setString(_kLocale, state);
    _locale = state;
  }

  set isDarkMode(bool state) {
    _setBool(_kTheme, state);
    _isDarkMode = state;
  }

}

const String _kLocale = "locale";
const String _kTheme = "is_dark_mode";