import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/group.dart';
import '../models/receipt.dart';
import '../providers/group_provider.dart';
import '../providers/item_provider.dart';

class ReceiptDetailsScreen extends StatefulWidget {
  final Receipt receipt;
  final Group group;

  const ReceiptDetailsScreen(
      {required this.receipt, required this.group, super.key});

  @override
  _ReceiptDetailsScreenState createState() => _ReceiptDetailsScreenState();
}

class _ReceiptDetailsScreenState extends State<ReceiptDetailsScreen> {
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
    _fetchReceiptItems();
  }

  Future<void> _fetchReceiptItems() async {
    final itemProvider = Provider.of<ItemProvider>(context, listen: false);
    await itemProvider.fetchReceiptItems(widget.receipt.receiptName);
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
    final itemProvider = Provider.of<ItemProvider>(context);
    final members = groupsProvider.getMembers(widget.group.groupName);
    final items = itemProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receipt.receiptName),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.receipt.receiptName,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Restaurant: ${widget.receipt.restaurantName}'),
              const SizedBox(height: 20),
              const Text(
                'Add Item:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _addItem,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('Add Item'),
                    ),
              const SizedBox(height: 20),
              const Text(
                'Items:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (ctx, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                      'Price: ${item.price.toStringAsFixed(2)}, Quantity: ${item.quantity}, Assigned to: ${item.userEmail}',
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
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
