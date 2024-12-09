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

  factory User.fromJson(Map<String, dynamic> json) {
    // Validar que 'user' exista dentro de 'response'
    if (json['user'] == null) {
      throw Exception('La clave "user" no existe en el JSON.');
    }

    final userJson = json['user'];
    return User(
      id: userJson['idUser'] ?? 0,
      name: userJson['name'] ?? 'Sin nombre',
      email: userJson['email'] ?? 'Sin correo',
      status: userJson['status'] ?? false,
      image: userJson['image'], // Puede ser null
    );
  }
}