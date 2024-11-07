import 'package:flutter/material.dart';
import './item_order_view.dart';

class ViewOrders extends StatelessWidget {
  const ViewOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Orders'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Buscar orden',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const ViewItemOrder(),
          const ViewItemOrder(),
          const ViewItemOrder(),
        ],
      ),
    );
  }
}
