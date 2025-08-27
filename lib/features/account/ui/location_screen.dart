import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapshop/features/cart/ui/set_location.dart';
import '../../../core/app_color.dart';
import '../../../core/custom_button.dart';
import '../../account/cubit/state.dart';
import '../cubit/logic.dart';

class LocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Load address when screen opens
    context.read<ProfileCubit>().loadAddress();

    return Scaffold(
      backgroundColor: AppColor.back_ground1,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.color_text, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Delivery Address",
          style: TextStyle(
            color: AppColor.color_text,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.back_ground1,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileAddressError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if(state is ChangePage){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SetLocationScreen(),
                ),
              );
            }
          },
          builder: (context, state) {
            String addressText = "No address available";

            // If state is ProfileLoaded or ProfileUpdated
            final user = (state is ProfileLoaded)
                ? state.user
                : (state is ProfileUpdated ? state.user : null);

            if (user != null && user.addresses != null && user.addresses!.isNotEmpty) {
              addressText = user.addresses!;
            }

            return Column(
              children: [
                // Card - Address
                Container(
                  width: 343.w,
                  child: Card(
                    color: AppColor.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0.r),
                                              side: BorderSide(
                          color: AppColor.white70,
                          width: 1.0,
                        ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0.w),
                      child: Text(
                        addressText,
                        style: TextStyle(
                          color: AppColor.back_ground1,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Edit - Button
                CustomButton(
                  width: 343.w,
                  text: 'Edit Address',
                  onPressed: () {
                    context.read<ProfileCubit>().changePage();
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
