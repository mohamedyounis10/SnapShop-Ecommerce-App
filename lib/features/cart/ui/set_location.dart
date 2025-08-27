import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_color.dart';
import '../../../core/custom_button.dart';
import '../../account/cubit/logic.dart';
import '../widget/input_field.dart';

class SetLocationScreen extends StatelessWidget {
  final TextEditingController governorate = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController block = TextEditingController();
  final TextEditingController street = TextEditingController();
  final TextEditingController building = TextEditingController();
  final TextEditingController floor = TextEditingController();
  final TextEditingController flat = TextEditingController();
  final TextEditingController avenue = TextEditingController();

  SetLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Variables
    final fields = [
      {"label": "Governorate", "controller": governorate},
      {"label": "City", "controller": city},
      {"label": "Block", "controller": block},
      {"label": "Street", "controller": street},
      {"label": "Building", "controller": building},
      {"label": "Floor", "controller": floor},
      {"label": "Flat", "controller": flat},
      {"label": "Avenue", "controller": avenue},
    ];

    return Scaffold(
      backgroundColor: AppColor.back_ground1,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.color_text, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Location",
          style: TextStyle(
            color: AppColor.color_text,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        surfaceTintColor: AppColor.back_ground1,
        backgroundColor: AppColor.back_ground1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: fields.length,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fields[index]["label"].toString(),
                  style: TextStyle(
                    color: AppColor.color_text,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                CustomInputField(
                  hint: fields[index]["label"] as String,
                  controller:
                  fields[index]["controller"] as TextEditingController,
                  fillColor: AppColor.shadow,
                  textColor: AppColor.black,
                  fontSize: 16,
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.w),
        child: CustomButton(
          text: 'Confirm',
          onPressed: () {
            // Collect data
            final addressText =
                "Governorate: ${governorate.text}, "
                "City: ${city.text}, "
                "Block: ${block.text}, "
                "Street: ${street.text}, "
                "Building: ${building.text}, "
                "Floor: ${floor.text}, "
                "Flat: ${flat.text}, "
                "Avenue: ${avenue.text}";


            // Ensure basic fields are filled
            if (city.text.isEmpty || street.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Please fill in at least City and Street"),
                ),
              );
              return;
            }

            // Save address to Firebase via Cubit
            context.read<ProfileCubit>().updateAddress(addressText);

            // Return to previous page
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
