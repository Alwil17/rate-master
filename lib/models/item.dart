import 'package:rate_master/models/tag.dart';

import 'category.dart';

class Item {
  final int id;
  final String name; // name in API
  final String? description;
  final String? imageUrl;
  final double avgRating;
  final int countRating;
  final List<Category> categories;
  final List<Tag> tags;

  Item({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.avgRating = 0.0,
    this.countRating = 0,
    this.categories = const [],
    this.tags = const [],
  });

  // Fonction pour convertir un Map (données JSON) en objet Item
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
      countRating: json['count_rating'] as int? ?? 0,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  // Fonction pour convertir un objet Item en Map (pour SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'avg_rating': avgRating,
      'count_rating': countRating,
      'categories': categories.map((c) => c.toJson()).toList(),
      'tags': tags.map((t) => t.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return name;
  }

  Item copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    double? avgRating,
    int? countRating,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      avgRating: avgRating ?? this.avgRating,
      countRating: countRating ?? this.countRating,
      imageUrl: imageUrl ?? this.imageUrl
    );
  }
}
