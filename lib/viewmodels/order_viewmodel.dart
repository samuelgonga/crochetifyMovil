import 'package:crochetify_movil/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:crochetify_movil/models/order.dart';
import '../services/shipment_service.dart';

class OrderViewmodel extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<Order> _orders = [];
  bool _isLoading = false;
  bool _isDisposed = false; // Bandera para verificar si el objeto está eliminado

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    _isDisposed = true; // Marcamos que el objeto está eliminado
    super.dispose();
  }

  // Método seguro para notificar cambios
  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  // Cargar órdenes por userId
  Future<void> loadOrdersByUserId(int userId) async {
    _isLoading = true;
    _safeNotifyListeners(); // Usamos el método seguro

    try {
      _orders = await _orderService.fetchOrdersByUserId(userId);
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
      _safeNotifyListeners(); // Usamos el método seguro
    }
  }
}
