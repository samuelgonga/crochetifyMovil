import 'package:crochetify_movil/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:crochetify_movil/models/cart.dart';
import 'package:crochetify_movil/models/sent_cart.dart';

class CartViewModel extends ChangeNotifier {
  final CartService _cartService;

  CartViewModel({required CartService cartService}) : _cartService = cartService;

  ApiResponse? _cartData;
  bool _isLoading = false;
  bool _hasError = false;

  ApiResponse? get cartData => _cartData;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get hasCart => _cartData != null;

  // Obtener productos agrupados del carrito
  List<CartProduct> get cartProducts {
    final Map<String, CartProduct> groupedProducts = {};

    for (var product in _cartData?.response.cart.cartProducts ?? []) {
      final String productName = product.product.name;

      if (groupedProducts.containsKey(productName)) {
        final existingProduct = groupedProducts[productName]!;
        groupedProducts[productName] = CartProduct(
          stockId: existingProduct.stockId,
          color: existingProduct.color,
          quantity: (existingProduct.quantity + product.quantity).toInt(),
          product: existingProduct.product,
        );
      } else {
        groupedProducts[productName] = CartProduct(
          stockId: product.stockId,
          color: product.color,
          quantity: product.quantity,
          product: product.product,
        );
      }
    }

    return groupedProducts.values.toList();
  }

  // Método para obtener la cantidad actual de un producto por su stockId
  int getQuantity(int stockId) {
    try {
      return _cartData?.response.cart.cartProducts
              .firstWhere((product) => product.stockId == stockId)
              .quantity ??
          0;
    } catch (e) {
      return 0; // Si no encuentra el producto, devuelve 0.
    }
  }

  // Obtener el carrito del usuario
  Future<void> fetchCart(int userId) async {
    if (_isLoading || _cartData != null) return;

    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      final data = await _cartService.getCart(userId);
      if (data != null && data.success) {
        _cartData = data;
      } else {
        _hasError = true;
        print("No se pudo obtener el carrito o la respuesta fue incorrecta.");
      }
    } catch (e) {
      _hasError = true;
      print("Error al obtener el carrito: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Agregar un producto al carrito
  Future<void> addToCart(int idUser, int idStock, int quantity) async {
    try {
      var newCart = await _cartService.createCart(
        SentCart(
          idUser: idUser,
          idStock: idStock,
          quantity: quantity,
        ),
      );

      if (newCart.success) {
        print("Carrito creado con éxito.");
        fetchCart(idUser); // Actualiza el carrito después de agregar el producto
      } else {
        print("No se pudo crear el carrito.");
      }
    } catch (e) {
      throw Exception("Error al agregar al carrito: $e");
    }
  }

  // Actualizar la cantidad de un producto en el carrito
  Future<void> updateProductQuantity(int userId, int stockId, int newQuantity) async {
    if (newQuantity <= 0) return;

    try {
      await updateCart(userId, stockId, newQuantity);
      notifyListeners(); // Notifica que el estado ha cambiado
    } catch (e) {
      print("Error al actualizar la cantidad del producto: $e");
    }
  }

  // Actualizar el carrito con la nueva cantidad
  Future<void> updateCart(int userId, int stockId, int quantity) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      // Realizar el PUT para actualizar el carrito
      final updatedCart = await _cartService.updateCart(
        SentCart(idUser: userId, idStock: stockId, quantity: quantity),
      );

      // Verificar que la actualización haya sido exitosa
      if (updatedCart.success) {
        print("Carrito actualizado con éxito.");
        // Después de la actualización, realizar un GET para obtener el carrito actualizado
        await fetchCart(userId);
      } else {
        _hasError = true;
        print("No se pudo actualizar el carrito.");
      }
    } catch (e) {
      _hasError = true;
      print("Error al actualizar el carrito: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Obtener el total del carrito
  double get cartTotal {
    return _cartData?.response.cart.total ?? 0.0;
  }
}
