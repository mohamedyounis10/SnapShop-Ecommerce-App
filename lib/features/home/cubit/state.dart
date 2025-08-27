import '../../../models/product.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Product> products;
  final String selectedCategory;
  final List<String> categories;
  final String? searchQuery;
  final bool isSearchMode;
  final int currentPage;

  HomeLoaded({
    required this.products,
    required this.selectedCategory,
    required this.categories,
    this.searchQuery,
    this.isSearchMode = false,
    this.currentPage = 0,
  });

  HomeLoaded copyWith({
    List<Product>? products,
    String? selectedCategory,
    List<String>? categories,
    String? searchQuery,
    bool? isSearchMode,
  }) {
    return HomeLoaded(
      products: products ?? this.products,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearchMode: isSearchMode ?? this.isSearchMode,
    );
  }
}
class CategoriesLoaded extends HomeState {
  final List<String> categories;

  CategoriesLoaded({required this.categories});
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

class HomeImageChanged extends HomeState {}

class UserOrderCleared extends HomeState {}
