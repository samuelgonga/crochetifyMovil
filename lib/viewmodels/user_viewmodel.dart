import 'package:flutter/material.dart';
import 'package:crochetify_movil/models/user.dart';
import 'package:crochetify_movil/models/direction.dart';
import 'package:crochetify_movil/services/user_service.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  User? _user;
  List<Direction> _directions = [];

  User? get user => _user;
  List<Direction> get directions => _directions;

  Future<void> fetchUser() async {
    try {
      _user = await _userService.fetchUser();
      notifyListeners();
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> fetchDirectionsByUserId(int userId) async {
    try {
      _directions = await _userService.fetchDirectionsByUserId(userId);
      notifyListeners();
    } catch (e) {
      print("Error fetching directions: $e");
    }
  }

  Future<void> addDirection(Direction direction) async {
  try {
    final newDirection = await _userService.addDirection(direction);
    if (newDirection != null) {
      _directions.add(newDirection);  // Agregar la dirección creada
      notifyListeners();
    }
  } catch (e) {
    print("Error adding direction: $e");
  }
}

}
