import 'package:crochetify_movil/views/profile/profile_edit.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/widget/navigation/bottom_navigation.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';
import 'package:flutter/material.dart';
import 'about_us_view.dart';
import 'category_view.dart';
import 'orders_view.dart';
import 'help_view.dart';
import 'package:crochetify_movil/views/login/login_view.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(
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
                right: -10,
                bottom: 0,
                child: ElevatedButton(
                  onPressed: () {
                    // Acción al editar perfil
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfileEdit()));
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
                _buildProfileOption(context, 'Mis Pedidos', PedidosScreen()),
                _buildProfileOption(context, 'Categorías', CategoryScreen()),
                _buildProfileOption(
                    context, 'Acerca de Nosotros', AcercaScreen()),
                _buildProfileOption(context, 'Ayuda', AyudaScreen()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 20.0), // Espacio en la parte inferior
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Llama al método logout del AuthViewModel
                  await Provider.of<AuthViewModel>(context, listen: false)
                      .logout();
                  // Redirige al LoginView y elimina todas las rutas anteriores
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
                    (route) => false, // Elimina todas las rutas anteriores
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 40), // Ajuste del tamaño
                  backgroundColor: const Color.fromARGB(255, 224, 20, 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Borde redondeado
                  ),
                ),
                child: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
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
