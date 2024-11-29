import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crochetify_movil/models/shipment.dart';

class ShipmentService {
  static const String _baseUrl = 'http://35.153.187.92:8087/api/crochetify/shipment';

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
