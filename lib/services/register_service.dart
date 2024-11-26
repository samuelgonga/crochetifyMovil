import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  static const _tokenKey = 'user_token';
  final String baseUrl = 'http://192.168.111.125:8080/api/crochetify';

  Future<void> registerUser(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/users');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'name': name, 'email': email, 'password': password,}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('Usuario registrado exitosamente: $data');
    } else if (response.statusCode == 400) {
      throw Exception('Datos inválidos. Verifica tu información.');
    } else {
      throw Exception(
          'Error al registrar usuario: ${response.statusCode}, ${response.body}');
    }
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
