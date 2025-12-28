import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/widget/glass_effact.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';
import '../../../utils/app_log/app_log.dart';
import 'controller/forgot_pass_verify_otp_screen_controller.dart';

// ignore: must_be_immutable
class ResetPassOtpVerifyScreen extends StatelessWidget {
  ResetPassOtpVerifyScreen({super.key});

  ForgotPassVerifyOtpScreenController controller =
      Get.find<ForgotPassVerifyOtpScreenController>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
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
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.h, vertical: 28.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceEvenly, // Equal spacing
                              children: [
                                // App Logo
                                Image.asset(AppImagePath.appLogo,
                                    width: 61.w, height: 60.h),
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
                                        text: AppStrings.enterText,
                                        style:
                                            TextStyle(color: AppColor.white500),
                                      ),
                                      TextSpan(
                                        text: "4",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 203, 32, 1)),
                                      ),
                                      TextSpan(
                                        text: AppStrings.digitsCode,
                                        style:
                                            TextStyle(color: AppColor.white500),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 12.h,
                                ),

                                // Subtitle
                                TextWidget(
                                  text: AppStrings.enterCodeEmailMessage,
                                  fontColor: AppColor.white500,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  textAlignment: TextAlign.center,
                                ),

                                SizedBox(
                                  height: 44.h,
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
                                                text: AppStrings.resendCodeIn,
                                                style: TextStyle(
                                                    color: AppColor.white500),
                                              ),
                                              TextSpan(
                                                text: controller.formatTime(),
                                                style: TextStyle(
                                                    color: AppColor.yello),
                                              ),
                                              TextSpan(
                                                text: " s",
                                                style: TextStyle(
                                                    color: AppColor.white500),
                                              ),
                                            ],
                                          ),
                                        ),

                                      // Resend Option
                                      if (controller.canResend.value)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextWidget(
                                              text:
                                                  AppStrings.didNotReceiveCode,
                                              fontColor: AppColor.white500,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                controller.resendCode();
                                              },
                                              child: TextWidget(
                                                text: "Resend",
                                                fontColor: AppColor.yello,
                                                fontSize: 14,
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
                                GetBuilder<ForgotPassVerifyOtpScreenController>(
                                    builder: (controller) {
                                  return Visibility(
                                    visible: controller.isLoading == false,
                                    replacement: CircularProgressIndicator(),
                                    child: ButtonWidget(
                                      backgroundColor: AppColor.backgroundColor,
                                      label: AppStrings.resetPassword,
                                      buttonHeight: 46.h,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        // Handle reset password
                                        if (controller.otpTextEditingController
                                                .text.length ==
                                            4) {
                                          controller.verifyOtpButton();
                                        } else {
                                          // Show error message
                                          // Show error message
                                          Fluttertoast.showToast(
                                            msg: AppStrings
                                                .completeFourDigitCodeError,
                                            backgroundColor: Colors.red
                                                .withValues(alpha: 0.8),
                                            textColor: Colors.white,
                                          );
                                        }
                                      },
                                    ),
                                  );
                                }),
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
            Positioned(
              top: 60.h,
              left: 20.w,
              child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back_ios_new_rounded)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPinCodeTextField(BuildContext context, controller) {
    // Calculate field width dynamically based on screen width
    double screenWidth = MediaQuery.of(context).size.width;
    double containerPadding =
        48.w; // total horizontal padding inside GlassEffact (24.w * 2)
    double spacing = 16.w; // space between fields
    double maxFieldWidth = 60.w; // maximum width for large screens

    // Calculate dynamic field width so 4 fields + spacing fit inside the GlassEffact
    double calculatedFieldWidth =
        ((screenWidth - containerPadding - spacing * 3) / 4)
            .clamp(40.w, maxFieldWidth);

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
