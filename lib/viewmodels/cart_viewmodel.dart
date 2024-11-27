import 'package:crochetify_movil/models/cart.dart';
import 'package:crochetify_movil/models/sent_cart.dart';
import 'package:flutter/material.dart';
import 'package:crochetify_movil/services/cart_service.dart';

class CartViewModel extends ChangeNotifier {
  final CartService _cartService;

  CartViewModel({required CartService cartService}) : _cartService = cartService;

  ApiResponse? _cartData;
  bool _isLoading = false;
  bool _hasError = false;

  ApiResponse? get cartData => _cartData;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  List<CartProduct> get cartProducts => _cartData?.cart.cartProducts ?? [];

  // Método para obtener el carrito por ID
  Future<void> fetchCart(int cartId) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final data = await _cartService.getCart(cartId);
      if (data != null) {
        _cartData = data.response as ApiResponse?;
        notifyListeners();  // Notificar para actualizar la UI
      } else {
        _hasError = true;
      }
    } catch (e) {
      _hasError = true;
      print("Error al obtener el carrito: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para agregar productos al carrito
  Future<void> addToCart(int idUser, int idStock, int quantity) async {
    try {
      var newCart = await _cartService.createCart(
        SentCart(
          idUser: idUser,
          idStock: idStock,
          quantity: quantity,
        ),
      );

      if (newCart != null) {
        print("Carrito creado con éxito.");
      } else {
        print("No se pudo crear el carrito.");
      }
    } catch (e) {
      throw Exception("Error al comprobar si el carrito existe: $e");
    }
  }

  // Método para actualizar el carrito
  Future<void> updateCart(int idUser, int idStock, int quantity) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      var updatedCart = await _cartService.updateCart(
        SentCart(
          idUser: idUser,
          idStock: idStock,
          quantity: quantity,
        ),
      );

      if (updatedCart != null) {
        print("Carrito actualizado con éxito.");
        fetchCart(updatedCart.idUser); // Carga el carrito actualizado
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
}
