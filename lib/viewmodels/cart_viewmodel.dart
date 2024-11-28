import 'package:crochetify_movil/models/cart.dart';
import 'package:crochetify_movil/models/sent_cart.dart';
import 'package:flutter/material.dart';
import 'package:crochetify_movil/services/cart_service.dart';

class CartViewModel extends ChangeNotifier {
  final CartService _cartService;

  CartViewModel({required CartService cartService})
      : _cartService = cartService;

  ApiResponse? _cartData;
  bool _isLoading = false;
  bool _hasError = false;

  ApiResponse? get cartData => _cartData;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  // Modificación aquí para evitar el error de "null"
  List<CartProduct> get cartProducts {
    // Verifica si _cartData es null antes de acceder a cartProducts
    return _cartData?.response.cart.cartProducts ?? [];
  }

  // Método para obtener el carrito por ID
  Future<void> fetchCart(int cartId) async {
    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      final data = await _cartService.getCart(cartId); // data ya es ApiResponse
      if (data != null && data.success) {
        _cartData = data; // Asignar el ApiResponse completo
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
