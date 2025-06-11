import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'token_service.dart';
import 'auth_service.dart';

class AuthInterceptor implements InterceptorContract {
  final TokenService _tokenService;
  final Future<bool> Function() _onTokenRefreshFailure;

  AuthInterceptor({
    TokenService? tokenService,
    required Future<bool> Function() onTokenRefreshFailure,
  }) : _tokenService = tokenService ?? TokenService(),
       _onTokenRefreshFailure = onTokenRefreshFailure;

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final token = await _tokenService.getAccessToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    if (response.statusCode == 401) {
      // On appelle la fonction onTokenRefreshFailure pour gérer la redirection vers la page de connexion
      await _onTokenRefreshFailure();
    }
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() async {
    return true; // Intercepte toutes les requêtes
  }

  @override
  Future<bool> shouldInterceptResponse() async {
    return true; // Intercepte toutes les réponses
  }
}

class ApiClient {
  final String baseUrl;
  final AuthService _authService;
  late InterceptedClient _client;

  ApiClient({
    required this.baseUrl,
    AuthService? authService,
    required void Function() onUnauthorized,
  }) : _authService = authService ?? AuthService() {
    _client = InterceptedClient.build(
      interceptors: [
        AuthInterceptor(
          onTokenRefreshFailure: () async {
            // Essaie de rafraîchir le token
            final success = await _authService.refreshToken();
            if (!success) {
              onUnauthorized();
              return false;
            }
            return true;
          },
        ),
      ],
      requestTimeout: const Duration(seconds: 30),
    );
  }

  // Méthode GET avec gestion des tokens
  Future<http.Response> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
    Uri uri = Uri.parse('$baseUrl$endpoint');
    if (queryParams != null) {
      uri = uri.replace(queryParameters: queryParams);
    }

    try {
      final response = await _client.get(uri);
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Méthode POST avec gestion des tokens
  Future<http.Response> post(
    String endpoint, 
    {dynamic body, Map<String, String>? headers}
  ) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = {'Content-Type': 'application/json'};
    if (headers != null) {
      requestHeaders.addAll(headers);
    }

    try {
      final response = await _client.post(
        uri,
        body: body != null ? jsonEncode(body) : null,
        headers: requestHeaders,
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Méthode PUT avec gestion des tokens
  Future<http.Response> put(
    String endpoint, 
    {dynamic body, Map<String, String>? headers}
  ) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = {'Content-Type': 'application/json'};
    if (headers != null) {
      requestHeaders.addAll(headers);
    }

    try {
      final response = await _client.put(
        uri,
        body: body != null ? jsonEncode(body) : null,
        headers: requestHeaders,
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Méthode DELETE avec gestion des tokens
  Future<http.Response> delete(
    String endpoint, 
    {Map<String, String>? headers}
  ) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = {'Content-Type': 'application/json'};
    if (headers != null) {
      requestHeaders.addAll(headers);
    }

    try {
      final response = await _client.delete(uri, headers: requestHeaders);
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Gère les réponses et les erreurs
  http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw http.ClientException(
        'Erreur ${response.statusCode}: ${response.body}',
        response.request?.url,
      );
    }
  }
}