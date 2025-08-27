class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final int stock;
  final String brand;
  final List<String> images;
  final int ratingCount;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.stock,
    required this.brand,
    required this.images,
    required this.ratingCount,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      double rating = 0.0;
      int ratingCount = 0;
      if (json['rating'] != null) {
        if (json['rating'] is double) {
          rating = json['rating'];
          ratingCount = 0;
        } else if (json['rating'] is Map) {
          rating = (json['rating']['rate'] ?? 0).toDouble();
          ratingCount = json['rating']['count'] ?? 0;
        }
      }
      List<String> images = [];
      if (json['images'] != null && json['images'] is List) {
        images = (json['images'] as List).map((item) => item.toString()).toList();
      }
      return Product(
        id: json['id'],
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        category: json['category']?.toString() ?? '',
        price: (json['price'] ?? 0).toDouble(),
        stock: json['stock'] ?? 0,
        brand: json['brand']?.toString() ?? '',
        images: images,
        ratingCount: ratingCount,
        rating: rating,
      );
    } catch (e) {
      print('Error parsing product: $e');
      return Product(
        id: -1,
        title: 'Error Product',
        description: 'Error parsing product data',
        category: 'unknown',
        price: 0.0,
        stock: 0,
        brand: 'unknown',
        images: [],
        ratingCount: 0,
        rating: 0.0,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'stock': stock,
      'brand': brand,
      'images': images,
      'ratingCount': ratingCount,
      'rating': rating,
    };
  }

}
