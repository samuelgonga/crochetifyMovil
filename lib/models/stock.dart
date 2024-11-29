import 'producto.dart';

class Stock {
  final int idStock;
  final String color;
  final int quantity;
  final double price;
  final bool status;
  final Product product;
  final List<String> images;

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
    // Maneja la lista de imágenes, extrayendo solo el campo `image` de cada objeto
    var imagesList = (json['images'] as List?)
        ?.map((image) => (image as Map<String, dynamic>)['image'] as String)
        .toList() ?? [];

    return Stock(
      idStock: json['idStock'],
      color: json['color'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      status: json['status'],
      product: Product.fromJson(json['product']),
      images: imagesList, // Lista con las cadenas Base64
    );
  }
}
