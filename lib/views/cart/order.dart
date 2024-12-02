import 'package:flutter/material.dart';
import 'package:crochetify_movil/widget/payment/pagar_widget.dart';

class PaymentView extends StatelessWidget {
  final String selectedDirection;
  final double total;

  const PaymentView({
    Key? key,
    required this.selectedDirection,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Confirmar Pago'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dirección Seleccionada:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              selectedDirection,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Total a Pagar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            PagarWidget(total: total), // Botón de Stripe
          ],
        ),
      ),
    );
  }
}
