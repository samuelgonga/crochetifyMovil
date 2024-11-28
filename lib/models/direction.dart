class Direction {
  final int idDirection;
  final int userId;
  final String direction;
  final String phone;
  final bool isDefault;

  Direction({
    required this.idDirection,
    required this.userId,
    required this.direction,
    required this.phone,
    this.isDefault = false,  // Valor por defecto
  });

  factory Direction.fromJson(Map<String, dynamic> json) {
    return Direction(
      idDirection: json['idDirection'] ?? 0,
      userId: json['userId'] ?? 0,
      direction: json['direction'] ?? '',
      phone: json['phone'] ?? '',
      isDefault: json['isDefault'] ?? false,  // Asegúrate de manejar null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idDirection': idDirection,
      'userId': userId,
      'direction': direction,
      'phone': phone,
      'isDefault': isDefault,
    };
  }

  // Método copyWith para crear una nueva instancia con propiedades modificadas
  Direction copyWith({
    int? idDirection,
    int? userId,
    String? direction,
    String? phone,
    bool? isDefault,
  }) {
    return Direction(
      idDirection: idDirection ?? this.idDirection,
      userId: userId ?? this.userId,
      direction: direction ?? this.direction,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
