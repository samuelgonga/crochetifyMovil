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
  final String image;

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      shadowColor: Colors.grey.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF1565C0), // Azul inspirado
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
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
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Color:',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _getColorFromHex(productColor),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black26,
                              width: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            final cartViewModel = Provider.of<CartViewModel>(
                                context,
                                listen: false);

                            if (productQuantity > 1) {
                              cartViewModel.updateProductQuantity(
                                  userId, stockId, productQuantity - 1);
                            } else {
                              cartViewModel.removeProductFromCart(stockId);
                              _showAlert(
                                context,
                                title: 'Producto eliminado',
                                message:
                                    'El producto ha sido eliminado del carrito.',
                                icon: Icons.delete,
                                iconColor: Colors.red,
                              );
                            }
                          },
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                        ),
                        Text(
                          '$productQuantity',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            final cartViewModel = Provider.of<CartViewModel>(
                                context,
                                listen: false);
                            cartViewModel.updateProductQuantity(
                                userId, stockId, productQuantity + 1);
                          },
                          icon: const Icon(Icons.add_circle,
                              color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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

  void _showAlert(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Row(
            children: [
              Icon(icon, color: iconColor, size: 30),
              const SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Aceptar',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
