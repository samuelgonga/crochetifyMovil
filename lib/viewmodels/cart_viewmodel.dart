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
    return _cart?.total ?? 0.0;
  }

  /// Cantidad total de productos en el carrito
  int get totalItems {
    return _cart?.cartProducts
            .fold<int>(0, (sum, product) => sum + (product.quantity ?? 0)) ??
        0;
  }

  Future<void> fetchCart(int userId) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _hasError = false;

      final fetchedCart = await _cartService.getCartByUserId(userId);

      if (fetchedCart != null && fetchedCart.cartProducts.isNotEmpty) {
        _cart = fetchedCart; // Actualiza el carrito con los datos del servidor
      } else {
        _cart = null; // Si el carrito está vacío, asigna null
        print("El carrito está vacío.");
      }
    } catch (e) {
      _hasError = true;
      print("Error al obtener el carrito: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Actualiza la vista
    }
  }

  /// Añade un producto al carrito
  /// Añade un producto al carrito
  Future<void> addToCart(int userId, int stockId, int quantity) async {
    try {
      // Verifica si el producto ya existe en el carrito
      final existingProductIndex = _cart?.cartProducts
          .indexWhere((product) => product.stockId == stockId);

      if (existingProductIndex != null && existingProductIndex != -1) {
        // Si el producto ya existe, suma la cantidad al existente
        final existingProduct = _cart!.cartProducts[existingProductIndex];
        final newQuantity = (existingProduct.quantity ?? 0) + quantity;

        // Actualiza localmente el carrito
        final updatedProducts = [..._cart!.cartProducts];
        updatedProducts[existingProductIndex] =
            existingProduct.copyWith(quantity: newQuantity);
        _cart = _cart?.copyWith(cartProducts: updatedProducts);
        notifyListeners();

        // Sincroniza el cambio con el servidor
        final sentCart = SentCart(
          idUser: userId,
          idStock: stockId,
          quantity: newQuantity,
        );

        final updatedCart = await _cartService.updateCart(sentCart);

        if (updatedCart != null) {
          _cart = updatedCart;
          notifyListeners();
        } else {
          print("No se pudo sincronizar el carrito con el servidor.");
        }
      } else {
        // Si el producto no existe, añádelo al carrito
        final sentCart = SentCart(
          idUser: userId,
          idStock: stockId,
          quantity: quantity,
        );

        final updatedCart = await _cartService.addToCart(sentCart, userId);

        if (updatedCart != null) {
          _cart = updatedCart;
          notifyListeners();
        } else {
          print("No se pudo agregar el producto al carrito.");
        }
      }
    } catch (e) {
      print("Error al agregar al carrito: $e");
    }
  }

  Future<void> updateProductQuantity(
      int userId, int stockId, int newQuantity) async {
    try {
      if (newQuantity < 1) {
        print("No se permiten cantidades negativas o cero.");
        return;
      }

      // Encuentra el índice del producto a actualizar
      final productIndex = _cart?.cartProducts
          .indexWhere((product) => product.stockId == stockId);

      if (productIndex != null && productIndex != -1) {
        // Clona la lista de productos para actualizar localmente
        final updatedProducts = [..._cart!.cartProducts];
        updatedProducts[productIndex] = updatedProducts[productIndex].copyWith(
          quantity: newQuantity,
        );

        // Si todos los productos tienen cantidad 0, marca el carrito como vacío
        if (updatedProducts.every((product) => product.quantity == 0)) {
          _cart = null;
          notifyListeners();
          print(
              "Todos los productos han sido eliminados. El carrito está vacío.");
          return;
        }

        // Actualiza localmente el carrito
        _cart = _cart?.copyWith(cartProducts: updatedProducts);

        // Notifica inmediatamente para reflejar los cambios locales
        notifyListeners();

        // Sincroniza el cambio con el servidor
        final sentCart = SentCart(
          idUser: userId,
          idStock: stockId,
          quantity: newQuantity,
        );

        final updatedCart = await _cartService.updateCart(sentCart);

        if (updatedCart == null) {
          print(
              "El servidor no devolvió un carrito actualizado. Solicitando carrito completo...");
          await fetchCart(
              userId); // Solicita el carrito completo si falla la sincronización
        } else {
          // Actualiza con los datos del servidor
          _cart = updatedCart;
          notifyListeners(); // Actualiza la vista con el carrito sincronizado
        }
      }
    } catch (e) {
      print("Error al actualizar la cantidad del producto: $e");
    }
  }

  void removeProductFromCart(int stockId) {
    cartProducts.removeWhere((product) => product.stockId == stockId);
    notifyListeners(); // Notifica a la vista que el estado ha cambiado
  }
}
