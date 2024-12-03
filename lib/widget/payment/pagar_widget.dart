import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PagarWidget extends StatefulWidget {
  final double total;
  final int userId; // Agregar userId
  final int directionId; // Agregar directionId
  const PagarWidget({
    Key? key,
    required this.total,
    required this.userId,
    required this.directionId,
  }) : super(key: key);
  @override
  _PagarWidgetState createState() => _PagarWidgetState();
}

class _PagarWidgetState extends State<PagarWidget> {
  Map<String, dynamic>? paymentIntentData;

  @override
  void initState() {
    super.initState();
    Stripe.publishableKey =
        'pk_test_51P0B7yIweajk9UR5c7fsrfhPDgEuiztt2ayVoPhHQ8WSNFz3dzLr6ismE4QPQxFAFvPlvg33NPvbMjlQD3tFzepB007z42Ukd9';
  }

  Future<void> _makePayment() async {
    try {
      paymentIntentData = await _createPaymentIntent(widget.total, 'usd');
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            merchantDisplayName: 'Mi Tienda',
          ),
        );

        await Stripe.instance.presentPaymentSheet();

        // Aquí llamamos al servicio para crear la orden
        await _createOrder(
          widget.userId,
          widget.directionId,
        );

        _showAlert(
          title: '¡Éxito!',
          message: 'Pago realizado y orden creada con éxito.',
          icon: Icons.check_circle,
          iconColor: Colors.green,
        );

        paymentIntentData = null;
      }
    } catch (e) {
      _showAlert(
        title: 'Error',
        message: 'Error al procesar el pago: $e',
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  Future<void> _createOrder(int userId, int directionId) async {
    print(userId);
    print(directionId);
    try {
      final url = Uri.parse('http://35.153.187.92:8087/api/crochetify/orden');
      final http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'idUser': userId,
          'idDirection': directionId,
        }),
      );

      if (response.statusCode == 201) {
        print('Orden creada con éxito.');
      } else {
        throw Exception('Error al crear la orden: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al enviar los datos de la orden: $e');
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent(
      double amount, String currency) async {
    try {
      final url = Uri.parse('https://api.stripe.com/v1/payment_intents');

      // Convierte el monto a centavos antes de enviarlo a Stripe
      final amountInCents = (amount * 100).toInt();

      final response = await http.post(
        url,
        headers: {
          'Authorization':
              'Bearer sk_test_51P0B7yIweajk9UR5NKSAId5SKolKtzYDALHAxfICRunfvQSUY2kYJghnOeIJF9pLxCAw01vgsMl35xSsVCrBtVcP00t7jIdah5',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amountInCents.toString(), // Envía el monto en centavos
          'currency': currency,
          'payment_method_types[]': 'card',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Error al crear PaymentIntent: $e');
    }
  }

  void _showAlert({
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
            style: TextStyle(fontSize: 16),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Text(
                      '\$${widget.total.toStringAsFixed(2)}', // Muestra el total
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              onPressed: _makePayment, // Llama a la lógica de Stripe
              child: Text(
                'Pagar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
