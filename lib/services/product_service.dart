import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:crochetify_movil/models/product.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    try {
      // Cargar el archivo JSON desde assets
      final response = await rootBundle.loadString('assets/datos.json');
      final List<dynamic> data = jsonDecode(response);

      // Mapear cada item JSON a una instancia de Product
      return data.map((dataJson) => Product.fromJson(dataJson)).toList();
    } catch (e) {
      print("Algo salió mal: $e");
      throw Exception("Failed to load products");
    }
  }
}
