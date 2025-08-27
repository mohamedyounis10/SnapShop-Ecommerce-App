import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapshop/features/home/cubit/logic.dart';
import 'package:snapshop/features/home/cubit/state.dart';
import '../../../core/app_color.dart';
import '../widgets/custom_textform.dart';
import 'product_screen.dart';

class WishlistScreen extends StatelessWidget {
  TextEditingController text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        final favorites = cubit.favorites;
        final searchQuery = text.text.toLowerCase();
        
        // Filter favorites based on search query
        final filteredFavorites = searchQuery.isEmpty 
            ? favorites 
            : favorites.where((product) {
                return product.title.toLowerCase().contains(searchQuery) ||
                       product.brand.toLowerCase().contains(searchQuery) ||
                       product.category.toLowerCase().contains(searchQuery);
              }).toList();
        
        return  Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              children: [
                // Search Bar
                CustomSearchField(
                  controller: text,
                  hintText: "Search in wishlist...",
                  onChanged: (value) {
                    // Trigger rebuild by accessing cubit
                    cubit.emit(HomeLoaded(
                      products: cubit.products,
                      selectedCategory: cubit.selectedCategory,
                      categories: cubit.categories,
                    ));
                  },
                ),
                SizedBox(height: 20.h),

                // Search Results Info
                if (searchQuery.isNotEmpty && filteredFavorites.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Row(
                      children: [
                        Icon(Icons.search, size: 16.sp, color: AppColor.grey),
                        SizedBox(width: 8.w),
                        Text(
                          '${filteredFavorites.length} item${filteredFavorites.length == 1 ? '' : 's'} found',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColor.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            text.clear();
                            cubit.emit(HomeLoaded(
                              products: cubit.products,
                              selectedCategory: cubit.selectedCategory,
                              categories: cubit.categories,
                            ));
                          },
                          child: Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColor.color_text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Wishlist Items
                Expanded(
                  child: filteredFavorites.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                searchQuery.isNotEmpty ? Icons.search_off : Icons.favorite_border,
                                size: 64.sp,
                                color: AppColor.grey,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                searchQuery.isNotEmpty ? 'No items found' : 'No favorites yet',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: AppColor.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                searchQuery.isNotEmpty 
                                    ? 'Try different keywords or check spelling'
                                    : 'Add products to your wishlist',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColor.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredFavorites.length,
                          itemBuilder: (context, index) {
                            final product = filteredFavorites[index];
                            return Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Container(
                                height: 100.h,
                                width: 343.w,
                                child: Center(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Product Image
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ProductDetailsPage(product: product),
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12.r),
                                          child: product.images.isNotEmpty
                                              ? Image.network(
                                                  product.images[0],
                                                  width: 80.w,
                                                  height: 80.h,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Image.asset(
                                                      'assets/images/Image (5).png',
                                                      width: 80.w,
                                                      height: 80.h,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                )
                                              : Image.asset(
                                                  'assets/images/Image (5).png',
                                                  width: 80.w,
                                                  height: 80.h,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),

                                      // Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.title,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4.h),
                                            Row(
                                              children: [
                                                Icon(Icons.star,
                                                    color: AppColor.amber, size: 16.sp),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  "${product.rating} ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                                Text(
                                                  "(${product.ratingCount} Reviews)",
                                                  style: TextStyle(
                                                    color: AppColor.grey,
                                                    fontSize: 12.sp,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              "\$${product.price.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Favorite Icon
                                      IconButton(
                                        icon: Icon(
                                          Icons.favorite,
                                          color: AppColor.error,
                                          size: 22.sp,
                                        ),
                                        onPressed: () => cubit.toggleFavorite(product),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          );
      },
    );
  }
}
