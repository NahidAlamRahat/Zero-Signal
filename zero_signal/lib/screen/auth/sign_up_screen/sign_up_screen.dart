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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _acceptTerms = false;
  final bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImagePath.signUpBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GlassEffact(
                    height: 750.h,
                    width: 390.w,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.h),
                          // Logo
                          Center(
                            child: Image.asset(
                              AppImagePath.appLogo,
                              height: 60.h,
                              width: 61.w,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Title
                          Center(
                            child: TextWidget(
                              text: AppStrings.registration,
                              fontColor: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // Subtitle
                          Center(
                            child: TextWidget(
                              text: AppStrings.createYourAccount,
                              fontColor: Colors.white70,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // User Name Field
                          TextWidget(
                            textAlignment: TextAlign.left,
                            text: "User Name",
                            fontColor: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 8.h),
                          TextFieldWidget(
                            fieldHeight: 44,
                            textColor: Colors.white,
                            hintText: "Enter User Name",
                            textStyle: TextStyle(fontSize: 14.sp),
                            hintColor: Colors.white54,
                            backgroundColor: Colors.transparent,
                            borderColor: Colors.white.withOpacity(0.5),
                            focusedBorderColor: Colors.white,
                            borderRadius: 8.r,
                            borderWidth: 1.0,
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 16.h),

                          // Email Field
                          TextWidget(
                            textAlignment: TextAlign.left,
                            text: "Email",
                            fontColor: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 8.h),
                          TextFieldWidget(
                            fieldHeight: 44,
                            textColor: Colors.white,
                            hintText: "Enter Email",
                            textStyle: TextStyle(fontSize: 14.sp),
                            hintColor: Colors.white54,
                            backgroundColor: Colors.transparent,
                            borderColor: Colors.white.withOpacity(0.5),
                            focusedBorderColor: Colors.white,
                            borderRadius: 8.r,
                            borderWidth: 1.0,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 16.h),

                          // Date of Birth Field
                          TextWidget(
                            textAlignment: TextAlign.left,
                            text: "Date of birth",
                            fontColor: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 8.h),
                          TextFieldWidget(
                            fieldHeight: 44,
                            textColor: Colors.white,
                            hintText: "mm/ dd/ yyyy",
                            textStyle: TextStyle(fontSize: 14.sp),
                            hintColor: Colors.white54,
                            backgroundColor: Colors.transparent,
                            borderColor: Colors.white.withOpacity(0.5),
                            focusedBorderColor: Colors.white,
                            borderRadius: 8.r,
                            borderWidth: 1.0,
                            keyboardType: TextInputType.datetime,
                            customSuffixIcon: Icon(
                              Icons.calendar_today,
                              color: Colors.white54,
                              size: 18,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Password Field
                          TextWidget(
                            textAlignment: TextAlign.left,
                            text: "Password",
                            fontColor: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(height: 8.h),
                          TextFieldWidget(
                            fieldHeight: 44,
                            textColor: Colors.white,
                            hintText: "Enter Password",
                            textStyle: TextStyle(fontSize: 14.sp),
                            hintColor: Colors.white54,
                            backgroundColor: Colors.transparent,
                            borderColor: Colors.white.withOpacity(0.5),
                            focusedBorderColor: Colors.white,
                            borderRadius: 8.r,
                            borderWidth: 1.0,
                            keyboardType: TextInputType.visiblePassword,
                          suffixIcon: true,
                          ),
                          SizedBox(height: 16.h),

                          // Terms and Conditions Checkbox
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _acceptTerms = value ?? false;
                                    });
                                  },
                                  activeColor: AppColor.backgroundColor,
                                  checkColor: Colors.white,
                                  side: BorderSide(color: Colors.white54),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(text: "By creating an account, I accept the "),
                                      TextSpan(
                                        text: "Terms & Conditions",
                                        style: TextStyle(
                                          color:Color(0xFF45EA69),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(text: " & "),
                                      TextSpan(
                                        text: "Privacy Policy",
                                        style: TextStyle(
                                          color: Color(0xFF45EA69),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),

                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            child: ButtonWidget(
                              backgroundColor: AppColor.backgroundColor,
                              label: "Register",
                              buttonHeight: 48,
                              textColor: Colors.white,
                              onPressed: () {
                                // Handle registration
                                 Get.back();
                              },
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // OR Divider
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: TextWidget(
                                  text: "OR",
                                  fontColor: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),

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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}