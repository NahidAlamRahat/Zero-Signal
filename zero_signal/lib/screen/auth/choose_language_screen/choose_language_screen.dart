import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

class ChooseLanguageScreen extends StatelessWidget {
  const ChooseLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 250.h),
          Image.asset(
            AppImagePath.appLogo,
            height: 160.w,
            width: 390.w,
          ),

          SizedBox(height: 20.h),

          TextWidget(text: AppStrings.chooseYourLanguage,
          textAlignment: TextAlign.center,
            fontSize: 28,
            fontWeight: FontWeight.w500,
            fontColor: AppColor.blackColor ,
          ),

          SizedBox(height: 8.h),

          TextWidget(text: AppStrings.selectYourPreferredLanguage,
            textAlignment: TextAlign.center,
            fontSize: 20,
            fontWeight: FontWeight.w400,
            fontColor: AppColor.subTitleColor ,
          ),

          // LanguageSelectionWidget()


          ],
        ),
      ),
    );
  
  }
}
