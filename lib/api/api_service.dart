import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';

  static Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final slug = category.toLowerCase().replaceAll(" ", "-");
      final encodedCategory = Uri.encodeComponent(slug);

      final response = await http.get(
        Uri.parse('$baseUrl/products/category/$encodedCategory'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['products'] != null) {
          final List<Product> products = (data['products'] as List)
              .map((productJson) {
            try {
              return Product.fromJson(productJson);
            } catch (e) {
              print('Error parsing product: $e');
              return null;
            }
          })
              .where((product) => product != null)
              .cast<Product>()
              .toList();

          return products;
        } else {
          throw Exception("No products found in response");
        }
      } else {
        throw Exception("Failed to load products: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }

  static Future<List<String>> getAllCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/categories'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> categoriesData = jsonDecode(response.body);
        final List<String> categories = categoriesData
            .map((category) => category['name'] as String)
            .toList();
        return categories;
      } else {
        throw Exception("Failed to load categories: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching categories: $e");
    }
  }

  static Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/search?q=$query'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['products'] != null) {
          final List<Product> products = (data['products'] as List)
              .map((productJson) {
            try {
              return Product.fromJson(productJson);
            } catch (e) {
              print('Error parsing product: $e');
              return null;
            }
          })
              .where((product) => product != null)
              .cast<Product>()
              .toList();
          return products;
        } else {
          throw Exception("No products found in search results");
        }
      } else {
        throw Exception("Failed to search products: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error searching products: $e");
    }
  }

  static Future<List<Product>> getAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['products'] != null) {
          final List<Product> products = (data['products'] as List)
              .map((productJson) {
            try {
              return Product.fromJson(productJson);
            } catch (e) {
              print('Error parsing product: $e');
              return null;
            }
          })
              .where((product) => product != null)
              .cast<Product>()
              .toList();
          return products;
        } else {
          throw Exception("No products found in response");
        }
      } else {
        throw Exception("Failed to load products: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching all products: $e");
    }
  }
}
