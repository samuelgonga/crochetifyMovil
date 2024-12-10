// Importaciones necesarias
import 'package:crochetify_movil/models/direction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/user_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';
import 'package:crochetify_movil/views/profile/direction_create_view.dart';
import 'package:crochetify_movil/views/profile/direction_edit_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DirectionView extends StatefulWidget {
  @override
  _DirectionViewState createState() => _DirectionViewState();
}

class _DirectionViewState extends State<DirectionView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final user = Provider.of<AuthViewModel>(context).user;

    if (user != null) {
      userViewModel.fetchDirectionsByUserId(user.id);
    }
  }

  Future<bool> _setDefaultDirection(int idDirection, int userId) async {
    final url = Uri.parse(
        'http://54.146.53.211:8087/api/crochetify/directions/set-default');

    try {
      print("Enviando solicitud para establecer dirección predeterminada...");
      print("URL: $url");
      print("Body: userId: $userId, directionId: $idDirection");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'directionId': idDirection,
        }),
      );

      print("Estado de respuesta: ${response.statusCode}");
      print("Cuerpo de respuesta: ${response.body}");

      if (response.statusCode == 200) {
        print(
            "Dirección predeterminada establecida. Obteniendo direcciones actualizadas...");

        final directionsResponse = await http.get(
          Uri.parse(
              'http://54.146.53.211:8087/api/crochetify/directions/$userId'),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (directionsResponse.statusCode == 200) {
          final data = jsonDecode(directionsResponse.body);
          print("Direcciones actualizadas: ${directionsResponse.body}");

          if (data['success'] == true) {
            final userViewModel =
                Provider.of<UserViewModel>(context, listen: false);

            userViewModel.directions =
                (data['response'] as Map<String, dynamic>)
                    .values
                    .map((direction) => Direction.fromJson(direction))
                    .toList();

            setState(() {});
          }
          _showSuccessDialog();
          return true;
        } else {
          print(
              "Error al obtener direcciones actualizadas: ${directionsResponse.body}");
          _showErrorDialog(
              'Error al obtener direcciones actualizadas: ${directionsResponse.body}');
          return false;
        }
      } else {
        _showErrorDialog(
            'Error al marcar como predeterminada: ${response.body}');
        return false;
      }
    } catch (e) {
      print("Error al realizar la solicitud: $e");
      _showErrorDialog('Error al conectar con el servidor: $e');
      return false;
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 30),
            const SizedBox(width: 10),
            const Text(
              '¡Éxito!',
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
        content: const Text(
          'La dirección fue marcada como predeterminada.',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cerrar',
              style: TextStyle(color: Colors.blueAccent, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    if (!mounted) return; // Verifica si el widget aún está montado
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 30),
            const SizedBox(width: 10),
            const Text(
              'Error',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cerrar',
              style: TextStyle(color: Colors.blueAccent, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final directions = userViewModel.directions;
    final user = Provider.of<AuthViewModel>(context).user;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Direcciones',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/images/ness.jpeg',
                fit: BoxFit.cover,
                height: 250,
                width: 250,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Mis Direcciones',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Aquí puedes ver todas las direcciones que has registrado. Si necesitas agregar una nueva, puedes hacerlo fácilmente.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            directions.isEmpty
                ? const Center(
                    child: Text(
                      'No tienes direcciones registradas.',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: directions.length,
                      itemBuilder: (context, index) {
                        final direction = directions[index];
                        print(
                            "Renderizando dirección: id=${direction.idDirection}, isDefault=${direction.isDefault}");
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: direction.isDefault
                              ? Colors.red.shade50
                              : Colors
                                  .white, // Fondo dinámico basado en isDefault
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        utf8.decode(direction.direction.runes
                                            .toList()), // Decodificación aquí
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: direction.isDefault
                                              ? Colors.red
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Teléfono: ${utf8.decode(direction.phone.runes.toList())}', // Decodificación aquí
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: direction.isDefault
                                              ? Colors.red
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blueAccent),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DirectionEditView(
                                          idDirection: direction.idDirection,
                                          currentPhone: direction.phone,
                                          currentDirection: direction.direction,
                                        ),
                                      ),
                                    );
                                    if (user != null) {
                                      userViewModel
                                          .fetchDirectionsByUserId(user.id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DirectionForm()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white),
                child: const Text('Agregar Nueva Dirección'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
