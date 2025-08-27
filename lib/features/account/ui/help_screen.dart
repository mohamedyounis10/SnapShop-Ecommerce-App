import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_color.dart';
import '../widgets/info_card.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.back_ground1,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.color_text, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Help Center",
          style: TextStyle(
            color: AppColor.color_text,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.back_ground1,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            InfoCard(
              title: "What is Snapshop?",
              content:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            ),
            InfoCard(
              title: "How to use Snapshop?",
              content: "Here you will learn how to use the app step by step...",
            ),
            InfoCard(
              title: "Contact Us",
              content: "010000000000",
            ),
            InfoCard(
              title: "Terms & Conditions",
              content: "It is a long established fact that a reader will be "
                  "distracted by the readable content of a page when looking at"
                  " its layout. The point of using Lorem Ipsum is that it has a"
                  " more-or-less normal distribution of letters, as opposed to using"
                  " 'Content here, content here', making it look like readable English."
                  " Many desktop publishing packages and web page editors now use Lorem"
                  " Ipsum as their default model text, and a search for 'lorem ipsum'"
                  " will uncover many web sites still in their infancy. Various versions "
                  "have evolved over the years, sometimes by accident, sometimes on purpose"
                  " (injected humour and the like).",
            ),
          ],
        ),
      ),
    );
  }
}