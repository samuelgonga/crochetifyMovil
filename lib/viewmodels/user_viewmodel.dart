import 'package:flutter/material.dart';
import 'dart:io';
import 'package:crochetify_movil/models/user.dart';
import 'package:crochetify_movil/models/direction.dart';
import 'package:crochetify_movil/services/user_service.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  User? _user;
  List<Direction> _directions = [];

  User? get user => _user;
  List<Direction> get directions => _directions;

  // Método para obtener la información del usuario logueado usando el token
  Future<void> fetchUser() async {
    try {
      _user = await _userService.getLoggedUser();
      if (_user != null) {
        print("Usuario cargado: ${_user!.name}");
      } else {
        print("No se pudo cargar el usuario.");
      }
      notifyListeners();
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // Método para obtener las direcciones del usuario por su ID
  Future<void> fetchDirectionsByUserId(int userId) async {
    try {
      _directions = await _userService.fetchDirectionsByUserId(userId);
      print("Direcciones cargadas para el usuario $userId: $_directions");
      notifyListeners();
    } catch (e) {
      print("Error fetching directions: $e");
    }
  }

  // Método para agregar una nueva dirección
  Future<void> addDirection(Direction direction) async {
    try {
      final newDirection = await _userService.addDirection(direction);
      if (newDirection != null) {
        _directions.add(newDirection);
        print("Dirección agregada: ${newDirection.direction}");
        notifyListeners();
      } else {
        print("No se pudo agregar la dirección.");
      }
    } catch (e) {
      print("Error adding direction: $e");
    }
  }

  // Método para actualizar el perfil del usuario (nombre e imagen)
  Future<void> updateUserProfile({
    required String name,
    File? imageFile,
  }) async {
    try {
      final success = await _userService.updateUserProfile(
        name: name,
        imageFile: imageFile,
      );

      if (success) {
        print("Perfil actualizado correctamente");
        await fetchUser();
      } else {
        print("No se pudo actualizar el perfil.");
      }
    } catch (e) {
      print("Error updating user profile: $e");
    }
  }

  // Método para marcar una dirección como predeterminada
  Future<void> setDefaultDirection(int userId, int directionId) async {
    try {
      final success =
          await _userService.setDefaultDirection(userId, directionId);
      if (success) {
        _directions = _directions.map((direction) {
          return Direction(
            idDirection: direction.idDirection,
            direction: direction.direction,
            phone: direction.phone,
            userId: direction.userId,
            isDefault: direction.idDirection == directionId,
          );
        }).toList();
        notifyListeners();
        print("Dirección predeterminada actualizada.");
      } else {
        print("No se pudo actualizar la dirección predeterminada.");
      }
    } catch (e) {
      print("Error setting default direction: $e");
    }
  }
}
