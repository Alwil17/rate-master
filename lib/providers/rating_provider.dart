import 'package:flutter/material.dart';
import 'package:rate_master/models/rating.dart';
import 'package:rate_master/services/rating_service.dart';

class RatingProvider with ChangeNotifier {
  final RatingService _service;

  bool _isSubmitting = false;
  String? _error;

  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  RatingProvider(this._service);

  /// Call service and handle loading / error state
  Future<bool> submitRating(Rating rating) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _service.submitRating(rating);
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
}
