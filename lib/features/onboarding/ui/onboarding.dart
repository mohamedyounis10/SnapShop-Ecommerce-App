import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapshop/features/login_signup/ui/login_page.dart';
import '../../../core/app_color.dart';
import '../cubit/logic.dart';
import '../cubit/state.dart';
import '../widgets/custom_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingLogic,OnboardingState>(
        listener: (context , state){
          if (state is NextPageState){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c){
              return LoginScreen();
            })
            );
          }
        },
      builder: (context , state){
          final cubit = context.read<OnboardingLogic>();
          return Scaffold(
            body: PageView(
              controller: cubit.controller,
              children: [
                // Onboarding 1
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Rectangle 1025.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 50.h,
                        left: 20.w,
                        child: CustomPageIndicator(
                          controller: cubit.controller,
                          count: 3,
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Discover Our New\nCollection',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: 35.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0.w),
                            child: Text(
                              'Easy shopping for all your needs just in hand, trusted by millions of people in the world.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 17.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          ElevatedButton(
                            onPressed: () {
                            cubit.changePage();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              minimumSize: Size(343.w, 56.h),
                            ),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ],
                  ),
                ),

                // Onboarding 2
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/image 318.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Order your Style',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColor.white,
                          fontSize: 35.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0.w),
                        child: Text(
                          'More than a thousand of our bags\nare available for your luxury',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 17.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      ElevatedButton(
                        onPressed: () {
                          cubit.changePage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get Started',
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              width: 36.w,
                              height: 36.h,
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColor.black,
                                  size: 18.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),

                // Onboarding 3
                Container(
                  decoration: const BoxDecoration(
                    color: AppColor.back_ground1,
                    image: DecorationImage(
                      image: AssetImage('assets/images/image 325.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(25.0.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomPageIndicator(
                              controller: cubit.controller,
                              count: 3,
                            ),
                            SizedBox(width: 10.w),
                            ElevatedButton(
                              onPressed: () {
                                cubit.nextPage();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.black,
                                maximumSize: Size(200.w, 56.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 12.h,
                                ),
                              ),
                              child: Text(
                                'Get Started',
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
    },
    );
  }
}