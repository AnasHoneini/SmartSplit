import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/group.dart';
import '../models/receipt.dart';

class GroupsProvider with ChangeNotifier {
  List<Group> _groups = [];
  final Map<String, List<Receipt>> _groupReceipts =
      {}; // Ensure it's a Map<String, List<Receipt>>

  final Map<String, List<String>> _groupMembers = {};

  List<Group> get groups => _groups;
  List<Receipt> getGroupReceipts(String groupName) =>
      _groupReceipts[groupName] ?? [];

  Future<void> fetchGroupsName(String userEmail) async {
    final url = Uri.parse('http://10.0.2.2:5001/api/group/user/$userEmail');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> groupList = json.decode(response.body);
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
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> groupList = json.decode(response.body);
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
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(groupData),
      );
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
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
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(addMemberData),
      );
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
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> membersList = json.decode(response.body);
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
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
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
