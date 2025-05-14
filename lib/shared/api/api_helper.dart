import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelper {
  final String token;

  ApiHelper(this.token);

  // Method for a GET request
  Future<http.Response> get(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Utilise le token stocké
        'Content-Type': 'application/json',
      },
    );

    return response; // Renvoie la réponse brute pour traitement
  }

  // Method for a POST request
  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Utilise le token stocké
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    return response;
  }

  // Method for a PUT request
  Future<http.Response> put(String url, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Utilise le token stocké
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    return response;
  }

  // Method for a DELETE request
  Future<http.Response> delete(String url) async {
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Utilise le token stocké
        'Content-Type': 'application/json',
      },
    );

    return response;
  }

  static List<String> parseApiErrors(dynamic detail) {
    if (detail is List) {
      return detail.map<String>((error) {
        final field = (error['loc'] as List?)?.last ?? 'Champ inconnu';
        final msg = error['msg'] ?? 'Erreur inconnue';
        return "$field : $msg";
      }).toList();
    }
    return [detail];
  }
}
