import 'producto.dart';

class Stock {
  final int idStock;
  final String color;
  final int quantity;
  final double price;
  final bool status;
  final Product product;
  final List<String> images;

  Stock(
      {required this.idStock,
      required this.color,
      required this.quantity,
      required this.price,
      required this.status,
      required this.product,
      required this.images});

  factory Stock.fromJson(Map<String, dynamic> json) {
    var imagesList =
        (json['images'] as List).map((i) => i['image'] as String).toList();

    return Stock(
      idStock: json['idStock'],
      color: json['color'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      status: json['status'],
      product: Product.fromJson(json['product']),
      images: imagesList,
    );
  }
}
