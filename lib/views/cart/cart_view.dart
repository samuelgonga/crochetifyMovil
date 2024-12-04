import 'package:crochetify_movil/models/direction.dart';
import 'package:crochetify_movil/viewmodels/user_viewmodel.dart';
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
  bool _isLoadingInitialData = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // Cargamos los datos iniciales.
  }

  /// Carga inicial de carrito y direcciones.
Future<void> _loadInitialData() async {
  final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
  final userViewModel = Provider.of<UserViewModel>(context, listen: false);

  await Future.wait([
    cartViewModel.fetchCart(widget.userId),
    userViewModel.fetchDirectionsByUserId(widget.userId),
  ]);

  if (mounted) {
    setState(() {
      _isLoadingInitialData = false; // Finalizamos la carga inicial.
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mi Carrito'),
      ),
      body: _isLoadingInitialData
          ? const Center(
              child: CircularProgressIndicator(), // Indicador de carga inicial.
            )
          : RefreshIndicator(
              onRefresh: _loadInitialData,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Consumer<CartViewModel>(
                      builder: (context, viewModel, child) {
                        if (viewModel.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (viewModel.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error,
                                    color: Colors.red, size: 60),
                                const SizedBox(height: 10),
                                const Text('Error al cargar el carrito.'),
                                ElevatedButton(
                                  onPressed: _loadInitialData,
                                  child: const Text('Reintentar'),
                                ),
                              ],
                            ),
                          );
                        }

                        if (viewModel.cartProducts.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart_outlined,
                                    size: 80, color: Colors.grey),
                                SizedBox(height: 10),
                                Text(
                                  'No tienes nada aquí, por ahora.',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '¿Qué te parece agregar algo?',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(8.0),
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
                              productName: product.product?.name ??
                                  'Producto sin nombre',
                              productDescription: product.product?.description ??
                                  'Sin descripción',
                              image: firstImage,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Consumer<CartViewModel>(
  builder: (context, cartViewModel, child) {
    if (cartViewModel.isLoading || cartViewModel.cartProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 113, 191, 254),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total: \$${cartViewModel.cartTotal.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255), // Azul vibrante
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Cantidad total de productos: ${cartViewModel.totalItems}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(221, 255, 255, 255),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final userViewModel =
                    Provider.of<UserViewModel>(context, listen: false);

                if (userViewModel.directions.isNotEmpty) {
                  Navigator.pushNamed(
                    context,
                    '/selectDirection',
                    arguments: widget.userId,
                  );
                } else {
                  final result = await Navigator.pushNamed(
                    context,
                    '/addDirection',
                  );

                  if (result == true) {
                    Navigator.pushNamed(
                      context,
                      '/selectDirection',
                      arguments: widget.userId,
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:  Colors.blueAccent, // Azul vibrante
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Pagar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  },
)

                ],
              ),
            ),
    );
  }
}
