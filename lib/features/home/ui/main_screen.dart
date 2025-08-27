import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapshop/features/home/cubit/logic.dart';
import 'package:snapshop/features/home/cubit/state.dart';
import 'package:snapshop/features/home/ui/wishlist_screen.dart';
import '../../../core/app_color.dart';
import '../../account/ui/profile_screen.dart';
import '../../cart/ui/cart_screen.dart';
import 'categories_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatelessWidget {
  // Pages
  final List<Widget> _pages = [
    HomeScreen(),
    CategoriesScreen(),
    WishlistScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  // AppBars
  AppBar? buildAppBar(int index, BuildContext context) {
    switch(index) {
      case 0:
        return null;
      case 1:
        return AppBar(
          title: Text(
            "Categories",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.color_text,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColor.back_ground1,
          surfaceTintColor: AppColor.back_ground1,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColor.color_text, size: 24.sp),
            onPressed: () =>  context.read<HomeCubit>().changePage(0)
          ),
        );
      case 2:
        return AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColor.color_text, size: 22.sp),
            onPressed: () =>context.read<HomeCubit>().changePage(0),
          ),
          title: Text(
            "Wishlist",
            style: TextStyle(
              color: AppColor.color_text,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          centerTitle: false,
          backgroundColor: AppColor.back_ground1,
          elevation: 0,
        );
      case 3:
        return  AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColor.color_text, size: 22.sp),
            onPressed: () => context.read<HomeCubit>().changePage(0),
          ),
          title: Text(
            "Cart",
            style: TextStyle(
              color: AppColor.color_text,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColor.back_ground1,
        );
      default:
        return AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColor.color_text, size: 22.sp),
            onPressed: () => context.read<HomeCubit>().changePage(0),
          ),
          title: Text(
            "My Account",
            style: TextStyle(
              color: AppColor.color_text,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColor.back_ground1,
        );
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
      },
      builder: (context, currentIndex) {
        final cubit = context.read<HomeCubit>();
        return Scaffold(
          backgroundColor: AppColor.back_ground1,
          appBar: buildAppBar(cubit.selectedIndex, context),
          body: _pages[cubit.selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.selectedIndex,
            backgroundColor: AppColor.back_ground1,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColor.color_text,
            unselectedItemColor: AppColor.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: cubit.changePage,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                activeIcon: Container(
                  decoration: BoxDecoration(color: AppColor.color_text, shape: BoxShape.circle),
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.home, color: AppColor.back_ground1),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_outlined),
                activeIcon: Container(
                  decoration: BoxDecoration(color: AppColor.color_text, shape: BoxShape.circle),
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.grid_view_rounded, color: AppColor.back_ground1),
                ),
                label: 'Category',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Container(
                  decoration: BoxDecoration(color: AppColor.color_text, shape: BoxShape.circle),
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.favorite, color: AppColor.back_ground1),
                ),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.card_travel_sharp),
                activeIcon: Container(
                  decoration: BoxDecoration(color: AppColor.color_text, shape: BoxShape.circle),
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.card_travel_sharp, color: AppColor.back_ground1),
                ),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Container(
                  decoration: BoxDecoration(color: AppColor.color_text, shape: BoxShape.circle),
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.person, color: AppColor.back_ground1),
                ),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
