import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapshop/core/app_color.dart';

class PaymentOption extends StatelessWidget {
  final String image;
  final int index;
  final int groupValue;
  final ValueChanged<int?>? onChanged;

  const PaymentOption({
    super.key,
    required this.image,
    required this.index,
    required this.groupValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onChanged == null;

    return GestureDetector(
      onTap: isDisabled ? null : () => onChanged!(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: isDisabled
              ? AppColor.grey300
              : (groupValue == index ? AppColor.grey400 : AppColor.white),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              image,
              height: 30.h,
              width: 40.w,
              fit: BoxFit.contain,
              color: isDisabled ? AppColor.grey : null, // Dim color if disabled
            ),
            SizedBox(width: 8.w),
            Radio<int>(
              value: index,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppColor.black,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}
