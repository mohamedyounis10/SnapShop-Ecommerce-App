import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_color.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: AppColor.back_ground1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r), // responsive border
        side: BorderSide(color: AppColor.grey300, width: 1.w),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        title: Text(
          title,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        iconColor: AppColor.black54,
        collapsedIconColor: AppColor.black54,
        children: [
          Divider(height: 1.h, thickness: 1.h),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              content,
              style: TextStyle(fontSize: 16.sp, color: AppColor.black54),
            ),
          ),
        ],
      ),
    );
  }
}
