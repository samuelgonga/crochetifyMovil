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

  List<CartProduct> get cartProducts {
    return _cart?.cartProducts ?? [];
  }

  double get cartTotal {
    return _cart?.total ?? 0.0;
  }

  Future<void> fetchCart(int userId) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _hasError = false;

      // Solo cambia los estados después de que la fase de construcción haya terminado
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      final fetchedCart = await _cartService.getCartByUserId(userId);
      if (fetchedCart != null) {
        _cart = fetchedCart;
      } else {
        _hasError = true;
        print("No se pudo obtener el carrito o la respuesta fue incorrecta.");
      }
    } catch (e) {
      _hasError = true;
      print("Error al obtener el carrito: $e");
    } finally {
      _isLoading = false;

      // Llama a notifyListeners después de que se complete la construcción
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> addToCart(int userId, int stockId, int quantity) async {
    try {
      final sentCart = SentCart(
        idUser: userId,
        idStock: stockId,
        quantity: quantity,
      );

      final updatedCart = await _cartService.addToCart(sentCart, userId);

      if (updatedCart != null) {
        _cart = updatedCart;
      } else {
        print("No se pudo agregar el producto al carrito.");
      }
    } catch (e) {
      print("Error al agregar al carrito: $e");
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }


Future<void> updateProductQuantity(int userId, int stockId, int newQuantity) async {
  try {
    if (newQuantity < 1) {
      print("No se permiten cantidades negativas o cero.");
      return;
    }

    // Actualizar la cantidad localmente antes de la llamada a la API
    final productIndex = _cart?.cartProducts.indexWhere((product) => product.stockId == stockId);
    if (productIndex != null && productIndex != -1) {
      _cart?.cartProducts[productIndex].quantity = newQuantity;

      // Recalcular el total localmente
      _cart = Cart(
        idCart: _cart!.idCart,
        total: _calculateLocalTotal(),
        cartProducts: _cart!.cartProducts,
      );
      notifyListeners(); // Refrescar la vista inmediatamente
    }

    // Llamar a la API para actualizar la cantidad en el servidor
    final sentCart = SentCart(
      idUser: userId,
      idStock: stockId,
      quantity: newQuantity,
    );

    final updatedCart = await _cartService.updateCart(sentCart);

    if (updatedCart != null) {
      _cart = updatedCart; // Actualizar el carrito con los datos del servidor
      notifyListeners(); // Refrescar la vista con los datos más recientes
    } else {
      print("No se pudo actualizar la cantidad del producto en el servidor.");
    }
  } catch (e) {
    print("Error al actualizar la cantidad del producto: $e");
  }
}

/// Método privado para calcular el total localmente
double _calculateLocalTotal() {
  if (_cart == null || _cart!.cartProducts.isEmpty) return 0.0;

  return _cart!.cartProducts.fold(0.0, (total, product) {
    final price = product.stock?.price ?? 0.0;
    return total + (product.quantity * price);
  });
}


  Future<void> removeFromCart(int userId, int stockId) async {
    try {
      final sentCart = SentCart(
        idUser: userId,
        idStock: stockId,
        quantity: 0, // Enviar 0 para eliminar el producto
      );

      final updatedCart = await _cartService.addToCart(sentCart, userId);

      if (updatedCart != null) {
        _cart = updatedCart;
      } else {
        print("No se pudo eliminar el producto del carrito.");
      }
    } catch (e) {
      print("Error al eliminar el producto del carrito: $e");
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}
