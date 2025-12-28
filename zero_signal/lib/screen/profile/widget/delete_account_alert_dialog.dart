import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/widget/space_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';
import 'package:zero_signal/constant/app_strings.dart';
import '../../../constant/app_colors.dart';
import '../controller/profile_controller.dart';

class DeleteAccountAlertDialog extends StatelessWidget {
  final ProfileController controller;

  const DeleteAccountAlertDialog({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.lightGrayishOrange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.all(12),
      content: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, size: 24),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
            SizedBox(height: 20.h),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextWidget(
                  text: AppStrings.wantToDeleteAccount,
                  textAlignment: TextAlign.center,
                  // style: TextStyle(
                  //   color: Color(0xFF2C2C2C),
                  //   fontSize: 20,
                  //   fontFamily: 'Poppins',
                  //   fontWeight: FontWeight.w500,
                  //   height: 1.10,
                  // ),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontColor: AppColor.textColor,
                ),
                const SizedBox(height: 8),
                const TextWidget(
                  text: AppStrings.confirmPasswordToDelete,
                  textAlignment: TextAlign.center,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontColor: AppColor.subTitleColor,
                ),
                const SpaceWidget(
                  spaceHeight: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextWidget(
                      text: AppStrings.enterPasswordLabel,
                      textAlignment: TextAlign.start,
                    ),
                    const SpaceWidget(
                      spaceHeight: 8,
                    ),
                    TextFieldWidget(
                      controller: controller.passwordController,
                      borderRadius: 8,
                      borderColor: AppColor.creamBackgroundColor,
                      hintText: AppStrings.enterPasswordLabel,
                      hintColor: AppColor.subTitleColor,
                      backgroundColor: AppColor.creamBackgroundColor,
                      suffixIcon: true,
                      suffixIconColor: AppColor.blackColor,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildButton(
                    label: AppStrings.cancel,
                    bgColor: Colors.transparent,
                    textColor: const Color(0xFF2E4F3E),
                    borderColor: const Color(0xFF2E4F3E),
                    onTap: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Obx(
                    () => _buildButton(
                      label: controller.isLoading.value
                          ? AppStrings.deleting
                          : AppStrings.delete,
                      bgColor: AppColor.creamBackgroundColor,
                      textColor: Colors.black,
                      onTap: controller.isLoading.value
                          ? () {}
                          : () => controller.deleteAccount(context),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required Color bgColor,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: ShapeDecoration(
        color: bgColor,
        shape: RoundedRectangleBorder(
          side: borderColor != null
              ? BorderSide(width: 1, color: borderColor)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: TextWidget(
          text: label,
          textAlignment: TextAlign.center,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontColor: textColor,
        ),
      ),
    );
  }
}

void showDeleteAccountDialog({
  required BuildContext context,
  required ProfileController controller,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DeleteAccountAlertDialog(controller: controller);
    },
  );
}
