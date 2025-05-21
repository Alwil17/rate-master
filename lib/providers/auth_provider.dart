import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rate_master/models/user.dart';
import 'package:rate_master/shared/api/api_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  final SharedPreferences prefs;
  String? _token;
  User?   _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this.prefs) {
    _loadFromPrefs();
  }

  bool get isAuthenticated => _token != null;
  String? get token => _token;
  User? get user  => _user;
  bool get isLoading  => _isLoading;
  String? get error => _error;

  Future<void> _loadFromPrefs() async {
    _token = prefs.getString(_kToken);
    final userJson = prefs.getString(_kUser);
    if (userJson != null) {
      _user = User.fromJson(jsonDecode(userJson));
    }
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

  Future<dynamic> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

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
          _isLoading = false;
          _error = null;
          notifyListeners();
          return true;
        } else {
          _isLoading = false;
          _error = jsonDecode(userResponse.body)['detail'][0]['msg'];
          notifyListeners();
          return jsonDecode(userResponse.body)['detail'][0]['msg'];
        }
      } else {
        _isLoading = false;
        _error = jsonDecode(tokenResponse.body);
        notifyListeners();
        return jsonDecode(tokenResponse.body);
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Erreur réseau ou serveur.';
      notifyListeners();
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

  Future<bool> verifyToken() async {
    try {
      final tokenResponse = await http.get(
        Uri.parse(ApiRoutes.me),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $token'
        },
      );
      if (tokenResponse.statusCode == 200) {
        // Si tu veux, tu peux mettre à jour l'utilisateur ici
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> deleteAccount() async {
    try {
      // Envoie une requête DELETE à l'API pour supprimer le compte
      final response = await http.delete(
        Uri.parse(ApiRoutes.deleteAccount), // Assurez-vous que cette route est définie dans `ApiRoutes`
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Suppression réussie, nettoie les données locales
        await logout();
        return true;
      } else {
        // Gère les erreurs de l'API
        return jsonDecode(response.body);
      }
    } catch (e) {
      // Gère les erreurs réseau ou autres
      return {
        'detail': [
          {'msg': 'Impossible de supprimer le compte : $e'}
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

  Future<dynamic> updateUser(Map<String, String> updatedData) async {
    try {
      final response = await http.put(
        Uri.parse(ApiRoutes.updateUser), // Assurez-vous que cette route est définie dans `ApiRoutes`
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        final updatedUser = User.fromJson(jsonDecode(response.body));
        await _saveToPrefs(_token!, updatedUser); // Met à jour localement
        return true;
      } else {
        return jsonDecode(response.body); // Retourne les erreurs éventuelles
      }
    } catch (e) {
      return {
        'detail': [
          {'msg': 'Erreur réseau ou serveur.'}
        ]
      };
    }
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
