import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rate_master/features/auth/models/user.dart';
import 'package:rate_master/shared/api/api_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  final SharedPreferences prefs;
  String? _token;
  User?   _user;

  AuthProvider(this.prefs) {
    _loadFromPrefs();
  }

  bool get isAuthenticated => _token != null;
  String? get token => _token;
  User? get user  => _user;

  Future<void> _loadFromPrefs() async {
    _token = prefs.getString(_kToken);
    final userJson = prefs.getString(_kUser);
    if (userJson != null) {
      _user = User.fromJson(jsonDecode(userJson));
    }
    print("loagind prefs");
    print(user);
    notifyListeners();
  }

  Future<void> _saveToPrefs(String token, User user) async {
    _token = token;
    _user  = user;
    await prefs.setString(_kToken, token);
    await prefs.setString(_kUser, jsonEncode(user.toJson()));
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

  Future<dynamic> login(String email, String password) async {
    try {
      final tokenResponse = await http.post(
        Uri.parse(ApiRoutes.token),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': '*/*',
        },
        body: {
          'username': email,
          'password': password,
        },
      );

      if (tokenResponse.statusCode == 200) {
        final tokenBody = jsonDecode(tokenResponse.body);
        final token = tokenBody['access_token'];

        // Ensuite, récupérer les infos utilisateur via /me ou /users/me
        final userResponse = await http.get(
          Uri.parse(ApiRoutes.me),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        if (userResponse.statusCode == 200) {
          final userMap = jsonDecode(userResponse.body) as Map<String, dynamic>;
          final user = User.fromJson(userMap).copyWith(token: token);

          // 3. Sauvegarde locale
          await _saveToPrefs(token, user);

          return true;
        } else {
          return jsonDecode(userResponse.body);
        }
      } else {
        return jsonDecode(tokenResponse.body);
      }
    } catch (e) {
      return {
        'detail': [
          {'msg': 'Erreur réseau ou serveur.'}
        ]
      };
    }
  }

  Future<dynamic> register(Map<String, String> datas) async {
    try {
      // Étape 1 : Inscription
      final registerResponse = await http.post(
        Uri.parse(ApiRoutes.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': datas["name"],
          'email': datas["email"],
          'password': datas["password"],
        }),
      );

      if (registerResponse.statusCode != 200 && registerResponse.statusCode != 201) {
        return jsonDecode(registerResponse.body);
      }

      return await login(datas["email"]!, datas["password"]!);

    } catch (e) {
      return {
        'detail': [
          {'msg': 'Erreur réseau ou serveur.'}
        ]
      };
    }
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
