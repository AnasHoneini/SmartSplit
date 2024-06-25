// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final String _baseUrl = 'http://10.0.2.2:5001/api';
  User? _user;

  User? get user => _user;

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
        notifyListeners();

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
    final url = Uri.parse('$_baseUrl/users/$email');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _user = User.fromJson(responseData);
        notifyListeners();

        Navigator.pushReplacementNamed(context, '/main');
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
