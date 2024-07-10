class Receipt {
  final String id;
  final String restaurantName;
  final String receiptName;
  final DateTime createdAt;
  Receipt({
    required this.id,
    required this.restaurantName,
    required this.receiptName,
    required this.createdAt,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['_id'],
      restaurantName: json['restaurantName'],
      receiptName: json['receiptName'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
