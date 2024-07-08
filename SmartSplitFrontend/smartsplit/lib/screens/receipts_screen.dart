import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/receipt_provider.dart';

class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  _ReceiptsScreenState createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  late Future<void> _receiptsFuture;

  @override
  void initState() {
    super.initState();
    _receiptsFuture =
        Provider.of<ReceiptProvider>(context, listen: false).fetchReceipts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipts'),
      ),
      body: FutureBuilder(
        future: _receiptsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<ReceiptProvider>(
              builder: (ctx, receiptProvider, child) {
                return ListView.builder(
                  itemCount: receiptProvider.receipts.length,
                  itemBuilder: (ctx, index) {
                    final receipt = receiptProvider.receipts[index];
                    return ListTile(
                      leading: const Icon(Icons.receipt),
                      title: Text(receipt.restaurantName),
                      subtitle: Text('Date: ${receipt.createdAt.toLocal()}'),
                      onTap: () {
                        // TODO: View receipt details
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
