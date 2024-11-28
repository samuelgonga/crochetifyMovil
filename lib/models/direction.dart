class Direction {
  final int idDirection; // Si el id puede ser nulo, se utiliza int?
  final String direction; 
  final String phone; 
  final int userId;

  Direction({
    required this.idDirection,
    required this.direction,
    required this.phone,
    required this.userId,
  });

  // Método para convertir un mapa (json) a una instancia de Direction
  factory Direction.fromJson(Map<String, dynamic> json) {
    return Direction(
      idDirection: json['idDirection'] ?? 0,  // Valor predeterminado 0 si es null
      direction: json['direction'] ?? '',     // Cadena vacía si es null
      phone: json['phone'] ?? '',             // Cadena vacía si es null
      userId: json['userId'] ?? 0,            // Valor predeterminado 0 si es null
    );
  }

  // Método para convertir la instancia de Direction a un mapa (json)
  Map<String, dynamic> toJson() {
    return {
      'idDirection': idDirection,
      'direction': direction,
      'phone': phone,
      'userId': userId,
    };
  }
}
