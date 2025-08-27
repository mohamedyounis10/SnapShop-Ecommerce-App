import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_color.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color selectedColor;
  final Color defaultColor;
  final Color borderColor;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.selectedColor = AppColor.cardSelected,
    this.defaultColor = AppColor.back_ground1,
    this.borderColor = AppColor.color_text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: 380.w,
          height: 150.h,
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : defaultColor,
            borderRadius: BorderRadius.circular(16.r),
            border: isSelected
                ? Border.all(color: borderColor, width: 2.w)
                : Border.all(color: AppColor.back_ground4, width: 2.w),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left-side icon in a circle
                    Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: AppColor.back_ground1,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.shadow,
                            blurRadius: 5.r,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        size: 20.sp,
                        color: AppColor.black,
                      ),
                    ),

                    // Right-side checkmark icon
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        size: 24.sp,
                        color: borderColor,
                      ),
                  ],
                ),


                SizedBox(width: 20.w),

                // Center text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.color_text,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColor.color_text,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}