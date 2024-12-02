import 'package:crochetify_movil/viewmodels/user_viewmodel.dart';
import 'package:crochetify_movil/views/cart/choose_direction.dart';
import 'package:crochetify_movil/views/profile/direction_create_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/cart_viewmodel.dart';
import 'package:crochetify_movil/views/cart/item_cart.dart';

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

                    // Validación adicional para manejar imágenes
                    final String? firstImage =
                        (product.stock?.images.isNotEmpty ?? false)
                            ? product.stock!.images.first
                            : null;

                    return CartItem(
                      productColor: product.color,
                      productQuantity: product.quantity,
                      stockId: product.stockId,
                      userId: widget.userId,
                      image: firstImage ??
                          '', // Pasa la imagen o una cadena vacía si no hay imágenes válidas
                    );
                  },
                );
              },
            ),
          ),
          Consumer<CartViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Total: \$${viewModel.cartTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      final userViewModel =
                          Provider.of<UserViewModel>(context, listen: false);
                      final directions = userViewModel.directions;

                      // Verifica si hay direcciones
                      if (directions.isEmpty) {
                        // Si no hay direcciones, lleva a la pantalla para agregar una nueva dirección
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DirectionForm(),
                          ),
                        );
                      } else {
                        // Si hay direcciones, navega a la pantalla de selección de dirección
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectDirectionView(
                              userId:
                                  widget.userId, // Asegúrate de pasar el userId
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Pagar'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
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
