import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:rate_master/shared/api/api_routes.dart';
import 'token_service.dart';

class ApiService {
  final TokenService _tokenService;

  ApiService({
    TokenService? tokenService,
  }) : _tokenService = tokenService ?? TokenService();

  /// Add authentication headers if token exists
  Future<Map<String, String>> _getHeaders({Map<String, String>? additionalHeaders}) async {
    final headers = {'Content-Type': 'application/json'};

    final token = await _tokenService.getAccessToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// Make GET request to the API
  Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
    final finalHeaders = await _getHeaders(additionalHeaders: headers);
    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: finalHeaders,
      );
      return await _handleResponse(response);
    } catch (e) {
      debugPrint('GET Error: $e');
      rethrow;
    }
  }

  /// GET using a pre-built Uri (with queryParameters, etc.).
  Future<http.Response> getUri(Uri uri, {Map<String, String>? headers}) async {
    final finalHeaders = await _getHeaders(additionalHeaders: headers);
    try {
      final response = await http.get(
        uri,
        headers: finalHeaders,
      );
      return await _handleResponse(response);
    } catch (e) {
      debugPrint('GET URI Error: $e');
      rethrow;
    }
  }

  /// Make POST request to the API
  Future<http.Response> post(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final finalHeaders = await _getHeaders(additionalHeaders: headers);
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: finalHeaders,
        body: jsonEncode(body),
      );
      return await _handleResponse(response);
    } catch (e) {
      debugPrint('POST Error: $e');
      rethrow;
    }
  }

  /// Make PUT request to the API
  Future<http.Response> put(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final finalHeaders = await _getHeaders(additionalHeaders: headers);
    try {
      final response = await http.put(
        Uri.parse(endpoint),
        headers: finalHeaders,
        body: jsonEncode(body),
      );
      return await _handleResponse(response);
    } catch (e) {
      debugPrint('PUT Error: $e');
      rethrow;
    }
  }

  /// Make DELETE request to the API
  Future<http.Response> delete(String endpoint, {Object? body, Map<String, String>? headers}) async {
    final finalHeaders = await _getHeaders(additionalHeaders: headers);
    try {
      final response = await http.delete(
        Uri.parse(endpoint),
        headers: finalHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
      return await _handleResponse(response);
    } catch (e) {
      debugPrint('DELETE Error: $e');
      rethrow;
    }
  }

  /// Handle API response, checking for token expiration
  Future<http.Response> _handleResponse(http.Response response) async {
    if (response.statusCode == 401) {
      // Token might be expired, try to refresh it
      await _handleTokenRefresh();

      // Retry the request with the new token
      final retryHeaders = await _getHeaders();
      final Uri requestUrl = response.request!.url;
      final String method = response.request!.method;
      
      // Récupérer le corps de la requête originale depuis la réponse
      String originalBody = '';
      try {
        if (response.request is http.Request) {
          originalBody = (response.request as http.Request).body;
        }
      } catch (e) {
        debugPrint('Impossible de récupérer le corps de la requête: $e');
      }
      
      // Créer et exécuter une nouvelle requête
      switch (method) {
        case 'GET':
          return await http.get(requestUrl, headers: retryHeaders);
        case 'POST':
          return await http.post(requestUrl, headers: retryHeaders, body: originalBody);
        case 'PUT':
          return await http.put(requestUrl, headers: retryHeaders, body: originalBody);
        case 'DELETE':
          return await http.delete(requestUrl, headers: retryHeaders, body: originalBody);
        default:
          throw Exception('Méthode HTTP non supportée: $method');
      }
    }

    return response;
  }

  /// Handle token refresh when a 401 is received
  Future<void> _handleTokenRefresh() async {
    final refreshToken = await _tokenService.getRefreshToken();
    if (refreshToken == null) return;

    try {
      final response = await http.post(
        Uri.parse(ApiRoutes.refreshToken),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _tokenService.saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );
      }
    } catch (e) {
      debugPrint('Token refresh error: $e');
    }
  }
}