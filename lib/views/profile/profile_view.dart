import 'dart:convert';
import 'package:crochetify_movil/viewmodels/order_viewmodel.dart';
import 'package:crochetify_movil/widget/navigation/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';
import 'package:crochetify_movil/views/profile/profile_edit.dart';
import 'package:crochetify_movil/views/home/home_view.dart';
import 'about_us_view.dart';
import 'orders_view.dart';
import 'help_view.dart';
import 'direction_view.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _fetchUpdatedUser(); // Asegúrate de cargar la información del usuario
  }

  Future<void> _fetchUpdatedUser() async {
    await Provider.of<AuthViewModel>(context, listen: false).fetchUserDetails();
  }

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
          // Imagen de perfil y botón de editar
          Center(
            child: Stack(
              children: [
                // Imagen de perfil
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      user?.image != null && user!.image!.isNotEmpty
                          ? MemoryImage(base64Decode(user.image!))
                          : AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                  backgroundColor: Colors.grey[200],
                ),
                // Botón de editar
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () async {
                      // Navegar a la pantalla de edición
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileEdit()),
                      );

                      // Recargar el perfil después de regresar
                      _fetchUpdatedUser();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 20,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            user?.email ?? 'Correo no disponible',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Text(
            "¡Hola ${user?.name ?? 'Usuario'}!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildProfileOption(
                  context,
                  'Mis Pedidos',
                  OrdersScreen(), // Aquí pasas el userId dinámicamente
                ),
                _buildProfileOption(
                    context, 'Mis direcciones', DirectionView()),
                _buildProfileOption(
                    context, 'Acerca de Nosotros', AcercaScreen()),
                _buildProfileOption(context, 'Ayuda', AyudaScreen()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  await Provider.of<AuthViewModel>(context, listen: false)
                      .logout();
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
