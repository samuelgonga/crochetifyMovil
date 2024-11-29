import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/stock.dart';

class StockService {
  final String baseUrl = 'http://35.153.187.92:8087/api/crochetify/stock';

  Future<List<Stock>> fetchStocksByCategory(int categoryId) async {
  final response = await http.get(Uri.parse('$baseUrl?categoryId=$categoryId'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);

    print('Respuesta de la API: $responseData'); // Para depurar

    if (responseData['response'] != null && responseData['response']['stocks'] != null) {
      final List<dynamic> stockList = responseData['response']['stocks'];
      return stockList.map((json) => Stock.fromJson(json)).toList();
    } else {
      throw Exception('No se encontraron stocks en la respuesta de la API.');
    }
  } else {
    throw Exception('Error al cargar stocks: ${response.statusCode}');
  }
}

}
