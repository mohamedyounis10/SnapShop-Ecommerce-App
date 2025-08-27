import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_color.dart';

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final bool isFavorite;
  final Color cardColor;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onTap; // Add onTap callback

  const ProductCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.isFavorite = false,
    this.cardColor = AppColor.back_ground1,
    this.onFavoriteToggle,
    this.onTap, // Add onTap parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Add gesture detector
      child: Container(
        width: 180.w,
        height: 250.h,
        child: Card(
          color: AppColor.back_ground1,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: imagePath.startsWith('http')
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/Image (5).png',
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 100.h,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.color_text.withOpacity(0.7),
                        AppColor.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),

              // Favorite icon
              Positioned(
                top: 10.h,
                right: 10.w,
                child: GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.color_text.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(6.w),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: AppColor.back_ground1,
                        size: 15.sp,
                      ),
                    ),
                  ),
                ),
              ),

              // Texts
              Positioned(
                bottom: 12.h,
                left: 12.w,
                right: 12.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColor.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
