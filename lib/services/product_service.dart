import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crochetify_movil/models/product.dart';

class ProductService {
  final String baseUrl = "http://192.168.100.162:8080/api/crochetify";

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Verificar si la clave "response" y luego "products" existen
        if (jsonResponse['response'] != null && jsonResponse['response']['products'] != null) {
          final List<dynamic> products = jsonResponse['response']['products']; // Aquí se corrige el error
          return products.map((json) => Product.fromJson(json)).toList();
        } else {
          throw Exception("No se encontraron productos");
        }
      } else {
        throw Exception("Error al cargar los productos: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception('Error de red o servidor: $e');
    }
  }
}
