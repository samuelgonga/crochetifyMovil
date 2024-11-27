import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoryService {
  final String baseUrl = "http://192.168.1.65:8080/api/crochetify";

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Navegar hasta 'response.categories'
        if (jsonResponse['response'] != null &&
            jsonResponse['response']['categories'] != null) {
          final List<dynamic> categories =
              jsonResponse['response']['categories'];
          return categories.map((json) => Category.fromJson(json)).toList();
        } else {
          throw Exception("No se encontraron categorías en la respuesta");
        }
      } else {
        throw Exception(
            'Error al cargar las categorías: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red o servidor: $e');
    }
  }
}
