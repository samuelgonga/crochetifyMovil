// viewmodels/auth_viewmodel.dart
import 'package:flutter/material.dart';
//import 'package:crochetify_movil/models/session.dart';
//import 'package:crochetify_movil/services/session_service.dart';

class AuthViewModel extends ChangeNotifier {
  //PRUEBAS
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  // Métodos para iniciar y cerrar sesión de prueba
  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  // Método para verificar si ya hay una sesión activa (para fines de prueba)
  Future<void> checkSession() async {
    // Simulación de verificación de sesión. Aquí podrías revisar un token almacenado en el almacenamiento local.
    await Future.delayed(const Duration(seconds: 1)); // Simula un retardo
    _isLoggedIn =
        false; // Cambia a true si deseas probar como si el usuario ya estuviera logueado
    print("Estado de sesión (isLoggedIn): $_isLoggedIn");

    notifyListeners();
  }

  //
  /*
  final AuthService _authService = AuthService();
  Session? _user;

  Session? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> checkSession() async {
    final token = await _authService.getToken();
    if (token != null) {
      _user = Session(token: token, role: 'USER');
    }
    notifyListeners();
  }
  
  Future<void> login(String email, String password) async {
    _user = await _authService.login(email, password);
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
  */
}
