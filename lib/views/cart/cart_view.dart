import 'package:crochetify_movil/models/direction.dart';
import 'package:crochetify_movil/viewmodels/user_viewmodel.dart';
import 'package:crochetify_movil/views/cart/choose_direction.dart';
import 'package:crochetify_movil/views/profile/direction_create_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/cart_viewmodel.dart';
import 'package:crochetify_movil/views/cart/item_cart.dart';
import 'package:crochetify_movil/viewmodels/user_viewmodel.dart';

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
                  itemCount: viewModel.cartProducts.length,
                  itemBuilder: (context, index) {
                    final product = viewModel.cartProducts[index];
                    final firstImage = product.images.isNotEmpty
                        ? product.images.first.image
                        : '';

                    return CartItem(
                      productColor: product.color,
                      productQuantity: product.quantity,
                      stockId: product.stockId,
                      userId: widget.userId,
                      productName:
                          product.product?.name ?? 'Producto sin nombre',
                      productDescription:
                          product.product?.description ?? 'Sin descripción',
                      image: firstImage,
                    );
                  },
                );
              },
            ),
          ),
          Consumer<CartViewModel>(
            builder: (context, cartViewModel, child) {
              if (cartViewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (cartViewModel.cart == null ||
                  cartViewModel.cartProducts.isEmpty) {
                return const Center(
                    child: Text('No hay productos en el carrito.'));
              }

              return Column(
                children: [
                  Text(
                    'Total: \$${cartViewModel.cartTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cantidad total de productos: ${cartViewModel.totalItems}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final userViewModel =
                          Provider.of<UserViewModel>(context, listen: false);
                      final directions = userViewModel.directions;
                      if (directions.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SelectDirectionView(userId: widget.userId),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DirectionForm(),
                          ),
                        );
                      }
                    },
                    child: const Text('Pagar'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
