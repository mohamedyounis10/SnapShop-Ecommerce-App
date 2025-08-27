import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_color.dart';
import '../../../core/custom_button.dart';
import '../../../models/product.dart';
import '../cubit/logic.dart';
import '../ui/product_screen.dart';


class RandomProductCard extends StatelessWidget {
  final Product product;
  final HomeCubit cubit;

  const RandomProductCard({
    Key? key,
    required this.product,
    required this.cubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.w,
      height: 140.h,
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            AppColor.color_text.withOpacity(0.2),
            AppColor.transparent,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Row(
        children: [
          // Texts
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  // Price
                  Text(
                    '\$${product.price}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColor.color_text,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Button
                  CustomButton(
                    width: 150,
                    height: 35,
                    text: 'View Product',
                    fontSize: 15,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsPage(product: product),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                product.images.isNotEmpty ? product.images[0] : 'https://via.placeholder.com/150',
                width: 100.w,
                height: 120.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/Image (5).png',
                  width: 100.w,
                  height: 120.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
