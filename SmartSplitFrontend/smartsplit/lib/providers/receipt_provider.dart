import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/receipt.dart';

class ReceiptProvider with ChangeNotifier {
  final String _baseUrl = 'http://10.0.2.2:5001/api';
  List<Receipt> _receipts = [];

  List<Receipt> get receipts => _receipts;

  Future<void> fetchReceipts() async {
    final url = Uri.parse('$_baseUrl/receipt');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> receiptList = json.decode(response.body);
        _receipts = receiptList.map((json) => Receipt.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load receipts');
      }
    } catch (e) {
      throw Exception('Failed to load receipts: $e');
    }
  }
}
