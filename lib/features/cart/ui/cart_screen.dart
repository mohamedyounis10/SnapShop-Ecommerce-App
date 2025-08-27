import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapshop/features/cart/cubit/logic.dart';
import 'package:snapshop/features/cart/cubit/state.dart';
import 'package:snapshop/features/cart/ui/checkout_screen.dart';
import '../../../core/app_color.dart';
import 'package:snapshop/core/custom_button.dart';
import 'package:snapshop/features/cart/widget/circle_icon_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state is UserOrderStockLimitReached) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Cannot add more than ${state.stock} items of ${state.product.title}'),
              backgroundColor: AppColor.error,
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<CartCubit>();
        final userOrder = cubit.userOrder;

        if (userOrder.isEmpty) {
          return Center(
            child: Text(
              "Your cart is empty",
              style: TextStyle(fontSize: 18.sp),
            ),
          );
        }

        double totalPrice = userOrder.fold(0, (sum, product) {
          int qty = cubit.productQuantities[product.id] ?? 1;
          return sum + product.price * qty;
        });

        return Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: userOrder.length,
                  itemBuilder: (context, index) {
                    final product = userOrder[index];
                    return Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Container(
                        height: 170.h,
                        decoration: BoxDecoration(
                          color: AppColor.back_ground1,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10.w),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: product.images.isNotEmpty
                                  ? Image.network(
                                product.images[0],
                                width: 92.w,
                                height: 144.h,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/Image (5).png',
                                    width: 92.w,
                                    height: 144.h,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                                  : Image.asset(
                                'assets/images/Image (5).png',
                                width: 92.w,
                                height: 144.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: AppColor.amber, size: 16.sp),
                                      SizedBox(width: 4.w),
                                      Text(
                                        "${product.rating.toStringAsFixed(1)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.sp),
                                      ),
                                      Text(
                                        "(Reviews N/A)",
                                        style: TextStyle(
                                            color: AppColor.grey, fontSize: 12.sp),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: [
                                      CircleIconButton(
                                        icon: Icons.remove,
                                        onPressed: () {
                                          cubit.decreaseQuantity(product);
                                        },
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        "${cubit.productQuantities[product.id] ?? 1}",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      CircleIconButton(
                                        icon: Icons.add,
                                        onPressed: () {
                                          cubit.increaseQuantity(product);
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    "\$${(product.price * (cubit.productQuantities[product.id] ?? 1)).toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () {
                                  cubit.removeFromUserOrder(product);
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: AppColor.color_text,
                                  size: 25.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Price :',
                    style: TextStyle(
                      color: AppColor.color_text2,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "\$${totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: AppColor.color_text,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              CustomButton(
                width: 343.w,
                text: 'Preview Order',
                onPressed: () {
                  cubit.previewOrder();
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>CheckoutScreen()));
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }
}
