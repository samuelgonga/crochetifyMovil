import 'dart:convert';
import 'package:crochetify_movil/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:crochetify_movil/models/shipment.dart';

class ShipmentService {
  static const String _baseUrl =
      'http://100.27.71.83:8087/api/crochetify/shipment';

  // Obtener la lista de Shipments
  Future<List<Shipment>> fetchShipments() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        return (data['response']['shipments'] as List)
            .map((shipment) => Shipment.fromJson(shipment))
            .toList();
      } else {
        throw Exception('Error fetching shipments: ${data["message"]}');
      }
    } else {
      throw Exception('Failed to load shipments');
    }
  }

  Future<List<Shipment>> fetchShipmentsByOrderId(int idOrder) async {
    final url = '$_baseUrl/orden/$idOrder'; // Endpoint específico para la orden
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        return (data['response']['shipments'] as List)
            .map((shipment) => Shipment.fromJson(shipment))
            .toList();
      } else {
        throw Exception(
            'Error fetching shipments for order $idOrder: ${data["message"]}');
      }
    } else {
      throw Exception('Failed to load shipments for order $idOrder');
    }
  }

  // Actualizar el Shipment como recibido (PUT)
  Future<void> markAsReceived(int idShipment, String deliveryDay) async {
    final url = '$_baseUrl/$idShipment'; // Endpoint para PUT
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "delivery_day": deliveryDay, // Enviar la fecha en formato String
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error updating shipment: ${response.body}');
    }
  }





}
