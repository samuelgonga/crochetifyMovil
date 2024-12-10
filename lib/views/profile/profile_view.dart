import 'dart:convert';
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
    _fetchUpdatedUser();
  }

  Future<void> _fetchUpdatedUser() async {
    try {
      await Provider.of<AuthViewModel>(context, listen: false)
          .fetchUserDetails();
    } catch (e) {
      _showAlert(
        context,
        title: 'Error',
        message: 'No se pudo actualizar la información del usuario.',
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  Future<void> _refreshProfile(BuildContext context) async {
    try {
      await _fetchUpdatedUser();
    } catch (e) {
      _showAlert(
        context,
        title: 'Error',
        message: 'Error al refrescar el perfil: $e',
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthViewModel>(context).user;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo azul detrás del contenido
          Container(
            height: 350,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 113, 191, 254),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          RefreshIndicator(
            onRefresh: () => _refreshProfile(context),
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Center(
                  child: Text(
                    'Mi perfil',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            user?.image != null && user!.image!.isNotEmpty
                                ? MemoryImage(base64Decode(user.image!))
                                : AssetImage('assets/images/default_avatar.png')
                                    as ImageProvider,
                        backgroundColor: Colors.grey[200],
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileEdit()),
                            );
                            _fetchUpdatedUser();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 20,
                            child: const Icon(
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
                  utf8.decode(user?.email?.runes.toList() ??
                      'Correo no disponible'
                          .runes
                          .toList()), // Decodificar email
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "¡Hola ${utf8.decode(user?.name?.runes.toList() ?? 'Usuario'.runes.toList())}!",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildProfileOption(
                        context,
                        'Mis Pedidos',
                        OrdersScreen(),
                        Icons.shopping_bag,
                        Colors.green,
                      ),
                      _buildProfileOption(
                        context,
                        'Mis Direcciones',
                        DirectionView(),
                        Icons.location_on,
                        Colors.red,
                      ),
                      _buildProfileOption(
                        context,
                        'Acerca de Nosotros',
                        AcercaScreen(),
                        Icons.info,
                        Colors.blue,
                      ),
                      _buildProfileOption(
                        context,
                        'Ayuda',
                        AyudaScreen(),
                        Icons.help,
                        Colors.orange,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await Provider.of<AuthViewModel>(context,
                                  listen: false)
                              .logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (route) => false,
                          );
                        } catch (e) {
                          _showAlert(
                            context,
                            title: 'Error',
                            message: 'No se pudo cerrar sesión.',
                            icon: Icons.error,
                            iconColor: Colors.red,
                          );
                        }
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
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, String title, Widget screen,
      IconData icon, Color iconColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        title: Text(
          utf8.decode(title.runes.toList()), // Decodificar título
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }

  void _showAlert(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Row(
            children: [
              Icon(icon, color: iconColor, size: 30),
              const SizedBox(width: 10),
              Text(utf8.decode(title.runes.toList())), // Decodificar título
            ],
          ),
          content: Text(
            utf8.decode(message.runes.toList()), // Decodificar mensaje
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Aceptar',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
