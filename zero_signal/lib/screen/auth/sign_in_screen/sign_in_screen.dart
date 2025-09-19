import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20,left: 20),
                child: GlassEffact(
                  height: 640.h,
                  width: 390.w,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         SizedBox(height: 18.w),

                        // Title
                        Center(
                          child: TextWidget(
                            text: AppStrings.neverMissASpot,
                            fontColor: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                         SizedBox(height: 8.w),

                        // Subtitle
                        Center(
                          child: TextWidget(
                            text: AppStrings.findAndVisitNature,
                            fontColor: Colors.white70,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                         SizedBox(height: 32.w),

                        // Email Label
                        TextWidget(
                          textAlignment: TextAlign.left,
                          text: AppStrings.email,
                          fontColor: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                         SizedBox(height: 8.w),

                        // Email TextField
                        TextFieldWidget(
                          fieldHeight: 44,
                          textColor: Colors.white,
                          hintText: AppStrings.enterYourEmail,
                          textStyle:TextStyle(fontSize: 14.sp) ,
                          hintColor: Colors.white54,
                          backgroundColor: Colors.transparent,
                          borderColor: Colors.white,
                          focusedBorderColor: Colors.white,
                          borderRadius: 8.r,
                          borderWidth: 1.0,
                          keyboardType: TextInputType.emailAddress,
                        ),
                         SizedBox(height: 15.w),

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
                        fieldHeight: 44,
                        textColor: Colors.white,
                        hintText: AppStrings.enterYourEmail,
                        textStyle:TextStyle(fontSize: 14.sp) ,
                        hintColor: Colors.white54,
                        backgroundColor: Colors.transparent,
                        borderColor: Colors.white,
                        focusedBorderColor: Colors.white,
                        borderRadius: 8.r,
                        borderWidth: 1.0,
                        keyboardType: TextInputType.emailAddress,
                      ),
                         SizedBox(height: 12.w),

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
                                  fontSize: 14.sp,
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
                            buttonHeight: 48,
                            textColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Or sign in with text
                        Center(
                          child: TextWidget(
                            text: AppStrings.orSignInWith,
                            fontColor: Colors.white70,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                         SizedBox(height: 20.w),

                        // Google Sign In Button
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              // Handle Google sign in
                            },
                            child: Container(
                              width: 75,
                              height: 55,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Image.asset(
                                AppIconPath.googleIcon,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ),
                          ),
                        ),

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
                                  Get.toNamed(AppRoutes.signUpScreen);
                                },
                                child: TextWidget(
                                  text: AppStrings.signUp,
                                  fontColor: AppColor.yello,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
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
            ],
          ),
        ),
      ),
    );
  }
}