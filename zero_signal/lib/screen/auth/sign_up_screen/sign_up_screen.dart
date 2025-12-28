import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_icon_path.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/widget/glass_effact.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';

import '../../../gen/assets.gen.dart';
import '../../../utils/date_input_formatter.dart';
import '../../../widget/text_widget/text_widgets.dart';
import 'controller/controller.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});
  final SignUpController controller = Get.find<SignUpController>();

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
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
                child: GetBuilder<SignUpController>(
                  builder: (controller) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 14.h),
                        GlassEffact(
                          width: 390.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Form(
                              key: controller.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 28.h),

                                  /// LOGO
                                  Center(
                                    child: Image.asset(
                                      AppImagePath.appLogo,
                                      height: 60.h,
                                      width: 61.w,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),

                                  /// Title
                                  Center(
                                    child: TextWidget(
                                      text: AppStrings.registration,
                                      fontColor: AppColor.white500,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),

                                  /// Subtitle
                                  Center(
                                    child: TextWidget(
                                      text: AppStrings.createYourAccount,
                                      fontColor: AppColor.white500,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),

                                  /// USER NAME LABEL
                                  TextWidget(
                                    textAlignment: TextAlign.left,
                                    text: AppStrings.userNameLabel,
                                    fontColor: AppColor.white500,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  SizedBox(height: 8.h),

                                  /// USER NAME FIELD
                                  TextFieldWidget(
                                    validator: controller.validateName,
                                    controller: controller.userNumberController,
                                    fieldHeight: 39,
                                    textColor: AppColor.white500,
                                    hintText: AppStrings.enterUserName,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    hintColor: AppColor.white500,
                                    backgroundColor: Colors.transparent,
                                    borderColor: AppColor.white500,
                                    focusedBorderColor: AppColor.white500,
                                    borderRadius: 8,
                                    borderWidth: 1.0,
                                    keyboardType: TextInputType.name,
                                  ),
                                  SizedBox(height: 16.h),

                                  /// EMAIL LABEL
                                  TextWidget(
                                    textAlignment: TextAlign.left,
                                    text: AppStrings.emailLabel,
                                    fontColor: AppColor.white500,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  SizedBox(height: 8.h),

                                  /// EMAIL FIELD
                                  TextFieldWidget(
                                    validator: controller.validateEmail,
                                    controller: controller.emailController,
                                    fieldHeight: 39,
                                    textColor: AppColor.white500,
                                    hintText: AppStrings.enterUserEmail,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    hintColor: AppColor.white500,
                                    backgroundColor: Colors.transparent,
                                    borderColor: AppColor.white500,
                                    focusedBorderColor: AppColor.white500,
                                    borderRadius: 8,
                                    borderWidth: 1.0,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  SizedBox(height: 16.h),

                                  /// DOB LABEL
                                  TextWidget(
                                    textAlignment: TextAlign.left,
                                    text: AppStrings.dateOfBirthLabel,
                                    fontColor: AppColor.white500,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  SizedBox(height: 8.h),

                                  /// DOB FIELD
                                  TextFieldWidget(
                                    validator: controller.validateDateOfBirth,
                                    controller: controller.birthDateController,
                                    customSuffixIcon: Image.asset(
                                      Assets.icons.calender.path,
                                      color: AppColor.white500,
                                      height: 16.h,
                                      width: 16.w,
                                    ),
                                    fieldHeight: 39,
                                    textColor: AppColor.white500,
                                    hintText: AppStrings.dateOfBirthHint,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    hintColor: AppColor.white500,
                                    backgroundColor: Colors.transparent,
                                    borderColor: AppColor.white500,
                                    focusedBorderColor: AppColor.white500,
                                    borderRadius: 8,
                                    borderWidth: 1.0,
                                    keyboardType: TextInputType.datetime,
                                    inputFormatters: [DateInputFormatter()],
                                  ),
                                  SizedBox(height: 16.h),

                                  /// PASSWORD LABEL
                                  TextWidget(
                                    textAlignment: TextAlign.left,
                                    text: AppStrings.passwordLabel,
                                    fontColor: AppColor.white500,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  SizedBox(height: 8.h),

                                  /// PASSWORD FIELD
                                  TextFieldWidget(
                                    validator: controller.validatePassword,
                                    controller: controller.passwordController,
                                    suffixIcon: true,
                                    iconPadding: 0,
                                    fieldHeight: 39,
                                    textColor: AppColor.white500,
                                    hintText: AppStrings.enterPassword,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    hintColor: AppColor.white500,
                                    backgroundColor: Colors.transparent,
                                    borderColor: AppColor.white500,
                                    focusedBorderColor: AppColor.white500,
                                    borderRadius: 8,
                                    borderWidth: 1.0,
                                    keyboardType: TextInputType.visiblePassword,
                                  ),
                                  SizedBox(height: 8.h),

                                  /// TERMS & CONDITIONS
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          side:
                                              BorderSide(color: Colors.white54),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
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
                                              TextSpan(
                                                  text:
                                                      "${AppStrings.byCreatingAccountIAccept} "),
                                              TextSpan(
                                                text: AppStrings
                                                    .termsAndConditions,
                                                style: TextStyle(
                                                  color: AppColor.green,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              TextSpan(
                                                  text:
                                                      " ${AppStrings.andText} "),
                                              TextSpan(
                                                text: AppStrings.privacyPolicy,
                                                style: TextStyle(
                                                  color: AppColor.green,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24.h),

                                  /// REGISTER BUTTON
                                  SizedBox(
                                    width: double.infinity,
                                    child: Visibility(
                                      visible: controller.isLoading == false,
                                      replacement: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      child: ButtonWidget(
                                        backgroundColor:
                                            AppColor.backgroundColor,
                                        label: AppStrings.register,
                                        buttonHeight: 46,
                                        textColor: AppColor.white500,
                                        onPressed: () {
                                          controller.onTapSignUpButton();
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),

                                  /// OR DIVIDER
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          color: AppColor.white500,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w),
                                        child: TextWidget(
                                          text: AppStrings.orText,
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

                                  /// GOOGLE BUTTON
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 75.w,
                                        height: 55.h,
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
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
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ));
  }
}
