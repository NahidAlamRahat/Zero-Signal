import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../../utils/app_size.dart';
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
        borderRadius: ResponsiveUtils.width(20),
        padding: EdgeInsets.all(
          ResponsiveUtils.width(10),
        ),
        margin: EdgeInsets.symmetric(
            horizontal: AppSize.width(value: 40.0),
            vertical: AppSize.width(value: 30)),
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
        borderRadius: AppSize.width(value: 20.0),
        padding: EdgeInsets.all(AppSize.width(value: 10.0)),
        margin: EdgeInsets.symmetric(
            horizontal: AppSize.width(value: 40.0),
            vertical: AppSize.width(value: 30)),
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
        borderRadius: AppSize.width(value: 20.0),
        padding: EdgeInsets.all(AppSize.width(value: 10.0)),
        margin: EdgeInsets.symmetric(
            horizontal: AppSize.width(value: 40.0),
            vertical: AppSize.width(value: 30)),
      ),
    );
  }
}
