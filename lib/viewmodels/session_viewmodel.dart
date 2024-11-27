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

  // Verifica si ya hay una sesión activa
  Future<void> checkSession() async {    
    final token = await _authService.getToken();
    _isLoggedIn = token != null;
    if (_isLoggedIn) {
      _session = Session(token: token!, userId: _extractUserId(token));
      await fetchUserDetails(); // Obtiene los detalles del usuario
    }    
    notifyListeners();
  }

  // Extrae el userId del token
  int _extractUserId(String token) {
    final decodedToken = JwtDecoder.decode(token);
    return decodedToken['idUser'];
  }

  // Obtiene los detalles del usuario desde el servidor usando el userId
  Future<void> fetchUserDetails() async {
    if (_session != null) {
      // Decodificar el token y extraer el userId
      final tokenData = JwtDecoder.decode(_session!.token);
      final userId = tokenData['idUser']; // Extraer el userId del token

      // Aquí hacemos una solicitud GET al servidor para obtener los detalles del usuario
      final url =
          Uri.parse('http://18.215.115.34:8087/api/crochetify/users/$userId');
      final response = await http.get(url, headers: {
        //'Authorization': 'Bearer ${_session!.token}', // Usamos el token para autenticación
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(
            'Respuesta del servidor: $data'); // Ver lo que realmente está regresando el servidor

        if (data['success'] == true && data['response'] != null) {
          final userData =
              data['response']['user']; // Acceder a la información del usuario

          _user = User(
            id: userData['idUser'], // Extraemos el idUser de la respuesta
            name: userData['name'] ??
                '', // Si no tiene nombre, asignamos una cadena vacía
            email: userData['email'] ??
                '', // Si no tiene email, asignamos una cadena vacía
            status: userData['status'] ??
                true, // Asignamos un valor por defecto si no existe
            image: userData['image'] ??
                '', // Asignamos una cadena vacía si no tiene imagen
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
