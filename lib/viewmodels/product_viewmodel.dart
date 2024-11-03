import 'package:flutter/material.dart';
import 'package:crochetify_movil/models/product.dart';
import 'package:crochetify_movil/services/product_service.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    try {
      _products = await _productService.fetchProducts();
      notifyListeners();
    } catch (e) {
      print("Error fetching products: $e");
    }
  }
}
