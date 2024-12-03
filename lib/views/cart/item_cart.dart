import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/cart_viewmodel.dart';

class CartItem extends StatelessWidget {
  final String productColor;
  final int productQuantity;
  final int stockId;
  final int userId;
  final String productName;
  final String productDescription;
  final String image; // Imagen base64

  const CartItem({
    Key? key,
    required this.productColor,
    required this.productQuantity,
    required this.stockId,
    required this.userId,
    required this.productName,
    required this.productDescription,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: _buildImage(),
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
                  Text(
                    productDescription,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Color:'),
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
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          final cartViewModel = Provider.of<CartViewModel>(
                              context,
                              listen: false);

                          if (productQuantity > 1) {
                            // Disminuye la cantidad si es mayor a 1
                            cartViewModel.updateProductQuantity(
                                userId, stockId, productQuantity - 1);
                          } else {
                            // Si llega a 0 o menos, elimina el producto del carrito
                            cartViewModel.removeProductFromCart(stockId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Producto eliminado del carrito.')),
                            );
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text('$productQuantity'),
                      IconButton(
                        onPressed: () {
                          final cartViewModel = Provider.of<CartViewModel>(
                              context,
                              listen: false);
                          cartViewModel.updateProductQuantity(
                              userId, stockId, productQuantity + 1);
                        },
                        icon: const Icon(Icons.add),
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

  Widget _buildImage() {
    if (image.isNotEmpty) {
      try {
        final cleanImage = image.replaceFirst('data:image/jpeg;base64,', '');
        return Image.memory(
          base64Decode(cleanImage),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        );
      } catch (e) {
        return const Icon(Icons.image_not_supported, size: 80);
      }
    } else {
      return const Icon(Icons.image_not_supported, size: 80);
    }
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse('0x$hexColor'));
  }
}
