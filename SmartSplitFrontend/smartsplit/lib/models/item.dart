class Item {
  final String name;
  final double price;
  final int quantity;
  final String userEmail;
  final String receiptName;
  DateTime? deletedAt;
  final DateTime updatedAt;

  Item({
    required this.name,
    required this.price,
    required this.quantity,
    required this.userEmail,
    required this.receiptName,
    this.deletedAt,
    required this.updatedAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] ?? 'Unknown',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 1,
      userEmail: json['userEmail'] ?? 'Unknown',
      receiptName: json['receiptName'] ?? 'Unknown',
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'userEmail': userEmail,
      'receiptName': receiptName,
      'deletedAt': deletedAt?.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
