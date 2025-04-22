import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rate_master/features/auth/models/user.dart';
import 'package:rate_master/shared/api/api_routes.dart';
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

  Future<void> _setString(String key, String value) async {
    await prefs.setString(key, value);
    notifyListeners();
  }

  Future<void> _setBool(String key, bool value) async {
    await prefs.setBool(key, value);
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final res = await http.post(
      Uri.parse(ApiRoutes.login),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      String returnToken = data['token'];

      User retrievedUser = User.fromJson({
        ...data['user'], // Combine les données du patient
        'token': returnToken  // Ajoute le token dans les données
      });

      user = retrievedUser;

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String fullname, String email, String password) async {
    final res = await http.post(
      Uri.parse(ApiRoutes.register),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({'name': fullname, 'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    await prefs.remove(_kToken);
    await prefs.remove(_kUser);
    notifyListeners();
  }

  // Setters with SharedPreferences updates
  set user(User? value) {
    String userJson = jsonEncode(value!.toJson());
    _setString(_kUser, userJson);
    _setString(_kToken, value.token!);
  }
}

const String _kToken = 'auth_token';
const String _kUser = 'auth_user';
