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
import '../../../utils/app_log/app_log.dart';
import '../../../widget/text_button_widget/text_button_widget.dart';
import 'controller/forgot_pass_verify_otp_screen_controller.dart';

class ResetPassOtpVerifyScreen extends StatelessWidget {
  const ResetPassOtpVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ForgotPassVerifyOtpScreenController controller = Get.find<ForgotPassVerifyOtpScreenController>();

    return Scaffold(
      body: Container(
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
                padding:  EdgeInsets.all(16.0.w),
                child: GlassEffact(
                  height: 438.h,
                  width: 390.w,
                  child: Padding(
                    padding:  EdgeInsets.all(24.w),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),

                          // App Logo
                          Image.asset(
                              AppImagePath.appLogo,
                              width: 80,
                              height: 80
                          ),
                           SizedBox(height: 30.w),

                          // Title with colored number
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: "Enter ",
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextSpan(
                                  text: "4",
                                  style: TextStyle(color: Colors.orange[400]),
                                ),
                                TextSpan(
                                  text: " digits code",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                           SizedBox(height: 12.h),

                          // Subtitle
                          TextWidget(
                            text: "Enter the four-digit code that was emailed to you.",
                            fontColor: Colors.white70,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            textAlignment: TextAlign.center,
                          ),
                           SizedBox(height: 40.w),

                          // PIN Code TextField
                          _buildPinCodeTextField(context, controller),
                          const SizedBox(height: 30),

                          // Timer/Resend Section
                          Obx(() {
                            return Column(
                              children: [
                                // Timer Display with colored seconds
                                if (!controller.canResend.value)
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Resend code in ",
                                          style: TextStyle(color: Colors.white70),
                                        ),
                                        TextSpan(
                                          text: "${controller.formatTime()}",
                                          style: TextStyle(color: Colors.orange[400]),
                                        ),
                                        TextSpan(
                                          text: " s",
                                          style: TextStyle(color: Colors.white70),
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
                                        fontColor: Colors.white70,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          controller.resendCode();
                                        },
                                        child: TextWidget(
                                          text: "Resend",
                                          fontColor: Colors.orange[300] ?? Colors.orange,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            );
                          }),
                          const SizedBox(height: 40),

                          // Reset Password Button
                          SizedBox(
                            width: double.infinity,
                            child: ButtonWidget(
                              backgroundColor: Colors.green[600] ?? Colors.green,
                              label: AppStrings.resetPassword,
                              buttonHeight: 50,
                              textColor: Colors.white,
                              onPressed: () {
                                // Handle reset password
                                if (controller.otpTextEditingController.text.length == 4) {
                                  // Process OTP verification
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
                          ),
                          const SizedBox(height: 20),
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

  Widget _buildPinCodeTextField(BuildContext context, controller) {
    return Container(

      child: PinCodeTextField(
        appContext: context,
        length: 4,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        obscureText: false,
        animationType: AnimationType.fade,
        keyboardType: TextInputType.number,
        textStyle:  TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(12.r),
          fieldHeight: 60.w,
          fieldWidth: 60.w,
          activeFillColor: Colors.white.withOpacity(0.1),
          activeColor: Colors.white,
          inactiveFillColor: Colors.white.withOpacity(0.05),
          inactiveColor: Colors.white.withOpacity(0.3),
          selectedFillColor: Colors.white.withOpacity(0.15),
          selectedColor: Colors.white,
          borderWidth: 2.w,
        ),
        cursorColor: Colors.white,
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        enableActiveFill: true,
        controller: controller.otpTextEditingController,
        onCompleted: (value) {
          // Auto-trigger verification when 4 digits are entered
          appLog("OTP Completed: $value");
        },
        onChanged: (value) {
          appLog("OTP Changed: $value");
        },
        beforeTextPaste: (text) {
          // Allow paste only if it's 4 digits
          return text?.length == 4 && RegExp(r'^\d+$').hasMatch(text!);
        },
      ),
    );
  }
}