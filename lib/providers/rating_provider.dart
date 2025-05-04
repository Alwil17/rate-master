import 'package:flutter/material.dart';
import 'package:rate_master/models/rating.dart';
import 'package:rate_master/services/rating_service.dart';

class RatingProvider with ChangeNotifier {
  final RatingService ratingService;

  List<Rating> _reviews = [];
  bool _isLoadingReviews = false;
  bool _isSubmitting = false;
  String? _error;

  /// Getters
  List<Rating> get reviews => _reviews;

  bool get isSubmitting => _isSubmitting;

  bool get isLoadingReviews => _isLoadingReviews;

  String? get error => _error;

  RatingProvider(this.ratingService);

  /// Call service and handle loading / error state
  Future<bool> submitRating(Rating rating) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final success = await ratingService.submitRating(rating);
      if (!success) {
        _error = 'Failed to submit rating';
      }
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// Loads reviews for a given item and notifies listeners.
  Future<void> fetchItemReviews(num itemId) async {
    _isLoadingReviews = true;
    _error = null;
    notifyListeners();
    try {
      _reviews = await ratingService.fetchItemReviews(itemId);
    } catch (e) {
      _error = e.toString();
      _reviews = [];
    } finally {
      _isLoadingReviews = false;
      notifyListeners();
    }
  }
}
