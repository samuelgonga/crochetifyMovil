class User {
  final int id;
  final String name;
  final String email;
  final bool status;
  final String image;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.image,
  });

  // Método para crear un objeto User desde un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0, // Si id es nulo, asigna 0 o un valor adecuado
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? true,
      image: json['image'] ?? '',
    );
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    bool? status,
    String? image,
  }) {
    return User(
      id: id ?? this.id, // Si no se pasa un valor, se conserva el actual
      name: name ?? this.name,
      email: email ?? this.email,
      status: status ?? this.status,
      image: image ?? this.image,
    );
  }
}
