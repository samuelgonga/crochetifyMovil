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
    if (_isLoading)
      return; // Prevenir llamadas múltiples mientras se está cargando
    _isLoading = true;
    // Posponemos notifyListeners() para no llamarlo durante el ciclo de construcción
    Future.delayed(Duration.zero, () {
      notifyListeners(); // Esto asegura que notifyListeners no se llame durante la construcción
    });

    try {
      _stocks = await _stockService.fetchStocks();
      print(_stocks);
    } catch (e) {
      print('Error al obtener stocks: $e');
      _stocks = []; // Asegurarse de no dejar la lista vacía en caso de error
    } finally {
      _isLoading = false;
      // Posponemos notifyListeners() nuevamente
      Future.delayed(Duration.zero, () {
        notifyListeners();
      });
    }
  }
}
