import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_cart.dart';

class Orders {
  final String orderId;
  final DateTime orderedAt;
  final List<OrderedProduct> products;
  final double totalOrderPrice;

  Orders({
    required this.orderId,
    required this.orderedAt,
    required this.products,
    required this.totalOrderPrice,
  });

  // These are what you need
  factory Orders.fromJson(Map<String, dynamic> json) {
    // Convert products
    List<OrderedProduct> productList = [];
    if (json['products'] != null && json['products'] is List) {
      productList = (json['products'] as List)
          .map((e) => OrderedProduct.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    // Convert date whether it's Timestamp or String
    DateTime orderedDate;
    if (json['orderedAt'] is Timestamp) {
      orderedDate = (json['orderedAt'] as Timestamp).toDate();
    } else if (json['orderedAt'] is String) {
      orderedDate = DateTime.tryParse(json['orderedAt']) ?? DateTime.now();
    } else {
      orderedDate = DateTime.now();
    }

    return Orders(
      orderId: json['orderId'] ?? '',
      orderedAt: orderedDate,
      products: productList,
      totalOrderPrice: (json['totalOrderPrice'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderedAt': orderedAt.toIso8601String(),
      'products': products.map((p) => p.toJson()).toList(),
      'totalOrderPrice': totalOrderPrice,
    };
  }
}
