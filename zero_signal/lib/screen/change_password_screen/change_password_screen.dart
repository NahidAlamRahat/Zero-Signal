import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/screen/change_password_screen/controller/change_password_controller.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../widget/space_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({super.key});
  final ChangePasswordController controller =
      Get.find<ChangePasswordController>();

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.creamBackgroundColor,
      appBar: AppbarWidget(
        backgroundColor: AppColor.creamBackgroundColor,
        centerTitle: true,
        text: AppStrings.changePasswordHeader,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, right: 20, left: 20),
        child: Form(
          key: widget.controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SpaceWidget(spaceHeight: 16),
              TextWidget(
                text: AppStrings.currentPasswordLabel,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              SpaceWidget(spaceHeight: 8),
              TextFieldWidget(
                controller: widget.controller.currentPasswordController,
                validator: widget.controller.validateCurrentPassword,
                textColor: AppColor.subTitleColor,
                borderColor: AppColor.lightGrayishOrange,
                borderRadius: 8,
                hintText: AppStrings.enterCurrentPassword,
                backgroundColor: AppColor.lightGrayishOrange,
                suffixIcon: true,
                suffixIconColor: AppColor.blackColor,
              ),
              SpaceWidget(spaceHeight: 16),
              TextWidget(
                text: AppStrings.newPassword,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              SpaceWidget(spaceHeight: 8),
              TextFieldWidget(
                controller: widget.controller.newPasswordController,
                validator: widget.controller.validateNewPassword,
                textColor: AppColor.subTitleColor,
                borderColor: AppColor.lightGrayishOrange,
                borderRadius: 8,
                hintText: AppStrings.enterNewPassword,
                backgroundColor: AppColor.lightGrayishOrange,
                suffixIcon: true,
                suffixIconColor: AppColor.blackColor,
              ),
              SpaceWidget(spaceHeight: 16),
              TextWidget(
                text: AppStrings.confirmPassword,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              SpaceWidget(spaceHeight: 8),
              TextFieldWidget(
                controller: widget.controller.confirmPasswordController,
                validator: widget.controller.validateConfirmPassword,
                textColor: AppColor.subTitleColor,
                borderColor: AppColor.lightGrayishOrange,
                borderRadius: 8,
                hintText: AppStrings.reEnterNewPassword,
                backgroundColor: AppColor.lightGrayishOrange,
                suffixIcon: true,
                suffixIconColor: AppColor.blackColor,
              ),
              SpaceWidget(spaceHeight: 32),
              Obx(() => ButtonWidget(
                    onPressed: widget.controller.isLoading.value
                        ? null
                        : () => widget.controller.onTapChangeButton(),
                    buttonWidth: double.infinity,
                    backgroundColor: AppColor.backgroundColor,
                    label: widget.controller.isLoading.value
                        ? AppStrings.loading
                        : AppStrings.saveChanges,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
