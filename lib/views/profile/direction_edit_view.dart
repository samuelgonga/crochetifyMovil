import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DirectionEditView extends StatefulWidget {
  final int? idDirection;
  final String? currentPhone;
  final String? currentDirection;

  const DirectionEditView({
    Key? key,
    this.idDirection,
    this.currentPhone,
    this.currentDirection,
  }) : super(key: key);

  @override
  _DirectionEditViewState createState() => _DirectionEditViewState();
}

class _DirectionEditViewState extends State<DirectionEditView> {
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

  Future<void> _createDirection(String phone, String direction) async {
    final url = Uri.parse('http://100.27.71.83:8087/api/crochetify/directions');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'direction': direction}),
      );

      if (response.statusCode == 201) {
        _showCustomAlertDialog(
          title: '¡Éxito!',
          message: '¡Dirección creada con éxito!',
          icon: Icons.check_circle,
          iconColor: Colors.green,
          goBackOnClose: true,
        );
      } else {
        _showCustomAlertDialog(
          title: 'Error',
          message: 'Error al crear dirección: ${response.body}',
          icon: Icons.error,
          iconColor: Colors.red,
        );
      }
    } catch (e) {
      _showCustomAlertDialog(
        title: 'Error',
        message: 'Error al conectar con el servidor: $e',
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  Future<void> _updateDirection(
      int idDirection, String phone, String direction) async {
    final url = Uri.parse(
        'http://100.27.71.83:8087/api/crochetify/directions/$idDirection');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'direction': direction}),
      );

      if (response.statusCode == 200) {
        _showCustomAlertDialog(
          title: '¡Actualizado!',
          message: '¡Dirección actualizada con éxito!',
          icon: Icons.check_circle,
          iconColor: Colors.green,
          goBackOnClose: true,
        );
      } else {
        _showCustomAlertDialog(
          title: 'Error',
          message: 'Error al actualizar dirección: ${response.body}',
          icon: Icons.error,
          iconColor: Colors.red,
        );
      }
    } catch (e) {
      _showCustomAlertDialog(
        title: 'Error',
        message: 'Error al conectar con el servidor: $e',
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  void _showCustomAlertDialog({
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
    bool goBackOnClose = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(icon, color: iconColor, size: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
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
              Navigator.of(context).pop(); // Cierra el diálogo
              if (goBackOnClose) {
                Navigator.of(context).pop(true); // Regresa a la pantalla anterior
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blueAccent,
              textStyle: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            child: const Text('Cerrar'),
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
              const SizedBox(height: 16),
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
                  } else if (value.length != 10) {
                    return 'El número debe tener 10 dígitos';
                  } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'El número solo debe contener dígitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final direction = _directionController.text.trim();
                    final phone = _phoneController.text.trim();

                    if (widget.idDirection != null) {
                      _updateDirection(
                          widget.idDirection!, phone, direction);
                    } else {
                      _createDirection(phone, direction);
                    }
                  }
                },
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
