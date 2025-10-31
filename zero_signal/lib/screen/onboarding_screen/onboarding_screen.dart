import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../constant/app_strings.dart';
import '../../routes/app_routes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      body: Stack(
        children: [




          _buildBackgroundImage(),
          _buildTitleText(),
          _buildGetStartedButton(context),
        ],
      ),
    );
  }

  /// Background image widget
  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        AppImagePath.onboardingBackgroundImage,
        fit: BoxFit.cover,
      ),
    );
  }

  /// Title text widget
  Widget _buildTitleText() {
    return  Positioned(
      bottom: 140,
      left: 20,
      right: 20,
      child: TextWidget(

        fontSize: 28,
        fontWeight: FontWeight.w600,
        textAlignment: TextAlign.center,
        text: AppStrings.discoverNewWorld,
        fontColor:AppColor.white500,
      ),
    );
  }

  /// Get Started button widget
  Widget _buildGetStartedButton(BuildContext context) {
    return Positioned(
      bottom: kBottomNavigationBarHeight,
      left: 16,
      right: 16,
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.signInAndRegistrationScreen);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              // Centered text
               Center(
                child: Text(
                  AppStrings.getStarted,
                  style: TextStyle(
                    color: AppColor.white500,
                    fontSize: 20.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Right-aligned icon
              Positioned(
                right: 16,
                top: 10,
                child: Container(
                  width: 28.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    color: AppColor.buttonArrowBackground,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child:  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.w,
                    color: AppColor.white500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}