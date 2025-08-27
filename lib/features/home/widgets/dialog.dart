// Dialog
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapshop/features/home/widgets/rounded_tag.dart';

import '../../../core/app_color.dart';
import '../../../core/custom_button.dart';

Future<Map<String, dynamic>?> showFilterDialog(BuildContext context, {required List<String> categories}) async {
  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      double startValue = 10;
      double endValue = 3000;
      int? selectedIndex;

      // Tags
      final List<String> tags = categories.take(6).toList();

      return Dialog(
        backgroundColor: AppColor.back_ground1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "Filter",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 40), // Balance
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Categories
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 90.h,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8.h,
                        crossAxisSpacing: 8.w,
                        childAspectRatio: 2.5,
                      ),
                      itemCount: tags.length,
                      itemBuilder: (context, index) {
                        return RoundedTag(
                          text: tags[index],
                          isSelected: selectedIndex == index,
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                        );
                      },
                    ),
                  ),

                  // Price
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Price",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  RangeSlider(
                    min: 10,
                    max: 3000,
                    activeColor: AppColor.color_text,
                    values: RangeValues(startValue, endValue),
                    onChanged: (values) {
                      setState(() {
                        startValue = values.start;
                        endValue = values.end;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\$${startValue.toInt()}"),
                      Text("\$${endValue.toInt()}"),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        text: "Clear",
                        onPressed: () {
                          setState(() {
                            selectedIndex = null;
                            startValue = 100;
                            endValue = 3000;
                          });
                        },
                        width: 100,
                        height: 43,
                        borderRadius: 30,
                        fontSize: 14,
                        backgroundColor: AppColor.back_ground1,
                        textColor: AppColor.color_text,
                      ),
                      CustomButton(
                        width: 100,
                        height: 43,
                        text: "Apply",
                        onPressed: () {
                          print('Dialog Apply: category=' + (selectedIndex != null ? tags[selectedIndex!] : 'null') + ', min=' + startValue.toString() + ', max=' + endValue.toString());
                          Navigator.pop(context, {
                            "category": selectedIndex != null ? tags[selectedIndex!] : null,
                            "minPrice": startValue,
                            "maxPrice": endValue,
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
