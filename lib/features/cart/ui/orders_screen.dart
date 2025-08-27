import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapshop/core/app_color.dart';
import 'package:snapshop/features/cart/cubit/logic.dart';
import 'package:snapshop/features/cart/cubit/state.dart';
import '../widget/order_cart.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    cubit.fetchOrders();

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Orders",
          style: TextStyle(
            color: AppColor.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Toggle Tabs
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                final isCurrentSelected = cubit.isCurrentSelected;
                return Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.black,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => cubit.toggleTab(true),
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                              isCurrentSelected ? AppColor.white : AppColor.black,
                              borderRadius: BorderRadius.circular(12),
                              border: isCurrentSelected
                                  ? Border.all(color: AppColor.black, width: 4)
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Current",
                              style: TextStyle(
                                color: isCurrentSelected
                                    ? AppColor.black
                                    : AppColor.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => cubit.toggleTab(false),
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                              !isCurrentSelected ? AppColor.white : AppColor.black,
                              borderRadius: BorderRadius.circular(12),
                              border: !isCurrentSelected
                                  ? Border.all(color: AppColor.black, width: 4)
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "History",
                              style: TextStyle(
                                color:
                                !isCurrentSelected ? AppColor.black : AppColor.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 16.h),

            // Orders List
            Expanded(
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  final now = DateTime.now();
                  final orders = cubit.UserOrders;

                  final filteredOrders = cubit.isCurrentSelected
                      ? orders
                      .where((o) =>
                  o.orderedAt.year == now.year &&
                      o.orderedAt.month == now.month &&
                      o.orderedAt.day == now.day)
                      .toList()
                      : orders
                      .where((o) =>
                      o.orderedAt.isBefore(
                          DateTime(now.year, now.month, now.day)))
                      .toList();

                  if (state is OrdersLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (filteredOrders.isEmpty) {
                    return Center(
                      child: Text(
                        "No orders yet",
                        style: TextStyle(
                          color: AppColor.grey,
                          fontSize: 16.sp,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return OrderCard(order: order);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
