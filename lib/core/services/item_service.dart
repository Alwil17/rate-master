import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rate_master/features/home/models/item.dart';
import 'package:rate_master/shared/api/api_routes.dart';

class ItemService {

  Future<List<Item>> fetchItems(String token) async {
    final response = await http.get(
      Uri.parse(ApiRoutes.items),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Item.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des items');
    }
  }
}
