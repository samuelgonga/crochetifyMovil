import 'package:flutter/material.dart';
import './detail_order_view.dart';

class ViewItemOrder extends StatelessWidget {
  const ViewItemOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/CrochetifyLogobyDesigner.png'),
          radius: 24,
        ),
        title: const Text('Orden 1'),
        subtitle: const Text('Sabado, 26 de Octubre'),
        trailing: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ViewOrderDatails()),
            );
          },
          child: const Text('Ver detalles'),
        ),
      ),
    );
  }
}
