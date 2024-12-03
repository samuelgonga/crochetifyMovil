import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/models/order.dart';
import 'package:crochetify_movil/viewmodels/shipment_viewmodel.dart';

class OrderDetailView extends StatelessWidget {
  final Order order;

  const OrderDetailView({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shipmentViewModel = Provider.of<ShipmentViewModel>(context);
    final int idShipment = order.idShipment;

    // Verifica si el idShipment es válido
    if (idShipment <= 0) {
      print('No se encontró un envío asociado a esta orden.');
    } else {
      print('El envío asociado tiene id: $idShipment');
    }

    // Determina el estado del botón
    final bool hasShippingDate = order.shippingDay.isNotEmpty;
    final bool isDelivered = order.statusShipment == 2;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Orden #${order.idOrder}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: \$${order.total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Dirección: ${order.orderDirection}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Productos:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: order.orderProducts.length,
                itemBuilder: (context, index) {
                  final product = order.orderProducts[index];
                  final firstImage = product.images.isNotEmpty
                      ? product.images.first.image
                      : '';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: _buildProductImage(firstImage),
                      title: Text(product.product.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cantidad: ${product.quantity}'),
                          const SizedBox(height: 4),
                          Text(product.product.description),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    idShipment <= 0
                        ? Colors.red // Rojo si no hay envío asociado
                        : isDelivered
                            ? Colors.green // Verde si ya está entregado
                            : hasShippingDate
                                ? Colors
                                    .blue // Azul si está listo para marcar como recibido
                                : Colors.orange, // Naranja si está pendiente
                  ),
                ),
                onPressed: idShipment <= 0 || isDelivered || !hasShippingDate
                    ? null // Botón desactivado si no hay envío, ya está entregado, o pendiente de envío
                    : () async {
                        await shipmentViewModel.markAsReceived(idShipment);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Orden #${order.idOrder} marcada como recibida'),
                          ),
                        );
                      },
                child: Text(
                  idShipment <= 0
                      ? 'Pendiente'
                      : isDelivered
                          ? 'Entregado'
                          : hasShippingDate
                              ? 'Marcar como Recibido'
                              : 'Pendiente',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String base64Image) {
    if (base64Image.isNotEmpty) {
      try {
        final cleanImage =
            base64Image.replaceFirst('data:image/jpeg;base64,', '');
        final decodedBytes = base64Decode(cleanImage);
        return Image.memory(
          decodedBytes,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image_not_supported, size: 50),
        );
      } catch (e) {
        return const Icon(Icons.image_not_supported, size: 50);
      }
    } else {
      return const Icon(Icons.image_not_supported, size: 50);
    }
  }
}
