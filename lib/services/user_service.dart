import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:crochetify_movil/models/user.dart';
import 'package:crochetify_movil/models/direction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserService {
  static const _tokenKey = 'user_token';

  final String baseUrl = 'http://100.27.71.83:8087/api/crochetify';

  Future<User?> getLoggedUser() async {
    final token = await getToken();

    if (token == null) {
      print('Token no disponible. Inicia sesión primero.');
      return null;
    }

    if (JwtDecoder.isExpired(token)) {
      print('El token ha expirado. Inicia sesión nuevamente.');
      return null;
    }

    final decodedToken = JwtDecoder.decode(token);
    final userId =
        decodedToken['idUser']; // Cambia 'idUser' si tu token usa otra clave

    if (userId == null) {
      print('No se encontró "idUser" en el token decodificado.');
      return null;
    }

    final url = Uri.parse('$baseUrl/users/$userId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Respuesta del servidor: $data');

        if (data['success'] == true && data['response'] != null) {
          // Pasar directamente el objeto 'user' al modelo
          final user = User.fromJson(data['response']);
          print('Usuario obtenido: ${user.name}');
          return user;
        } else {
          print('Error: Respuesta del servidor no contiene datos válidos.');
          return null;
        }
      } else {
        print('Error al conectar con el servidor: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error durante la solicitud HTTP: $e');
      return null;
    }
  }

  Future<bool> setDefaultDirection(int userId, int directionId) async {
    final url = Uri.parse('$baseUrl/set-default');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'directionId': directionId,
        }),
      );

      if (response.statusCode == 200) {
        return true; // Operación exitosa
      } else {
        print(
            'Error al marcar la dirección como predeterminada: ${response.body}');
        return false; // Operación fallida
      }
    } catch (e) {
      print('Error en la solicitud al servidor: $e');
      return false; // Error al conectar con el servidor
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

  // Actualizar perfil del usuario (nombre e imagen en base64)
  Future<bool> updateProfile({
    required String name,
    String? imageBase64,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token =
        prefs.getString('token'); // Obtener el token desde SharedPreferences

    if (token == null) {
      print('Token no disponible');
      return false;
    }

    // Verificar si el token ha expirado
    if (JwtDecoder.isExpired(token)) {
      print('El token ha expirado');
      return false;
    }

    // Decodificar el token para obtener el ID del usuario
    final decodedToken = JwtDecoder.decode(token);
    final userId =
        decodedToken['id']; // Cambia 'id' según la estructura de tu token

    final url =
        Uri.parse('$baseUrl/users/$userId'); // URL para actualizar usuario

    final body = {
      'name': name,
      if (imageBase64 != null)
        'image': imageBase64, // Incluye la imagen si no es nula
    };

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Token en el encabezado
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Perfil actualizado correctamente');
        return true;
      } else {
        print('Error al actualizar perfil: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
      return false;
    }
  }

  // Métodos adicionales: addDirection, fetchDirectionsByUserId, updateProfile...
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    print('Token guardado en SharedPreferences.');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    print('Token recuperado: $token');
    return token;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    print('Token eliminado. Usuario desconectado.');
  }

  // Agregar una nueva dirección
  Future<Direction?> addDirection(Direction direction) async {
    final url = Uri.parse('$baseUrl/directions');
    final token = await getToken(); // Obtener el token desde SharedPreferences

    if (token == null) {
      print('Token no disponible. Inicia sesión primero.');
      return null;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Incluir el token en los headers
        },
        body: jsonEncode({
          'direction': direction.direction,
          'phone': direction.phone,
          'userId': direction.userId,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['response'] != null) {
          // Crear la dirección desde la respuesta
          return Direction.fromJson(data['response']);
        } else {
          print('Error en la respuesta del servidor: ${data['message']}');
          return null;
        }
      } else {
        print('Error al agregar la dirección: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error durante la solicitud HTTP: $e');
      return null;
    }
  }

  // Actualizar el perfil del usuario (nombre e imagen en base64)
  Future<bool> updateUserProfile({
    required String name,
    File? imageFile, // Imagen seleccionada como un archivo
  }) async {
    final token = await getToken(); // Obtener el token desde SharedPreferences

    if (token == null) {
      print('Token no disponible. Inicia sesión primero.');
      return false;
    }

    // Verificar si el token ha expirado
    if (JwtDecoder.isExpired(token)) {
      print('El token ha expirado. Inicia sesión nuevamente.');
      return false;
    }

    // Decodificar el token para obtener el ID del usuario
    final decodedToken = JwtDecoder.decode(token);
    final userId = decodedToken[
        'idUser']; // Cambia 'idUser' según la estructura de tu token

    if (userId == null) {
      print('No se encontró "idUser" en el token decodificado.');
      return false;
    }

    final url =
        Uri.parse('$baseUrl/users/$userId'); // URL para actualizar usuario

    String? imageBase64;
    if (imageFile != null) {
      try {
        final bytes =
            await imageFile.readAsBytes(); // Leer los bytes del archivo
        imageBase64 = base64Encode(bytes); // Convertir a Base64
      } catch (e) {
        print('Error al convertir la imagen a Base64: $e');
        return false;
      }
    }

    // Construir el cuerpo de la solicitud
    final body = {
      'name': name,
      if (imageBase64 != null)
        'image': imageBase64, // Incluir la imagen si no es nula
    };

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Token en el encabezado
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Perfil actualizado correctamente');
        return true;
      } else {
        print('Error al actualizar el perfil: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error durante la solicitud HTTP: $e');
      return false;
    }
  }

  // Método para obtener el usuario por ID
  Future<Map<String, dynamic>> fetchUserById(int userId) async {
    final url = Uri.parse(
        '$baseUrl/users/$userId'); // Suponiendo que la API tiene un endpoint similar

    try {
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['response'] != null) {
          // Si la respuesta es exitosa, devolver el usuario
          return data['response'];
        } else {
          throw Exception('No se pudo obtener el usuario');
        }
      } else {
        throw Exception(
            'Error al conectar con el servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener el usuario: $e');
    }
  }
}
