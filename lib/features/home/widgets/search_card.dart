import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapshop/core/app_color.dart';

class SearchCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onAddToCart; // <-- New

  const SearchCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onAddToCart, // <-- New
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card
          Container(
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black12,
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // favorite
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? AppColor.error : AppColor.grey,
                        size: 18.sp,
                      ),
                      onPressed: onFavoriteToggle,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 24.w,
                        minHeight: 24.h,
                      ),
                    ),
                  ),

                  // Image
                  SizedBox(
                    height: 90.h,
                    child: Image.network(
                      image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/Image (5).png',
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 6.h),

                  // Title - product
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 3.h),

                  // price
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),

          // Button
          Positioned(
            bottom: -18.h,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: onAddToCart,
                child: Container(
                  width: 40.w,
                  height: 40.h,
                                            decoration: const BoxDecoration(
                            color: AppColor.black,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            color: AppColor.white,
                            size: 20.sp,
                          ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


