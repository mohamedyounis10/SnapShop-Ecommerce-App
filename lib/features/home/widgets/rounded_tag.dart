import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_color.dart';

class RoundedTag extends StatelessWidget {
  final String text;
  final bool isSelected;
  final double fontSize;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const RoundedTag({
    Key? key,
    required this.text,
    this.isSelected = false,
    this.fontSize = 15,
    this.padding,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.color_text : AppColor.grey300,
          borderRadius: BorderRadius.circular(45.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize.sp,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColor.back_ground1 : AppColor.color_text2,
            ),
          ),
        ),
      ),
    );
  }
}
