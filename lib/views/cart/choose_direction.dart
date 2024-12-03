import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/user_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/cart_viewmodel.dart';
import 'package:crochetify_movil/views/cart/order.dart';
import 'package:crochetify_movil/views/profile/direction_create_view.dart';

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
        title: const Text(
          'Selecciona una Dirección',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/cart');
            }
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: userViewModel.directions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_off,
                            size: 80, color: Colors.grey),
                        const SizedBox(height: 10),
                        const Text(
                          'No tienes direcciones registradas.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Por favor, agrega una nueva dirección.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: userViewModel.directions.length,
                    itemBuilder: (context, index) {
                      final direction = userViewModel.directions[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 25,
                            child: Icon(
                              Icons.home,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          title: Text(
                            direction.direction,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'Teléfono: ${direction.phone}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          trailing: direction.isDefault
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green, size: 30)
                              : null,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentView(
                                  selectedDirection: direction,
                                  total: cartViewModel.cartTotal,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
         Container(
  padding: const EdgeInsets.all(16.0),
  decoration: const BoxDecoration(
    color: Color.fromARGB(255, 113, 191, 254), // Fondo azul claro
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    ),
  ),
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DirectionForm(),
          ),
        ).then((_) {
          userViewModel.fetchDirectionsByUserId(userId);
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text(
        'Agregar Nueva Dirección',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  ),
)

        ],
      ),
    );
  }
}
