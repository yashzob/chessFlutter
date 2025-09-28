import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String username, String password) async {
    // Implement login logic, e.g., API call
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> signUp(String username, String password) async {
    // Implement sign up logic, e.g., API call
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
