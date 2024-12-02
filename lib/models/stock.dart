import 'package:crochetify_movil/models/producto.dart';

class Stock {
  final int idStock;
  final String color;
  final int quantity;
  final double price;
  final bool status;
  final Product product;
  final List<String> images; // Cambiado a `List<String>` para simplificar

  Stock({
    required this.idStock,
    required this.color,
    required this.quantity,
    required this.price,
    required this.status,
    required this.product,
    required this.images,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      idStock: json['idStock'] ?? 0, // Maneja `null` asignando un valor predeterminado
      color: json['color'] ?? '', // Asegura un valor por defecto
      quantity: json['quantity'] ?? 0,
      price: (json['price'] != null ? json['price'].toDouble() : 0.0), // Maneja null en `price`
      status: json['status'] ?? false,
      product: Product.fromJson(json['product'] ?? {}), // Evita errores si `product` es null
      // Manejo seguro de imágenes
      images: (json['images'] as List<dynamic>?)
              ?.map((img) => img['image'] as String?)
              .whereType<String>() // Filtra nulos
              .toList() ??
          [], // Si `images` es null, usar lista vacía
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idStock': idStock,
      'color': color,
      'quantity': quantity,
      'price': price,
      'status': status,
      'product': product.toJson(),
      'images': images.map((img) => {'image': img}).toList(),
    };
  }
}
