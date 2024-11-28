import 'package:crochetify_movil/viewmodels/cart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final int cartId;

  const CartItem({Key? key, required this.cartId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(
      builder: (context, viewModel, child) {
        // Mostrar indicador de carga
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Mostrar mensaje de error
        if (viewModel.hasError) {
          return const Center(child: Text('Error al cargar el carrito'));
        }

        // Verificar si hay datos
        final cartProducts = viewModel.cartProducts;
        if (cartProducts.isEmpty) {
          return const Center(child: Text('No hay productos en el carrito'));
        }

        // Mostrar lista de productos
        return ListView.builder(
          itemCount: cartProducts.length,
          shrinkWrap: true,
          padding: const EdgeInsets.all(12.0),
          itemBuilder: (context, index) {
            final cartProduct = cartProducts[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Row(
                children: [
                  // Imagen del producto
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/16fadc71-0d8e-470d-bd38-763317aa20c8/ddicfjl-6d5acae2-b3ac-40e7-a6c9-e6a08b834577.jpg/v1/fill/w_1032,h_774,q_70,strp/hollow_knight_amigurumi_crochet_pattern_by_elizettacrafts_ddicfjl-pre.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9OTYwIiwicGF0aCI6IlwvZlwvMTZmYWRjNzEtMGQ4ZS00NzBkLWJkMzgtNzYzMzE3YWEyMGM4XC9kZGljZmpsLTZkNWFjYWUyLWIzYWMtNDBlNy1hNmM5LWU2YTA4YjgzNDU3Ny5qcGciLCJ3aWR0aCI6Ijw9MTI4MCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.gxXsbXa7_3E5U1oLqkDzzG_8zeNLLzlkRVreoPHJ4e0",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Detalles del producto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartProduct.product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Color: ${cartProduct.color}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Cantidad: ${cartProduct.quantity}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
