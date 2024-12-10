import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderService {
  Future<List<Order>> fetchOrdersByUserId(int userId) async {
    final url = 'http://54.146.53.211:8087/api/crochetify/orden/user/$userId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      print(userId);
      if (data['success']) {
        // Filtra correctamente los datos
        return (data['response']['pedidosUsuario'] as List)
            .map((order) => Order.fromJson(order))
            .toList();
      } else {
        throw Exception('Error fetching orders: ${data["message"]}');
      }
    } else {
      throw Exception('Failed to load orders');
    }
  }

    Future<Order> fetchOrderDetails(int idOrder) async {
  final url = 'http://54.146.53.211:8087/api/crochetify/orden/$idOrder'; // Asegúrate de que el endpoint sea correcto
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['success']) {
      return Order.fromJson(data['response']); // Ajusta según la estructura de tu respuesta
    } else {
      throw Exception('Error fetching order details: ${data["message"]}');
    }
  } else {
    throw Exception('Failed to load order details for order $idOrder');
  }
}
}
