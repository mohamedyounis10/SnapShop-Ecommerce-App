import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_color.dart';
import '../../../core/custom_button.dart';
import '../../account/ui/terms_conditions.dart';
import '../cubit/logic.dart';
import '../cubit/state.dart';
import '../widgets/custom_social_button.dart';
import '../../../core/custom_textformfield_container.dart';
import 'otp_screen.dart';

class SignupScreen extends StatelessWidget {
  // Variables
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  // Check validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              listener: (context, state) {
                if (state is ErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Have Problem'),
                      backgroundColor: AppColor.grey,
                    ),
                  );
                }
                if (state is ReturnPageState) {
                  Navigator.of(context).pop();
                }
                if (state is NextPageState) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (c) {
                      return OtpScreen();
                    }),
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
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Return to home screen
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColor.color_text,
                          size: 25.sp,
                        )),

                    // Text - Sign Up
                    SizedBox(height: 5.h),
                    Text(
                      'Create Your Account',
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.color_text,
                      ),
                    ),
                    Text(
                      'Which part of country that you call home?',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: AppColor.color_text2,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Items
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Full name
                          CustomTextFormFieldContainer(
                            controller: name,
                            labelText: 'Name',
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.h),

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
                          ),
                          SizedBox(height: 10.h),

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
                          ),
                          SizedBox(height: 10.h),

                          Row(
                            children: [
                              Checkbox(value: cubit.isChecked,
                                  activeColor: AppColor.color_text,
                                  onChanged: (v) {
                                cubit.checkBox();
                              }),
                              Text(
                                'I accepted',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColor.color_text2,
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (c){
                                      return TermsScreen();
                                    })
                                  );
                                },
                                child: Text(
                                  ' Terms & Privacy Policy',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),

                          // Sign Up button
                          Center(
                            child: CustomButton(
                              text: 'Sign Up',
                              width: 300.w,
                              onPressed: () async {
                                if (email.text.isEmpty ||
                                    password.text.isEmpty ||
                                    name.text.isEmpty || cubit.isChecked== false) {
                                  cubit.errorMessage();
                                }
                                if (_formKey.currentState!.validate()) {
                                  await cubit.sendOtpForSignup(
                                    name: name.text.trim(),
                                    email: email.text.trim(),
                                    password: password.text.trim(),
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),

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
                                'Or sign in with',
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
                        SizedBox(height: 7.h),

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
                      child: TextButton(
                        onPressed: () {
                          cubit.returnPage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account ?',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.color_text2,
                              ),
                            ),
                            Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColor.color_text,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
