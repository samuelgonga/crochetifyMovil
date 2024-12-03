import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PagarWidget extends StatefulWidget {
  final double total;
  final int userId;
  final int directionId;

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
  } on StripeException catch (e) {
    if (e.error.code == FailureCode.Canceled) {
      // El usuario canceló el flujo de pago
      _showAlert(
        title: '¡Error!',
        message: 'El pago fue detenido por el usuario.',
        icon: Icons.error_outline,
        iconColor: Colors.orange,
      );
    } else {
      // Otros errores de Stripe
      _showAlert(
        title: 'Error',
        message: 'Error al procesar el pago: ${e.error.localizedMessage}',
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  } catch (e) {
    // Manejo genérico de errores
    _showAlert(
      title: 'Error',
      message: 'Ocurrió un error inesperado. Intenta de nuevo más tarde.',
      icon: Icons.error,
      iconColor: Colors.red,
    );
  }
}


  Future<void> _createOrder(int userId, int directionId) async {
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

      final amountInCents = (amount * 100).toInt();

      final response = await http.post(
        url,
        headers: {
          'Authorization':
              'Bearer sk_test_51P0B7yIweajk9UR5NKSAId5SKolKtzYDALHAxfICRunfvQSUY2kYJghnOeIJF9pLxCAw01vgsMl35xSsVCrBtVcP00t7jIdah5',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amountInCents.toString(),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 50,
              ),
              const SizedBox(height: 16.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: iconColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Aceptar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
          const SizedBox(height: 16.0),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              onPressed: _makePayment,
              child: const Text(
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
