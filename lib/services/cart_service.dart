import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crochetify_movil/models/sent_cart.dart';
import 'package:crochetify_movil/models/cart.dart'; // Importa ApiResponse

class CartService {
  final String baseUrl = "http://192.168.1.65:8080/api/crochetify/cart";

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
        return null;
      }
    } catch (e) {
      print("Error en la solicitud: $e");
      return null;
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
        body: json.encode(
            sentCart.toJson()), // Utilizamos toJson() para enviar el objeto
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print("Respuesta exitosa: ${jsonResponse}");

        // Asumiendo que la respuesta contiene la estructura 'response' -> 'cart'
        final createdCart = SentCart.fromJson(jsonResponse['response']['cart']);
        return createdCart;
      } else {
        throw Exception(
            "Error al crear el carrito. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al crear el carrito: $e");
    }
  }

// Actualizar el carrito
  Future<SentCart> updateCart(SentCart sentCart) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl'), // Utilizamos PUT para actualizar el carrito
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'idUser': sentCart.idUser,
          'idStock': sentCart.idStock,
          'quantity': sentCart.quantity,
        }),
      );

      if (response.statusCode == 200) {
        // Imprimimos la respuesta completa del servidor para inspeccionarla
        print("Respuesta del servidor: ${response.body}");

        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Verificamos si la respuesta contiene el campo 'cart'
        if (jsonResponse.containsKey('cart')) {
          final updatedCart = SentCart.fromJson(jsonResponse['cart']);
          return updatedCart;
        } else {
          // Si no contiene 'cart', imprimimos la respuesta completa para análisis
          throw Exception(
              "Respuesta inesperada del servidor. No contiene 'cart'.");
        }
      } else {
        throw Exception(
            "Error al actualizar el carrito. Código de respuesta: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al actualizar el carrito: $e");
    }
  }
}
