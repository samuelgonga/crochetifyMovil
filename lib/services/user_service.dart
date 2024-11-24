import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crochetify_movil/models/user.dart';

class UserService {
  final String baseUrl = 'http://192.168.100.5:8080/api/crochetify';

  Future<User> fetchUser() async {
    final url =
        Uri.parse('$baseUrl/users/1'); // Endpoint para obtener un usuario
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Devuelve una instancia de User
      return User.fromJson(data);
    } else {
      throw Exception(
          'Error al obtener los datos del usuario: ${response.statusCode}');
    }
  }
}
