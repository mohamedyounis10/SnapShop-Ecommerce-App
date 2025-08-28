import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshop/features/home/cubit/state.dart';
import '../../../api/api_service.dart';
import '../../../db/firebase.dart';
import '../../../models/product.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {
    loadProducts();
  }
  final FirebaseService services = FirebaseService();

  int selectedIndex = 0; // change images
  String selectedCategory = "All";

  // Public Lists
  List<Product> allProducts = [];
  List<Product> products = [];
  List<String> categories = [];
  List<Product> favorites = [];

  Future<void> loadProducts() async {
    emit(HomeLoading());
    try {
      if (selectedCategory == "All") {
        allProducts = await ApiService.getAllProducts();
      } else {
        allProducts = await ApiService.getProductsByCategory(selectedCategory);
      }
      products = List.from(allProducts);
      categories = await ApiService.getAllCategories();
      emit(HomeLoaded(
        products: products,
        selectedCategory: selectedCategory,
        categories: categories,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> loadFavorites() async {
    try {
      final userId = services.getCurrentUserId();
      
      if (userId != null) {
        favorites = await services.getFavorites(userId: userId);
        emit(HomeLoaded(
          products: products,
          selectedCategory: selectedCategory,
          categories: categories,
        ));
      }
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  Future<void> changeCategory(String category) async {
    selectedCategory = category;
    emit(HomeLoading());

    try {
      products = await ApiService.getProductsByCategory(category);

      emit(HomeLoaded(
        products: products,
        selectedCategory: selectedCategory,
        categories: categories,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      await loadProducts();
      return;
    }

    emit(HomeLoading());
    try {
      products = await ApiService.searchProducts(query);

      emit(HomeLoaded(
        products: products,
        selectedCategory: 'search',
        categories: categories,
        searchQuery: query,
        isSearchMode: true,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> toggleFavorite(Product product) async {
    final userId = services.getCurrentUserId();
    
    if (userId == null) {
      print('User not logged in - cannot toggle favorite');
      return;
    }

    try {
      if (favorites.any((fav) => fav.id == product.id)) {
        // Remove from favorites
        favorites.removeWhere((fav) => fav.id == product.id);
        await services.removeFavorite(
          userId: userId,
          product: product,
        );
      } else {
        // Add to favorites
        favorites.add(product);
        await services.addFavorite(
          userId: userId,
          product: product,
        );
      }

      emit(HomeLoaded(
        products: products,
        selectedCategory: selectedCategory,
        categories: categories,
      ));
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  bool isFavorite(Product product) {
    return favorites.any((fav) => fav.id == product.id);
  }

  void setSelectedImage(int index) {
    selectedIndex = index;
    emit(HomeImageChanged());
  }

  void filterLocalProducts({String? category, double? minPrice, double? maxPrice}) {
    List<Product> filtered = allProducts.where((product) {
      final inCategory = (category == null || category == 'All' || product.category == category);
      final inPrice = (minPrice == null || product.price >= minPrice) && (maxPrice == null || product.price <= maxPrice);
      return inCategory && inPrice;
    }).toList();
    products = filtered;
    selectedCategory = category ?? 'All';
    emit(HomeLoaded(
      products: products,
      selectedCategory: selectedCategory,
      categories: categories,
    ));
  }

  void changePage(int index) {
    selectedIndex = index;
    emit(HomeLoaded(
      products: products,
      selectedCategory: selectedCategory,
      categories: categories,
      currentPage: index,
    ));
  }
}
