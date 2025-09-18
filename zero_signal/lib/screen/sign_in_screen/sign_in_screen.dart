import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/widget/glass_effact.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                height: 640,
                width: 390,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(child: Image.asset(AppImagePath.appLogo, width: 61, height: 60)),
                    const SizedBox(height: 20),

                    Center(
                      child: TextWidget(
                        text: AppStrings.neverMissASpot,
                        fontColor: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Center(
                      child: TextWidget(
                        text: AppStrings.findAndVisitNature,
                        fontColor: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextWidget(
                        textAlignment: TextAlign.left,
                        text: AppStrings.email,
                        fontColor: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    TextFieldWidget(
                      textColor: Colors.white,
                      hintText: AppStrings.enterYourEmail,
                      hintColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      borderColor: Colors.white,
                      focusedBorderColor: Colors.white,
                      borderRadius: 12,
                      borderWidth: 0.9,
                      keyboardType: TextInputType.emailAddress,
                     ),


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextWidget(
                        textAlignment: TextAlign.left,
                        text: AppStrings.password,
                        fontColor: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    TextFieldWidget(
                      textColor: Colors.white,
                      hintText: AppStrings.enterYourPassword,
                      hintColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      borderColor: Colors.white,
                      focusedBorderColor: Colors.white,
                      borderRadius: 12,
                      borderWidth: 0.9,
                      keyboardType: TextInputType.emailAddress,
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
