class Session {
  final String token;
  final int? userId; // Hacer que userId sea nullable

  Session({
    required this.token,
    this.userId, // Hacer que userId sea opcional
  });

  // Constructor para crear una instancia desde JSON
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      token: json['token'],
      userId: json['id'], // Si no existe 'id', userId será null por defecto
    );
  }
}
