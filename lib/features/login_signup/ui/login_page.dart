import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapshop/features/home/ui/main_screen.dart';
import '../../../core/app_color.dart';
import '../../../core/custom_button.dart';
import '../cubit/logic.dart';
import '../cubit/state.dart';
import 'forget_password_screen.dart';
import 'signup_screen.dart';
import '../widgets/custom_social_button.dart';
import '../../../core/custom_textformfield_container.dart';
import 'package:snapshop/features/home/cubit/logic.dart';

class LoginScreen extends StatelessWidget {
  // Variables
   TextEditingController email = TextEditingController();
   TextEditingController password = TextEditingController();

  // Check validation
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Object from Cubit
    final cubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColor.back_ground1,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.all(20.0.w),
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context,state){
                if(state is NextPageState){
                  Navigator.push(context, MaterialPageRoute(builder: (c){
                    return SignupScreen();
                  })
                  );
                }
                if(state is ErrorState){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Have Problem is empty'),
                      backgroundColor: AppColor.grey,
                    ),
                  );
                }
                if (state is SuccessState) {
                  // Prefetch home data
                  Future.microtask(() {
                    context.read<HomeCubit>().loadProducts();
                  });
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (c){
                        return MainScreen();
                      })
                  );
                }
                if (state is PasswordPageState) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (c){
                        return ForgetPasswordScreen();
                      })
                  );
                }
                if (state is FailureState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: AppColor.error,
                    ),
                  );
                }
              },
              builder: (context,state){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text - login
                    SizedBox(height: 20.h),
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: 35.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.color_text,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 27.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.color_text,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Items
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email
                          CustomTextFormFieldContainer(
                            controller: email,
                            labelText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value.trim())) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onChanged: cubit.updateEmail,
                          ),
                          SizedBox(height: 20.h),

                          // Password
                          CustomTextFormFieldContainer(
                            controller: password,
                            labelText: 'Password',
                            obscureText: cubit.isObscure,
                            keyboardType: TextInputType.visiblePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                cubit.isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColor.grey,
                              ),
                              onPressed: cubit.togglePasswordVisibility,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.trim().length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            onChanged: cubit.updatePassword,
                          ),
                          SizedBox(height: 10.h),

                          // Forget password
                          Align(
                            alignment: Alignment.topRight,
                            child:TextButton(onPressed: (){
                              cubit.PasswordPage();
                            }, child: Text(
                              'Forget Password?',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColor.color_text,
                              ),
                            ),),),
                          SizedBox(height: 10.h),

                          // Login button
                          Center(
                            child: CustomButton(
                              text: 'LOGIN',
                              width: 300.w,
                              onPressed: () async {
                                // Empty
                                if(email.text.isEmpty || password.text.isEmpty){
                                  cubit.errorMessage();
                                }

                                // Check
                                if (_formKey.currentState!.validate()) {
                                  await cubit.login();
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Social Media
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: AppColor.border_color,
                                thickness: 2.h,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: AppColor.border_color,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: AppColor.border_color,
                                thickness: 2.h,
                              ),
                            ),
                          ],
                        ),

                        // Social Media
                        SocialButton(
                          onPressed: () {
                            context.read<AuthCubit>().loginWithGoogle();
                            print('Google login');
                            },
                          backgroundColor: AppColor.back_ground1,
                          iconPath: 'assets/images/Group.png',
                          text: 'Continue with Google',
                        ),
                        SizedBox(height: 7.w),
                        SocialButton(
                          onPressed: () {
                            context.read<AuthCubit>().loginWithApple();
                            print('Apple login');
                            },
                          backgroundColor: AppColor.back_ground1,
                          iconPath: 'assets/images/Apple.png',
                          text: 'Continue with Apple',
                        ),

                      ],
                    ),
                    SizedBox(height: 5.h),
                    Align(
                      alignment: Alignment.topRight,
                      child:TextButton(onPressed: (){
                        cubit.nextPage();
                      }, child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don’t have an account ?',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.color_text2,
                            ),
                          ),
                          TextButton(onPressed: (){
                            cubit.nextPage();
                          }, child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.color_text,
                            ),
                          ),
                          )
                        ],
                      ),),),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
