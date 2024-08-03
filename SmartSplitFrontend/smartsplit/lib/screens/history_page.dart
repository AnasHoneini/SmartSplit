import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartsplit/models/receiptWithTotal.dart';
import 'package:smartsplit/screens/receipt_history_details_screen.dart';
import '../providers/receipt_provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/main');
        break;
      case 1:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final receiptProvider = Provider.of<ReceiptProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Receipt History'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: FutureBuilder(
        future: receiptProvider.fetchUserReceipts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final receipts = snapshot.data as List<ReceiptWithTotal>;
            if (receipts.isEmpty) {
              return Center(child: Text('No receipts found.'));
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Receipts',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: receipts.length,
                      itemBuilder: (context, index) {
                        final receipt = receipts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade800,
                              child: Icon(Icons.receipt, color: Colors.white),
                            ),
                            title: Text(receipt.receiptName,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'Total: \$${receipt.totalPrice.toStringAsFixed(2)}'),
                            trailing: Icon(Icons.arrow_forward_ios,
                                color: Colors.grey),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReceiptHistoryDetailsScreen(
                                          receipt: receipt),
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
            );
          } else {
            return Center(child: Text('No receipts found.'));
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade800,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('Create Group'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/create-group');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.receipt),
                  title: const Text('Create Receipt'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/create-receipt');
                  },
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue.shade800,
      ),
    );
  }
}
