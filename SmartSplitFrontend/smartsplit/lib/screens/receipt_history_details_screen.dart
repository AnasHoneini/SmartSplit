import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartsplit/models/receiptWithTotal.dart';
import '../models/item.dart';
import '../providers/item_provider.dart';
import '../providers/receipt_provider.dart';

class ReceiptHistoryDetailsScreen extends StatefulWidget {
  final ReceiptWithTotal receipt;

  const ReceiptHistoryDetailsScreen({required this.receipt, Key? key})
      : super(key: key);

  @override
  _ReceiptHistoryDetailsScreenState createState() =>
      _ReceiptHistoryDetailsScreenState();
}

class _ReceiptHistoryDetailsScreenState
    extends State<ReceiptHistoryDetailsScreen> {
  bool _isLoading = true;
  late Map<String, List<Item>> _userItems;
  late Map<String, double> _userTotalPrices;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final itemProvider = Provider.of<ItemProvider>(context, listen: false);
    await itemProvider.fetchReceiptItems(widget.receipt.receiptName);
    _groupItemsByUser(itemProvider.items);
    setState(() {
      _isLoading = false;
    });
  }

  void _groupItemsByUser(List<Item> items) {
    _userItems = {};
    _userTotalPrices = {};
    for (var item in items) {
      if (item.deletedAt == null) {
        if (!_userItems.containsKey(item.userEmail)) {
          _userItems[item.userEmail] = [];
          _userTotalPrices[item.userEmail] = 0.0;
        }
        _userItems[item.userEmail]!.add(item);
        _userTotalPrices[item.userEmail] =
            (_userTotalPrices[item.userEmail]! + (item.price * item.quantity));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receipt.receiptName),
        backgroundColor: Colors.blue.shade800,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Members',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _userItems.keys.length,
                      itemBuilder: (ctx, index) {
                        final userEmail = _userItems.keys.elementAt(index);
                        final userItems = _userItems[userEmail]!;
                        final userTotalPrice = _userTotalPrices[userEmail]!;
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ExpansionTile(
                            title: Text(
                              userEmail,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            subtitle: Text(
                              'Total Price: \$${userTotalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            children: userItems.map((item) {
                              return ListTile(
                                title: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              color: Colors.grey.shade600),
                                          children: [
                                            TextSpan(
                                              text: 'Price: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text:
                                                  '\$${item.price.toStringAsFixed(2)}',
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              color: Colors.grey.shade600),
                                          children: [
                                            TextSpan(
                                              text: 'Quantity: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: '${item.quantity}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Consumer<ReceiptProvider>(
                    builder: (context, receiptProvider, child) {
                      final updatedReceipt = receiptProvider.receipts
                          .firstWhere(
                              (receipt) =>
                                  receipt.receiptName ==
                                  widget.receipt.receiptName,
                              orElse: () => widget.receipt);
                      return Text(
                        'Total Price: \$${updatedReceipt.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
