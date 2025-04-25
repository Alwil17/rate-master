class Item {
  final int id;
  final String name; // name in API
  final String description;
  final String? image_url;
  final num avg_rating;
  final num count_rating;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.avg_rating,
    required this.count_rating,
    this.image_url,
  });

  // Fonction pour convertir un Map (données JSON) en objet Item
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      avg_rating: json['avg_rating'],
      count_rating: json['count_rating'],
      image_url: json['image_url']
    );
  }

  // Fonction pour convertir un objet Item en Map (pour SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avg_rating': avg_rating,
      'count_rating': count_rating,
      'image_url': image_url
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
    num? avg_rating,
    num? count_rating,
    String? image_url,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      avg_rating: avg_rating ?? this.avg_rating,
      count_rating: count_rating ?? this.count_rating,
      image_url: image_url ?? this.image_url
    );
  }
}
