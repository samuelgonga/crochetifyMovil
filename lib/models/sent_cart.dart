class SentCart {
  final int idUser;
  final int idStock;
  final int quantity;

  SentCart({
    required this.idUser,
    required this.idStock,
    required this.quantity,
  });

  factory SentCart.fromJson(Map<String, dynamic> json) {
    return SentCart(
      idUser: json['idUser'],
      idStock: json['idStock'],
      quantity: json['quantity'],
    );
  }

  get success => null;

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'idStock': idStock,
      'quantity': quantity,
    };
  }
}
