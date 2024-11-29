import 'package:flutter/material.dart';
import 'package:crochetify_movil/models/shipment.dart';
import '../services/shipment_service.dart';

class ShipmentViewModel extends ChangeNotifier {
  final ShipmentService _shipmentService = ShipmentService();
  List<Shipment> _shipments = [];
  bool _isLoading = false;

  List<Shipment> get shipments => _shipments;
  bool get isLoading => _isLoading;

  Future<void> loadShipments() async {
    _isLoading = true;
    notifyListeners();

    try {
      _shipments = await _shipmentService.fetchShipments();
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Marcar como recibido
  Future<void> markAsReceived(int idShipment) async {
    final shipmentIndex = _shipments.indexWhere((s) => s.idShipment == idShipment);
    if (shipmentIndex == -1) return;

    final currentDate = DateTime.now();
    final deliveryDay = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

    try {
      // Realiza el PUT a la API
      await _shipmentService.markAsReceived(idShipment, deliveryDay);

      // Actualiza el estado local con la fecha recibida
      _shipments[shipmentIndex] = _shipments[shipmentIndex].copyWith(
        deliveryDay: currentDate,
        status: 2, // Cambiar el status a "Entregado"
      );
      notifyListeners();
    } catch (e) {
      print('Error updating shipment: $e');
    }
  }
}
