import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/screen/onboarding_screen/widget/language_selection_widget.dart';
import 'package:zero_signal/utils/app_size.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColor.creamBackgroundColor,

      body: Center(
        child: Column(
          children: [
            SizedBox(height: AppSize.height(value: 250)),
            Image.asset(
              AppImagePath.appLogo,
              height: AppSize.width(value: 160),
              width: AppSize.width(value: 390),
            ),

            SizedBox( height: AppSize.height(value: 20),),

            TextWidget(text: AppStrings.chooseYourLanguage,
            textAlignment: TextAlign.center,
              fontSize: 28,
              fontWeight: FontWeight.w500,
              fontColor: AppColor.blackColor ,
            ),

            SizedBox( height: AppSize.height(value: 8),),

            TextWidget(text: AppStrings.selectYourPreferredLanguage,
              textAlignment: TextAlign.center,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontColor: AppColor.subTitleColor ,
            ),

            LanguageSelectionWidget()


          ],
        ),
      ),
    );
  }
}
