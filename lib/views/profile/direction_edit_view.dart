import 'package:crochetify_movil/widget/navigation/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'direction_view.dart';

class DirectionForm extends StatefulWidget {
  final int? idDirection; // ID de la dirección para edición (null si es nueva)
  final String? currentPhone; // Teléfono actual (null si es nueva)
  final String? currentDirection; // Dirección actual (null si es nueva)

  const DirectionForm({
    Key? key,
    this.idDirection,
    this.currentPhone,
    this.currentDirection,
  }) : super(key: key);

  @override
  _DirectionFormState createState() => _DirectionFormState();
}

class _DirectionFormState extends State<DirectionForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  late TextEditingController _directionController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.currentPhone ?? '');
    _directionController =
        TextEditingController(text: widget.currentDirection ?? '');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _directionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final direction = _directionController.text.trim();
      final phone = _phoneController.text.trim();

      if (widget.idDirection != null) {
        // Actualizar una dirección existente
        await _updateDirection(widget.idDirection!, phone, direction);
      } else {
        // Crear una nueva dirección
        await _createDirection(phone, direction);
      }
    }
  }

  Future<void> _createDirection(String phone, String direction) async {
    // Lógica para crear una dirección en el backend.
    // Reemplaza esto con tu lógica HTTP.
    try {
      // Simulación de creación exitosa
      _showSuccessDialog('¡Dirección creada con éxito!');
    } catch (e) {
      _showErrorDialog('Error al crear la dirección: $e');
    }
  }

  void _showEditSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(Icons.edit, color: Colors.blueAccent, size: 30),
            const SizedBox(width: 10),
            const Text(
              '¡Actualizado!',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
        content: const Text(
          'La dirección fue actualizada correctamente.',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,
                );
              }
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

  Future<void> _updateDirection(
      int idDirection, String phone, String direction) async {
    final url = Uri.parse(
        'http://100.27.71.83:8087/api/crochetify/directions/$idDirection');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phone': phone,
          'direction': direction,
        }),
      );

      if (response.statusCode == 200) {
        _showEditSuccessDialog();
        setState(() {
          // Implementa la lógica para actualizar los datos localmente, si aplica.
        });
      } else {
        _showErrorDialog('Error al actualizar: ${response.body}');
      }
    } catch (e) {
      _showErrorDialog('Error al conectar con el servidor: $e');
    }
  }

  void _showSuccessDialog(String message) {
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
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Vuelve a la pantalla anterior
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.idDirection != null
            ? 'Editar Dirección'
            : 'Agregar Dirección'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un teléfono válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _directionController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una dirección válida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white),
                child: Text(widget.idDirection != null
                    ? 'Actualizar Dirección'
                    : 'Guardar Dirección'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
