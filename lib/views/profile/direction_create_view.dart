import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/models/direction.dart';
import 'package:crochetify_movil/viewmodels/user_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';

class DirectionForm extends StatefulWidget {
  @override
  _DirectionFormState createState() => _DirectionFormState();
}

class _DirectionFormState extends State<DirectionForm> {
  final TextEditingController directionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false; // Para controlar el estado de carga
  bool isPhoneValid = false; // Controla si el número de teléfono es válido

  // Función para validar el número de teléfono
  void validatePhoneNumber(String value) {
    final isValid = RegExp(r'^\d{10}$').hasMatch(value);
    setState(() {
      isPhoneValid = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthViewModel>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Dirección'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: directionController,
                      decoration: InputDecoration(
                        labelText: 'Dirección',
                        hintText: 'Ingresa la dirección',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Número de Teléfono',
                        hintText: 'Ingresa el número de teléfono',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: validatePhoneNumber, // Llama a la validación
                    ),
                    SizedBox(height: 8),
                    // Validaciones visuales para el número de teléfono
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isPhoneValid
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: isPhoneValid ? Colors.green : Colors.red,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '10 dígitos',
                              style: TextStyle(
                                color: isPhoneValid
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              RegExp(r'^\d+$')
                                      .hasMatch(phoneController.text) &&
                                  phoneController.text.isNotEmpty
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: RegExp(r'^\d+$').hasMatch(
                                      phoneController.text)
                                  ? Colors.green
                                  : Colors.red,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Solo números',
                              style: TextStyle(
                                color: RegExp(r'^\d+$')
                                        .hasMatch(phoneController.text)
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
            Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        final direction = directionController.text;
                        final phone = phoneController.text;

                        if (direction.isNotEmpty &&
                            isPhoneValid &&
                            user != null) {
                          setState(() {
                            isLoading = true;
                          });

                          final newDirection = Direction(
                            direction: direction,
                            phone: phone,
                            idDirection: 0,
                            userId: user.id,
                          );

                          try {
                            await Provider.of<UserViewModel>(context,
                                    listen: false)
                                .addDirection(newDirection);

                            // Cierra el formulario y vuelve a la pila anterior
                            if (mounted) {
                              Navigator.pop(context, true); // Indica éxito
                            }
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'Error al guardar la dirección: $e'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Aceptar'),
                                  ),
                                ],
                              ),
                            );
                          } finally {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Validación'),
                              content: Text(
                                  'Por favor, completa todos los campos y asegúrate de que el número de teléfono sea válido.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Aceptar'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Guardar Dirección'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
