import 'dart:convert';
import 'package:rate_master/models/item.dart';
import 'package:rate_master/shared/api/api_routes.dart';

import 'api_service.dart';

class ItemService {
  final ApiService api;

  ItemService(this.api);

  Future<List<Item>> fetchItems({
    int? categoryId,
    List<String>? tags,
    bool ascending = true,
  }) async {
    final queryParams = <String, dynamic>{
      if (categoryId != null) 'category_id': categoryId.toString(),
      if (tags != null && tags.isNotEmpty) 'tags': tags,
      // If your backend supports sorting, add this:
      // 'sort': 'asc' or 'desc' or a field name
      // For now, we skip it unless you confirm it's supported
    };

    final uri = Uri.parse(ApiRoutes.items).replace(queryParameters: {
      for (var entry in queryParams.entries)
        if (entry.value is List)
          ...{for (var v in (entry.value as List)) 'tags': v}
        else
          entry.key: entry.value.toString(),
    });

    final response = await api.getUri(uri);

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      List jsonList = jsonDecode(decoded);
      return jsonList.map((e) => Item.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load filtered items");
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
