import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderService {
  Future<List<Order>> fetchOrdersByUserId(int userId) async {
    final url = 'http://100.27.71.83:8087/api/crochetify/orden/user/$userId';
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
}
