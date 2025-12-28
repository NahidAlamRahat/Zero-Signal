import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/widget/appbar_widget/appbar_widget.dart';
import 'package:zero_signal/constant/app_strings.dart';

import 'controller/edit_activity_controller.dart';

import '../../constant/app_colors.dart';
import '../../widget/button_widget/button_widget.dart';
import '../../widget/text_field_widget/text_field_widget.dart';
import '../../widget/text_widget/text_widgets.dart';

class EditActivityScreen extends StatelessWidget {
  const EditActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditActivityController>(
        init: EditActivityController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppbarWidget(
              text: 'Edit Activity',
              backgroundColor: AppColor.bGColor,
              centerTitle: true,
            ),
            backgroundColor: AppColor.bGColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    TextWidget(
                      text: 'Description',
                      fontColor: AppColor.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 8.h),
                    TextFieldWidget(
                      controller: controller.descriptionController,
                      hintText:
                          'Let’s enjoy a scenic morning hike together. We’ll walk at a relaxed pace along a forest trail.',
                      hintColor: AppColor.subTitleColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      borderRadius: 8,
                      textColor: AppColor.subTitleColor,
                      backgroundColor: AppColor.overLayBoxColor,
                      borderColor: AppColor.overLayBoxColor,
                      maxLines: 5,
                      minLines: 4,
                    ),
                    SizedBox(height: 20.h),
                    TextWidget(
                      text: 'Number of participants',
                      fontColor: AppColor.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 8.h),
                    TextFieldWidget(
                      controller: controller.participantsController,
                      hintText: AppStrings.enterNumberOfParticipants,
                      hintColor: AppColor.subTitleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      borderRadius: 8,
                      textColor: AppColor.subTitleColor,
                      backgroundColor: AppColor.overLayBoxColor,
                      borderColor: AppColor.overLayBoxColor,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 145.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ButtonWidget(
                            textColor: AppColor.red,
                            backgroundColor: AppColor.red50,
                            label: "Cancel Activity",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                        SizedBox(width: 40.w),
                        Expanded(
                          child: Obx(() => ButtonWidget(
                                isLoading: controller.isLoading.value,
                                textColor: AppColor.white500,
                                backgroundColor: AppColor.backgroundColor,
                                label: "Update Information",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                onPressed: () {
                                  controller.updateActivity();
                                },
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
