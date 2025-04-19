import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rate_master/features/auth/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  final SharedPreferences prefs;
  String? _token;
  User? _user;

  AuthProvider(this.prefs) {
    _loadFromPrefs();
  }

  // getters
  bool get isAuthenticated => _token != null;
  String? get token => _token;
  User? get user => _user;

  Future<void> _loadFromPrefs() async {
    _token = prefs.getString(_kToken);

    String? userJson = prefs.getString(_kUser);
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      _user = User.fromJson(userMap);
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://yourapi.com/auth/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      _user = data['user'];

      await prefs.setString(_kToken, _token!);
      await prefs.setString(_kUser, jsonEncode(_user!));
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    await prefs.remove(_kToken);
    await prefs.remove(_kUser);
    notifyListeners();
  }
}

const String _kToken = 'auth_token';
const String _kUser = 'auth_user';
