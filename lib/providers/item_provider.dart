import 'package:flutter/material.dart';
import 'package:rate_master/models/item.dart';

import 'package:rate_master/services/item_service.dart';

class ItemProvider with ChangeNotifier {
  final ItemService itemService;

  ItemProvider(this.itemService);

  List<Item> _items = [];
  List<Item> _recommandations = [];
  List<Item> _filtered = [];
  Item? _currentItem;
  bool _isLoading = false;
  String? _error;

  List<Item> get items => _items;
  List<Item> get recommandations => _recommandations;
  List<Item> get filtered => _filtered;
  Item? get currentItem => _currentItem;
  bool get isLoading => _isLoading;
  String? get error => _error;


  Future<void> fetchItemsFiltered({
    int? categoryId,
    List<String>? tags,
    bool ascending = true,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await itemService.fetchItems(
        categoryId: categoryId,
        tags: tags,
        ascending: ascending,
      );
      _filtered = response;

    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

  Future<void> fetchRecommandations(num userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _recommandations = await itemService.fetchRecommandations(userId);
    } catch (e) {
      _error = "An error occurred while fetching your reviews";
    }
    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _items = [];
    _recommandations = [];
    notifyListeners();
  }
}
