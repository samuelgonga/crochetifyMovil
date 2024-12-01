import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/cart_viewmodel.dart';

class CartItem extends StatelessWidget {
  final String productName;
  final String productColor;
  final int productQuantity;
  final int stockId;
  final int userId;

  const CartItem({
    Key? key,
    required this.productName,
    required this.productColor,
    required this.productQuantity,
    required this.stockId,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/16fadc71-0d8e-470d-bd38-763317aa20c8/ddicfjl-6d5acae2-b3ac-40e7-a6c9-e6a08b834577.jpg/v1/fill/w_1032,h_774,q_70,strp/hollow_knight_amigurumi_crochet_pattern_by_elizettacrafts_ddicfjl-pre.jpg",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Color: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _getColorFromHex(productColor),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () async {
                          if (productQuantity > 1) {
                            await _updateQuantity(
                              context, cartViewModel, productQuantity - 1);
                          }
                        },
                      ),
                      Text(
                        '$productQuantity',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          await _updateQuantity(
                            context, cartViewModel, productQuantity + 1);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Asegura que sea un color válido
    }
    return Color(int.parse('0x$hexColor'));
  }

  Future<void> _updateQuantity(BuildContext context,
      CartViewModel cartViewModel, int newQuantity) async {
    try {
      if (newQuantity < 1) {
        return; // No permitir cantidades negativas o cero
      }

      // Actualizamos el carrito local
      await cartViewModel.updateProductQuantity(userId, stockId, newQuantity);

      // Después de la actualización, se refresca automáticamente el carrito
      // No es necesario hacer nada extra debido a la notificación del ChangeNotifier
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
