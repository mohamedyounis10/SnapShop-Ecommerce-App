import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapshop/features/cart/cubit/state.dart';
import 'package:snapshop/features/home/ui/main_screen.dart';
import '../../../core/app_color.dart';
import '../../../core/custom_button.dart';
import '../../home/cubit/logic.dart';
import '../cubit/logic.dart';

class SuccessOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit,CartState>(
      builder: (context,state){
        return Scaffold(
          backgroundColor: AppColor.back_ground1,
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image
                  Image.asset('assets/images/illustrations.png'),
                  SizedBox(height: 5.h),

                  // Text 1
                  Text(
                    'Order Successful!!',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.color_text,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Text 2
                  Text('You have successfully made order',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColor.color_text2,
                    ),
                  ),
                  SizedBox(height: 50.h),

                  // Go to main
                  Center(
                    child: CustomButton(
                      text:'Continue Shopping',
                      width: 343.w,
                      onPressed: () {
                        context.read<CartCubit>().clearUserOrder();
                        context.read<HomeCubit>().changePage(0);
                        Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (c)=> MainScreen()),
                        );
                      },
                    ),
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



