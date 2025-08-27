import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_color.dart';

class SocialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final String iconPath;
  final String text;
  final Color textColor;
  final double? width;
  final double? height;

  const SocialButton({
    Key? key,
    required this.onPressed,
    required this.backgroundColor,
    required this.iconPath,
    required this.text,
    this.textColor = AppColor.color_text2,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?.w ?? double.infinity, // If width not specified, use full width
      height: height?.h ?? 60.h,          // Default responsive height
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.r),
            side: const BorderSide(color: AppColor.border_color),
          ),
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        ),
        child: Row(
          children: [
            SizedBox(width: 15.w),
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                iconPath,
                width: 25.w,
                height: 25.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 25.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
