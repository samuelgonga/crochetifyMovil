import 'package:crochetify_movil/models/order.dart';
import 'package:crochetify_movil/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:crochetify_movil/models/shipment.dart';
import '../services/shipment_service.dart';

class ShipmentViewModel extends ChangeNotifier {
  final ShipmentService _shipmentService = ShipmentService();
  final OrderService _orderService = OrderService();
  List<Shipment> _shipments = [];
  bool _isLoading = false;

  List<Shipment> get shipments => _shipments;
  bool get isLoading => _isLoading;

  Future<void> loadShipments(int idOrder) async {
    _isLoading = true;
    notifyListeners();

    try {
      _shipments = await _shipmentService.fetchShipmentsByOrderId(idOrder);
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsReceived(int idShipment) async {
    final currentDate = DateTime.now();
    final deliveryDay =
        "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

    try {
      await _shipmentService.markAsReceived(idShipment, deliveryDay);
      print('Shipment $idShipment marcado como recibido');
      notifyListeners(); // Notifica a la vista para que se actualice
    } catch (e) {
      print('Error marcando el envío como recibido: $e');
    }
  }

  Future<Order> reloadOrderDetails(int idOrder) async {
  try {
    // Llama al servicio para obtener los detalles del pedido actualizados
    final updatedOrder = await _orderService.fetchOrderDetails(idOrder);
    notifyListeners(); // Notifica a la vista para que reaccione a los cambios
    return updatedOrder;
  } catch (e) {
    print('Error recargando detalles de la orden: $e');
    rethrow; // Permite manejar el error en la vista si es necesario
  }
}




}
