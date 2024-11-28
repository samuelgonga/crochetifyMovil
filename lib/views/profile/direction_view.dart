import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/user_viewmodel.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';
import 'package:crochetify_movil/views/profile/direction_create_view.dart';

class DirectionView extends StatefulWidget {
  @override
  _DirectionViewState createState() => _DirectionViewState();
}

class _DirectionViewState extends State<DirectionView> {
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

  final int id = 0;
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final directions = userViewModel.directions;
    return Scaffold(
      appBar: AppBar(title: const Text('Direcciones')),
      body: Column(
        children: [
          Expanded(
            child: directions.isEmpty
                ? const Center(
                    child: Text('No tienes direcciones registradas.'),
                  )
                : ListView.builder(
                    itemCount: directions.length,
                    itemBuilder: (context, index) {
                      final direction = directions[index];
                      return Card(
                        elevation: 5, // Elevación para el efecto de sombra
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                direction.direction,
                                style: TextStyle(
                                  fontSize:
                                      18, // Tamaño de letra grande para la dirección
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Teléfono: ${direction.phone}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DirectionForm()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Color azul para el botón
                foregroundColor: Colors.white, // Texto blanco
              ),
              child: const Text('Agregar Nueva Dirección'),
            ),
          ),
        ],
      ),
    );
  }
}
