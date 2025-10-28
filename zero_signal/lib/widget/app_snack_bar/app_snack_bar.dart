import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../text_widget/text_widgets.dart';

class AppSnackBar {
  static error(String parameterValue, {int seconds = 2}) {
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: Colors.grey,
        animationDuration: const Duration(seconds: 2),
        duration: Duration(seconds: seconds),
        isDismissible: true,
        onTap: (snack) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Get.closeAllSnackbars();
          });
        },
        messageText: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextWidget(
              text: "Error!",
              fontColor: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
            SizedBox(height: 5),
            TextWidget(
              text: parameterValue,
              fontColor: Colors.white,
              textAlignment: TextAlign.center,
            ),
          ],
        ),
        borderRadius: 20.w,
        padding: EdgeInsets.all(10.w),
        margin: EdgeInsets.symmetric(
            horizontal: 40.w,
            vertical: 30.w),
      ),
    );
  }

  static success(String parameterValue, {int seconds = 2}) {
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: Colors.grey,
        animationDuration: const Duration(seconds: 2),
        duration: Duration(seconds: seconds),
        isDismissible: true,
        onTap: (snack) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Get.closeAllSnackbars();
          });
        },
        messageText: TextWidget(
          text: parameterValue,
          fontColor: Colors.white,
          textAlignment: TextAlign.center,
        ),
        borderRadius: 20.w,
        padding: EdgeInsets.all(10.w),
        margin: EdgeInsets.symmetric(
            horizontal: 40.w,
            vertical: 30.w),
      ),
    );
  }

  static message(
    String parameterValue, {
    Color backgroundColor = Colors.grey,
    Color color = Colors.white,
    int seconds = 2,
  }) {
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: backgroundColor,
        animationDuration: const Duration(seconds: 2),
        duration: Duration(seconds: seconds),
        isDismissible: true,
        onTap: (snack) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Get.closeAllSnackbars();
          });
        },
        messageText: TextWidget(
          text: parameterValue,
          fontColor: color,
          fontSize: 16,
          textAlignment: TextAlign.center,
          fontWeight: FontWeight.w400,
        ),
        borderRadius: 20.w,
        padding: EdgeInsets.all(10.w),
        margin: EdgeInsets.symmetric(
            horizontal: 40.w,
            vertical: 30.w),
      ),
    );
  }
}
