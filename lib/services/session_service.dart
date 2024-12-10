import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart'; // Librería para decodificar el token
import '../models/session.dart';
import 'package:crochetify_movil/services/user_service.dart';

class AuthService {
  static const _tokenKey = 'user_token';
  final UserService _userService = UserService();
  Future<Session?> login(String email, String password) async {
  final url = Uri.parse('http://54.146.53.211:8087/api/crochetify/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Respuesta del servidor: $data'); // Debugging

    if (data['success'] == true && data['response'] != null) {
      final token = data['response']['token'] as String?;
      if (token != null && token.isNotEmpty) {
        // Decodificar el token para obtener el userId
        final decodedToken = JwtDecoder.decode(token);
        final userId =
            decodedToken['idUser']; // Suponiendo que el id está en el token
        final response = await _userService.fetchUserById(userId);
        if (response['user']['status']) {
          final session = Session(token: token, userId: userId);
          await _saveToken(token);
          return session;
        } else {
          print('El usuario está deshabilitado.');
          throw Exception('El usuario está deshabilitado. Contacta soporte.');
        }
      } else {
        throw Exception('Token vacío o nulo en la respuesta del servidor');
      }
    } else {
      throw Exception('Error en la respuesta del servidor');
    }
  } else if (response.statusCode == 401) {
    // Manejo del error 401 (Credenciales inválidas)
    final data = jsonDecode(response.body);
    final message = data['message'] ?? 'Credenciales inválidas.';
    throw Exception(message); // Lanza una excepción con el mensaje del servidor
  } else {
    throw Exception(
        'Error al conectar con el servidor: ${response.statusCode}');
  }
}


  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
