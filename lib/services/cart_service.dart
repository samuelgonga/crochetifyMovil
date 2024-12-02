import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crochetify_movil/models/cart.dart';
import 'package:crochetify_movil/models/sent_cart.dart';

class CartService {
  final String baseUrl = "http://35.153.187.92:8087/api/crochetify/cart";

  // Obtener Carrito por ID de usuario
  Future<Cart?> getCartByUserId(int userId) async {
  final url = Uri.parse('$baseUrl/$userId');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Imprime el JSON recibido para validar
      print('JSON recibido para Cart: $data');

      if (data['response'] != null && data['response']['cart'] != null) {
        final cartJson = data['response']['cart'];

        // Imprime el JSON del carrito antes de mapear
        print('JSON del carrito: $cartJson');

        return Cart.fromJson(cartJson);
      } else {
        print("Error: La respuesta no contiene el campo esperado 'cart'.");
        return null;
      }
    } else {
      print("Error al obtener el carrito: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error en la solicitud: $e");
    return null;
  }
}


 Future<Cart?> addToCart(SentCart sentCart, int userId) async {
  try {
    // Intentar crear un carrito
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(sentCart.toJson()),
    );

    if (response.statusCode == 201) {
      // Carrito creado exitosamente
      final data = json.decode(response.body);
      if (data['response'] != null && data['response']['cart'] != null) {
        return Cart.fromJson(data['response']['cart']);
      } else {
        print("La respuesta no contiene el campo esperado 'cart'.");
        return null;
      }
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      // Manejar caso cuando ya tiene un carrito o el carrito no se encuentra
      print("El usuario ya tiene un carrito activo o no se encontró: ${response.statusCode}");

      // Recuperar carrito existente
      final existingCart = await getCartByUserId(userId);

      if (existingCart != null) {
        // Actualizar carrito existente
        return await updateCart(sentCart);
      } else {
        print("No se pudo recuperar el carrito existente.");
        return null;
      }
    } else {
      print("Error al crear el carrito: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error al agregar al carrito: $e");
    return null;
  }
}

Future<Cart?> updateCart(SentCart sentCart) async {
  try {
    final response = await http.put(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(sentCart.toJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Verificar si la respuesta contiene el campo 'cart'
      if (data['response'] != null && data['response']['cart'] != null) {
        return Cart.fromJson(data['response']['cart']);
      } else {
        print("La respuesta no contiene el campo esperado 'cart'.");
        return null;
      }
    } else {
      print("Error al actualizar el carrito: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error al actualizar el carrito: $e");
    return null;
  }
}



}
