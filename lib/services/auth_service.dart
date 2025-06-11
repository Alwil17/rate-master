import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:rate_master/shared/api/api_routes.dart';
import 'token_service.dart';
import '../models/user.dart';
import '../config/api_config.dart';

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException(this.message);

  @override
  String toString() => 'AuthenticationException: $message';
}

class AuthService {
  final TokenService _tokenService;
  final String _baseUrl = ApiConfig.baseUrl;
  User? _currentUser;
  String? _currentToken;

  AuthService({TokenService? tokenService})
      : _tokenService = tokenService ?? TokenService();

  User? get currentUser => _currentUser;

  String? get currentToken => _currentToken;

  // Connecte un utilisateur et stocke ses tokens
  Future<User> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/token'),
        body: {
          'username': email, // FastAPI OAuth2 attend 'username'
          'password': password,
        },
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _tokenService.saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );
        _currentToken = data['access_token'];

        // Récupérer les informations de l'utilisateur
        return await fetchUserProfile();
      } else {
        throw AuthenticationException('Identifiants invalides');
      }
    } catch (e) {
      throw AuthenticationException(
          'Erreur lors de la connexion: ${e.toString()}');
    }
  }

  // Rafraîchit le token d'accès
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _tokenService.getRefreshToken();
      if (refreshToken == null) {
        return false;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        body: jsonEncode({'refresh_token': refreshToken}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _tokenService.saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );
        _currentToken = data['access_token'];
        return true;
      } else {
        // Si le refresh token est invalide, on déconnecte l'utilisateur
        await logout();
        return false;
      }
    } catch (e) {
      debugPrint('Erreur lors du rafraîchissement du token: ${e.toString()}');
      return false;
    }
  }

  // Déconnecte l'utilisateur
  Future<void> logout() async {
    try {
      final refreshToken = await _tokenService.getRefreshToken();
      if (refreshToken != null) {
        // Optionnel: notifier le serveur de la déconnexion
        await http.post(
          Uri.parse('$_baseUrl/auth/logout'),
          body: jsonEncode({'refresh_token': refreshToken}),
          headers: {'Content-Type': 'application/json'},
        ).catchError((e) {
          // On ignore les erreurs ici, car on veut supprimer les tokens quoi qu'il arrive
          debugPrint(
              'Erreur lors de la déconnexion côté serveur: ${e.toString()}');
        });
      }
    } finally {
      // On supprime les tokens et l'utilisateur courant
      _currentUser = null;
      _currentToken = null;
      await _tokenService.deleteTokens();
    }
  }

  // Inscription d'un nouvel utilisateur
  Future<User> register(Map<String, String> data) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        body: jsonEncode({
          'name': data['name'],
          'email': data['email'],
          'password': data['password'],
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        // Une fois inscrit, on connecte automatiquement l'utilisateur
        return await login(data['email']!, data['password']!);
      } else {
        final errorData = jsonDecode(response.body);
        throw AuthenticationException(
            errorData['detail'] ?? 'Erreur lors de l\'inscription');
      }
    } catch (e) {
      throw AuthenticationException(
          'Erreur lors de l\'inscription: ${e.toString()}');
    }
  }

  // Récupère le token d'accès courant
  Future<String?> getAccessToken() async {
    _currentToken = await _tokenService.getAccessToken();
    return _currentToken;
  }

  // Récupère les informations de l'utilisateur courant
  Future<User> fetchUserProfile() async {
    try {
      final accessToken = await _tokenService.getAccessToken();
      final response = await http.get(
        Uri.parse('$_baseUrl/auth/me'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        _currentUser = User.fromJson(userData);
        return _currentUser!;
      } else {
        throw AuthenticationException(
            'Impossible de récupérer le profil utilisateur');
      }
    } catch (e) {
      throw AuthenticationException(
          'Erreur lors de la récupération du profil: ${e.toString()}');
    }
  }

  // Vérifie si l'utilisateur est authentifié
  Future<bool> isAuthenticated() async {
    return await _tokenService.isAuthenticated();
  }

  Future<User> editUserProfile(Map<String, String> updatedData) async {
    try {
      final accessToken = await _tokenService.getAccessToken();
      final response = await http.put(
        Uri.parse(ApiRoutes.updateUser),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        _currentUser = User.fromJson(userData);
        return _currentUser!;
      } else {
        throw AuthenticationException(
            'Impossible de récupérer le profil utilisateur');
      }
    } catch (e) {
      throw AuthenticationException(
          'Erreur lors de la récupération du profil: ${e.toString()}');
    }
  }

  Future<bool> deleteUser() async {
    try {
      final accessToken = await _tokenService.getAccessToken();
      final response = await http.delete(
        Uri.parse(ApiRoutes.deleteAccount),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
