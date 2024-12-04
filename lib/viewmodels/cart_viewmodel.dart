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

  /// Recupera el carrito desde el servidor
Future<void> fetchCart(int userId) async {
  try {
    // Marca como cargando sin notificar inmediatamente
    _isLoading = true;

    // Espera un ciclo para evitar conflictos de construcción
    await Future.delayed(Duration.zero);

    final fetchedCart = await _cartService.getCartByUserId(userId);

    if (fetchedCart != null) {
      print("Carrito recuperado: ${fetchedCart.toJson()}");
      _cart = fetchedCart;
    } else {
      print("No se pudo recuperar el carrito.");
      _cart = null;
    }
  } catch (e) {
    print("Error al obtener el carrito: $e");
    _hasError = true;
  } finally {
    // Finaliza el estado de carga y notifica a los listeners
    _isLoading = false;
    notifyListeners();
  }
}


  /// Agrega un producto al carrito
  Future<void> addToCart(int userId, int stockId, int quantity) async {
    try {
      print("Intentando agregar al carrito: userId=$userId, stockId=$stockId, quantity=$quantity");

      // Crea el objeto SentCart
      final sentCart = SentCart(
        idUser: userId,
        idStock: stockId,
        quantity: quantity,
      );

      // Llama al servicio para agregar el producto
      final updatedCart = await _cartService.addToCart(sentCart, userId);

      if (updatedCart != null) {
        print("Carrito actualizado: ${updatedCart.toJson()}");
        _cart = updatedCart; // Sincroniza con el backend
      } else {
        print("No se pudo agregar el producto al carrito.");
      }
    } catch (e) {
      print("Error al agregar al carrito: $e");
    } finally {
      notifyListeners();
    }
  }

  /// Actualiza la cantidad de un producto en el carrito
  Future<void> updateProductQuantity(
      int userId, int stockId, int newQuantity) async {
    try {
      print("Actualizando cantidad: userId=$userId, stockId=$stockId, newQuantity=$newQuantity");

      final sentCart = SentCart(
        idUser: userId,
        idStock: stockId,
        quantity: newQuantity,
      );

      final updatedCart = await _cartService.updateCart(sentCart);

      if (updatedCart != null) {
        print("Cantidad actualizada. Nuevo carrito: ${updatedCart.toJson()}");
        _cart = updatedCart;
      } else {
        print("El servidor no devolvió un carrito actualizado.");
        await fetchCart(userId); // Recupera el carrito completo si no se devolvió correctamente
      }
    } catch (e) {
      print("Error al actualizar la cantidad del producto: $e");
    } finally {
      notifyListeners();
    }
  }

  /// Elimina un producto del carrito localmente y sincroniza con el backend
  Future<void> removeProductFromCart(int userId, int stockId) async {
    try {
      print("Eliminando producto: userId=$userId, stockId=$stockId");

      final sentCart = SentCart(
        idUser: userId,
        idStock: stockId,
        quantity: 0,
      );

      final updatedCart = await _cartService.updateCart(sentCart);

      if (updatedCart != null) {
        print("Producto eliminado. Nuevo carrito: ${updatedCart.toJson()}");
        _cart = updatedCart;
      } else {
        print("Error al eliminar el producto en el servidor.");
      }
    } catch (e) {
      print("Error al eliminar el producto: $e");
    } finally {
      notifyListeners();
    }
  }
}
