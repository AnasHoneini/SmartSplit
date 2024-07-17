import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsplit/providers/auth_provider.dart';
import '../models/group.dart';
import '../models/receipt.dart';
import '../utils/jwt_utils.dart';
import '../main.dart'; // Import navigatorKey

class GroupsProvider with ChangeNotifier {
  List<Group> _groups = [];
  final Map<String, List<Receipt>> _groupReceipts =
      {}; // Ensure it's a Map<String, List<Receipt>>
  final Map<String, List<String>> _groupMembers = {};

  List<Group> get groups => _groups;
  List<Receipt> getGroupReceipts(String groupName) =>
      _groupReceipts[groupName] ?? [];

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

  Future<void> fetchGroupsName(String userEmail) async {
    final url = Uri.parse('http://10.0.2.2:5001/api/group/user/$userEmail');
    final request = http.Request('GET', url);
    await _addAuthHeaders(request);

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> groupList =
            json.decode(await response.stream.bytesToString());
        _groups = groupList.map((json) => Group.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load groups');
      }
    } catch (e) {
      throw Exception('Failed to load groups: $e');
    }
  }

  Future<void> fetchGroups() async {
    final url = Uri.parse('http://10.0.2.2:5001/api/group');
    final request = http.Request('GET', url);
    await _addAuthHeaders(request);

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> groupList =
            json.decode(await response.stream.bytesToString());
        _groups = groupList.map((json) => Group.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load groups');
      }
    } catch (e) {
      throw Exception('Failed to load groups: $e');
    }
  }

  Future<void> createGroup(Map<String, dynamic> groupData) async {
    final url = Uri.parse('http://10.0.2.2:5001/api/group');
    final request = http.Request('POST', url)..body = json.encode(groupData);
    await _addAuthHeaders(request);

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        final responseData = json.decode(await response.stream.bytesToString());
        final group = Group.fromJson(responseData['group']);
        _groups.add(group);
        notifyListeners();
      } else {
        throw Exception('Failed to create group');
      }
    } catch (e) {
      throw Exception('Failed to create group: $e');
    }
  }

  Future<void> addMemberToGroup(Map<String, dynamic> addMemberData) async {
    final url = Uri.parse(
        'http://10.0.2.2:5001/api/group/${addMemberData['groupName']}/addMember');
    final request = http.Request('POST', url)
      ..body = json.encode(addMemberData);
    await _addAuthHeaders(request);

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        if (_groupMembers.containsKey(addMemberData['groupName'])) {
          _groupMembers[addMemberData['groupName']]!
              .add(addMemberData['userEmail']);
        } else {
          _groupMembers[addMemberData['groupName']] = [
            addMemberData['userEmail']
          ];
        }
        notifyListeners();
      } else {
        throw Exception('Failed to add member');
      }
    } catch (e) {
      throw Exception('Failed to add member: $e');
    }
  }

  Future<void> fetchGroupMembers(String groupName) async {
    final url = Uri.parse('http://10.0.2.2:5001/api/group/$groupName/members');
    final request = http.Request('GET', url);
    await _addAuthHeaders(request);

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> membersList =
            json.decode(await response.stream.bytesToString());
        _groupMembers[groupName] =
            membersList.map((json) => json['email'] as String).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load group members');
      }
    } catch (e) {
      throw Exception('Failed to load group members: $e');
    }
  }

  Future<void> fetchGroupReceipts(String groupName) async {
    final encodedGroupName = Uri.encodeComponent(groupName);
    final url =
        Uri.parse('http://10.0.2.2:5001/api/group/$encodedGroupName/receipts');
    final request = http.Request('GET', url);
    await _addAuthHeaders(request);

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final List<dynamic> data =
            json.decode(await response.stream.bytesToString());
        _groupReceipts[groupName] =
            data.map((receipt) => Receipt.fromJson(receipt)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load receipts');
      }
    } catch (e) {
      throw Exception('Failed to load receipts: $e');
    }
  }

  List<String> getMembers(String groupName) {
    return _groupMembers[groupName] ?? [];
  }
}
