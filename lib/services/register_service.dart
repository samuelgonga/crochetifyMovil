import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RegisterService {
  static const _tokenKey = 'user_token';
  final String baseUrl = 'http://54.146.53.211:8087/api/crochetify';

Future<void> registerUser(String name, String email, String password) async {
  final url = Uri.parse('$baseUrl/users');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': name,
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    print('Usuario registrado exitosamente: $data');
  } else if (response.statusCode == 400) {
    // Aquí solo lanzas la excepción
    throw Exception('El correo ya está registrado. Usa uno diferente.');
  } else if (response.statusCode == 401) {
    throw Exception('Datos inválidos. Verifica tu información.');
  } else {
    throw Exception(
        'Error al registrar usuario: ${response.statusCode}, ${response.body}');
  }
}


  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
