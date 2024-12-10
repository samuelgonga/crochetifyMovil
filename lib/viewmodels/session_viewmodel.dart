import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:crochetify_movil/services/session_service.dart';
import 'package:flutter/material.dart';
import '../models/session.dart';
import 'package:crochetify_movil/models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;
  Session? _session;
  User? _user;

  bool get isLoggedIn => _isLoggedIn;
  Session? get session => _session;
  User? get user => _user;

  Future<void> checkSession() async {
    final token = await _authService.getToken();
    _isLoggedIn = token != null;

    if (_isLoggedIn) {
      if (token != null && JwtDecoder.isExpired(token)) {
        await logout(); // Si el token ha expirado, cerrar sesión
      } else if (token != null) {
        try {
          _session = Session(token: token, userId: _extractUserId(token));
          await fetchUserDetails(); // Obtiene los detalles del usuario
        } catch (e) {
          print("Error al procesar la sesión: $e");
          _isLoggedIn = false; // Marca al usuario como no autenticado
        }
      }
    }
    notifyListeners();
  }

  // Extrae el userId del token
  int _extractUserId(String token) {
    final decodedToken = JwtDecoder.decode(token);
    final userId = decodedToken['idUser'];

    // Verifica si el userId es null o no está presente
    if (userId == null) {
      throw Exception('El userId no está presente en el token.');
    }

    return userId;
  }

  // Obtiene los detalles del usuario desde el servidor usando el userId
  Future<void> fetchUserDetails() async {
    if (_session != null) {
      final tokenData = JwtDecoder.decode(_session!.token);
      final userId = tokenData['idUser']; // Extraer el userId del token

      final url =
          Uri.parse('http://54.146.53.211:8087/api/crochetify/users/$userId');
      final response = await http.get(url, headers: {
        'Authorization':
            'Bearer ${_session!.token}', // Usamos el token para autenticación
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['response'] != null) {
          final userData = data['response']['user'];

          _user = User(
            id: userData['idUser'],
            name: userData['name'] ?? '',
            email: userData['email'] ?? '',
            status: userData['status'] ?? true,
            image: userData['image'] ?? '',
          );
        } else {
          throw Exception(
              'Error al obtener los detalles del usuario: ${data['message']}');
        }
      } else {
        throw Exception('Error al obtener los detalles del usuario');
      }
    }
    notifyListeners();
  }

  // Maneja el inicio de sesión
  Future<void> login(String email, String password) async {
    _session = await _authService.login(email, password);
    if (_session != null) {
      _isLoggedIn = true;
      await fetchUserDetails(); // Obtiene los detalles del usuario tras el login
    }
    notifyListeners();
  }

  // Maneja el cierre de sesión
  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    _session = null;
    _user = null; // Limpia los datos del usuario
    notifyListeners();
  }
}
