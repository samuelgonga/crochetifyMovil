import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomButton extends StatefulWidget {
  final String text;

  const CustomButton({super.key, required this.text});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isSelected =
              !_isSelected; // Cambia el estado del botón al presionarlo
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _isSelected
            ? Colors.grey
            : Colors.white, // Fondo gris si está seleccionado
        foregroundColor: _isSelected
            ? Colors.white
            : Colors.black, // Texto blanco si está seleccionado
        side: BorderSide(
          color: _isSelected
              ? const Color.fromARGB(177, 111, 113, 117)
              : const Color.fromARGB(
                  255, 167, 161, 161), // Cambia el color del borde
          width: 1,
        ),
        padding: const EdgeInsets.symmetric(
            vertical: 8.0, horizontal: 12.0), // Espaciado interno
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: Text(
        widget.text,
        style: const TextStyle(fontSize: 13), // Ajustar el tamaño de la fuente
      ),
    );
  }
}
