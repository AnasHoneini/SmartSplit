import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../main.dart';

class AuthProvider with ChangeNotifier {
  final String _baseUrl = 'http://10.0.2.2:5001/api';
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  Future<void> signUp(BuildContext context, String firstName, String lastName,
      String email, String password, String? profilePictureUrl) async {
    final url = Uri.parse('$_baseUrl/users');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'profilePicture': profilePictureUrl ?? '',
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        _user = User.fromJson(responseData['user']);
        _token = responseData['token'];
        notifyListeners();

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', _token!);

        Navigator.pushReplacementNamed(context, '/login');
      } else {
        throw Exception('Failed to sign up: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _user = User.fromJson(responseData['user']);
        _token = responseData['token'];
        notifyListeners();

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', _token!);

        Navigator.pushReplacementNamed(context, '/main');
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');

    navigatorKey.currentState!.pushReplacementNamed('/login');
  }
}
