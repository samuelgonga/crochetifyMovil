import 'package:crochetify_movil/views/cart/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/user_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/cart_viewmodel.dart';


class SelectDirectionView extends StatelessWidget {
  final int userId;

  const SelectDirectionView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final cartViewModel = Provider.of<CartViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Selecciona una Dirección'),
      ),
      body: Column(
        children: [
          Expanded(
            child: userViewModel.directions.isEmpty
                ? const Center(
                    child: Text('No tienes direcciones registradas.'),
                  )
                : ListView.builder(
                    itemCount: userViewModel.directions.length,
                    itemBuilder: (context, index) {
                      final direction = userViewModel.directions[index];
                      return ListTile(
                        title: Text(direction.direction),
                        subtitle: Text('Teléfono: ${direction.phone}'),
                        trailing: direction.isDefault
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentView(
                                selectedDirection: direction.direction,
                                total: cartViewModel.cartTotal,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Lógica para agregar nueva dirección
                Navigator.pushNamed(context, '/addDirection');
              },
              child: const Text('Agregar Nueva Dirección'),
            ),
          ),
        ],
      ),
    );
  }
}
