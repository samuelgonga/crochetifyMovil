import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/cart_viewmodel.dart';

class CartItem extends StatelessWidget {
  final String productColor;
  final int productQuantity;
  final int stockId;
  final int userId;
  final String image; // Imagen en formato base64

  const CartItem({
    Key? key,
    required this.productColor,
    required this.productQuantity,
    required this.stockId,
    required this.userId,
    required this.image,
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
              child: image.isNotEmpty
                  ? Image.memory(
                      base64Decode(
                          image.replaceFirst('data:image/jpeg;base64,', '')),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        size: 80,
                      ),
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      size: 80,
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
  
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

Future<void> _updateQuantity(BuildContext context, CartViewModel cartViewModel, int newQuantity) async {
  try {
    if (newQuantity < 1) {
      return; // No permitir cantidades negativas o cero
    }

    await cartViewModel.updateProductQuantity(userId, stockId, newQuantity);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al actualizar la cantidad: ${e.toString()}')),
    );
  }
}




}
