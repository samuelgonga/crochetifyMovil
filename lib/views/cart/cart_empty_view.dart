import 'package:crochetify_movil/views/profile/profile_view.dart';
import 'package:crochetify_movil/views/cart/cart_view.dart'; // Importa correctamente la clase CartView
import 'package:flutter/material.dart';

class CartEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Mi Carrito'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/carro-vacio.png'),
              width: 100.0,
              height: 100.0,
            ),
            SizedBox(height: 10.0),
            Text(
              "No tienes nada aquí, Por ahora.",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              "¿Qué te parece agregar algo?",
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF5C5C5C)),
            ),
            SizedBox(height: 12.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Fondo azul
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(), // Navega a ProfileScreen
                    ),
                  );
                },
                child: Text('Ir a la Tienda', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 12.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Fondo azul
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartView(), // Navega a CartView (anteriormente CartS)
                    ),
                  );
                },
                child: Text('LLenar carrito', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
