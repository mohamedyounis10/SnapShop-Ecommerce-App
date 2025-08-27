import 'product.dart';

class AppUser {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? addresses;          // <-- Make it String instead of List<String>
  final List<Product> favorites;   // Fixed and clear
  final List<Product> cart;        // cart also products
  final List<dynamic>? orders;     // Keep this dynamic temporarily

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.addresses,
    this.favorites = const [],
    this.cart = const [],
    this.orders,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'addresses': addresses,       // <-- String here
      'favorites': favorites.map((p) => p.toJson()).toList(),
      'cart': cart.map((p) => p.toJson()).toList(),
      'orders': orders,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'],
      addresses: json['addresses'] as String?,   // <-- String here
      favorites: (json['favorites'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e))
          .toList() ?? [],
      cart: (json['cart'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e))
          .toList() ?? [],
      orders: json['orders'] as List<dynamic>? ?? [],
    );
  }
}
