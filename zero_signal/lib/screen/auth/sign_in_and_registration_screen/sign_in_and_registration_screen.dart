import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/widget/glass_effact.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../../routes/app_routes.dart';

class SignInAndRegistrationScreen extends StatelessWidget {
  const SignInAndRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final screenHeight = size.height;
    final screenWidth = size.width;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImagePath.signInBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: screenHeight * 0.08,
              left: screenWidth * 0.04,
              right: screenWidth * 0.04,
              child: GlassEffact(
                // height: screenHeight * 0.35,
                width: screenWidth * 0.92,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 25.h,
                    ),

                    // App Logo
                    Image.asset(
                      AppImagePath.appLogo,
                      width: screenWidth * 0.15,
                      height: screenHeight * 0.08,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Title Text
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                      ),
                      child: TextWidget(
                        fontSize: screenWidth * 0.038,
                        text: AppStrings.lifeIsShortAndSignIn,
                        fontColor: Colors.white,
                        fontWeight: FontWeight.w400,
                        textAlignment: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Sign In Button
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenHeight * 0.008,
                      ),
                      child: ButtonWidget(
                        buttonWidth: screenWidth * 0.9,
                        backgroundColor: Colors.transparent,
                        label: 'Sign In',
                        buttonHeight: screenHeight * 0.05,
                        borderColor: Colors.white,
                        textColor: Colors.white,
                        onPressed: () {
                          Get.toNamed(AppRoutes.signInScreen);
                        },
                      ),
                    ),

                    // Registration Button
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenHeight * 0.008,
                      ),
                      child: ButtonWidget(
                        buttonWidth: screenWidth * 0.9,
                        onPressed: () {
                          Get.toNamed(AppRoutes.signUpScreen);
                        },
                        backgroundColor: AppColor.backgroundColor,
                        label: 'Registration',
                        buttonHeight: screenHeight * 0.05,
                      ),
                    ),

                    SizedBox(
                      height: 35.h,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
