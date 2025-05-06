class User {
  final int id;
  final String name; // name in API
  final String email;
  final String? token;
  final String? imageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    this.imageUrl,
  });

  // Fonction pour convertir un Map (données JSON) en objet User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
      imageUrl: json['image_url'] as String?,
    );
  }

  // Fonction pour convertir un objet User en Map (pour SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'image_url': imageUrl,
    };
  }

  @override
  String toString() {
    return name;
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? token,
    String? imageUrl,
  }) {
    return User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        token: token ?? this.token,
        imageUrl: imageUrl ?? this.imageUrl);
  }
}
