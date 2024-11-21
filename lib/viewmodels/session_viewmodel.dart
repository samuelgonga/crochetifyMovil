import 'package:crochetify_movil/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;
  Session? _session;

  bool get isLoggedIn => _isLoggedIn;
  Session? get session => _session;

  // Verifica si ya hay una sesión activa
  Future<void> checkSession() async {
    final token = await _authService.getToken();
    _isLoggedIn = token != null;
    if (_isLoggedIn) {
      _session = Session(token: token!);
    }
    notifyListeners();
  }

  // Maneja el inicio de sesión
  Future<void> login(String email, String password) async {
    _session = await _authService.login(email, password);
    if (_session != null) {
      _isLoggedIn = true;
    }
    notifyListeners();
  }

  // Maneja el cierre de sesión
  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    _session = null;
    notifyListeners();
  }
}
