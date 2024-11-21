import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stock.dart';

class StockService {
  final String baseUrl = 'http://192.168.0.11:8080/api/crochetify/stock';

  Future<List<Stock>> fetchStocks() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> stocksJson = jsonData['response']['stocks'];
      return stocksJson.map((json) => Stock.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los stocks');
    }
  }
}
