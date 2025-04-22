import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelper {
  final String token;

  ApiHelper(this.token);

  // Méthode pour un GET request
  Future<http.Response> get(String url) async {
    if (token == null) {
      throw Exception("Token manquant");
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Utilise le token stocké
        'Content-Type': 'application/json',
      },
    );

    return response; // Renvoie la réponse brute pour traitement
  }

  // Méthode pour un POST request
  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    if (token == null) {
      throw Exception("Token manquant");
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Utilise le token stocké
        'Content-Type': 'application/json',
      },
      body: body != null ? jsonEncode(body) : null,
    );

    return response;
  }

  Future<http.Response> put(String url, Map<String, dynamic> body) async {
    if (token == null) {
      throw Exception("Token manquant");
    }

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Utilise le token stocké
        'Content-Type': 'application/json',
      },
      body: body != null ? jsonEncode(body) : null,
    );

    return response;
  }

  // Méthode pour un DELETE request
  Future<http.Response> delete(String url) async {
    if (token == null) {
      throw Exception("Token manquant");
    }

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
    return ['Une erreur est survenue.'];
  }
}
