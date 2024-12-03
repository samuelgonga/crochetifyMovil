import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/order_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';
import 'package:crochetify_movil/views/profile/order_detail_view.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthViewModel>(context, listen: false).user?.id;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mis Pedidos'),
        ),
        body: const Center(
          child: Text('No se pudo obtener la información del usuario.'),
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => OrderViewmodel()..loadOrdersByUserId(userId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Pedidos'),
          centerTitle: true,
        ),
        body: Consumer<OrderViewmodel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.orders.isEmpty) {
              return const Center(
                child: Text('No tienes pedidos disponibles.'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.orders.length,
              itemBuilder: (context, index) {
                final order = viewModel.orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text('Pedido numero: ${order.idOrder}'),
                    subtitle:
                        Text('Total: \$${order.total.toStringAsFixed(2)}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navegar hacia OrderDetailView
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailView(order: order),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
