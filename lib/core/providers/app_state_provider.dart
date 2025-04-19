import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rate_master/features/auth/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider with ChangeNotifier {
  late SharedPreferences sharedPreferences;

  bool _loggedIn = false;
  String _locale = "fr";

  // Getters
  bool get loggedIn => _loggedIn;
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
    _loggedIn = sharedPreferences.getBool(_kLoggedIn) ?? false;
    _locale = sharedPreferences.getString(_kLocale) ?? "fr";

    notifyListeners();
  }

  // Load preferences from SharedPreferences at startup
  Future<void> clear() async {
    // Use jsonDecode for user data stored in SharedPreferences
    _loggedIn = false;
    //_user = null;
    await sharedPreferences.clear();

    notifyListeners();
  }

  // Setters with SharedPreferences updates
  set loggedIn(bool state) {
    _setBool(_kLoggedIn, state);
    _loggedIn = state;
  }

  set locale(String state) {
    _setString(_kLocale, state);
    _locale = state;
  }

  set user(User? value) {
    String userJson = jsonEncode(value!.toJson());
    _setString(_kUser, userJson);
  }
}

const String _kUser = "user";
const String _kLoggedIn = "loggedIn";
const String _kLocale = "locale";