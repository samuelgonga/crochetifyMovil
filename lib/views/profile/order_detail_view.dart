import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/models/order.dart';
import 'package:crochetify_movil/viewmodels/shipment_viewmodel.dart';

class OrderDetailView extends StatefulWidget {
  final Order order;

  const OrderDetailView({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailViewState createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  late ShipmentViewModel shipmentViewModel;
  late Order order;

  @override
  void initState() {
    super.initState();
    shipmentViewModel = Provider.of<ShipmentViewModel>(context, listen: false);
    order = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    final bool hasShippingDate = order.shippingDay.isNotEmpty;
    final bool isDelivered = order.statusShipment == 2;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo azul superior
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 113, 191, 254),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botón de salir
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 40),
                // Título
                Center(
                  child: Text(
                    'Detalles de Orden',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: order.orderProducts.length,
                      itemBuilder: (context, index) {
                        final product = order.orderProducts[index];
                        final firstImage = product.images.isNotEmpty
                            ? product.images.first.image
                            : '';
                        final backgroundColor = _getBackgroundColor(index);

                        return Card(
                          color: backgroundColor,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: _buildProductImage(firstImage),
                            title: Text(
                              product.product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cantidad: ${product.quantity}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.product.description,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Total y Botón en la parte inferior
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: const Color.fromARGB(255, 113, 191, 254),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '\$${order.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDelivered
                          ? Colors.green // Pedido entregado
                          : hasShippingDate
                              ? Colors.blue // Pedido enviado
                              : Colors.red, // Pedido pendiente
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 30,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: isDelivered
                        ? null // Botón deshabilitado si ya está entregado
                        : hasShippingDate
                            ? () async {
                                try {
                                  await shipmentViewModel
                                      .markAsReceived(order.idShipment);
                                  _showDialog(
                                    context,
                                    '¡Éxito!',
                                    'Orden #${order.idOrder} marcada como recibida.',
                                    Icons.check_circle,
                                    Colors.green,
                                  );
                                  setState(() {
                                    order = order.copyWith(
                                      statusShipment: 2,
                                      deliveryDay: DateTime.now()
                                          .toString()
                                          .substring(0, 10),
                                    );
                                  });
                                } catch (e) {
                                  _showDialog(
                                    context,
                                    'Error',
                                    'Hubo un error al marcar la orden como recibida: $e',
                                    Icons.error,
                                    Colors.red,
                                  );
                                }
                              }
                            : null,
                    child: Text(
                      isDelivered
                          ? 'Entregado'
                          : hasShippingDate
                              ? 'Marcar como Recibido'
                              : 'Pendiente',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String base64Image) {
    if (base64Image.isNotEmpty) {
      try {
        final cleanImage = _cleanBase64(base64Image);
        final decodedBytes = base64Decode(cleanImage!);
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(
            decodedBytes,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported, size: 50),
          ),
        );
      } catch (e) {
        return const Icon(Icons.image_not_supported, size: 50);
      }
    } else {
      return const Icon(Icons.image_not_supported, size: 50);
    }
  }

  String? _cleanBase64(String? base64String) {
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

  void _showDialog(BuildContext context, String title, String message,
      IconData icon, Color iconColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Row(
            children: [
              Icon(icon, color: iconColor, size: 30),
              const SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Color _getBackgroundColor(int index) {
    final colors = [
      const Color(0xFFF8E1F4),
      const Color(0xFFE8F5E9),
      const Color(0xFFE3F2FD),
      const Color(0xFFFFF3E0),
    ];
    return colors[index % colors.length];
  }
}
