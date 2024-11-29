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
            // Card elevadas para los campos de entrada
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
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),

            // Centramos el botón
            Center(
              child: isLoading
                  ? CircularProgressIndicator() // Indicador de carga
                  : ElevatedButton(
                      onPressed: () async {
                        final direction = directionController.text;
                        final phone = phoneController.text;

                        // Verificar si los datos están completos
                        if (direction.isNotEmpty && phone.isNotEmpty && user != null) {
                          // Mostrar indicador de carga
                          setState(() {
                            isLoading = true;
                          });

                          final newDirection = Direction(
                            direction: direction,
                            phone: phone,
                            idDirection: 0, // Asigna 0 o el valor adecuado
                            userId: user.id, // El ID del usuario
                          );

                          try {
                            // Intentar agregar la dirección
                            await Provider.of<UserViewModel>(context, listen: false)
                                .addDirection(newDirection);

                            // Cerrar la pantalla si el contexto sigue montado
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          } catch (e) {
                            // Mostrar mensaje de error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error al guardar la dirección: $e')),
                            );
                          } finally {
                            // Ocultar indicador de carga
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        } else {
                          // Mostrar mensaje si los campos están vacíos
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Por favor, completa todos los campos.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Color azul para el botón
                        foregroundColor: Colors.white, // Texto blanco
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
