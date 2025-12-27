import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/widget/glass_effact.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../../widget/text_field_widget/text_field_widget.dart';
import 'controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
   ForgotPasswordScreen({super.key});
   final ForgotPasswordOnTapButtonController controller = Get.find<ForgotPasswordOnTapButtonController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImagePath.authBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(height: 30.h,),


              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.w, ),
                child: Center(
                  child: GlassEffact(
                //    height: 374,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Center(child: Image.asset(AppImagePath.appLogo, width: 61, height: 60)),
                          const SizedBox(height: 20),

                          Center(
                            child: TextWidget(
                              text: AppStrings.forgotPassword,
                              fontColor: AppColor.white500,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Center(
                            child: TextWidget(
                              text: AppStrings.resetPasswordInstruction,
                              fontColor: AppColor.white500,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),


                          // Email Label
                          TextWidget(
                            textAlignment: TextAlign.left,
                            text: AppStrings.email,
                            fontColor: AppColor.white500,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),

                          SizedBox(
                            height: 8.h,
                          ),

                          // Email TextField
                          TextFieldWidget(
                            controller: controller.emailTEController,
                            textColor: Colors.white,
                            hintText: AppStrings.enterYourEmail,
                            hintColor: Colors.white54,
                            backgroundColor: Colors.transparent,
                            borderColor: Colors.white,
                            focusedBorderColor: Colors.white,
                            borderRadius: 8,
                            borderWidth: 1.0,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          SizedBox(height: 32.h
                          ),


                          ButtonWidget(
                            onPressed: (){
                              controller.onTapSentPhoneOtpButton();
                            },
                            buttonWidth: double.infinity,
                            backgroundColor: AppColor.backgroundColor,
                            label: AppStrings.verify,
                            buttonHeight: 40,
                          ),

                           SizedBox(height: 29.h
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
}
