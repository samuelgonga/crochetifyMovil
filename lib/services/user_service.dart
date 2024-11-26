import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crochetify_movil/models/user.dart';
import 'package:crochetify_movil/models/direction.dart';

class UserService {
  final String baseUrl = 'http://192.168.0.200:8080/api/crochetify';

  Future<User> fetchUser() async {
    final url =
        Uri.parse('$baseUrl/users/1'); // Endpoint para obtener un usuario
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception(
          'Error al obtener los datos del usuario: ${response.statusCode}');
    }
  }

  Future<Direction?> addDirection(Direction direction) async {
  final url = Uri.parse('$baseUrl/directions'); // Endpoint para agregar una nueva dirección
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'direction': direction.direction,
      'phone': direction.phone,
      'userId': direction.userId
    }),
  );

  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    return Direction.fromJson(data);  // Devolver la dirección recién creada
  } else {
    throw Exception('Error al agregar la dirección: ${response.statusCode}');
  }
}


  Future<List<Direction>> fetchDirectionsByUserId(int userId) async {
    final url = Uri.parse('$baseUrl/directions/$userId');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        final directionsMap = data['response'] as Map<String, dynamic>;
        final directions = directionsMap.values.map((value) {
          return Direction(  
            userId: userId,          
            direction: value['direction'] ??
                '', // Si 'direction' es null, asigna una cadena vacía
            phone: value['phone'] ??
                '', // Si 'phone' es null, asigna una cadena vacía
            idDirection: 0        
          );
        }).toList();

        return directions;
      } else {
        throw Exception('Error: ${data['message']}');
      }
    } else {
      throw Exception(
          'Error al obtener las direcciones: ${response.statusCode}');
    }
  }
}
