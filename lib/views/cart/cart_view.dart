import 'package:crochetify_movil/viewmodels/cart_viewmodel.dart';
import 'package:crochetify_movil/views/cart/item_cart.dart';
import 'package:crochetify_movil/widget/payment/pagar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartView extends StatefulWidget {
  final int cartId;

  const CartView({Key? key, required this.cartId}) : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();

    // Llama a fetchCart después de que el árbol de widgets esté construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<CartViewModel>(context, listen: false);
      viewModel.fetchCart(widget.cartId);
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
            child: Consumer<CartViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (viewModel.hasError) {
                  return const Center(
                      child: Text('Error al cargar el carrito'));
                }
                if (viewModel.cartProducts.isEmpty) {
                  return const Center(
                      child: Text('No hay productos en el carrito'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: viewModel.cartProducts.length,
                  itemBuilder: (context, index) {
                    final product = viewModel.cartProducts[index];
                    return CartItem(cartId: 5); // CartItem renderizado
                  },
                );
              },
            ),
          ),
          PagarWidget(), // Puedes actualizar el total según sea necesario
        ],
      ),
    );
  }
}
