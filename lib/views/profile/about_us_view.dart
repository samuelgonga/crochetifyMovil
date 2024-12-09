import 'package:flutter/material.dart';

class AcercaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white, // Color blanco para la "X"
          ),
          onPressed: () {
            // Acción al presionar el ícono de cerrar
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Acerca de Nosotros',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent, // Fondo azul
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Imagen en la parte superior
            Center(
              child: Image.asset(
                'assets/images/ness.jpeg', // Imagen a utilizar
                fit: BoxFit.cover,
                height: 210, // Ajusta la altura según tus necesidades
                width: 210,
              ),
            ),
            const SizedBox(height: 20),
             const Icon(
              Icons.info,
              color: Color(0xFF30596b), // Color de icono
              size: 48,
            ),

            // Título de la sección "¿Quiénes Somos?"
            const Text(
              '¿Quiénes Somos?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent, // Color azul en el título
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Descripción
            const Text(
              'Crochetify nació de la pasión por el arte del crochet y el deseo de compartir esta magia con el mundo. Somos una tienda en línea dedicada a ofrecer muñecos de crochet hechos a mano, cada uno creado con esmero y amor por nuestros talentosos artesanos.\n\n'
              'Nuestra misión es llevar la calidez y el encanto de estos adorables personajes de crochet a personas de todas las edades, convirtiendo cada compra en una experiencia especial y memorable. Nos enorgullecemos de ofrecer una amplia variedad de diseños, desde animales y personajes clásicos hasta creaciones personalizadas.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Contacto
            const Text(
              'Para más información o contacto, envíanos un correo a crochetify@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.black87,fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Botón de contacto

          ],
        ),
      ),
    );
  }
}
