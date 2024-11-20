import 'package:flutter/material.dart';
import '../models/stock.dart';
import '../services/stock_service.dart';

class StockViewModel extends ChangeNotifier {
  final StockService _stockService = StockService();
  List<Stock> _stocks = [];
  bool _isLoading = false;

  List<Stock> get stocks => _stocks;
  bool get isLoading => _isLoading;

  // Método para obtener stocks
  Future<void> fetchStocks() async {
    _isLoading = true;
    notifyListeners();
    try {
      _stocks = await _stockService.fetchStocks();
    } catch (e) {
      print('Error al obtener stocks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
