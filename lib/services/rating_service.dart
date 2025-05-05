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
      final decoded = utf8.decode(response.bodyBytes);
      List jsonList = jsonDecode(decoded);
      return jsonList.map((e) => Rating.fromJson(e)).toList();
    } else {
      throw Exception("Erreur lors du chargement des ratings");
    }
  }

  Future<List<Rating>> fetchItemReviews(num itemId) async {
    final response = await api.get("${ApiRoutes.items}/$itemId/ratings");

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      List jsonList = jsonDecode(decoded);
      return jsonList.map((e) => Rating.fromJson(e)).toList();
    } else {
      throw Exception("Erreur lors du chargement des ratings pour l'item");
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

  /// Submit a new rating via POST /ratings
  Future<bool> submitRating(Rating rating) async {
    final response = await api.post(
      ApiRoutes.ratings,
      rating.toJson(),
    );
    return response.statusCode == 201 || response.statusCode == 200;
  }

  Future<Rating> fetchUserReviewForItem(num itemId) async {
    final response = await api.get("${ApiRoutes.ratings}/$itemId/my-rating");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return Rating.fromJson(decoded);
    } else {
      throw Exception("Erreur lors du chargement des ratings");
    }
  }

  /// Delete a rating via DELETE /ratings/{ratingId}
  Future<bool> deleteRating(num ratingId) async {
    final response = await api.delete("${ApiRoutes.ratings}/$ratingId");
    return response.statusCode == 204;
  }
}
