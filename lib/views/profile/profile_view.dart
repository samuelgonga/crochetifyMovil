import 'package:flutter/material.dart';
import 'about_us_view.dart';
import 'addres_view.dart';
import 'category_view.dart';
import 'orders_view.dart';
import 'help_view.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 40.0,
                  bottom: 20), // Ajusta el valor según lo que necesites
              child: Text(
                'Mi perfil',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ),
          // Imagen de perfil y botón Editar
          Stack(
            alignment: Alignment.center,
            children: [
              // Imagen de perfil
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://www.dafont.com/forum/attach/orig/7/4/746410.png?1',
                ),
              ),
              // Botón de editar encima
              Positioned(
                right: 0,
                bottom: 0,
                child: ElevatedButton(
                  onPressed: () {
                    // Acción al editar perfil
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(10),
                    backgroundColor: Colors.blue,
                  ),
                  child: Icon(Icons.edit, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Nombre del usuario
          const Text(
            'RayoBM45',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          // Opciones de perfil
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildProfileOption(
                    context, 'Mis Direcciones', DireccionesScreen()),
                _buildProfileOption(context, 'Mis Pedidos', PedidosScreen()),
                _buildProfileOption(context, 'Categorías', CategoryScreen()),
                _buildProfileOption(
                    context, 'Acerca de Nosotros', AcercaScreen()),
                _buildProfileOption(context, 'Ayuda', AyudaScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
      BuildContext context, String title, Widget screen) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 3,
      child: ListTile(
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}
