import 'package:flutter/material.dart';

class PagarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(16.0), // Agrega un padding general al container
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 2.0), // Añade margen a la izquierda
                    child: Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 2.0), // Añade margen a la derecha
                    child: Text(
                      '\$390.00',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0), // Espacio entre los textos y el botón
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Fondo azul
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0), // Padding vertical del botón
              ),
              onPressed: () {
                // Aquí va la lógica para pagar
              },
              child: Text(
                'Pagar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
