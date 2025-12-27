import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/screen/auth/createa_password_screen/controller/create_pass_controller.dart';
import 'package:zero_signal/widget/glass_effact.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/space_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../../widget/text_field_widget/text_field_widget.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final CreatePassController controller = Get.find<CreatePassController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImagePath.authBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              child: Center(
                child: GlassEffact(
                  //  height: 480.h,
                  width: 390.w,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Image.asset(AppImagePath.appLogo,
                                  width: 61, height: 60)),
                          const SizedBox(height: 16),

                          Center(
                            child: TextWidget(
                              text: AppStrings.createPassword,
                              fontColor: AppColor.white500,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Center(
                            child: TextWidget(
                              text: AppStrings.yourNewPassword,
                              fontColor: AppColor.white500,
                              fontSize: 16,
                              maxLines: 2,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),

                          TextWidget(
                            textAlignment: TextAlign.left,
                            text: AppStrings.newPassword,
                            fontColor: AppColor.white500,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),

                          SizedBox(height: 8.h),

                          TextFieldWidget(
                            controller: controller.newPasswordController,
                            validator: controller.validateNewPassword,
                            textColor: Colors.white,
                            hintText: AppStrings.enterNewPassword,
                            hintColor: Colors.white54,
                            backgroundColor: Colors.transparent,
                            borderColor: Colors.white,
                            focusedBorderColor: Colors.white,
                            borderRadius: 8,
                            borderWidth: 1.0,
                            keyboardType: TextInputType.visiblePassword,
                            suffixIcon: true,
                          ),

                          SizedBox(
                            height: 20.w,
                          ),

                          TextWidget(
                            textAlignment: TextAlign.left,
                            text: AppStrings.confirmPassword,
                            fontColor: AppColor.white500,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),

                          SizedBox(height: 8.h),

                          // Confirm Password TextField
                          TextFieldWidget(
                            controller: controller.confirmPasswordController,
                            validator: controller.validateConfirmPassword,
                            textColor: Colors.white,
                            hintText: AppStrings.enterNewPassword,
                            hintColor: Colors.white54,
                            backgroundColor: Colors.transparent,
                            borderColor: Colors.white,
                            focusedBorderColor: Colors.white,
                            borderRadius: 8,
                            borderWidth: 1.0,
                            keyboardType: TextInputType.visiblePassword,
                            suffixIcon: true,
                          ),

                          SpaceWidget(
                            spaceHeight: 44,
                          ),
                          Obx(() => ButtonWidget(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : () => controller.onTapSaveButton(context),
                                buttonWidth: double.infinity,
                                backgroundColor: AppColor.backgroundColor,
                                label: controller.isLoading.value
                                    ? 'Loading...'
                                    : AppStrings.save,
                              )),
                        ],
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
