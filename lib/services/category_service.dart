import 'dart:convert';
import 'package:rate_master/models/category.dart';
import 'package:rate_master/shared/api/api_routes.dart';

import 'api_service.dart';

class CategoryService {
  final ApiService api;

  CategoryService(this.api);

  Future<List<Category>> fetchCategorys() async {
    final response = await api.get(ApiRoutes.items);

    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception("Erreur lors du chargement des items");
    }
  }
}
