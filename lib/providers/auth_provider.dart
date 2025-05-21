import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rate_master/models/user.dart';
import 'package:rate_master/shared/api/api_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// [AuthProvider] manages authentication state, user info, and error/loading flags.
class AuthProvider with ChangeNotifier {
  final SharedPreferences prefs;

  String? _token;
  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this.prefs) {
    _loadFromPrefs();
  }

  /// Public getters
  bool get isAuthenticated => _token != null;
  String? get token => _token;
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load token and user from shared preferences on startup.
  Future<void> _loadFromPrefs() async {
    _token = prefs.getString(_kToken);
    final userJson = prefs.getString(_kUser);
    if (userJson != null) {
      _user = User.fromJson(jsonDecode(userJson));
    }
    notifyListeners();
  }

  /// Save token and user into shared preferences.
  Future<void> _saveToPrefs(String token, User user) async {
    _token = token;
    _user = user;
    await prefs.setString(_kToken, token);
    await prefs.setString(_kUser, jsonEncode(user.toJson()));
    notifyListeners();
  }

  /// Perform login with [email] and [password].
  /// Updates [isLoading], [error], [token], and [user].
  /// Returns true on success, false otherwise.
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Retrieve access token
      final tokenRes = await http.post(
        Uri.parse(ApiRoutes.token),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'username': email,
          'password': password,
        },
      );

      if (tokenRes.statusCode != 200) {
        final body = jsonDecode(tokenRes.body);
        _error = _parseError(body);
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final tokenBody = jsonDecode(tokenRes.body);
      final accessToken = tokenBody['access_token'] as String;

      // 2. Fetch user profile
      final userRes = await http.get(
        Uri.parse(ApiRoutes.me),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );

      if (userRes.statusCode != 200) {
        final body = jsonDecode(userRes.body);
        _error = _parseError(body);
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final userMap = jsonDecode(userRes.body) as Map<String, dynamic>;
      final user = User.fromJson(userMap).copyWith(token: accessToken);

      // 3. Save credentials locally
      await _saveToPrefs(accessToken, user);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Network or server error.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout clears token, user, and shared preferences.
  Future<void> logout() async {
    _token = null;
    _user = null;
    await prefs.remove(_kToken);
    await prefs.remove(_kUser);
    notifyListeners();
  }

  /// Register a new user and perform login on success.
  Future<bool> register(Map<String, String> data) async {
    try {
      final registerRes = await http.post(
        Uri.parse(ApiRoutes.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': data['name'],
          'email': data['email'],
          'password': data['password'],
        }),
      );

      if (registerRes.statusCode != 200 && registerRes.statusCode != 201) {
        final body = jsonDecode(registerRes.body);
        _error = _parseError(body);
        notifyListeners();
        return false;
      }

      // Auto-login after successful registration
      return await login(data['email']!, data['password']!);
    } catch (e) {
      _error = 'Network or server error.';
      notifyListeners();
      return false;
    }
  }

  /// Verify the current token by making a request to the API.
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

  /// Delete the current user's account and logout on success.
  Future<bool> deleteAccount() async {
    if (_token == null) return false;

    try {
      final response = await http.delete(
        Uri.parse(ApiRoutes.deleteAccount),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        await logout();
        return true;
      }

      final body = jsonDecode(response.body);
      _error = _parseError(body);
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Network or server error.';
      notifyListeners();
      return false;
    }
  }

  /// Update user profile and persist changes.
  Future<bool> updateUser(Map<String, String> updatedData) async {
    if (_token == null) return false;

    try {
      final response = await http.put(
        Uri.parse(ApiRoutes.updateUser),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode != 200) {
        final body = jsonDecode(response.body);
        _error = _parseError(body);
        notifyListeners();
        return false;
      }

      final updatedUser = User.fromJson(jsonDecode(response.body));
      await _saveToPrefs(_token!, updatedUser);
      return true;
    } catch (e) {
      _error = 'Network or server error.';
      notifyListeners();
      return false;
    }
  }

  /// Helper to extract a user-friendly error message from API error bodies.
  String _parseError(dynamic body) {
    try {
      if (body is Map<String, dynamic> && body.containsKey('detail')) {
        final detail = body['detail'];
        if (detail is List && detail.isNotEmpty && detail[0] is Map) {
          return detail[0]['msg'] as String;
        }
        if (detail is String) return detail;
      }
      return body.toString();
    } catch (_) {
      return 'Unknown error';
    }
  }
}

const String _kToken = 'auth_token';
const String _kUser = 'auth_user';