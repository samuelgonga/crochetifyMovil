import 'package:flutter/material.dart';
import 'package:crochetify_movil/services/cart_service.dart';
import 'package:crochetify_movil/models/cart.dart';
import 'package:crochetify_movil/models/sent_cart.dart';

class CartViewModel extends ChangeNotifier {
  final CartService _cartService;

  CartViewModel({required CartService cartService})
      : _cartService = cartService;

  Cart? _cart;
  bool _isLoading = false;
  bool _hasError = false;

  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  /// Lista de productos en el carrito
  List<CartProduct> get cartProducts {
    return _cart?.cartProducts ?? [];
  }

  /// Total del carrito
  double get cartTotal {
    return _cart?.total ?? 0.0; // Toma el total directamente del backend
  }

  /// Cantidad total de productos en el carrito
  int get totalItems {
    return _cart?.cartProducts
            .fold<int>(0, (sum, product) => sum + (product.quantity ?? 0)) ??
        0;
  }

  Future<void> fetchCart(int userId) async {
    try {
      _isLoading = true;
      _cart = await _cartService.getCartByUserId(userId);

      if (_cart == null || _cart!.cartProducts.isEmpty) {
        print("El carrito está vacío.");
      }
    } catch (e) {
      print("Error al obtener el carrito: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Añade un producto al carrito
  Future<void> addToCart(int userId, int stockId, int quantity) async {
    try {
      final sentCart = SentCart(
        idUser: userId,
        idStock: stockId,
        quantity: quantity,
      );

      final updatedCart = await _cartService.addToCart(sentCart, userId);

      if (updatedCart != null) {
        _cart = updatedCart; // Sincroniza con los datos del backend
        notifyListeners();
      } else {
        print("No se pudo agregar el producto al carrito.");
      }
    } catch (e) {
      print("Error al agregar al carrito: $e");
    }
  }

  Future<void> updateProductQuantity(
      int userId, int stockId, int newQuantity) async {
    try {
      final sentCart = SentCart(
        idUser: userId,
        idStock: stockId,
        quantity: newQuantity,
      );

      final updatedCart = await _cartService.updateCart(sentCart);

      if (updatedCart != null) {
        _cart = updatedCart; // Sincroniza con el backend
      } else {
        print("El servidor no devolvió un carrito actualizado.");
        await fetchCart(
            userId); // Recupera el carrito completo si no se devolvió correctamente
      }
    } catch (e) {
      print("Error al actualizar la cantidad del producto: $e");
    } finally {
      notifyListeners(); // Notifica cambios al final
    }
  }

  /// Elimina un producto del carrito localmente y sincroniza con el backend
  Future<void> removeProductFromCart(int userId, int stockId) async {
    try {
      final sentCart = SentCart(
        idUser: userId,
        idStock: stockId,
        quantity: 0,
      );

      final updatedCart = await _cartService.updateCart(sentCart);

      if (updatedCart != null) {
        _cart = updatedCart; // Sincroniza con el backend
        notifyListeners();
      } else {
        print("Error al eliminar el producto en el servidor.");
      }
    } catch (e) {
      print("Error al eliminar el producto: $e");
    }
  }
}
