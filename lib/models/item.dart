class Item {
  final int id;
  final String name; // name in API
  final String description;

  Item({
    required this.id,
    required this.name,
    required this.description
  });

  // Fonction pour convertir un Map (données JSON) en objet Item
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  // Fonction pour convertir un objet Item en Map (pour SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description
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
    String? token,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description
    );
  }
}
