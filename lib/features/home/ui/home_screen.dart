import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:snapshop/features/home/cubit/logic.dart';
import 'package:snapshop/features/home/ui/search_screen.dart';
import '../../../core/app_color.dart';
import '../cubit/state.dart';
import '../widgets/product_card.dart';
import '../widgets/random_product.dart';
import '../widgets/rounded_tag.dart';
import 'product_screen.dart';

class HomeScreen extends StatelessWidget {
  final pageController = PageController();
  final String? selectedCategoryFromCategoryScreen;
  HomeScreen({this.selectedCategoryFromCategoryScreen, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    TextEditingController text = TextEditingController();

    if (selectedCategoryFromCategoryScreen != null) {
      cubit.changeCategory(selectedCategoryFromCategoryScreen!);
    }

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColor.error,
              duration: Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Retry',
                textColor: AppColor.white,
                onPressed: () => cubit.loadProducts(),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        // All Products
        final products = cubit.products;
        final categories = cubit.categories;

        // Selected
        final selectedCategory = (state is HomeLoaded) ? state.selectedCategory : 'All';

        // Get 3 random products
        final randomProducts = [...products]..shuffle();
        final displayProducts = randomProducts.take(3).toList();

         return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10.h),

                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Image
                        Image.asset('assets/images/Logo (1).png', scale: 0.85),

                        // Search
                      IconButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => SearchScreen()),
                            );
                          }, icon: Icon(Icons.search,size: 30.w,color: AppColor.black,)),

                      ],
                    ),
                    SizedBox(height: 10.h,),

                    // Random Products
                    if (displayProducts.isNotEmpty)
                      Column(
                        children: [
                          SizedBox(
                            height: 180.h,
                            child: PageView.builder(
                              controller: pageController,
                              itemCount: displayProducts.length,
                              itemBuilder: (context, index) {
                                final product = displayProducts[index];
                                return RandomProductCard(
                                  product: product,
                                  cubit: HomeCubit(),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // Smooth Page Indicator
                          SmoothPageIndicator(
                            controller: pageController,
                            count: displayProducts.length,
                            effect: ExpandingDotsEffect(
                              dotHeight: 8.h,
                              dotWidth: 8.w,
                              activeDotColor: AppColor.color_text,
                              dotColor: AppColor.color_text2.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 10.h),

                    // Categories
                    SizedBox(
                      height: 40.h,
                      child: categories.isEmpty
                          ? Center(child: CircularProgressIndicator(color: AppColor.color_text))
                          : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: RoundedTag(
                              text: category,
                              isSelected: category == selectedCategory,
                              onTap: () => cubit.changeCategory(category),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Products Grid
                    if (state is HomeLoading)
                      Center(child: CircularProgressIndicator(color: AppColor.color_text))
                    else if (products.isEmpty)
                      Center(
                        child: Text('No products available', style: TextStyle(fontSize: 16.sp)),
                      )
                    else
                      GridView.builder(
                        itemCount: products.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 1.7 / 2.7,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(
                            imagePath: product.images.isNotEmpty
                                ? product.images[0]
                                : 'assets/images/Image (5).png',
                            title: product.title,
                            subtitle: "\$${product.price.toStringAsFixed(2)}",
                            isFavorite: cubit.isFavorite(product),
                            onFavoriteToggle: () => cubit.toggleFavorite(product),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailsPage(product: product),
                                ),
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
      },
    );
  }
}
