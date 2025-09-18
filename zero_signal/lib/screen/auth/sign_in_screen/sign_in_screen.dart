import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/utils/app_size.dart';
import 'package:zero_signal/widget/glass_effact.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../../routes/app_routes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _rememberMe = false;

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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GlassEffact(
                  height: AppSize.height(value: 640),
                  width: AppSize.width(value: 390),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),

                          // App Logo
                          Center(
                              child: Image.asset(
                                  AppImagePath.appLogo,
                                  width: 61,
                                  height: 60
                              )
                          ),
                          const SizedBox(height: 15),

                          // Title
                          Center(
                            child: TextWidget(
                              text: AppStrings.neverMissASpot,
                              fontColor: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Subtitle
                          Center(
                            child: TextWidget(
                              text: AppStrings.findAndVisitNature,
                              fontColor: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Email Label
                          TextWidget(
                            textAlignment: TextAlign.left,
                            text: AppStrings.email,
                            fontColor: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 8),

                          // Email TextField
                          TextFieldWidget(
                            textColor: Colors.white,
                            hintText: AppStrings.enterYourEmail,
                            hintColor: Colors.white54,
                            backgroundColor: Colors.transparent,
                            borderColor: Colors.white,
                            focusedBorderColor: Colors.white,
                            borderRadius: 12,
                            borderWidth: 1.0,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 15),

                          // Password Label
                          TextWidget(
                            textAlignment: TextAlign.left,
                            text: AppStrings.password,
                            fontColor: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 8),

                          // Password TextField
                          TextFieldWidget(
                            textColor: Colors.white,
                            hintText: AppStrings.enterYourPassword,
                            hintColor: Colors.white54,
                            backgroundColor: Colors.transparent,
                            borderColor: Colors.white,
                            focusedBorderColor: Colors.white,
                            borderRadius: 12,
                            borderWidth: 1,
                            keyboardType: TextInputType.visiblePassword,
                            suffixIcon: true,
                          ),
                          const SizedBox(height: 12),

                          // Remember Me & Forgot Password Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                    activeColor: Colors.blue,
                                    checkColor: Colors.white,
                                    side: BorderSide(color: Colors.white54),
                                  ),
                                  TextWidget(
                                    text: AppStrings.rememberMe,
                                    fontColor: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle forgot password
                                  Get.toNamed(AppRoutes.forgotPasswordScreen);
                                },
                                child: TextWidget(
                                  text: AppStrings.forgotPassword,
                                  fontColor: AppColor.yello,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // Sign In Button
                          SizedBox(
                            width: double.infinity,
                            child: ButtonWidget(
                              backgroundColor:AppColor.backgroundColor,
                              label: AppStrings.signIn,
                              buttonHeight: 50,
                              textColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Or sign in with text
                          Center(
                            child: TextWidget(
                              text: AppStrings.orSignInWith,
                              fontColor: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Google Sign In Button
                          Center(
                            child: Center(
                              child: Image.asset(AppIconPath.googleIcon,width: 75,height: 55,)
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Sign Up Link
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: AppStrings.dontHaveAccount,
                                  fontColor: Color(0xFFF1F1F1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to Sign Up
                                  },
                                  child: TextWidget(
                                    text: AppStrings.signUp,
                                    fontColor: AppColor.yello,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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