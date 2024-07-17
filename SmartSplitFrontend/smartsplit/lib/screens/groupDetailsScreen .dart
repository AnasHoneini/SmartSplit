import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/group.dart';
import '../models/receipt.dart';
import '../providers/group_provider.dart';
import 'receipt_details_screen.dart';

class GroupDetailsScreen extends StatefulWidget {
  final Group group;

  const GroupDetailsScreen({required this.group, super.key});

  @override
  _GroupDetailsScreenState createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  final _memberEmailController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchGroupDetails();
  }

  Future<void> _fetchGroupDetails() async {
    final groupsProvider = Provider.of<GroupsProvider>(context, listen: false);
    await groupsProvider.fetchGroupMembers(widget.group.groupName);
    await groupsProvider.fetchGroupReceipts(widget.group.groupName);
  }

  Future<void> _addMember() async {
    final email = _memberEmailController.text.trim();
    if (email.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final groupsProvider = Provider.of<GroupsProvider>(context, listen: false);
    final addMemberData = {
      'groupName': widget.group.groupName,
      'userEmail': email,
    };

    try {
      await groupsProvider.addMemberToGroup(addMemberData);
      _memberEmailController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member added successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupsProvider = Provider.of<GroupsProvider>(context);
    final receipts = groupsProvider.getGroupReceipts(widget.group.groupName);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.groupName),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.group.groupName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(widget.group.description),
            const SizedBox(height: 20),
            const Text(
              'Members:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount:
                    groupsProvider.getMembers(widget.group.groupName).length,
                itemBuilder: (ctx, index) {
                  final member =
                      groupsProvider.getMembers(widget.group.groupName)[index];
                  return ListTile(
                    title: Text(member),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Receipts:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: receipts.length,
                itemBuilder: (ctx, index) {
                  final receipt = receipts[index];
                  return Card(
                    child: ListTile(
                      title: Text(receipt.receiptName),
                      subtitle: Text(receipt.restaurantName),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReceiptDetailsScreen(
                                receipt: receipt, group: widget.group),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _memberEmailController,
              decoration: InputDecoration(
                labelText: 'Add Member by Email',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addMember,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _addMember,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Add Member'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _memberEmailController.dispose();
    super.dispose();
  }
}