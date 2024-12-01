import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crochetify_movil/models/sent_cart.dart';
import 'package:crochetify_movil/models/cart.dart'; // Importa ApiResponse

class CartService {
  final String baseUrl = "http://35.153.187.92:8087/api/crochetify/cart";

  // Obtener Carrito por id
  Future<ApiResponse?> getCart(int cartId) async {
    final url = Uri.parse('$baseUrl/$cartId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse.fromJson(data); // Construir ApiResponse
      } else {
        print("Error al obtener el carrito: ${response.statusCode}");
        return null; // Retorna null si hay un error
      }
    } catch (e) {
      print("Error en la solicitud: $e");
      return null; // Retorna null si ocurre una excepción
    }
  }

  // Crear un carrito
  Future<SentCart> createCart(SentCart sentCart) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(sentCart.toJson()), // Utilizamos toJson() para enviar el objeto
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print("Respuesta exitosa: ${jsonResponse}");

        // Asumiendo que la respuesta contiene la estructura 'response' -> 'cart'
        final createdCart = SentCart.fromJson(jsonResponse['response']['cart']);
        return createdCart;
      } else {
        throw Exception("Error al crear el carrito. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al crear el carrito: $e");
    }
  }

  // Actualizar el carrito
  Future<ApiResponse> updateCart(SentCart sentCart) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(sentCart.toJson()), // Usamos toJson() para los datos del carrito
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Verificamos si la respuesta contiene el campo 'success' y 'message'
        if (jsonResponse['success']) {
          return ApiResponse(
            success: jsonResponse['success'],
            message: jsonResponse['message'],
            response: CartResponse(cart: Cart(idCart: 0, total: 0.0, cartProducts: [])), // No usamos 'cart' en la respuesta
          );
        } else {
          throw Exception("No se pudo actualizar el carrito.");
        }
      } else {
        throw Exception("Error al actualizar el carrito. Código de respuesta: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al actualizar el carrito: $e");
    }
  }
}
