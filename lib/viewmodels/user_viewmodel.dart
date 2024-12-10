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

  // Agrega un setter para directions
  set directions(List<Direction> directions) {
    _directions = directions;
    notifyListeners(); // Notifica cambios
  }

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

  Future<void> fetchDirectionsByUserId(int userId) async {
    try {
      print("Cargando direcciones para el usuario $userId...");

      final fetchedDirections =
          await _userService.fetchDirectionsByUserId(userId);

      if (fetchedDirections != null) {
        _directions = fetchedDirections;
        print("Direcciones cargadas exitosamente: $_directions");
      } else {
        _directions = [];
        print("No se encontraron direcciones para el usuario $userId.");
      }
    } catch (e) {
      _directions = [];
      print("Error al cargar direcciones para el usuario $userId: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> addDirection(Direction direction) async {
    try {
      final newDirection = await _userService.addDirection(direction);

      if (newDirection != null) {
        _directions.add(newDirection);
        print("Dirección agregada: ${newDirection.direction}");
        notifyListeners();
      } else {
        print("No se pudo agregar la dirección. Respuesta nula.");
      }
    } catch (e) {
      print("Error al agregar dirección: $e");
    }
  }

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

  Future<void> setDefaultDirection(int userId, int directionId) async {
    try {
      final success = await _userService.setDefaultDirection(userId, directionId);
      if (success) {
        _directions = _directions.map((direction) {
          return direction.copyWith(
            isDefault: direction.idDirection == directionId,
          );
        }).toList();

        print("Estado actualizado de direcciones:");
        _directions.forEach((direction) {
          print("idDirection: ${direction.idDirection}, isDefault: ${direction.isDefault}");
        });

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
