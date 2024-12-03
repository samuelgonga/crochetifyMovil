import 'package:crochetify_movil/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:crochetify_movil/models/order.dart';
import '../services/shipment_service.dart';

class OrderViewmodel extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> loadOrdersByUserId(int userId) async {
    _isLoading = true;
    if (hasListeners) {
      notifyListeners();
    }

    try {
      _orders = await _orderService.fetchOrdersByUserId(userId);
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
      if (hasListeners) {
        notifyListeners();
      }
    }
  }
}
