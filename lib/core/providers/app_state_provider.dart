import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rate_master/features/auth/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider with ChangeNotifier {
  late SharedPreferences sharedPreferences;

  String _locale = "fr";

  // Getters
  String get locale => _locale;


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
}

const String _kLocale = "locale";