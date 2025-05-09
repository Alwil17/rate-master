import 'dart:convert';
import 'package:http/http.dart';
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

  /// Submit or update a rating depending on whether the ID is present.
  Future<bool> submitRating(Rating rating) async {
    late final Response response;

    if (rating.id != null) {
      // Update existing rating
      response = await api.put(
        "${ApiRoutes.ratings}/${rating.id}",
        rating.toJson(),
      );
    } else {
      // Create new rating
      response = await api.post(
        ApiRoutes.ratings,
        rating.toJson(),
      );
    }

    return response.statusCode == 200 || response.statusCode == 201;
  }


  Future<Rating?> fetchUserReviewForItem(num itemId) async {
    final response = await api.get("${ApiRoutes.ratings}/$itemId/my-rating");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return Rating.fromJson(decoded);
    }else if (response.statusCode == 404) {
      // Silently return null if no review found
      return null;
    } else {
      // Unexpected error, can still be logged if needed
      throw Exception("Erreur lors du chargement des ratings");
    }
  }

  /// Delete a rating via DELETE /ratings/{ratingId}
  Future<bool> deleteRating(num ratingId) async {
    final response = await api.delete("${ApiRoutes.ratings}/$ratingId");
    return response.statusCode == 204;
  }

  /// fetch all reviews for a user
  Future<List<Rating>> fetchMyReviews(num userId) async {
    final response = await api.get("${ApiRoutes.users}/$userId/ratings");

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      List jsonList = jsonDecode(decoded);
      return jsonList.map((e) => Rating.fromJson(e)).toList();
    } else {
      throw Exception("Erreur lors du chargement des ratings pour l'utilisateur");
    }
  }
}
