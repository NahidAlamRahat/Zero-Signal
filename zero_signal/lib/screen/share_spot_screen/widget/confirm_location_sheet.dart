import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';

import '../../../constant/app_icon_path.dart';
import '../../../constant/app_image_path.dart';

class ConfirmLocationSheet extends StatelessWidget {
  const ConfirmLocationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0EBE6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.w),
          topRight: Radius.circular(20.w),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 40.w),
                  Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 20.w,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black54,
                      size: 24.w,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(height: 15.h),

              // Map Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.w),
                    child: Image.asset(
                      AppImagePath.mapImage2,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 20.h,
                    right: 10.w,
                    child: Image.asset(
                      AppIconPath.myLocationIcon,
                      width: 40.w,
                      height: 40.w,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel Button
                  Expanded(
                    child: ButtonWidget(
                      onPressed: (){
                        Get.back();
                      },
                      label: 'Cancel',
                      fontSize: 16.w,
                      fontWeight: FontWeight.w500,
                      backgroundColor: const Color(0xFFE2DACC),
                      buttonRadius: BorderRadius.circular(8.w),
                      textColor: const Color(0xFF565656),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  // Confirm Location Button
                  Expanded(
                    child: ButtonWidget(
                      onPressed: (){
                        Get.back();
                      },
                      label: 'Confirm location',
                      fontSize: 16.w,
                      fontWeight: FontWeight.w500,
                      backgroundColor: AppColor.backgroundColor,
                      buttonRadius: BorderRadius.circular(8.w),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}