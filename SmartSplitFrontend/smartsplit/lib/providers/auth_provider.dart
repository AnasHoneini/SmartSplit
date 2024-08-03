import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsplit/utils/jwt_utils.dart';
import '../models/user.dart';
import '../main.dart';

class AuthProvider with ChangeNotifier {
  final String _baseUrl = 'http://10.0.2.2:5001/api';
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;
  Future<bool> signUp(
      String firstName, String lastName, String email, String password) async {
    final url = Uri.parse('$_baseUrl/users');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to sign up: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<bool> login(String email, String password) async {
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
        await prefs.setString('token', _token!);

        return true;
      } else {
        return false;
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
    await prefs.remove('token');

    navigatorKey.currentState!.pushReplacementNamed(
      '/login',
      arguments: {'logoutMessage': 'Logout successful!'},
    );
  }

  Future<void> logoutUserDueToExpiredToken() async {
    _user = null;
    _token = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    navigatorKey.currentState!.pushReplacementNamed(
      '/login',
      arguments: {
        'logoutMessage': 'Your session has expired. Please log in again.'
      },
    );
  }

  Future<void> _addAuthHeaders(http.Request request) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (isTokenExpired(token)) {
      await logoutUserDueToExpiredToken();
      throw Exception('Token is expired');
    }

    request.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
  }

  Future<void> updateUser({
    String? firstName,
    String? lastName,
    required String email,
    String? password,
  }) async {
    final url = Uri.parse('$_baseUrl/$email');
    final request = http.Request('PUT', url);
    await _addAuthHeaders(request);

    final Map<String, dynamic> updatedData = {};
    if (firstName != null && firstName.isNotEmpty)
      updatedData['firstName'] = firstName;
    if (lastName != null && lastName.isNotEmpty)
      updatedData['lastName'] = lastName;
    if (password != null && password.isNotEmpty)
      updatedData['password'] = password;

    request.body = json.encode(updatedData);

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final responseData = json.decode(responseBody);
        _user = User.fromJson(responseData);
        notifyListeners();
      } else {
        final errorMessage =
            json.decode(responseBody)['message'] ?? 'Unknown error occurred';
        throw Exception('Failed to update user: $errorMessage');
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }
}
