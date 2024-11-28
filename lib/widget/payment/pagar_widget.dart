import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PagarWidget extends StatefulWidget {
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
      paymentIntentData = await _createPaymentIntent('390', 'usd');
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            merchantDisplayName: 'Mi Tienda',
          ),
        );

        await Stripe.instance.presentPaymentSheet();

        _showAlert(
          title: '¡Éxito!',
          message: 'Pago realizado con éxito.',
          icon: Icons.check_circle,
          iconColor: Colors.green,
        );

        paymentIntentData = null;
      }
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        _showAlert(
          title: 'Pago cancelado',
          message: 'El pago ha sido interrumpido por el usuario.',
          icon: Icons.info,
          iconColor: Colors.orange,
        );
      } else {
        _showAlert(
          title: 'Error',
          message: 'Error al realizar el pago: ${e.error.localizedMessage}',
          icon: Icons.error,
          iconColor: Colors.red,
        );
      }
    } catch (e) {
      _showAlert(
        title: 'Error inesperado',
        message: 'Ha ocurrido un error inesperado: $e',
        icon: Icons.error_outline,
        iconColor: Colors.red,
      );
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent(
      String amount, String currency) async {
    try {
      final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
      final response = await http.post(
        url,
        headers: {
          'Authorization':
              'Bearer sk_test_51P0B7yIweajk9UR5NKSAId5SKolKtzYDALHAxfICRunfvQSUY2kYJghnOeIJF9pLxCAw01vgsMl35xSsVCrBtVcP00t7jIdah5',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': (int.parse(amount) * 100).toString(),
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
                      '\$390.00',
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
