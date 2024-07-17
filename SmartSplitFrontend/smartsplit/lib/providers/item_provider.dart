import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsplit/providers/auth_provider.dart';
import 'package:smartsplit/utils/jwt_utils.dart';
import '../models/item.dart';
import '../main.dart'; // Import navigatorKey

class ItemProvider with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items => _items;

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

  Future<void> fetchReceiptItems(String receiptName) async {
    final url =
        Uri.parse('http://10.0.2.2:5001/api/items/receipt/$receiptName');
    final request = http.Request('GET', url);
    await _addAuthHeaders(request);

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> itemList =
            json.decode(await response.stream.bytesToString());
        _items = itemList.map((json) => Item.fromJson(json)).toList();
        notifyListeners();
      } else {
        final errorMessage =
            json.decode(await response.stream.bytesToString())['message'];
        throw Exception('Failed to load items: $errorMessage');
      }
    } catch (e) {
      throw Exception('Failed to load items: $e');
    }
  }

  Future<void> addItemToReceipt(Map<String, dynamic> itemData) async {
    final url = Uri.parse('http://10.0.2.2:5001/api/items');
    final request = http.Request('POST', url)..body = json.encode(itemData);
    await _addAuthHeaders(request);

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        final responseData = json.decode(await response.stream.bytesToString());
        final newItem = Item.fromJson(responseData['item']);
        _items.add(newItem);
        notifyListeners();
      } else {
        final errorMessage =
            json.decode(await response.stream.bytesToString())['message'];
        throw Exception('Failed to add item: $errorMessage');
      }
    } catch (e) {
      throw Exception('Failed to add item: $e');
    }
  }
}
