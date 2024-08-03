import 'package:smartsplit/models/item.dart';

class ReceiptWithTotal {
  final String receiptName;
  late final double totalPrice;
  final List<Item> items;

  ReceiptWithTotal({
    required this.receiptName,
    required this.totalPrice,
    required this.items,
  });

  factory ReceiptWithTotal.fromJson(Map<String, dynamic> json) {
    List<Item> items = (json['items'] as List<dynamic>?)
            ?.map((itemJson) => Item.fromJson(itemJson))
            .where((item) => item.deletedAt == null)
            .toList() ??
        [];

    double totalPrice = items.fold(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );

    return ReceiptWithTotal(
      receiptName: json['receipt']['receiptName'] ?? 'Unknown',
      totalPrice: totalPrice,
      items: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receiptName': receiptName,
      'totalPrice': totalPrice,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
