import 'color.dart';
import 'comentario.dart';

class Product {
  String nombre;
  String descripcion;
  double precio;
  double valoracion;
  List<ColorImagen> imagenesPorColor;
  List<Comentario> comentariosProducto;

  Product({
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.valoracion,
    required this.imagenesPorColor,
    required this.comentariosProducto,
  });

  // Agrega el método para deserializar desde JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: json['precio'].toDouble(),
      valoracion: json['valoracion'].toDouble(),
      imagenesPorColor: (json['imagenesPorColor'] as List)
          .map((i) => ColorImagen.fromJson(i))
          .toList(),
      comentariosProducto: (json['comentariosProducto'] as List)
          .map((c) => Comentario.fromJson(c))
          .toList(),
    );
  }
}
