class User {
  final int id;
  final String name; // name in API
  final String email;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
  });

  // Fonction pour convertir un Map (données JSON) en objet User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
    );
  }

  // Fonction pour convertir un objet User en Map (pour SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': name,
      'email': email,
      'token': token,
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
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }
}
