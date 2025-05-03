import 'package:flutter/material.dart';
import 'package:rate_master/models/tag.dart';
import 'package:rate_master/services/tag_service.dart';

class TagProvider with ChangeNotifier {
  final TagService tagService;

  TagProvider(this.tagService);

  List<Tag> _tags = [];
  bool _isLoading = false;
  String? _error;

  List<Tag> get tags => _tags;
  bool get isLoading => _isLoading;
  String? get error => _error;


  Future<void> fetchTags() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tags = await tagService.fetchTags();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _tags = [];
    notifyListeners();
  }
}
