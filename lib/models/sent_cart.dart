class SentCart {
  final int idUser;
  final int idStock;
  final int quantity;

  SentCart({
    required this.idUser,
    required this.idStock,
    required this.quantity,
  });

  // Método para crear un objeto SentCart desde un JSON
  factory SentCart.fromJson(Map<String, dynamic> json) {
    return SentCart(
      idUser: json['idUser'] ?? 0, // Asignar valor por defecto si es null
      idStock: json['idStock'] ?? 0, // Asignar valor por defecto si es null
      quantity: json['quantity'] ?? 0, // Asignar valor por defecto si es null
    );
  }

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'idStock': idStock,
      'quantity': quantity,
    };
  }
}
