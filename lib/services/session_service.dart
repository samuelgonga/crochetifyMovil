import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart'; // Librería para decodificar el token
import '../models/session.dart';

class AuthService {
  static const _tokenKey = 'user_token';

  Future<Session?> login(String email, String password) async {
    final url = Uri.parse('http://192.168.111.125:8080/api/crochetify/login');
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
          final userId = decodedToken['idUser']; // Suponiendo que el id está en el token

          // Crear la sesión con el userId extraído del token
          final session = Session(token: token, userId: userId);
          await _saveToken(token);
          return session;
        } else {
          throw Exception('Token vacío o nulo en la respuesta del servidor');
        }
      } else {
        throw Exception('Error en la respuesta del servidor');
      }
    } else {
      throw Exception('Error al conectar con el servidor: ${response.statusCode}');
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
