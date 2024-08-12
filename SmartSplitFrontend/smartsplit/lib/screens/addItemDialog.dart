import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/group.dart';
import '../models/receipt.dart';
import '../providers/item_provider.dart';
import '../providers/group_provider.dart';

class AddItemDialog extends StatefulWidget {
  final Receipt receipt;
  final Group group;

  const AddItemDialog({
    required this.receipt,
    required this.group,
    Key? key,
  }) : super(key: key);

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _itemNameController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _itemQuantityController = TextEditingController();
  String? _selectedMember;
  bool _isLoading = false;
  bool _isShared = false;
  List<String> _sharedWith = [];

  @override
  void initState() {
    super.initState();
    _populateMemberList();
  }

  void _populateMemberList() {
    final groupsProvider = Provider.of<GroupsProvider>(context, listen: false);
    final members = groupsProvider.getMembers(widget.group.groupName);
    if (!members.contains(widget.group.createdBy)) {
      members.add(widget.group.createdBy);
    }
  }

  Future<void> _addItem() async {
    final name = _itemNameController.text.trim();
    final price = double.tryParse(_itemPriceController.text.trim());
    final quantity = int.tryParse(_itemQuantityController.text.trim());
    final userEmail = _selectedMember;

    if (name.isEmpty ||
        price == null ||
        quantity == null ||
        userEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final itemProvider = Provider.of<ItemProvider>(context, listen: false);
    final itemData = {
      'name': name,
      'price': price,
      'quantity': quantity,
      'userEmail': userEmail,
      'receiptName': widget.receipt.receiptName,
      'shared': _isShared,
      'sharedWith': _sharedWith,
    };

    try {
      await itemProvider.addItemToReceipt(itemData);
      _itemNameController.clear();
      _itemPriceController.clear();
      _itemQuantityController.clear();
      setState(() {
        _isShared = false;
        _sharedWith = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added successfully!')),
      );
      Navigator.pop(context);
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
    final members = groupsProvider.getMembers(widget.group.groupName);
    if (!members.contains(widget.group.createdBy)) {
      members.add(widget.group.createdBy);
    }

    return AlertDialog(
      title: const Text('Add Item'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _itemNameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _itemPriceController,
              decoration: InputDecoration(
                labelText: 'Item Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _itemQuantityController,
              decoration: InputDecoration(
                labelText: 'Item Quantity',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedMember,
              decoration: InputDecoration(
                labelText: 'Assign to Member',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: members.map((member) {
                return DropdownMenuItem(
                  value: member,
                  child: Text(member),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMember = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _isShared,
                  onChanged: (bool? value) {
                    setState(() {
                      _isShared = value ?? false;
                    });
                  },
                ),
                const Text('Shared'),
              ],
            ),
            if (_isShared)
              Column(
                children: [
                  const Text(
                    'Share with:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ...members
                      .where((member) => member != _selectedMember)
                      .map((member) {
                    return CheckboxListTile(
                      title: Text(member),
                      value: _sharedWith.contains(member),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _sharedWith.add(member);
                          } else {
                            _sharedWith.remove(member);
                          }
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
          ],
        ),
      ),
      actions: [
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
        _isLoading
            ? const SizedBox()
            : ElevatedButton(
                onPressed: _addItem,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Add Item'),
              ),
      ],
    );
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemPriceController.dispose();
    _itemQuantityController.dispose();
    super.dispose();
  }
}
