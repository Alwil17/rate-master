import 'package:flutter/material.dart';
import 'package:rate_master/models/rating.dart';
import 'package:rate_master/services/rating_service.dart';

class RatingProvider with ChangeNotifier {
  final RatingService ratingService;

  List<Rating> _reviews = [];
  Rating? _currentRating;
  bool _isLoadingReviews = false;
  bool _isSubmitting = false;
  bool _isLoadingCurrentUserRating = false;
  String? _error;

  /// Getters
  List<Rating> get reviews => _reviews;
  Rating? get currentRating => _currentRating;
  bool get isSubmitting => _isSubmitting;

  bool get isLoadingReviews => _isLoadingReviews;
  bool get isLoadingCurrentUserRating => _isLoadingCurrentUserRating;

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

  /// Loads user review for a given item stores it in [_currentRating].
  Future<void> fetchUserReviewForItem(num itemId) async {
    _isLoadingCurrentUserRating = true;
    notifyListeners();
    try {
      final fetched = await ratingService.fetchUserReviewForItem(itemId);
      _currentRating = fetched;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingCurrentUserRating = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyReviews(num userId) async {
    _isLoadingReviews = true;
    _error = null;
    notifyListeners();

    try {
      _reviews = await ratingService.fetchMyReviews(userId);
    } catch (e) {
      _error = "An error occurred while fetching your reviews";
    }
    _isLoadingReviews = false;
    notifyListeners();
  }


  /// Deletes the current user’s rating for the given item.
  Future<bool> deleteReviewForItem(int ratingId) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final success = await ratingService.deleteRating(ratingId);
      if (!success) {
        _error = 'Failed to delete rating';
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
}
