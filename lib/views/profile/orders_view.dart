import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/order_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';
import 'package:crochetify_movil/views/profile/order_detail_view.dart';

class OrdersScreen extends StatefulWidget {
  final bool fromPayment; // Indica si la navegación viene de un pago exitoso

  const OrdersScreen({Key? key, this.fromPayment = false}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late OrderViewmodel orderViewModel;
  late int userId;

  @override
  void initState() {
    super.initState();
    // Inicializa el UserId y carga las órdenes
    userId = Provider.of<AuthViewModel>(context, listen: false).user?.id ?? 0;
    orderViewModel = Provider.of<OrderViewmodel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderViewModel.loadOrdersByUserId(userId);
    });
  }

  Future<void> _refreshOrders() async {
    try {
      await orderViewModel.loadOrdersByUserId(userId);
    } catch (e) {
      _showAlert(
        context,
        title: 'Error',
        message: 'Error al refrescar los pedidos: $e',
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis Pedidos',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 113, 191, 254),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (widget.fromPayment) {
              // Regresar al perfil después de un flujo de pago
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/profile',
                (route) => false,
              );
            } else {
              // Regresar normalmente
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Stack(
        children: [
          // Fondo azul claro
          Container(
            height: 100,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 113, 191, 254),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          Consumer<OrderViewmodel>(
            builder: (context, viewModel, _) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.orders.isEmpty) {
                return const Center(
                  child: Text(
                    'No tienes pedidos disponibles.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _refreshOrders,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 120, 16, 16),
                  itemCount: viewModel.orders.length,
                  itemBuilder: (context, index) {
                    final order = viewModel.orders[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 113, 191, 254)
                                  .withOpacity(0.2),
                          child: const Icon(
                            Icons.shopping_bag,
                            color: Color.fromARGB(255, 113, 191, 254),
                          ),
                        ),
                        title: Text(
                          'Tu Pedido',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          'Total: \$${order.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          // Navegar hacia OrderDetailView
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailView(order: order),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAlert(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Row(
            children: [
              Icon(icon, color: iconColor, size: 30),
              const SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Aceptar',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
