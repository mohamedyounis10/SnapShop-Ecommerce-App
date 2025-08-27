import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_color.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final IconData prefixIcon;

  const CustomSearchField({
    super.key,
    required this.controller,
    this.hintText = "Search",
    this.onTap,
    this.onChanged,
    this.prefixIcon = Icons.search,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, size: 30),
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColor.black,
          fontSize: 18.sp,
        ),
        filled: true,
        fillColor: AppColor.back_ground1,
        contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
            color: AppColor.border_color,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
            color: AppColor.border_color,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
            color: AppColor.error,
            width: 1.5,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
            color: AppColor.color_text,
            width: 1.5,
          ),
        ),
      ),
      readOnly: onTap != null && onChanged == null,
      onTap: onTap,
      onChanged: onChanged,
    );
  }
}
