import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapshop/core/app_color.dart';
import 'package:snapshop/features/cart/cubit/logic.dart';
import 'package:snapshop/features/cart/cubit/state.dart';
import 'package:snapshop/features/home/ui/product_screen.dart';
import '../widgets/custom_textform.dart';
import '../widgets/dialog.dart';
import '../widgets/rounded_tag.dart';
import '../widgets/search_card.dart';
import '../cubit/logic.dart';
import '../cubit/state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final TextEditingController textController = TextEditingController();

    return MultiBlocListener(
      listeners: [
        // Listener for HomeCubit
        BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is HomeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        // Listener for CartCubit
        BlocListener<CartCubit, CartState>(
          listener: (context, state) {
            if (state is UserOrderAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item Added in Cart'),
                  backgroundColor: AppColor.success,
                ),
              );
            } else if (state is UserOrderAlreadyAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item already in Cart'),
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final categories = cubit.categories;
          final products = cubit.products;
          final selectedCategory = cubit.selectedCategory;
          final isLoading = state is HomeLoading;

          return Scaffold(
            backgroundColor: AppColor.back_ground1,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColor.back_ground1,
              elevation: 0,
              title: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColor.color_text),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: CustomSearchField(
                      controller: textController,
                      hintText: "Search",
                      onChanged: (value) {
                        if (value.isEmpty) {
                          cubit.selectedCategory = 'All';
                          cubit.loadProducts();
                        } else {
                          cubit.searchProducts(value);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune, color: AppColor.color_text),
                    onPressed: () async {
                      final result = await showFilterDialog(
                        context,
                        categories: cubit.categories,
                      );
                      if (result != null) {
                        cubit.filterLocalProducts(
                          category: result['category'],
                          minPrice: (result['minPrice'] as num?)?.toDouble(),
                          maxPrice: (result['maxPrice'] as num?)?.toDouble(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  // Tags
                  SizedBox(
                    height: 40.h,
                    child: categories.isEmpty
                        ? Center(child: CircularProgressIndicator(color: AppColor.color_text))
                        : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      itemCount: categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: RoundedTag(
                              text: 'All',
                              isSelected: selectedCategory == 'All',
                              onTap: () => cubit.loadProducts(),
                            ),
                          );
                        } else {
                          final category = categories[index - 1];
                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: RoundedTag(
                              text: category,
                              isSelected: selectedCategory == category,
                              onTap: () => cubit.changeCategory(category),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Products
                  Expanded(
                    child: isLoading
                        ? Center(child: CircularProgressIndicator(color: AppColor.color_text))
                        : products.isEmpty
                        ? Center(child: Text('No products found', style: TextStyle(fontSize: 16.sp)))
                        : GridView.builder(
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.70,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailsPage(product: product),
                              ),
                            );
                          },
                          child: SearchCard(
                            image: product.images.isNotEmpty ? product.images[0] : "assets/images/img.png",
                            title: product.title,
                            price: "\$${product.price}",
                            isFavorite: cubit.isFavorite(product),
                            onFavoriteToggle: () => cubit.toggleFavorite(product),
                            onAddToCart: () => context.read<CartCubit>().addToUserOrder(product),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
