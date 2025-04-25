import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rate_master/models/item.dart';
import 'package:rate_master/shared/api/api_routes.dart';

import 'api_service.dart';

class ItemService {
  final ApiService api;

  ItemService(this.api);

  Future<List<Item>> fetchItems() async {
    final response = await api.get(ApiRoutes.items);

    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Item.fromJson(e)).toList();
    } else {
      throw Exception("Erreur lors du chargement des items");
    }
  }
}
