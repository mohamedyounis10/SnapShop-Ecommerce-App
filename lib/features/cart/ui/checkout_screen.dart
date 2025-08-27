import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapshop/core/custom_button.dart';
import 'package:snapshop/features/account/cubit/state.dart';
import 'package:snapshop/features/cart/cubit/state.dart';
import 'package:snapshop/features/cart/ui/set_location.dart';
import 'package:snapshop/features/cart/ui/success_order.dart';
import 'package:snapshop/features/cart/widget/payment_option.dart';
import 'package:snapshop/features/home/cubit/logic.dart';
import '../../../core/app_color.dart';
import '../../account/cubit/logic.dart';
import '../cubit/logic.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit,CartState>(
        listener: (context, state) {
          if (state is OrderSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => SuccessOrder()),
            );
          }
        },

        builder: (context,state) {
        final cubit = context.watch<CartCubit>();

        double subtotal = cubit.userOrder.fold(0, (sum, product) {
          final qty = cubit.productQuantities[product.id] ?? 1;
          return sum + (product.price * qty);
        });
        double shipping = 20;
        double total = subtotal + shipping;

        return Scaffold(
          backgroundColor: AppColor.back_ground1,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                  Icons.arrow_back, color: AppColor.color_text, size: 22.sp),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Checkout",
              style: TextStyle(
                color: AppColor.color_text,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
            centerTitle: true,
            surfaceTintColor: AppColor.back_ground1,
            backgroundColor: AppColor.back_ground1,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery Location
                Text(
                  "Delivery Location",
                  style: TextStyle(
                      fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.h),
                BlocConsumer<ProfileCubit,ProfileState>(
                  listener:(context,state){
                    if(state is ChangePage){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SetLocationScreen(),
                        ),
                      );
                    }
                  },
                builder: (context,state){
                  context.read<ProfileCubit>().loadAddress();
                  String addressText = "No Address";

                final user = (state is ProfileLoaded)
                    ? state.user
                    : (state is ProfileUpdated ? state.user : null);

                if (user != null && user.addresses != null && user.addresses!.isNotEmpty) {
                  addressText = user.addresses!;
                }
                return ListTile(
                      leading: CircleAvatar(
                      backgroundColor: AppColor.grey,
                      radius: 22.r,
                      child: Icon(
                          Icons.location_on, color: AppColor.white, size: 20.sp),
                    ),
                  title: Text(addressText,
                      style: TextStyle(fontSize: 14.sp)),
                  trailing: IconButton(onPressed: (){
                    context.read<ProfileCubit>().changePage();
                  }, icon:  Icon(Icons.edit, color: AppColor.grey, size: 20.sp),)
                );
                  },
                ),
                SizedBox(height: 10.h),

                // Products in Order
                Text(
                  "Your Products",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cubit.userOrder.length,
              itemBuilder: (context, index) {
                final product = cubit.userOrder[index];
                final qty = cubit.productQuantities[product.id] ?? 1;
                final totalForItem = product.price * qty;

                return Card(
                  color: AppColor.back_ground1,
                  margin: EdgeInsets.symmetric(vertical: 6.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            product.images[0],
                            width: 60.w,
                            height: 60.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.title,
                                  style: TextStyle(
                                      fontSize: 14.sp, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4.h),
                                                              Text("Qty: $qty   |   Total: \$${totalForItem.toStringAsFixed(2)}",
                                    style: TextStyle(fontSize: 12.sp, color: AppColor.grey700)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: AppColor.black),
                          onPressed: () {
                            cubit.removeFromUserOrder(product);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

               // Payment Method
                Text(
                  "Payment Method",
                  style: TextStyle(
                      fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.h),

                // Cash (always enabled & selected)
                PaymentOption(
                  image: "assets/images/img_3.png",
                  index: 0,
                  groupValue: 0,
                  onChanged: (_) {},
                ),
                SizedBox(height: 10.h),

                // Other payment methods
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Visa (disabled)
                    PaymentOption(
                      image: "assets/images/Vector.png",
                      index: 1,
                      groupValue: 0,
                      onChanged: null, // Disabled
                    ),

                    // Paypal (disabled)
                    PaymentOption(
                      image: "assets/images/icon.png",
                      index: 2,
                      groupValue: 0,
                      onChanged: null, // Disabled
                    ),

                    // MasterCard (disabled)
                    PaymentOption(
                      image: "assets/images/Mastercard.png",
                      index: 3,
                      groupValue: 0,
                      onChanged: null, // Disabled
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Order Summary
                _orderRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
                _orderRow("Shipping", "\$${shipping.toStringAsFixed(2)}"),
                Divider(thickness: 1.h),
                _orderRow("Total", "\$${total.toStringAsFixed(2)}", isBold: true),

                SizedBox(height: 20.h),

                // Total - Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "TOTAL \$${total.toStringAsFixed(2)}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),
                        Text(
                          "(VAT included)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColor.color_text2,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp),
                        ),
                      ],
                    ),
                    SizedBox(width: 20.h),

                    // Place Order Button
                    CustomButton(
                        width: 190.w, text: 'Place Order', onPressed: () {
                          cubit.saveOrderForUser();
                    })
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _orderRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 14.sp)),
        Text(value,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 14.sp)),
      ],
    );
  }
}
