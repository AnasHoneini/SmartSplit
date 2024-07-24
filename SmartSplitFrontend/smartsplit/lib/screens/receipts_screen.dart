import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/receipt_provider.dart';

class ReceiptsScreen extends StatelessWidget {
  const ReceiptsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final receiptProvider = Provider.of<ReceiptProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Receipts Price'),
      ),
      body: FutureBuilder(
        future: receiptProvider.fetchUserReceipts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final receipts = snapshot.data as List<ReceiptWithTotal>;

            return ListView.builder(
              itemCount: receipts.length,
              itemBuilder: (context, index) {
                final receipt = receipts[index];
                return ListTile(
                  title: Text(receipt.receiptName),
                  subtitle:
                      Text('Total: \$${receipt.totalPrice.toStringAsFixed(2)}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ReceiptWithTotal {
  final String receiptName;
  final double totalPrice;

  ReceiptWithTotal({required this.receiptName, required this.totalPrice});

  factory ReceiptWithTotal.fromJson(Map<String, dynamic> json) {
    return ReceiptWithTotal(
      receiptName: json['receipt']['receiptName'],
      totalPrice: (json['totalPrice'] is int)
          ? (json['totalPrice'] as int).toDouble()
          : json['totalPrice'],
    );
  }
}
