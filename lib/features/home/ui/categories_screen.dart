import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_color.dart';
import '../cubit/logic.dart';
import '../ui/home_screen.dart';
import '../cubit/state.dart';
import '../../../models/product.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final categories = cubit.categories;
        final allProducts = cubit.allProducts;

        if (categories.isEmpty) {
          return  Center(
              child: CircularProgressIndicator(color: AppColor.color_text),
          );
        }

        return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final firstProduct = allProducts.firstWhere(
                    (product) =>
                product.category.toLowerCase() ==
                    category.toLowerCase().replaceAll(' ', '-'),
                orElse: () => Product(
                  id: -1,
                  title: '',
                  description: '',
                  category: category,
                  price: 0.0,
                  stock: 0,
                  brand: '',
                  images: ['assets/images/img_2.png'],
                  ratingCount: 0,
                  rating: 0.0,
                ),
              );
              return GestureDetector(
                onTap: () {
                  final cubit = context.read<HomeCubit>();
                  cubit.changeCategory(category);
                  cubit.changePage(0);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.black12,
                        blurRadius: 4.r,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          bottomLeft: Radius.circular(16.r),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 120.w,
                            maxHeight: 100.h,
                          ),
                          child: firstProduct.images.isNotEmpty && firstProduct.images[0].startsWith('http')
                              ? Image.network(
                            firstProduct.images[0],
                            height: 100.h,
                            width: 120.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/img_2.png',
                                width: 120.w,
                                height: 100.h,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                              : Image.asset(
                            'assets/images/img_2.png',
                            width: 120.w,
                            height: 100.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                    ],
                  ),
                ),
              );
            },
        );
      },
    );
  }
}
