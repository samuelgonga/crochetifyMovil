import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/category.dart';

class CategoryService {
  final String baseUrl = 'http://54.146.53.211:8087/api/crochetify/categories';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> categoryList =
          responseData['response']['categories'] ?? [];
      return categoryList.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar categorías: ${response.statusCode}');
    }
  }
}
