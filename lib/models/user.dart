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
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      status: json['status'] ?? true,
      image: json['image'] ?? '',
    );
  }
}
