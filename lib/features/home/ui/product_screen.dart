import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapshop/core/custom_button.dart';
import 'package:snapshop/features/cart/cubit/state.dart';
import 'package:snapshop/features/home/cubit/logic.dart';
import 'package:snapshop/features/home/cubit/state.dart';
import '../../../core/app_color.dart';
import '../../../models/product.dart';
import '../../cart/cubit/logic.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>().setSelectedImage(0);
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state is HomeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error")),
          );
        }
        if (state is UserOrderAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColor.success,
              content: Text('Item Added in Cart'),
            ),
          );
        }
        if (state is UserOrderAlreadyAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Item is Already Added')),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<CartCubit>();
        return Scaffold(
          backgroundColor: AppColor.back_ground1,
          appBar: AppBar(
            title: Text(
              "Product Details",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.color_text,
              ),
            ),
            centerTitle: true,
            surfaceTintColor: AppColor.back_ground1,
            backgroundColor: AppColor.back_ground1,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: AppColor.color_text, size: 22.sp),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              // Product images
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Other Images
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: product.images.asMap().entries.map((entry) {
                      int index = entry.key;
                      String img = entry.value;
                      return GestureDetector(
                        onTap: () => context.read<HomeCubit>().setSelectedImage(index),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                              height: 70.h,
                              width: 60.w,
                              color: AppColor.white,
                              child: img.startsWith('http')
                                  ? Image.network(
                                img,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/Image (5).png',
                                    fit: BoxFit.contain,
                                  );
                                },
                              )
                                  : Image.asset(img, fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(width: 16.w),

                  // Main Image
                  Expanded(
                    child: SizedBox(
                      height: 280.h,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: product.images.isNotEmpty
                              ? (product.images[context.read<HomeCubit>().selectedIndex].startsWith('http')
                              ? Image.network(
                            product.images[context.read<HomeCubit>().selectedIndex],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/Image (5).png',
                                fit: BoxFit.contain,
                              );
                            },
                          )
                              : Image.asset(
                            product.images[context.read<HomeCubit>().selectedIndex],
                            fit: BoxFit.contain,
                          ))
                              : Image.asset(
                            'assets/images/Image (5).png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Category
              Row(
                children: [
                  Text(
                    "Category: ",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.color_text,
                    ),
                  ),
                  Text(
                    product.category,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: AppColor.color_text2,
                    ),
                  ),
                ],
              ),

              // Brand
              Row(
                children: [
                  Text(
                    "Brand: ",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.color_text,
                    ),
                  ),
                  Text(
                    product.brand,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: AppColor.color_text2,
                    ),
                  ),
                ],
              ),

              // Product title
              Text(
                product.title,
                style: TextStyle(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.color_text,
                ),
              ),
              SizedBox(height: 8.h),

              // Price
              Text(
                "\$${product.price.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.color_text,
                ),
              ),
              SizedBox(height: 10.h),

              // Stock
              Row(
                children: [
                  Text(
                    "Stock: ",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.color_text,
                    ),
                  ),
                  Text(
                    "${product.stock}",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.color_text2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // Rating
              Row(
                children: [
                  Text(
                    "Rating: ",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.color_text,
                    ),
                  ),
                  Text(
                    "${product.rating}",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.color_text2,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.star,
                    color: AppColor.amber,
                    size: 20.sp,
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // Description
              Text(
                product.description,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColor.color_text2,
                ),
              ),
              SizedBox(height: 20.h),

              // Add to cart button
              CustomButton(
                text: 'Add to Cart',
                onPressed: () {
                  cubit.addToUserOrder(product);
                  print(cubit.userOrder.length);
                },
              )
            ],
          ),
        );
      },
    );
  }
}
