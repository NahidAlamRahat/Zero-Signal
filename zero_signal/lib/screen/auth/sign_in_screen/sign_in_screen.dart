import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/widget/glass_effact.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../../routes/app_routes.dart';
import '../../../widget/space_widget.dart';

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
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(

          image: DecorationImage(
            image: AssetImage(AppImagePath.signInBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20,left: 20),
              child: SingleChildScrollView(
                child: Center(
                  child: GlassEffact(
                 //   height: 600.h,
                    width: 390.w,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: SingleChildScrollView(
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               SizedBox(height: 18.w),
                        
                              // Title
                              Center(
                                child: TextWidget(
                                  text: AppStrings.neverMissASpot,
                                  fontColor: AppColor.white500,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                ),
                              ),
                               SizedBox(height: 8.w),
                        
                              // Subtitle
                              Center(
                                child: TextWidget(
                                  text: AppStrings.findAndVisitNature,
                                  fontColor: AppColor.white300,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: GoogleFonts.openSans().fontFamily,
                                ),
                              ),
                               SizedBox(height: 28.w),
                        
                              // Email Label
                              TextWidget(
                                textAlignment: TextAlign.left,
                                text: AppStrings.email,
                                fontColor: AppColor.white500,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                               SizedBox(height: 8.w),
                        
                              // Email TextField
                              TextFieldWidget(
                                fontWeight: FontWeight.w400,
                                fieldHeight: 44,
                                textColor: AppColor.white500,
                                hintText: AppStrings.enterYourEmail,
                              fontSize: 14,
                                hintColor: AppColor.white500,
                                hintFontSize: 14,
                                backgroundColor: Colors.transparent,
                                borderColor: AppColor.white500,
                                focusedBorderColor:AppColor.white500,
                                borderRadius: 8,
                                borderWidth: 1.0,
                                keyboardType: TextInputType.emailAddress,
                              ),
                               SizedBox(height: 20.w),
                        
                              // Password Label
                              TextWidget(
                                textAlignment: TextAlign.left,
                                text: AppStrings.password,
                                fontColor: AppColor.white500,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              const SizedBox(height: 8),
                        
                              // Password TextField
                              TextFieldWidget(
                                fieldHeight: 44,
                                textColor: AppColor.white500,
                                hintText: AppStrings.enterYourPassword,
                                fontWeight: FontWeight.w400,
                                hintColor: AppColor.white500,
                                hintFontSize: 14,
                                backgroundColor: Colors.transparent,
                                borderColor: AppColor.white500,
                                focusedBorderColor:AppColor.white500,
                                borderRadius: 8,
                                borderWidth: 1.0,
                                keyboardType: TextInputType.emailAddress,
                                fontSize: 14,
                                suffixIcon: true,

                              ),
                               SizedBox(height: 12.w),
                        
                              // Remember Me & Forgot Password Row
                              Row(

                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 14.h
                                        ,
                                        width: 14.w
                                        ,
                                        child: Checkbox(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.r),
                                          ),
                                          value: _rememberMe,
                                          onChanged: (value) {
                                            setState(() {
                                              _rememberMe = value ?? false;
                                            });
                                          },
                                          activeColor: AppColor.white500,
                                          checkColor: AppColor.white500,
                                          side: BorderSide(color: Colors.white54),
                                        ),
                                      ),


                                      SizedBox(width: 8.w,),
                                      TextWidget(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        text: AppStrings.rememberMe,
                                        fontColor: AppColor.white500,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),

                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      // Handle forgot password
                                      Get.toNamed(AppRoutes.forgotPasswordScreen);
                                    },
                                    child: TextWidget(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: AppStrings.forgotPassword,
                                      fontColor: AppColor.yello,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height: 50.h),
                        
                              // Sign In Button
                              SizedBox(
                                width: double.infinity,
                                child: ButtonWidget(
                                  backgroundColor:AppColor.backgroundColor,
                                  label: AppStrings.signIn,
                                  buttonHeight: 48,
                                  textColor: AppColor.white500,
                                  onPressed: (){
                                    Get.toNamed(AppRoutes.bottomNav);
                                  },
                                ),
                              ),
                               SizedBox(height: 28.h),
                        
                              // Or sign in with text
                              Center(
                                child: TextWidget(
                                  text: AppStrings.orSignInWith,
                                  fontColor: AppColor.white500,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                               SizedBox(height: 28.w),
                        
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

                              SizedBox(height: 28.h,),
                              // Sign Up Link
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                      text: AppStrings.dontHaveAccount,
                                      fontColor: AppColor.white500,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigate to Sign Up
                                        Get.toNamed(AppRoutes.signUpScreen);
                                      },
                                      child: TextWidget(
                                        text: AppStrings.signUp,
                                        underline: true,
                                        underlineColor: AppColor.yello,
                                        fontColor: AppColor.yello,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        underlineWidth: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 28.h,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}