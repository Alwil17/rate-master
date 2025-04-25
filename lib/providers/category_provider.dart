import 'package:flutter/material.dart';
import 'package:rate_master/models/item.dart';

import 'package:rate_master/services/item_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService itemService;

  CategoryProvider(this.itemService);

  List<Category> _items = [];
  bool _isLoading = false;
  String? _error;

  List<Category> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;


  Future<void> fetchCategorys() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await itemService.fetchCategorys();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _items = [];
    notifyListeners();
  }
}
