class Receipt {
  final String id;
  final String restaurantName;
  final DateTime updatedAt;
  final DateTime createdAt;

  Receipt({
    required this.id,
    required this.restaurantName,
    required this.updatedAt,
    required this.createdAt,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['_id'],
      restaurantName: json['restaurantName'],
      updatedAt: DateTime.parse(json['updatedAt']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
