import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshop/features/home/ui/home_screen.dart';
import 'package:snapshop/features/home/ui/main_screen.dart';
import '../cubit/logic.dart';
import '../cubit/state.dart';
import '../../../core/app_color.dart';
import '../../../core/custom_button.dart';
import '../../../core/custom_textformfield_container.dart';
import '../widgets/otp_textfield.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  // Merge otp
  String _mergeOtp(TextEditingController otp1, TextEditingController otp2, TextEditingController otp3, TextEditingController otp4) {
    return otp1.text + otp2.text + otp3.text + otp4.text;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _otp1 = TextEditingController();
    final TextEditingController _otp2 = TextEditingController();
    final TextEditingController _otp3 = TextEditingController();
    final TextEditingController _otp4 = TextEditingController();

    final FocusNode _focus1 = FocusNode();
    final FocusNode _focus2 = FocusNode();
    final FocusNode _focus3 = FocusNode();
    final FocusNode _focus4 = FocusNode();

    return Scaffold(
      backgroundColor: AppColor.back_ground1,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is FailureState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: AppColor.error,
                  ),
                );
              }
              if (state is SuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Success'),
                    backgroundColor: AppColor.success,
                  ),
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<AuthCubit>(),
                      child: MainScreen(),
                    ),
                  ),
                );
              }
              if (state is ConfirmSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('OTP verified successfully'),
                    backgroundColor: AppColor.success,
                  ),
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<AuthCubit>(),
                      child: HomeScreen(),
                    ),
                  ),
                );
              }
              if (state is ConfirmFailureState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColor.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5.h),
                  Text(
                    'Verify code',
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.color_text,
                    ),
                  ),
                  Text(
                    'Enter the 4-digit code sent to your email.',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColor.color_text2,
                    ),
                  ),
                  SizedBox(height: 50.h),

                  // OTP Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OtpTextField(controller: _otp1, currentFocus: _focus1, nextFocus: _focus2),
                      OtpTextField(controller: _otp2, currentFocus: _focus2, nextFocus: _focus3),
                      OtpTextField(controller: _otp3, currentFocus: _focus3, nextFocus: _focus4),
                      OtpTextField(controller: _otp4, currentFocus: _focus4),
                    ],
                  ),
                  SizedBox(height: 50.h),

                  // Confirm Button
                  Center(
                    child: CustomButton(
                      text: state is LoadingState ? 'Verifying...' : 'Verify',
                      width: 300.w,
                      onPressed: () {
                        if (state is LoadingState) return;
                        final code = _mergeOtp(_otp1, _otp2, _otp3, _otp4);
                        if (code.length == 4) {
                          context.read<AuthCubit>().verifyOtpAndRegister(code);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter 4-digit code'),
                              backgroundColor: AppColor.error,
                            ),
                          );
                        }
                      },

                    ),
                  ),

                  SizedBox(height: 15.h),

                  // Resend OTP
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement resend OTP logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Resend functionality coming soon'),
                            backgroundColor: AppColor.info,
                          ),
                        );
                      },
                      child: Text(
                        "Resend OTP",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColor.color_text,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
