import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final SharedPreferences prefs;

  ApiService(this.prefs);

  /// Build standard headers, optionally adding the auth token.
  Future<Map<String, String>> _getHeaders({bool withAuth = true}) async {
    final token = prefs.getString('auth_token');
    return {
      'Content-Type': 'application/json',
      if (withAuth && token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Simple GET with a String URL.
  Future<http.Response> get(String url, {bool withAuth = true}) async {
    final headers = await _getHeaders(withAuth: withAuth);
    return http.get(Uri.parse(url), headers: headers);
  }

  /// GET using a pre-built Uri (with queryParameters, etc.).
  Future<http.Response> getUri(Uri uri, {bool withAuth = true}) async {
    final headers = await _getHeaders(withAuth: withAuth);
    return http.get(uri, headers: headers);
  }

  /// POST with JSON body.
  Future<http.Response> post(String url, dynamic body, {bool withAuth = true}) async {
    final headers = await _getHeaders(withAuth: withAuth);
    return http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
  }

  /// PUT with JSON body.
  Future<http.Response> put(String url, dynamic body, {bool withAuth = true}) async {
    final headers = await _getHeaders(withAuth: withAuth);
    return http.put(Uri.parse(url), headers: headers, body: jsonEncode(body));
  }

  /// DELETE by URL.
  Future<http.Response> delete(String url, {bool withAuth = true}) async {
    final headers = await _getHeaders(withAuth: withAuth);
    return http.delete(Uri.parse(url), headers: headers);
  }
}
