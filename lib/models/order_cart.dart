import 'package:snapshop/models/product.dart';

class OrderedProduct {
  final Product product;
  final int quantity;
  final double totalPrice;

  OrderedProduct({
    required this.product,
    required this.quantity,
    required this.totalPrice,
  });

  factory OrderedProduct.fromJson(Map<String, dynamic> json) {
    return OrderedProduct(
      product: Product.fromJson(json),
      quantity: json['quantity'] ?? 1,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final productJson = product.toJson();
    return {
      ...productJson,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }
}
