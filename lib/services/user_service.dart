import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:crochetify_movil/models/user.dart';

class UserService {
  Future<User> fetchUser() async {
    try {
      // Cargar el archivo JSON desde assets
      final response = await rootBundle.loadString('assets/user.json');
      final Map<String, dynamic> data = jsonDecode(response);
      print(data);
      // Convertir el JSON en una instancia de User
      return User.fromJson(data);
    } catch (e) {
      print("Algo salió mal: $e");
      throw Exception("Failed to load user data");
    }
  }
}
