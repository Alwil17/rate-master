import 'package:flutter/material.dart';
import 'package:rate_master/models/item.dart';

import 'package:rate_master/services/item_service.dart';

class ItemProvider with ChangeNotifier {
  final ItemService itemService;

  ItemProvider(this.itemService);

  List<Item> _items = [];
  Item? _currentItem;
  bool _isLoading = false;
  String? _error;

  List<Item> get items => _items;
  Item? get currentItem => _currentItem;
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

  /// Charge un item depuis l'API et le stocke dans [_currentItem].
  Future<void> fetchItem(num itemId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetched = await itemService.fetchItem(itemId);
      _currentItem = fetched;
    } catch (e) {
      _error = e.toString();
      _currentItem = null;
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
