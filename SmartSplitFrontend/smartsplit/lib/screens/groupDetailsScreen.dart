import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import '../models/group.dart';
import '../providers/group_provider.dart';
import 'receipt_details_screen.dart';

class GroupDetailsScreen extends StatefulWidget {
  final Group group;

  const GroupDetailsScreen({required this.group, super.key});

  @override
  _GroupDetailsScreenState createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _fetchGroupDetails();
  }

  Future<void> _fetchGroupDetails() async {
    final groupsProvider = Provider.of<GroupsProvider>(context, listen: false);
    await groupsProvider.fetchGroupMembers(widget.group.groupName);
    await groupsProvider.fetchGroupReceipts(widget.group.groupName);
    setState(() {});
  }

  void _showAddMemberDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddMemberDialog(group: widget.group);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupsProvider = Provider.of<GroupsProvider>(context);
    final receipts = groupsProvider.getGroupReceipts(widget.group.groupName);
    final members = groupsProvider.getMembers(widget.group.groupName);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.groupName),
        backgroundColor: Colors.blue.shade800,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.group.groupName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.group.description,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Members',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.blue.shade800),
                    onPressed: _showAddMemberDialog,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: members.length,
                  itemBuilder: (ctx, index) {
                    final member = members[index];
                    return ListTile(
                      title: Text(
                        member,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Receipts',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: receipts.length,
                  itemBuilder: (ctx, index) {
                    final receipt = receipts[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading:
                            Icon(Icons.receipt, color: Colors.blue.shade800),
                        title: Text(
                          receipt.receiptName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        subtitle: Text(
                          receipt.restaurantName,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class AddMemberDialog extends StatefulWidget {
  final Group group;

  const AddMemberDialog({required this.group, Key? key}) : super(key: key);

  @override
  _AddMemberDialogState createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _memberEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _emailError;

  Future<void> _addMember() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _memberEmailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Email is required';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _emailError = null;
    });

    final groupsProvider = Provider.of<GroupsProvider>(context, listen: false);
    final addMemberData = {
      'groupName': widget.group.groupName,
      'userEmail': email,
    };

    try {
      await groupsProvider.addMemberToGroup(addMemberData);
      await groupsProvider.fetchGroupMembers(widget.group.groupName);
      _memberEmailController.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member added successfully!')),
      );
    } catch (error) {
      setState(() {
        _emailError = 'Failed to add member: Email does not exist';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupsProvider = Provider.of<GroupsProvider>(context);

    return AlertDialog(
      title: Text('Add Member'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TypeAheadFormField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _memberEmailController,
                decoration: InputDecoration(
                  labelText: 'Add Member by Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              suggestionsCallback: (pattern) async {
                final creatorEmail = widget.group.createdBy;
                return await groupsProvider.fetchAllEmails(
                    pattern, creatorEmail);
              },
              itemBuilder: (context, String suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (String suggestion) {
                setState(() {
                  _emailError = null;
                  _memberEmailController.text = suggestion;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Email is required';
                }
                if (_emailError != null) {
                  return _emailError;
                }
                return null;
              },
            ),
            if (_emailError != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  _emailError!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        _isLoading
            ? CircularProgressIndicator()
            : TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
        _isLoading
            ? SizedBox()
            : ElevatedButton(
                onPressed: _addMember,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Add'),
              ),
      ],
    );
  }

  @override
  void dispose() {
    _memberEmailController.dispose();
    super.dispose();
  }
}
