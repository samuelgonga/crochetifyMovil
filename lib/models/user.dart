class User {
  final int id;
  final String name;
  final String email;
  final bool status;
  final String? image;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    this.image,
  });

  // Constructor para crear una instancia de User desde JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['idUser'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? false,
      image: json['image'],
    );
  }
}
