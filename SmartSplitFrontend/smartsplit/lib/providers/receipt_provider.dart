import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsplit/providers/auth_provider.dart';
import 'package:smartsplit/screens/receipts_screen.dart';
import 'package:smartsplit/utils/jwt_utils.dart';
import '../main.dart';

class ReceiptProvider with ChangeNotifier {
  final String _baseUrl = 'http://10.0.2.2:5001/api';

  Future<void> _addAuthHeaders(http.Request request) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (isTokenExpired(token)) {
      await Provider.of<AuthProvider>(navigatorKey.currentContext!,
              listen: false)
          .logout();
      return;
    }
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
  }

  Future<void> createReceipt(Map<String, dynamic> receiptData) async {
    final url = Uri.parse('$_baseUrl/receipt');
    final request = http.Request('POST', url)..body = json.encode(receiptData);
    await _addAuthHeaders(request);

    try {
      final response = await request.send();
      if (response.statusCode != 201) {
        throw Exception('Failed to create receipt');
      }

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create receipt: $e');
    }
  }

  Future<List<ReceiptWithTotal>> fetchUserReceipts() async {
    final url = Uri.parse('$_baseUrl/user/receipts');
    final request = http.Request('GET', url);
    await _addAuthHeaders(request);

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> receiptList =
            json.decode(await response.stream.bytesToString());
        return receiptList
            .map((json) => ReceiptWithTotal.fromJson(json))
            .toList();
      } else {
        final errorMessage =
            json.decode(await response.stream.bytesToString())['message'];
        throw Exception('Failed to load receipts: $errorMessage');
      }
    } catch (e) {
      throw Exception('Failed to load receipts: $e');
    }
  }
}
