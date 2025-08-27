import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_color.dart';
import '../../../models/order.dart';
class OrderCard extends StatelessWidget {
  final Orders order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.grey300),
        boxShadow: [
          BoxShadow(
            color: AppColor.black12,
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Order ID / Status
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColor.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Order ID: ${order.orderId}",
              style: TextStyle(
                color: AppColor.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8.h),

          /// Items
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Items:",
                style: TextStyle(
                  color: AppColor.grey700,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              ...order.products.map((p) => Text(
                "- ${p.product.title}",
                style: TextStyle(
                  color: AppColor.grey700,
                  fontSize: 14.sp,
                ),
              )),
            ],
          ),
          SizedBox(height: 6.h),

          /// Total Price
          Text(
            "\$${order.totalOrderPrice}",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
          ),
          SizedBox(height: 6.h),

          /// Date
          Text(
            "${order.orderedAt.day} "
                "${_monthName(order.orderedAt.month)} "
                "${order.orderedAt.year} - "
                "${order.orderedAt.hour}:${order.orderedAt.minute.toString().padLeft(2, '0')}",
            style: TextStyle(
              color: AppColor.grey600,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }
}
