import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImagePath.signInBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GlassEffact(
                height: 371.h,
                width: 390.w,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(AppImagePath.appLogo, width: 61, height: 60),
                    const SizedBox(height: 20),

                    TextWidget(
                      text: AppStrings.lifeIsShortAndSignIn,
                      fontColor: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ButtonWidget(
                        backgroundColor: Colors.transparent,
                        label: 'Sign In',
                        buttonHeight: 40,
                        borderColor: Colors.white,
                        textColor: Colors.white,
                        onPressed: (){
                          Get.toNamed(AppRoutes.signInScreen);
                        },
                        
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ButtonWidget(
                        backgroundColor: AppColor.backgroundColor,
                        label: 'Registration',
                        buttonHeight: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Background image widget
  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(AppImagePath.signInBackgroundImage, fit: BoxFit.cover),
    );
  }
}
