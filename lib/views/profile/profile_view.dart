import 'package:crochetify_movil/views/profile/profile_edit.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/widget/navigation/bottom_navigation.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';
import 'package:flutter/material.dart';
import 'about_us_view.dart';
import 'orders_view.dart';
import 'help_view.dart';
import 'direction_view.dart';

class ProfileScreen extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {    
    final user = Provider.of<AuthViewModel>(context).user;

    return Scaffold(
      body: Column(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 40.0, bottom: 20),
              child: Text(
                'Mi perfil',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          // Imagen de perfil y botón Editar
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: user!.image.isNotEmpty
                    ? NetworkImage(user.image) // Usamos la imagen del usuario si existe
                    : const NetworkImage(
                        'https://affinitaslegal.com/wp-content/uploads/2023/10/imagen-perfil-sin-foto.jpg', // Imagen predeterminada
                      ),
              ),
              Positioned(
                right: -10,
                bottom: 0,
                child: ElevatedButton(
                  onPressed: () {
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
          Text(
            user.email ?? 'Correo no disponible',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),          
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildProfileOption(context, 'Mis Pedidos', PedidosScreen()),
                _buildProfileOption(context, 'Mis direcciones', DirectionView()),
                _buildProfileOption(context, 'Acerca de Nosotros', AcercaScreen()),
                _buildProfileOption(context, 'Ayuda', AyudaScreen()),
              ],
            ),
          ),          
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  await Provider.of<AuthViewModel>(context, listen: false).logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 40),
                  backgroundColor: const Color.fromARGB(255, 224, 20, 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
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

  Widget _buildProfileOption(BuildContext context, String title, Widget screen) {
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
