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
    notifyListeners(); // Notificar que está en carga

    try {
      _stocks = await _stockService.fetchStocks(); // Obtener los stocks
      print(_stocks); // Para depuración
    } catch (e) {
      print('Error al obtener stocks: $e');
      _stocks = []; // En caso de error, dejar la lista vacía
    } finally {
      _isLoading = false;
      notifyListeners(); // Notificar que la carga ha terminado
    }
  }
}
