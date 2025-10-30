import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/widget/glass_effact.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/app_log/app_log.dart';
import 'controller/forgot_pass_verify_otp_screen_controller.dart';

class ResetPassOtpVerifyScreen extends StatelessWidget {
   ResetPassOtpVerifyScreen({super.key});

  ForgotPassVerifyOtpScreenController controller = Get.find<ForgotPassVerifyOtpScreenController>();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,


            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImagePath.authBackground),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main content in center
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0.w),
                      child: GlassEffact(
                       // height: 438.h,
                        width: 390.w,
                        child: Padding(
                          padding: EdgeInsets.all(24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Equal spacing
                            children: [
                              // App Logo
                              Image.asset(
                                  AppImagePath.appLogo,
                                  width: 61.w,
                                  height: 60.h
                              ),
                              SizedBox(
                                height: 16.h,
                              ),

                              // Title with colored number
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Enter ",
                                      style: TextStyle(color: AppColor.white500),
                                    ),
                                    TextSpan(
                                      text: "4",
                                      style: TextStyle(color: Color.fromRGBO(255, 203, 32, 1)),
                                    ),
                                    TextSpan(
                                      text: " digits code",
                                      style: TextStyle(color:  AppColor.white500),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 12.h,
                              ),

                              // Subtitle
                              TextWidget(
                                text: "Enter the four-digit code that was emailed to you.",
                                fontColor:  AppColor.white500,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                textAlignment: TextAlign.center,
                              ),

                              // PIN Code TextField
                              _buildPinCodeTextField(context, controller),

                              // Timer/Resend Section
                              Obx(() {
                                return Column(
                                  children: [
                                    // Timer Display with colored seconds
                                    if (!controller.canResend.value)
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Resend code in ",
                                              style: TextStyle(color:  AppColor.white500),
                                            ),
                                            TextSpan(
                                              text: controller.formatTime(),
                                              style: TextStyle(color: AppColor.yello),
                                            ),
                                            TextSpan(
                                              text: " s",
                                              style: TextStyle(color: AppColor.white500),
                                            ),
                                          ],
                                        ),
                                      ),

                                    // Resend Option
                                    if (controller.canResend.value)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          TextWidget(
                                            text: "Didn't receive code? ",
                                            fontColor: AppColor.white500,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              controller.resendCode();
                                            },
                                            child: TextWidget(
                                              text: "Resend",
                                              fontColor: AppColor.yello,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                );
                              }),


                              SizedBox(
                                height: 32.h,
                              ),

                              // Reset Password Button
                              ButtonWidget(
                                backgroundColor: AppColor.backgroundColor,
                                label: AppStrings.resetPassword,
                                buttonHeight: 46.h,
                                textColor: Colors.white,
                                onPressed: () {
                                  // Handle reset password
                                  if (controller.otpTextEditingController.text.length == 4) {
                                    // Process OTP verification
                                    Get.toNamed(AppRoutes.createPasswordScreen);
                                  } else {
                                    // Show error message
                                    Get.snackbar(
                                      "Error",
                                      "Please enter the complete 4-digit code",
                                      backgroundColor: Colors.red.withOpacity(0.8),
                                      colorText: Colors.white,
                                    );
                                  }
                                },
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
          Positioned(top: 60.h,
            left: 20.w, child: InkWell(
                onTap: (){
                  Get.back();
                },
                child: Icon(Icons.arrow_back_ios_new_rounded)),
          )
        ],
      ),
    );
  }

  Widget _buildPinCodeTextField(BuildContext context, controller) {
    // Calculate field width dynamically based on screen width
    double screenWidth = MediaQuery.of(context).size.width;
    double containerPadding = 48.w; // total horizontal padding inside GlassEffact (24.w * 2)
    double spacing = 16.w; // space between fields
    double maxFieldWidth = 60.w; // maximum width for large screens

    // Calculate dynamic field width so 4 fields + spacing fit inside the GlassEffact
    double calculatedFieldWidth =
    ((screenWidth - containerPadding - spacing * 3) / 4).clamp(40.w, maxFieldWidth);

    return PinCodeTextField(
      appContext: context,
      length: 4,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      obscureText: false,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
      ),
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12.r),
        fieldHeight: calculatedFieldWidth, // make height same as width
        fieldWidth: calculatedFieldWidth,
        activeFillColor: Colors.transparent,
        activeColor: Colors.white,
        inactiveFillColor: Colors.transparent,
        inactiveColor: Colors.white,
        selectedFillColor: Colors.transparent,
        selectedColor: Colors.white,
        borderWidth: 2.w,
      ),
      cursorColor: Colors.white,
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      controller: controller.otpTextEditingController,
      onCompleted: (value) {
        appLog("OTP Completed: $value");
      },
      onChanged: (value) {
        appLog("OTP Changed: $value");
      },
      beforeTextPaste: (text) {
        return text?.length == 4 && RegExp(r'^\d+$').hasMatch(text!);
      },
    );
  }

}