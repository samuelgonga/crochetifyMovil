import 'package:flutter/material.dart';
import 'package:crochetify_movil/views/login/login_view.dart';

class LoginPromptWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Ups... Parece que no has iniciado sesión',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const Padding(
            padding: const EdgeInsets.all(
                30.0), // Espacio de 16 píxeles en todos los lados
            child: Column(
              children: [
                Text('Primero debes de tener una cuenta'),
                Text('para iniciar sesión')
              ],
            ),
          ),
          Image.asset(
            'assets/images/candado2.png', // Ruta de la imagen en assets
            width: 100, // Ancho de la imagen (opcional)
            height: 100, // Alto de la imagen (opcional)
            fit: BoxFit.cover, // Ajuste de la imagen (opcional)
          ),
        ],
      ),
    );
  }
}
