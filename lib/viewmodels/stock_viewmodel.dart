import 'package:flutter/material.dart';
import '../models/stock.dart';
import '../services/stock_service.dart';

class StockViewModel extends ChangeNotifier {
  final StockService _stockService = StockService();
  List<Stock> _stocks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Stock> get stocks => _stocks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Método para obtener stocks por categoría o todos los stocks si categoryId es 0
  Future<void> fetchStocksByCategory(int categoryId) async {
    if (_isLoading) return; // Prevenir llamadas múltiples mientras se está cargando

    _isLoading = true;
    _errorMessage = null; // Reinicia el mensaje de error
    notifyListeners(); // Notificar que está en carga

    try {
      // Obtener todos los stocks desde el backend
      List<Stock> allStocks = await _stockService.fetchStocksByCategory(categoryId);

      if (categoryId == 0) {
        // Si categoryId es 0, no filtramos
        _stocks = allStocks;
      } else {
        // Filtrar los stocks que pertenecen a la categoría seleccionada
        _stocks = allStocks.where((stock) {
          return stock.product.categories.any((category) => category.idCategory == categoryId);
        }).toList();
      }

      print("Stocks cargados (categoryId: $categoryId): $_stocks");
    } catch (e) {
      _errorMessage = 'Error al obtener los productos: $e';
      _stocks = []; // En caso de error, dejar la lista vacía
      print(_errorMessage); // Para depuración
    } finally {
      _isLoading = false;
      notifyListeners(); // Notificar que la carga ha terminado
    }
  }
}

