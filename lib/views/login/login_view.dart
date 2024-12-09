import 'package:crochetify_movil/views/login/register_view.dart';
import 'package:flutter/material.dart';
import 'package:crochetify_movil/widget/navigation/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';
import 'package:crochetify_movil/services/session_service.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false; // Variable para controlar la visibilidad de la contraseña

  final AuthService _authService = AuthService();

void _login() async {
  setState(() {
    _isLoading = true;
  });

  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    _showAlert(
      title: 'Campos Vacíos',
      message: 'Por favor, completa todos los campos.',
      icon: Icons.warning,
      iconColor: Colors.orange,
    );
    setState(() {
      _isLoading = false;
    });
    return;
  }

  try {
    // Llama al método login del AuthViewModel
    await Provider.of<AuthViewModel>(context, listen: false)
        .login(email, password);

    // Redirige al HomeScreen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (route) => false, // Elimina todas las rutas anteriores
    );
  } catch (error) {
    _showAlert(
      title: 'Error de Inicio de Sesión',
      message: 'Usuario o contraseña incorrectos. Por favor, verifica tus datos.',
      icon: Icons.error,
      iconColor: Colors.red,
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

void _showAlert({
  required String title,
  required String message,
  required IconData icon,
  required Color iconColor,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Row(
          children: [
            Icon(icon, color: iconColor, size: 30),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el diálogo
            },
            child: const Text(
              'Aceptar',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/CrochetifyLogobyDesigner.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Bienvenido!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Cambiar el icono según la visibilidad
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible; // Alternar visibilidad
                            });
                          },
                        ),
                      ),
                      obscureText: !_isPasswordVisible, // Mostrar u ocultar contraseña
                    ),
                    const SizedBox(height: 16),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              'Entrar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿Aún no tienes cuenta?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterView(),
                                ));
                          },
                          child: const Text('Regístrate ahora'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
