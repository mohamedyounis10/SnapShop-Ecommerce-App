import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snapshop/core/custom_button.dart';
import 'package:snapshop/core/custom_textformfield_container.dart';
import 'package:snapshop/features/account/cubit/state.dart';
import '../../../core/app_color.dart';
import '../cubit/logic.dart';

class PasswordScreen extends StatelessWidget {
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfilePasswordChangedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password updated successfully!'),
              backgroundColor: AppColor.success,
              duration: Duration(seconds: 1),
            ),
          );

          currentPassword.clear();
          newPassword.clear();
          confirmPassword.clear();

          Future.delayed(Duration(seconds: 1), () {
            Navigator.pop(context);
          });
      } else if (state is ProfilePasswordChangeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        final isLoading = state is ProfileLoading;

        return Scaffold(
          backgroundColor: AppColor.back_ground1,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColor.color_text, size: 22.sp),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Password",
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Current Password
                  CustomTextFormFieldContainer(
                    controller: currentPassword,
                    labelText: 'Current Password',
                    obscureText: cubit.isObscure1,
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        cubit.isObscure1 ? Icons.visibility_off : Icons.visibility,
                        color: AppColor.grey,
                      ),
                      onPressed: cubit.toggleNewPasswordVisibility1,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // New Password
                  CustomTextFormFieldContainer(
                    controller: newPassword,
                    labelText: "New Password",
                    obscureText: cubit.isObscure2,
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        cubit.isObscure2 ? Icons.visibility_off : Icons.visibility,
                        color: AppColor.grey,
                      ),
                      onPressed: cubit.toggleNewPasswordVisibility2,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.trim().length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Confirm Password
                  CustomTextFormFieldContainer(
                    controller: confirmPassword,
                    labelText: "Confirm Password",
                    obscureText: cubit.isObscure3,
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        cubit.isObscure3 ? Icons.visibility_off : Icons.visibility,
                        color: AppColor.grey,
                      ),
                      onPressed: cubit.toggleNewPasswordVisibility3,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != newPassword.text.trim()) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32.h),

                  // Save Button
                  CustomButton(
                    width: 343,
                    text: isLoading ? 'Saving...' : 'Save',
                    onPressed: () {
                      if (!isLoading && _formKey.currentState!.validate()) {
                        cubit.changePasswordWithCurrent(
                          currentPassword: currentPassword.text.trim(),
                          newPassword: newPassword.text.trim(),
                        );
                      }
                    },
                  )

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
