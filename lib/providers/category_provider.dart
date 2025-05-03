import 'package:flutter/material.dart';
import 'package:rate_master/models/category.dart';
import 'package:rate_master/services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService categoryService;

  CategoryProvider(this.categoryService);

  List<Category> _categorys = [];
  bool _isLoading = false;
  String? _error;

  List<Category> get categorys => _categorys;
  bool get isLoading => _isLoading;
  String? get error => _error;


  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categorys = await categoryService.fetchCategories();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _categorys = [];
    notifyListeners();
  }
}
