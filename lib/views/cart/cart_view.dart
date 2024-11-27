import 'package:flutter/material.dart';
import 'package:crochetify_movil/views/cart/item_cart.dart';
import 'package:crochetify_movil/widget/payment/pagar_widget.dart';

class CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Mi Carrito'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: <Widget>[
                ItemCart(),
              ],
            ),
          ),
          PagarWidget(),
        ],
      ),
    );
  }
}
