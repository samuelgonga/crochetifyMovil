import 'dart:convert';

import 'package:crochetify_movil/models/cart.dart';
import 'package:crochetify_movil/viewmodels/cart_viewmodel.dart';
import 'package:crochetify_movil/views/cart/item_cart.dart';
import 'package:crochetify_movil/widget/payment/pagar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<Cart> cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final String jsonString = await rootBundle.loadString('assets/cart.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    setState(() {
      cartItems = jsonData.map((item) => Cart.fromJson(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mi Carrito'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: cartItems.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      // Cambiado 'id' a 'idCart'
                      return CartItem(cartId: cartItems[index].idCart);
                    },
                  ),
          ),
          PagarWidget(
              total: 69), // Puedes actualizar el total según sea necesario
        ],
      ),
    );
  }
}
