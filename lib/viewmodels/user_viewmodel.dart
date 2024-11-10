import 'package:flutter/material.dart';
import 'package:crochetify_movil/models/user.dart';
import 'package:crochetify_movil/services/user_service.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  User? _user;

  User? get user => _user;

  Future<void> fetchUser() async {
    try {
      _user = await _userService.fetchUser();
      notifyListeners();
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
}
