import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/receipt.dart';
import '../providers/auth_provider.dart';
import '../providers/receipt_provider.dart';
import '../providers/group_provider.dart';

class CreateReceiptScreen extends StatefulWidget {
  const CreateReceiptScreen({super.key});

  @override
  CreateReceiptScreenState createState() => CreateReceiptScreenState();
}

class CreateReceiptScreenState extends State<CreateReceiptScreen> {
  final _restaurantNameController = TextEditingController();
  final _receiptNameController = TextEditingController();
  String? _selectedGroup;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    final groupsProvider = Provider.of<GroupsProvider>(context, listen: false);
    try {
      await groupsProvider.fetchGroups();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching groups: $error')),
      );
    }
  }

  Future<void> _createReceipt() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final receiptProvider =
        Provider.of<ReceiptProvider>(context, listen: false);
    final user = authProvider.user;

    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    if (_selectedGroup == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a group')),
      );
      return;
    }

    final receiptData = {
      'restaurantName': _restaurantNameController.text,
      'receiptName': _receiptNameController.text,
      'groupName': _selectedGroup!,
    };

    setState(() {
      _isLoading = true;
    });

    try {
      await receiptProvider.createReceipt(receiptData);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receipt created successfully!')),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupsProvider = Provider.of<GroupsProvider>(context);
    final groups = groupsProvider.groups;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Receipt'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create a New Receipt',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _restaurantNameController,
              decoration: InputDecoration(
                labelText: 'Restaurant Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _receiptNameController,
              decoration: InputDecoration(
                labelText: 'Receipt Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedGroup,
              decoration: InputDecoration(
                labelText: 'Select Group',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: groups.map((group) {
                return DropdownMenuItem<String>(
                  value: group.groupName,
                  child: Text(group.groupName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGroup = value;
                });
              },
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _createReceipt,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Create Receipt'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _receiptNameController.dispose();
    super.dispose();
  }
}
