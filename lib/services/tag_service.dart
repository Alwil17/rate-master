import 'dart:convert';
import 'package:rate_master/models/tag.dart';
import 'package:rate_master/shared/api/api_routes.dart';

import 'api_service.dart';

class TagService {
  final ApiService api;

  TagService(this.api);

  Future<List<Tag>> fetchTags() async {
    final response = await api.get(ApiRoutes.categories);

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      List jsonList = jsonDecode(decoded);
      return jsonList.map((e) => Tag.fromJson(e)).toList();
    } else {
      throw Exception("Erreur lors du chargement des items");
    }
  }
}
