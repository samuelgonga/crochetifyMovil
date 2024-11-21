import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    if (_isLoading)
      return; // Prevenir llamadas múltiples mientras se está cargando
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _productService.fetchProducts();
    } catch (e) {
      print('Error al obtener productos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
