import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ViewOrderDatails extends StatelessWidget {
  const ViewOrderDatails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Order 1'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    AssetImage('assets/CrochetifyLogobyDesigner.png'),
                radius: 24,
              ),
              title: Text('Orden 1',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text('Fecha: 2022-01-01',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
            ),
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          Text(
            'Gracias por confiar en nosotros',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '¿Qué te parecio tu pedido?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          // Widget de estrellas de ranking
          RatingBar.builder(
            minRating: 1, // Calificación mínima
            direction: Axis.horizontal,
            itemCount: 5, // Número de estrellas
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print("Calificación: $rating");
            },
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Envía tu comentario',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          ElevatedButton(
            onPressed: () {
              // Acción al presionar el botón
              print("Comentario enviado");
            },
            style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color(0xFF46C5F3)),
            child: const Text(
              'Enviar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
