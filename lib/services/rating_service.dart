import 'dart:convert';
import 'package:rate_master/models/rating.dart';
import 'package:rate_master/shared/api/api_routes.dart';

import 'api_service.dart';

class RatingService {
  final ApiService api;

  RatingService(this.api);

  Future<List<Rating>> fetchRatings() async {
    final response = await api.get(ApiRoutes.ratings);

    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Rating.fromJson(e)).toList();
    } else {
      throw Exception("Erreur lors du chargement des ratings");
    }
  }

  Future<Rating> fetchRating(num ratingId) async {
    final response = await api.get("${ApiRoutes.ratings}/$ratingId");

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Rating.fromJson(jsonData);
    } else {
      throw Exception("Erreur lors du chargement des ratings");
    }
  }
}
