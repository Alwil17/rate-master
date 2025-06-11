import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  AuthStatus _status = AuthStatus.unknown;
  User? _user;
  String? _error;
  bool _isLoading = false;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService() {
    // Vérifier l'état d'authentification au démarrage
    _checkAuthStatus();
  }

  AuthStatus get status => _status;
  User? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> _checkAuthStatus() async {
    try {
      final isLoggedIn = await _authService.isAuthenticated();
      if (isLoggedIn) {
        _user = await _authService.fetchUserProfile();
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      _error = null;
      _status = AuthStatus.unknown;
      _isLoading = true;
      notifyListeners();

      _user = await _authService.login(email, password);
      if(_user!.role != 'user') {
        await logout();
        throw AuthenticationException('Access denied: Only regular users can log in.');
      }
      _status = AuthStatus.authenticated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(Map<String, String> data) async {
    try {
      _error = null;
      _status = AuthStatus.unknown;
      _isLoading = true;
      notifyListeners();

      _user = await _authService.register(data);
      _status = AuthStatus.authenticated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    try {
      await _authService.logout();
      _user = null;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Delete the current user's account and logout on success.
  Future<bool> deleteAccount() async {
    try {
      final actionStatus = await _authService.deleteUser();

      if (actionStatus) {
        await logout();
        return true;
      }
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Impossible de supprimer le compte. Veuillez réessayer plus tard.';
      notifyListeners();
      return false;
    }
  }

  /// Update user profile and persist changes.
  Future<bool> updateUser(Map<String, String> updatedData) async {
    try {
      _error = null;
      _isLoading = true;
      notifyListeners();

      _user = await _authService.editUserProfile(updatedData);
      _status = AuthStatus.authenticated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Network or server error.';
      notifyListeners();
      return false;
    }
  }

  /// Refresh the user profile from the server.
  Future<void> refreshProfile() async {
    try {
      _isLoading = true;
      _user = await _authService.fetchUserProfile();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
