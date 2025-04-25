import 'package:flutter/material.dart';
import 'package:rate_master/models/item.dart';

import 'package:rate_master/services/item_service.dart';

class ItemProvider with ChangeNotifier {
  final ItemService itemService;

  ItemProvider(this.itemService);

  List<Item> _items = [];
  bool _isLoading = false;
  String? _error;

  List<Item> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;


  Future<void> fetchItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await itemService.fetchItems();
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
