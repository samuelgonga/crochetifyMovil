import 'package:flutter/material.dart';
import 'package:crochetify_movil/models/category.dart';
import 'package:crochetify_movil/services/category_service.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Método para inicializar las categorías (solo se carga una vez)
  Future<void> initializeCategories() async {
    if (_categories.isNotEmpty || _isLoading) return; // Evita recargar si ya se han cargado

    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _categoryService.fetchCategories();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar categorías: $e';
      _categories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Método para recargar las categorías
  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _categoryService.fetchCategories();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar categorías: $e';
      _categories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
