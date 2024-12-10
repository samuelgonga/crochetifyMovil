import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crochetify_movil/models/stock.dart';

class ProductService {
  final String baseUrl = "http://54.146.53.211:8087/api/crochetify";

  Future<List<Stock>> fetchStocksByCategory(int categoryId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/stocks?categoryId=$categoryId'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['response'] != null &&
            jsonResponse['response']['stocks'] != null) {
          final stocks = jsonResponse['response']['stocks'] as List;
          return stocks.map((json) => Stock.fromJson(json)).toList();
        } else {
          throw Exception("Estructura de respuesta inesperada");
        }
      } else {
        throw Exception(
            "Error en la respuesta del servidor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al intentar cargar stocks: $e");
    }
  }
}
