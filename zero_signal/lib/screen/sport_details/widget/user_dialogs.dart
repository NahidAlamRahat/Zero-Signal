import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/constant/app_image_path.dart';
import 'package:zero_signal/gen/assets.gen.dart';
import 'package:zero_signal/routes/app_routes.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/showCustomDialog.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

void showUserDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => ShowCustomDialog(
      backgroundColor: AppColor.creamBackgroundColor,
      title: '@naturanauta',
      titleStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      description: "I'm a nature lover and outdoor enthusiast",
      descriptionStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
      image: Image.asset(AppImagePath.profileImage),
      actionsLayout: ActionsLayout.column,
      actions: [
        Image.asset(
          Assets.icons.likeIcon.path,
          height: 24.h,
          width: 24.w,
        ),
        SizedBox(
          height: 16.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ButtonWidget(
            onPressed: () => Get.toNamed(AppRoutes.viewProfileScreen),
            backgroundColor: AppColor.backgroundColor,
            label: 'View Profile',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            buttonHeight: 40,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ButtonWidget(
            onPressed: () {
              showReportDialog(context);
            },
            backgroundColor: Colors.transparent,
            textColor: Colors.red,
            label: 'Report user',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            buttonHeight: 40,
          ),
        ),
      ],
    ),
  );
}

void showReportDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => ShowCustomDialog(
      topPadding: 50,
      showIcon: false,
      backgroundColor: AppColor.creamBackgroundColor,
      title: 'Report User',
      bottomPadding: 30,
      titleStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16.sp,
      ),
      description:
          'Your report is anonymous. Please provide details about the issue to help our moderation team.',
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
                text: 'Reason for reporting',
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              SizedBox(
                height: 8,
              ),
              TextFieldWidget(
                hintText: "e.g., inappropriate content, spam, harassment.....",
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
              ButtonWidget(
                buttonHeight: 44,
                buttonWidth: double.infinity,
                onPressed: () {
                  Get.back();
                  Fluttertoast.showToast(
                    msg: "Thank you for your feedback!",
                    backgroundColor: AppColor.backgroundColor,
                    textColor: Colors.white,
                  );
                },
                backgroundColor: AppColor.backgroundColor,
                textColor: Colors.white,
                label: 'Send to Administration',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
