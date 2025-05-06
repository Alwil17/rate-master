import 'dart:convert';
import 'package:rate_master/models/item.dart';
import 'package:rate_master/shared/api/api_routes.dart';

import 'api_service.dart';

class ItemService {
  final ApiService api;

  ItemService(this.api);

  Future<List<Item>> fetchItems() async {
    final response = await api.get(ApiRoutes.items);

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      List jsonList = jsonDecode(decoded);
      return jsonList.map((e) => Item.fromJson(e)).toList();
    } else {
      throw Exception("Erreur lors du chargement des items");
    }
  }

  Future<Item> fetchItem(num itemId) async {
    final response = await api.get("${ApiRoutes.items}/$itemId");

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonData = jsonDecode(decoded);
      return Item.fromJson(jsonData);
    } else {
      throw Exception("Erreur lors du chargement des items");
    }
  }

  Future<List<Item>> fetchRecommandations(num userId) async {
    final response = await api.get("${ApiRoutes.users}/$userId/recommandations");

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      List jsonList = jsonDecode(decoded);
      return jsonList.map((e) => Item.fromJson(e)).toList();
    } else {
      throw Exception("Erreur lors du chargement des recommendations pour l'utilisateur");
    }
  }
}
