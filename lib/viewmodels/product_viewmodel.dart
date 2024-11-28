import 'package:flutter/material.dart';
import 'package:crochetify_movil/models/stock.dart';
import 'package:crochetify_movil/services/product_service.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService;
  List<Stock> _stocks = [];
  String? _errorMessage;

  ProductViewModel(this._productService); // Requiere ProductService como dependencia

  List<Stock> get stocks => _stocks;
  String? get errorMessage => _errorMessage;

  Future<void> fetchStocksByCategory(int categoryId) async {
    try {
      _errorMessage = null; // Limpia cualquier error previo
      _stocks = await _productService.fetchStocksByCategory(categoryId);
      notifyListeners(); // Notifica cambios a los listeners
    } catch (e) {
      _errorMessage = "Error fetching stocks: $e";
      print(_errorMessage);
      notifyListeners(); // Notifica cambios a los listeners
    }
  }
}
