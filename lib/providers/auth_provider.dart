import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;

  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/api/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['access'];
        _isLoggedIn = true;
        notifyListeners();
      } else {
        _isLoggedIn = false;
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      _isLoggedIn = false;
      rethrow;
    }
  }

  Future<void> signUp(String username, String password) async {
    try {
      final url = Uri.parse('http://10.0.2.2:8000/api/signup/');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'username': username, 'password': password});
      debugPrint('Signup request url: \\${url.toString()}');
      debugPrint('Signup request headers: \\${headers.toString()}');
      debugPrint('Signup request body: \\${body.toString()}');
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      debugPrint('Signup response status: \\${response.statusCode}');
      debugPrint('Signup response body: \\${response.body}');
      if (response.statusCode == 201) {
        _isLoggedIn = true; // Signup success, but user should login separately
        notifyListeners();
      } else {
        throw Exception('Signup failed: Status \\${response.statusCode}, Body: \\${response.body}');
      }
    } catch (e) {
      debugPrint('Signup error: \\${e.toString()}');
      rethrow;
    }
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
