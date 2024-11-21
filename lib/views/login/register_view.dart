import 'package:flutter/material.dart';
import 'package:crochetify_movil/services/register_service.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegisterService _registerService = RegisterService();

  bool _isLoading = false;

  void _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _registerService.registerUser(name, email, password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario registrado exitosamente')),
      );

      // Redirige a la pantalla de inicio de sesión o home después del registro
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar usuario: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Regístrate!',
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Crea una cuenta para continuar',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: Colors.black45),
                ),
              ),
              const SizedBox(height: 32.0),
              _buildTextField('Nombre', 'Juan', _nameController),
              const SizedBox(height: 16.0),
              _buildTextField(
                  'Correo Electrónico', 'micorreo@gmail.com', _emailController),
              const SizedBox(height: 16.0),
              _buildPasswordField(
                  'Ingresa tu contraseña', 'Contraseña', _passwordController),
              const SizedBox(height: 16.0),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _register,
                      child: const Text(
                        'Registrarme',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String placeholder, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w100)),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: placeholder,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
      String label, String placeholder, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w100)),
        TextField(
          obscureText: true,
          controller: controller,
          decoration: InputDecoration(
            hintText: placeholder,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
