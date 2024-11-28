import 'package:flutter/material.dart';

class AcercaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            // Acción al presionar el ícono de cerrar
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Acerca de Nosotros', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Row(
              
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            // Imagen en la parte superior
            Image.asset(
              'assets/images/ness.jpeg', // Coloca aquí la imagen que deseas mostrar en la carpeta assets
              fit: BoxFit.cover,
              height: 250, // Ajusta la altura según tus necesidades
              width: 250,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.info, color: Color(0XFF30596b), size: 48),
                  SizedBox(height: 16),
                  Text(
                    '¿Quiénes Somos?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9FB3EF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Crochetify nació de la pasión por el arte del crochet y el deseo de compartir esta magia con el mundo. Somos una tienda en línea dedicada a ofrecer muñecos de crochet hechos a mano, cada uno creado con esmero y amor por nuestros talentosos artesanos.\n\n'
                    'Nuestra misión es llevar la calidez y el encanto de estos adorables personajes de crochet a personas de todas las edades, convirtiendo cada compra en una experiencia especial y memorable. Nos enorgullecemos de ofrecer una amplia variedad de diseños, desde animales y personajes clásicos hasta creaciones personalizadas.\n\n'
                   ,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
