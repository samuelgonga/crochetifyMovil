import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/cart_viewmodel.dart';
import 'package:crochetify_movil/views/cart/item_cart.dart';
import 'package:crochetify_movil/widget/payment/pagar_widget.dart';

class CartView extends StatefulWidget {
  final int userId;

  const CartView({Key? key, required this.userId}) : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  bool _hasFetchedCart = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFetchedCart) {
      final viewModel = Provider.of<CartViewModel>(context, listen: false);
      viewModel.fetchCart(widget.userId);
      _hasFetchedCart = true;
    }
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
                    return CartItem(
                      productName: product.product.name,
                      productColor: product.color,
                      productQuantity: product.quantity,
                      stockId: product.stockId,
                      userId: widget.userId,
                    );
                  },
                );
              },
            ),
          ),
          Consumer<CartViewModel>(
            builder: (context, viewModel, child) {
              return PagarWidget(total: viewModel.cartTotal);
            },
          ),
        ],
      ),
    );
  }
}
