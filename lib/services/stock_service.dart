import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stock.dart';

class StockService {
  final String baseUrl = 'http://127.0.0.1:8080/api/crochetify/stock';

  Future<List<Stock>> fetchStocks() async {
    final response = await http.get(Uri.parse(baseUrl));
    print('Respeusta: ${response}');
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Stock.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los stocks');
    }
  }

  Future<Stock> fetchStockById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Stock.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el stock');
    }
  }
}
