import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/widget/glass_effact.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../../routes/app_routes.dart';
import '../../../widget/text_field_widget/text_field_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImagePath.authBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: GlassEffact(
              height: 374,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(child: Image.asset(AppImagePath.appLogo, width: 61, height: 60)),
                  const SizedBox(height: 20),

                  Center(
                    child: TextWidget(
                      text: AppStrings.forgotPassword,
                      fontColor: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Center(
                    child: TextWidget(
                      text: AppStrings.resetPasswordInstruction,
                      fontColor: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),


                  // Email Label
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: TextWidget(
                      textAlignment: TextAlign.left,
                      text: AppStrings.email,
                      fontColor: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // Email TextField
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextFieldWidget(
                       fieldHeight: 40,
                      textColor: Colors.white,
                      hintText: AppStrings.enterYourEmail,
                      hintColor: Colors.white54,
                      backgroundColor: Colors.transparent,
                      borderColor: Colors.white,
                      focusedBorderColor: Colors.white,
                      borderRadius: 8,
                      borderWidth: 1.0,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: ButtonWidget(
                        onPressed: (){
                          Get.toNamed(AppRoutes.resetPassOtpVerifyScreen);
                        },
                        buttonWidth: double.infinity,
                        backgroundColor: AppColor.backgroundColor,
                        label: AppStrings.verify,
                        buttonHeight: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
