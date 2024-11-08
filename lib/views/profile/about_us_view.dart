import 'package:flutter/material.dart';

class AcercaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acerca de nosotros')),
      body: Center(child: Text('Contenido de Acerca de nosotros')),
    );
  }
}
