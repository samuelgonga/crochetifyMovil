import 'package:flutter/material.dart';

class AyudaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ayuda',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(
            Icons.close, // Icono de la "X"
            color: Colors.white, // Color blanco para el icono
          ),
          onPressed: () {
            Navigator.pop(context); // Navega hacia atrás
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Título de la sección de ayuda
            const Text(
              'Bienvenido a la sección de Ayuda',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            
            // Descripción sobre la app
            const Text(
              'Aquí encontrarás información para ayudarte a navegar por la aplicación y resolver cualquier duda.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            
            // Sección de preguntas frecuentes
            const Text(
              'Preguntas Frecuentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent, // Color azul en el encabezado
              ),
            ),
            const SizedBox(height: 10),
            _buildFAQTile(
              context,
              question: '¿Cómo ver una categoría?',
              answer:
                  'Para ver una categoría, ve al menú de categorías y podrás visualizar todos los productos por categorías.',
            ),
            _buildFAQTile(
              context,
              question: '¿Cómo visualizar los productos?',
              answer:
                  'Para ver los productos, selecciona una categoría desde la pantalla de inicio. Esto te llevará a una lista de productos disponibles.',
            ),
            _buildFAQTile(
              context,
              question: '¿Cómo editar mis datos?',
              answer:
                  'Para editar tus datos, dirígete a la sección de "Mi perfil", donde podrás actualizar tu nombre, correo electrónico y foto.',
            ),
            const SizedBox(height: 30),
            
            // Contacto y soporte
            const Text(
              '¿Necesitas más ayuda?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent, // Color azul en el encabezado
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Si tienes alguna pregunta que no se encuentra en las preguntas frecuentes, no dudes en contactarnos a través de nuestro correo electrónico: support@crochetify.com',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            
            // Botón para contacto
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar lógica para enviar un correo o abrir una página de soporte
              },
              child: const Text(
                'Contactar Soporte',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Color de fondo azul
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función para construir un tile de preguntas frecuentes
  Widget _buildFAQTile(BuildContext context, {required String question, required String answer}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent, // Color azul en el título
          ),
        ),
        trailing: const Icon(
          Icons.arrow_drop_down,
          color: Colors.blueAccent, // Color azul en la flecha
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
