import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapshop/features/account/cubit/logic.dart';
import 'package:snapshop/features/cart/cubit/logic.dart';
import 'package:snapshop/features/cart/ui/checkout_screen.dart';
import 'package:snapshop/features/home/cubit/logic.dart';
import 'package:snapshop/features/login_signup/ui/login_page.dart';
import 'package:snapshop/features/splash_screen/ui/splash_screen.dart';
import 'core/app_color.dart';
import 'features/login_signup/cubit/logic.dart';
import 'features/onboarding/cubit/logic.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => OnboardingLogic()),
            BlocProvider(create: (context) => AuthCubit()),
            BlocProvider(create: (context) => HomeCubit()),
            BlocProvider(create: (context) => CartCubit()),
            BlocProvider(create: (context) => ProfileCubit()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SnapShot App',
            theme: ThemeData(
              scaffoldBackgroundColor: AppColor.back_ground1,
              appBarTheme: AppBarTheme(
                backgroundColor: AppColor.back_ground1,
                elevation: 0,
                surfaceTintColor: AppColor.back_ground1,
              ),
            ),
            home:SplashScreen(),
          ),
        );
      },
    );
  }
}
