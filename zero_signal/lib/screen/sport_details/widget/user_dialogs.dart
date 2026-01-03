import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/gen/assets.gen.dart';
import 'package:zero_signal/routes/app_routes.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/showCustomDialog.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../../repository/report_repository.dart';
import '../../../repository/user_repository.dart';

void showUserDialog(
  BuildContext context, {
  required String userId,
  required String userName,
  required String userBio,
  String? userImage,
}) {
  final UserRepository userRepository = UserRepository();

  showDialog(
    context: context,
    builder: (context) => ShowCustomDialog(
      backgroundColor: AppColor.creamBackgroundColor,
      title: '@$userName',
      titleStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      description: userBio.isNotEmpty ? userBio : AppStrings.noBioAvailable,
      descriptionStyle:
          const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
      image: userImage != null
          ? Image.network(
              userImage.startsWith('http')
                  ? userImage
                  : 'https://shariful5000.binarybards.online$userImage',
              errorBuilder: (_, __, ___) =>
                  Image.asset(AppImagePath.profileImage),
            )
          : Image.asset(AppImagePath.profileImage),
      actionsLayout: ActionsLayout.column,
      actions: [
        InkWell(
          onTap: () async {
            final success = await userRepository.likeUser(userId: userId);
            if (success) {
              Get.snackbar(
                AppStrings.success,
                AppStrings.likedUserMessage,
                backgroundColor: AppColor.backgroundColor,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
              Navigator.pop(context); // Optional: close dialog upon action
            } else {
              Get.snackbar(
                AppStrings.error,
                AppStrings.failedToLikeUser,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: Image.asset(
            Assets.icons.likeIcon.path,
            height: 24.h,
            width: 24.w,
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ButtonWidget(
            onPressed: () async {
              // Fetch user info and navigate
              // Or simply navigate passing ID if the target screen fetches it.
              // Based on prompt: "api call hobe ... get api eta ... eta api responce"
              // The user implies we might need to fetch data here?
              // Usually we pass ID to the next screen. Assuming ViewProfileScreen takes arguments.
              // But let's fetch to be safe as requested implicitly by showing the response structure suitable for passing.

              // However, typically we just navigate with ID.
              // Let's assume looking at AppRoutes might reveal if it takes args.
              // For now, I'll fetch and pass data if successful, or just pass ID.

              // Simplest approach: Call API, then navigate with result.
              final userInfo = await userRepository.getUserInfo(userId: userId);
              if (userInfo != null) {
                Get.back(); // Close dialog
                Get.toNamed(AppRoutes.viewProfileScreen, arguments: userInfo);
              } else {
                Get.snackbar(
                    AppStrings.error, AppStrings.couldNotRetrieveUserDetails);
              }
            },
            backgroundColor: AppColor.backgroundColor,
            label: AppStrings.viewProfile,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            buttonHeight: 40,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ButtonWidget(
            onPressed: () {
              Navigator.pop(context); // Close User Dialog first
              showReportDialog(context, userId: userId);
            },
            backgroundColor: Colors.transparent,
            textColor: Colors.red,
            label: AppStrings.reportUserLabel,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            buttonHeight: 40,
          ),
        ),
      ],
    ),
  );
}

void showReportDialog(BuildContext context, {required String userId}) {
  final TextEditingController reasonController = TextEditingController();
  final ReportRepository reportRepository = ReportRepository();
  final RxBool isLoading = false.obs;

  showDialog(
    context: context,
    builder: (context) => ShowCustomDialog(
      topPadding: 50,
      showIcon: false,
      backgroundColor: AppColor.creamBackgroundColor,
      title: AppStrings.reportUser,
      bottomPadding: 30,
      titleStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16.sp,
      ),
      description: AppStrings.reportInstruction,
      descriptionStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      image: Image.asset(AppImagePath.profileImage),
      actionsLayout: ActionsLayout.column,
      actionsAlignment: MainAxisAlignment.start,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: AppStrings.reasonForReporting,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              const SizedBox(
                height: 8,
              ),
              TextFieldWidget(
                controller: reasonController,
                hintText: AppStrings.reportPlaceholder,
                textColor: AppColor.subTitleColor,
                backgroundColor: AppColor.lightGrayishOrange,
                borderColor: AppColor.creamBackgroundColor,
                maxLines: 4,
                minLines: 3,
                borderRadius: 8,
              ),
              SizedBox(
                height: 30.h,
              ),
              Obx(() => isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ButtonWidget(
                      buttonHeight: 44,
                      buttonWidth: double.infinity,
                      onPressed: () async {
                        if (reasonController.text.trim().isEmpty) {
                          Get.snackbar(
                              AppStrings.error, AppStrings.pleaseEnterReason);
                          return;
                        }

                        isLoading.value = true;
                        final success = await reportRepository.reportItem(
                          reason: reasonController.text.trim(),
                          itemId: userId,
                          type: "User",
                        );
                        isLoading.value = false;

                        if (success) {
                          Get.back(); // Close dialog
                          Get.snackbar(
                            AppStrings.success,
                            AppStrings.reportSubmittedSuccessfully,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        } else {
                          Get.snackbar(
                            AppStrings.error,
                            AppStrings.failedToSubmitReport,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                        }
                      },
                      backgroundColor: AppColor.backgroundColor,
                      textColor: Colors.white,
                      label: AppStrings.sendToAdministration,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    )),
            ],
          ),
        ),
      ],
    ),
  );
}
