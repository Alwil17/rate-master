import 'package:flutter/material.dart';
import 'package:rate_master/models/item.dart';

class ApiDataProvider with ChangeNotifier {
  List<Item> _items = [];

  // Getter pour accéder aux données
  List<Item> get items => _items;
}
