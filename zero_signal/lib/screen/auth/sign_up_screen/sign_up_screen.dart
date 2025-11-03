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


import '../../../gen/assets.gen.dart';
import '../../../routes/app_routes.dart';
import '../../../widget/text_widget/text_widgets.dart';

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            
             SizedBox(height: 14.h,),
                GlassEffact(
             //     height: 750.h,
                  width: 390.w,
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.w ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 28.h),
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
                            fontColor: AppColor.white500,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.h),
            
                        // Subtitle
                        Center(
                          child: TextWidget(
                            text: AppStrings.createYourAccount,
                            fontColor: AppColor.white500,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 20.h),
            
                        // User Name Field
                        TextWidget(
                          textAlignment: TextAlign.left,
                          text: "User Name",
                          fontColor: AppColor.white500,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
            
                        ),
            
                        SizedBox(height: 8.h),
                        TextFieldWidget(
                          fieldHeight: 39,
                          textColor: AppColor.white500,
                          hintText: "Enter User Name",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          hintColor: AppColor.white500,
            
                          backgroundColor: Colors.transparent,
                          borderColor: AppColor.white500,
                          focusedBorderColor:AppColor.white500,
                          borderRadius: 8,
                          borderWidth: 1.0,
                          keyboardType: TextInputType.name,
                        ),
                        SizedBox(height: 16.h),
            
                        // Email Field
                        TextWidget(
                          textAlignment: TextAlign.left,
                          text: "Email",
                          fontColor: AppColor.white500,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
            
                        ),
            
                        SizedBox(height: 8.h),
                        TextFieldWidget(
                          fieldHeight: 39,
                          textColor: AppColor.white500,
                          hintText: "Enter User Email",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          hintColor: AppColor.white500,
            
                          backgroundColor: Colors.transparent,
                          borderColor: AppColor.white500,
                          focusedBorderColor:AppColor.white500,
                          borderRadius: 8,
                          borderWidth: 1.0,
                          keyboardType: TextInputType.name,
                        ),
                        SizedBox(height: 16.h),
            
                        // Date of Birth Field
                        TextWidget(
                          textAlignment: TextAlign.left,
                          text: "Date of birth",
                          fontColor: AppColor.white500,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
            
                        ),
            
                        SizedBox(height: 8.h),
                        TextFieldWidget(
            
                          customSuffixIcon: Image.asset(
                            Assets.icons.calender.path,
                            color: AppColor.white500,
                            height: 16.h,
                            width: 16.w,
                          ),
                          fieldHeight: 39,
                          textColor: AppColor.white500,
                          hintText: "mm/ dd/ yyyy",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          hintColor: AppColor.white500,
            
                          backgroundColor: Colors.transparent,
                          borderColor: AppColor.white500,
                          focusedBorderColor:AppColor.white500,
                          borderRadius: 8,
                          borderWidth: 1.0,
                          keyboardType: TextInputType.datetime,
                        ),
                        SizedBox(height: 16.h),
            
                        // Password Field
                        TextWidget(
                          textAlignment: TextAlign.left,
                          text: "Password",
                          fontColor: AppColor.white500,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
            
                        ),
            
                        SizedBox(height: 8.h),
                        TextFieldWidget(
                          suffixIcon: true,
                          iconPadding: 0,
                          fieldHeight: 39,
                          textColor: AppColor.white500,
                          hintText: "Enter Password",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          hintColor: AppColor.white500,
            
                          backgroundColor: Colors.transparent,
                          borderColor: AppColor.white500,
                          focusedBorderColor:AppColor.white500,
                          borderRadius: 8,
                          borderWidth: 1.0,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        SizedBox(height: 8.h),
            
                        // Terms and Conditions Checkbox
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16.h,
                              width: 16.w,
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
                                    color: AppColor.white500,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: [
                                    TextSpan(text: "By creating an account, I accept the "),
                                    TextSpan(
                                      text: "Terms & Conditions",
                                      style: TextStyle(
                                        color:AppColor.green,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    TextSpan(text: " & "),
                                    TextSpan(
                                      text: "Privacy Policy",
                                      style: TextStyle(
                                        color:AppColor.green,
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
                            buttonHeight: 46,
                            textColor: AppColor.white500,
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
                                color: AppColor.white500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: TextWidget(
                                text: "OR",
                                fontColor: AppColor.white500,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColor.white500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
            
            
                        // Google Sign In Button
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              // Handle Google sign in
                            },
                            child: Container(
                              width: 75.w,
                              height: 55.h,
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
                        SizedBox(height: 30.h),
            
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}