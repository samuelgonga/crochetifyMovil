import 'package:crochetify_movil/widget/navigation/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:crochetify_movil/services/register_service.dart';
import 'login_view.dart';
import 'package:provider/provider.dart';
import 'package:crochetify_movil/viewmodels/session_viewmodel.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final RegisterService _registerService = RegisterService();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  final List<PasswordRequirement> _passwordRequirements = [
    PasswordRequirement(
      'Mínimo 8 caracteres',
      (password) => password.length >= 8,
    ),
    PasswordRequirement(
      'Al menos una mayúscula',
      (password) => password.contains(RegExp(r'[A-Z]')),
    ),
    PasswordRequirement(
      'Al menos un número',
      (password) => password.contains(RegExp(r'[0-9]')),
    ),
  ];

  void _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      if (name.isEmpty) _nameError = 'Por favor, ingresa tu nombre';
      if (email.isEmpty) _emailError = 'Por favor, ingresa tu correo';
      if (password.isEmpty) _passwordError = 'Por favor, ingresa tu contraseña';
      if (confirmPassword.isEmpty)
        _confirmPasswordError = 'Por favor, confirma tu contraseña';
      setState(() {});
      return;
    }

    if (!_isValidName(name)) {
      _nameError = 'El nombre no debe contener números';
    }

    if (!_isValidEmail(email)) {
      _emailError = 'El correo debe ser de Gmail o Hotmail';
    }

    if (!_isValidPassword(password)) {
      _passwordError = 'La contraseña debe cumplir con los requisitos';
    }

    if (password != confirmPassword) {
      _confirmPasswordError = 'Las contraseñas no coinciden';
    }

    if (_nameError != null ||
        _emailError != null ||
        _passwordError != null ||
        _confirmPasswordError != null) {
      setState(() {});
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _registerService.registerUser(name, email, password);
      await Provider.of<AuthViewModel>(context, listen: false)
          .login(email, password);
      _showSuccessAlert('Usuario registrado exitosamente');
    } catch (error) {
      final errorMessage = error.toString();
      if (errorMessage.contains('El correo ya está registrado')) {
        _showAlert(
            'El correo ya está registrado. Por favor, intenta con otro correo.');
      } else if (errorMessage.contains('Datos inválidos')) {
        _showAlert('Datos inválidos. Verifica tu información.');
      } else {
        _showAlert('Error al registrar usuario: $errorMessage');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isValidName(String name) {
    return !RegExp(r'\d').hasMatch(name);
  }

bool _isValidEmail(String email) {
  // Reglas:
  // 1. Verificar que no empiece o termine con un punto
  if (email.startsWith('.') || email.endsWith('.')) return false;

  // 2. Verificar que no tenga puntos consecutivos
  if (email.contains('..')) return false;

  // 3. Regex para caracteres permitidos
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Validar estructura básica
  if (!emailRegex.hasMatch(email)) return false;

  // Validar caracteres permitidos específicamente
  final localPart = email.split('@')[0];
  final domain = email.split('@')[1];

  // Solo caracteres alfabéticos, numéricos, guiones (-), y guiones bajos (_) en el dominio
  if (!RegExp(r'^[a-zA-Z0-9-._]+$').hasMatch(localPart) ||
      !RegExp(r'^[a-zA-Z0-9.-]+$').hasMatch(domain)) {
    return false;
  }

  return true;
}


  bool _isValidPassword(String password) {
    return _passwordRequirements
        .every((requirement) => requirement.isValid(password));
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8.0),
            Text(
              'Error',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              'Aceptar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8.0),
            Text(
              'Éxito',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra la alerta
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen()), // Navega a la vista de inicio
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              'Aceptar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
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
                  '¡Regístrate!',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Crea una cuenta para continuar',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Colors.black45,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              _buildTextField('Nombre', 'Juan', _nameController, _nameError),
              const SizedBox(height: 16.0),
              _buildTextField('Correo Electrónico', 'micorreo@gmail.com',
                  _emailController, _emailError),
              const SizedBox(height: 16.0),
              _buildPasswordField(
                'Ingresa tu contraseña',
                'Contraseña',
                _passwordController,
                _isPasswordVisible,
                (value) {
                  setState(() {
                    _isPasswordVisible = value;
                  });
                },
                _passwordError,
                _passwordRequirements,
              ),
              const SizedBox(height: 16.0),
              _buildConfirmPasswordField(
                'Confirma tu contraseña',
                'Confirmar Contraseña',
                _confirmPasswordController,
                _isConfirmPasswordVisible,
                (value) {
                  setState(() {
                    _isConfirmPasswordVisible = value;
                  });
                },
                _confirmPasswordError,
              ),
              const SizedBox(height: 16.0),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _register,
                      child: const Text(
                        'Registrarme',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                      ),
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder,
      TextEditingController controller, String? error) {
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
            errorText: error,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String label,
    String placeholder,
    TextEditingController controller,
    bool isVisible,
    Function(bool) onVisibilityChange,
    String? error,
    List<PasswordRequirement> passwordRequirements,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w100)),
        TextField(
          obscureText: !isVisible,
          controller: controller,
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: placeholder,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                onVisibilityChange(!isVisible);
              },
            ),
            errorText: error,
          ),
        ),
        const SizedBox(height: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: passwordRequirements
              .map((requirement) => Row(
                    children: [
                      Icon(
                        requirement.isValid(controller.text)
                            ? Icons.check
                            : Icons.close,
                        color: requirement.isValid(controller.text)
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 8.0),
                      Text(requirement.description),
                    ],
                  ))
              .toList(),
        ),
        const SizedBox(height: 8.0),
        LinearProgressIndicator(
          value: passwordRequirements.fold<double>(
            0.0,
            (value, requirement) =>
                value +
                (requirement.isValid(controller.text) ? 1 : 0) /
                    passwordRequirements.length,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField(
    String label,
    String placeholder,
    TextEditingController controller,
    bool isVisible,
    Function(bool) onVisibilityChange,
    String? error,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w100)),
        TextField(
          obscureText: !isVisible,
          controller: controller,
          decoration: InputDecoration(
            hintText: placeholder,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                onVisibilityChange(!isVisible);
              },
            ),
            errorText: error,
          ),
        ),
        const SizedBox(height: 8.0),
        if (_passwordController.text.isNotEmpty && controller.text.isNotEmpty)
          Row(
            children: [
              Icon(
                _passwordController.text == controller.text
                    ? Icons.check
                    : Icons.close,
                color: _passwordController.text == controller.text
                    ? Colors.green
                    : Colors.red,
              ),
              const SizedBox(width: 8.0),
              const Text('Las contraseñas coinciden'),
            ],
          ),
      ],
    );
  }
}

class PasswordRequirement {
  final String description;
  final bool Function(String) isValid;

  PasswordRequirement(this.description, this.isValid);
}
