import 'package:flutter/material.dart';

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
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Text('Primero debes de tener una cuenta'),
                Text('para iniciar sesión')
              ],
            ),
          ),
          Image.asset(
            'assets/images/candado2.png',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
