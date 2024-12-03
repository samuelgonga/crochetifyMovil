import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/user_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';
import 'package:crochetify_movil/views/profile/direction_create_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DirectionView extends StatefulWidget {
  @override
  _DirectionViewState createState() => _DirectionViewState();
}

class _DirectionViewState extends State<DirectionView> {
  Map<int, bool> directionDefaults = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final user = Provider.of<AuthViewModel>(context).user;

    if (user != null) {
      userViewModel.fetchDirectionsByUserId(user.id);
    }
  }

  Future<void> _setDefaultDirection(int idDirection, int userId) async {
    final url = Uri.parse(
        'http://35.153.187.92:8087/api/crochetify/directions/set-default');

    try {
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

      if (response.statusCode == 200) {
        _showSuccessDialog();
        setState(() {
          directionDefaults.updateAll((key, value) => false);
          directionDefaults[idDirection] = true;
        });
      } else {
        _showErrorDialog(response.body);
      }
    } catch (e) {
      _showErrorDialog('Error al conectar con el servidor: $e');
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
            Icon(Icons.check_circle, color: Colors.green, size: 30),
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
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        content: Text(
          message,
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

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final directions = userViewModel.directions;
    final user = Provider.of<AuthViewModel>(context).user;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close,
              color: Colors.white), // Aquí está el cambio
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
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                                        direction.direction,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Teléfono: ${direction.phone}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (user != null) {
                                      _setDefaultDirection(
                                          direction.idDirection, user.id);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: directionDefaults[
                                                  direction.idDirection] ??
                                              false
                                          ? Colors.red.shade200
                                          : Colors.grey.shade300,
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      directionDefaults[
                                                  direction.idDirection] ??
                                              false
                                          ? Icons.favorite // Corazón lleno
                                          : Icons
                                              .favorite_border, // Corazón vacío
                                      color: Colors.red,
                                      size: 28,
                                    ),
                                  ),
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
