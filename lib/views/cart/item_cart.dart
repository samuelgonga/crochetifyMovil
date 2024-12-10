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
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                    utf8.decode(productName.runes.toList()),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    utf8.decode(productDescription.runes.toList()),
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
                          border: Border.all(color: Colors.black26, width: 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final cartViewModel = Provider.of<CartViewModel>(
                              context,
                              listen: false);
                          if (productQuantity > 1) {
                            await cartViewModel.updateProductQuantity(
                                userId, stockId, productQuantity - 1);
                          } else {
                            _showConfirmationDialog(context, cartViewModel);
                          }
                        },
                        icon:
                            const Icon(Icons.remove_circle, color: Colors.red),
                      ),
                      Text(
                        '$productQuantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final cartViewModel = Provider.of<CartViewModel>(
                              context,
                              listen: false);
                          await cartViewModel.updateProductQuantity(
                              userId, stockId, productQuantity + 1);
                        },
                        icon: const Icon(Icons.add_circle, color: Colors.green),
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
        final cleanImage = cleanBase64(image);
        return Image.memory(
          base64Decode(cleanImage!),
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

  String? cleanBase64(String? base64String) {
    if (base64String == null) return null;
    final prefixes = [
      'data:image/jpeg;base64,',
      'data:image/jpg;base64,',
      'data:image/png;base64,',
    ];
    for (var prefix in prefixes) {
      if (base64String.startsWith(prefix)) {
        return base64String.replaceFirst(prefix, '');
      }
    }
    return base64String;
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse('0x$hexColor'));
  }

  void _showConfirmationDialog(
      BuildContext context, CartViewModel cartViewModel) {
    final rootContext = Navigator.of(context).context;

    showDialog(
      context: rootContext,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 30),
            SizedBox(width: 10),
            Text(
              'Eliminar producto',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este producto del carrito?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await cartViewModel.removeProductFromCart(userId, stockId);
                _showAlert(
                  rootContext,
                  'Producto eliminado',
                  'El producto se eliminó correctamente del carrito.',
                  Colors.green,
                  cartViewModel,
                );
              } catch (e) {
                _showAlert(
                  rootContext,
                  'Error al eliminar',
                  'Hubo un problema al eliminar el producto.',
                  Colors.red,
                  cartViewModel,
                );
              }
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  void _showAlert(BuildContext context, String title, String message,
      Color iconColor, CartViewModel cartViewModel) {
    final rootContext = Navigator.of(context).context;

    Future.delayed(Duration.zero, () {
      showDialog(
        context: rootContext,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.info, color: iconColor, size: 30),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await cartViewModel.fetchCart(userId);
              },
              child: const Text(
                'Aceptar',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
          ],
        ),
      );
    });
  }
}
