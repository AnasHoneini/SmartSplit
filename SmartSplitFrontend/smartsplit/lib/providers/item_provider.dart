import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/item.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items => _items;

  Future<void> fetchReceiptItems(String receiptName) async {
    final url = Uri.parse('http://10.0.2.2:5001/api/items/$receiptName');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> itemList = json.decode(response.body);
        _items = itemList.map((json) => Item.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      throw Exception('Failed to load items: $e');
    }
  }

  Future<void> addItemToReceipt(Map<String, dynamic> itemData) async {
    final url = Uri.parse(
        'http://10.0.2.2:5001/api/items'); // Ensure this matches your backend endpoint
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(itemData),
      );
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final newItem = Item.fromJson(responseData['item']);
        _items.add(newItem);
        notifyListeners();
      } else {
        final errorMessage = json.decode(response.body)['message'];
        throw Exception('Failed to add item: $errorMessage');
      }
    } catch (e) {
      throw Exception('Failed to add item: $e');
    }
  }
}
