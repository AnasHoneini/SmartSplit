class Item {
  final String id;
  final String name;
  final double price;
  final String userEmail;
  final String receiptName;
  final int quantity;

  Item(
      {required this.id,
      required this.name,
      required this.price,
      required this.userEmail,
      required this.receiptName,
      required this.quantity});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['_id'],
      name: json['name'],
      price: json['price'].toDouble(),
      userEmail: json['userEmail'],
      receiptName: json['receiptName'],
      quantity: json['quantity'],
    );
  }
}
