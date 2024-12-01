import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crochetify_movil/models/user.dart';
import 'package:crochetify_movil/models/direction.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserService {
  final String baseUrl = 'http://35.153.187.92:8087/api/crochetify';
  String? token;

  // Obtener el usuario
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

  // Agregar una nueva dirección
  Future<Direction?> addDirection(Direction direction) async {
    final url = Uri.parse(
        '$baseUrl/directions'); // Endpoint para agregar una nueva dirección
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
      return Direction.fromJson(data); // Devolver la dirección recién creada
    } else {
      throw Exception('Error al agregar la dirección: ${response.statusCode}');
    }
  }

  // Realizar el login y obtener el token
  Future<void> login(String username, String password) async {
    final url = 'http://35.153.187.92:8087/api/crochetify/login';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      token = data['token']; // Aquí asignas el token que obtuviste del servidor
      print('Token obtenido: $token');

      // Guardamos el token en SharedPreferences
      await saveToken(token!);
    } else {
      print('Error al obtener el token');
    }
  }

  // Obtener direcciones por ID de usuario
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
            idDirection: value['idDirection'] ?? 0,
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

  // Guardar el token en SharedPreferences

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('Token guardado: $token'); // Verifica si se guarda correctamente
  }

  // Obtener el token desde SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token recuperado: $token');
    return token;
  }

  // Future<void> updateUserWithImage(int userId, String name) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     final imageFile = File(pickedFile.path);
  //     String? base64Image = await compressImage(
  //         imageFile); // Comprimir la imagen y convertirla a base64

  //     if (base64Image != null) {
  //       // Llamar al método de actualización con la imagen convertida a base64
  //       final success = await updateUser(
  //           userId: userId,
  //           name: name,
  //           imageBase64:
  //               base64Image // Pasa la imagen comprimida y convertida a base64
  //           );

  //       if (success) {
  //         print('Usuario actualizado correctamente');
  //       } else {
  //         print('Error al actualizar el usuario');
  //       }
  //     } else {
  //       print('No se pudo comprimir la imagen');
  //     }
  //   } else {
  //     print('No se seleccionó ninguna imagen');
  //   }
  // }

  Future<bool> updateUser({
    required int userId,
    required String name,
    String? imageBase64,
  }) async {
    final url =
        Uri.parse('http://35.153.187.92:8087/api/crochetify/users/$userId');

    // Obtener el token desde SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token =
        prefs.getString('token'); // Obtener el token de SharedPreferences

    if (token == null) {
      print('Token no disponible');
      return false;
    }

    // Verificar si el token ha expirado
    if (JwtDecoder.isExpired(token)) {
      print('El token ha expirado');
      return false; // El token ha expirado, no realizar la solicitud
    }

    // Cuerpo de la solicitud
    final Map<String, dynamic> body = {
      'idUser': userId,
      'name': name,
      if (imageBase64 != null)
        'image': imageBase64, // Si la imagen no es nula, se incluye
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Usamos el token en las cabeceras
    };

    try {
      // Enviar la solicitud PUT
      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        print('Usuario actualizado con éxito');
        return true;
      } else {
        print('Error al actualizar usuario: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
      return false;
    }
  }
}
