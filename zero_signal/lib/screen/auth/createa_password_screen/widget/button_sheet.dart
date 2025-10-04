import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../../../constant/app_strings.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widget/button_widget/button_widget.dart';

void showPasswordChangedSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top drag indicator
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),

            // Success Icon
            Image.asset(AppIconPath.completedIcon, width: 130.w, height: 130.h),

             SizedBox(height: 20.w),

            // Title
            TextWidget(text: AppStrings.passwordChanged,
            fontSize: 20.sp,
              fontWeight: FontWeight.w500,
            ),

            const SizedBox(height: 10),

            // Subtitle
            TextWidget(text: AppStrings.returnToLogin,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              fontColor: Color(0xFF565656),
            ),

            const SizedBox(height: 25),

            // Continue Button
           ButtonWidget(
             onPressed: (){
               Get.offAllNamed(AppRoutes.signInScreen);
             },
             buttonHeight: 48.h,
             label: AppStrings.continueText,
             fontWeight: FontWeight.w500,
             fontSize: 16.sp,
               backgroundColor: AppColor.backgroundColor,
           ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
