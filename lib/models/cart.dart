import 'package:crochetify_movil/models/stock.dart';

class CartProduct {
  final int stockId;
  final String color;
  int quantity;
  final Stock? stock; // Puede ser null si el stock no está disponible

  CartProduct({
    required this.stockId,
    required this.color,
    required this.quantity,
    required this.stock,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      stockId: json['stockId'] ?? 0, // Maneja valores nulos asignando un valor por defecto
      color: json['color'] ?? '', // Asigna una cadena vacía si el valor es null
      quantity: json['quantity'] ?? 0, // Asigna 0 si `quantity` es null
      stock: json['stock'] != null ? Stock.fromJson(json['stock']) : null, // Manejo seguro de `stock`
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stockId': stockId,
      'color': color,
      'quantity': quantity,
      'stock': stock?.toJson(), // Usa null-aware operator para evitar errores
    };
  }
}

class Cart {
  final int idCart;
  final double total;
  final List<CartProduct> cartProducts;

  Cart({
    required this.idCart,
    required this.total,
    required this.cartProducts,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      idCart: json['idCart'] ?? 0,
      total: (json['total'] ?? 0.0).toDouble(),
      cartProducts: (json['cartProducts'] as List?)?.map((item) {
        return CartProduct.fromJson(item);
      }).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCart': idCart,
      'total': total,
      'cartProducts': cartProducts.map((item) => item.toJson()).toList(),
    };
  }
}
