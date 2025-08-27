import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:snapshop/core/app_color.dart';

class CustomPageIndicator extends StatelessWidget {
  final PageController controller;
  final int count;

  const CustomPageIndicator({
    Key? key,
    required this.controller,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: const ExpandingDotsEffect(
        activeDotColor: AppColor.black,
        dotColor: AppColor.white,
        dotHeight: 10,
        dotWidth: 10,
        expansionFactor: 3,
      ),
    );
  }
}
