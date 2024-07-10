import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReceiptProvider with ChangeNotifier {
  final String _baseUrl = 'http://localhost:5001/api';

  Future<void> createReceipt(Map<String, dynamic> receiptData) async {
    final url = Uri.parse('$_baseUrl/receipt');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(receiptData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create receipt');
    }

    notifyListeners();
  }
}
