import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';

import '../../../constant/app_icon_path.dart';
import '../../../constant/app_image_path.dart';
import '../../../utils/app_size.dart';

class ConfirmLocationSheet extends StatelessWidget {
  const ConfirmLocationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0EBE6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSize.width(value: 20)),
          topRight: Radius.circular(AppSize.width(value: 20)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSize.width(value: 20)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: AppSize.width(value: 40)),
                  Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: AppSize.width(value: 20),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black54,
                      size: AppSize.width(value: 24),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(height: AppSize.height(value: 15)),

              // Map Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.width(value: 15)),
                    child: Image.asset(
                      AppImagePath.mapImage2,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: AppSize.height(value: 20),
                    right: AppSize.width(value: 10),
                    child: Image.asset(
                      AppIconPath.myLocationIcon,
                      width: AppSize.width(value: 40),
                      height: AppSize.width(value: 40),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSize.height(value: 25)),

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
                      fontSize: AppSize.width(value: 16),
                      fontWeight: FontWeight.w500,
                      backgroundColor: const Color(0xFFE2DACC),
                      buttonRadius: BorderRadius.circular(AppSize.width(value: 8)),
                      textColor: const Color(0xFF565656),
                    ),
                  ),
                  SizedBox(width: AppSize.width(value: 15)),
                  // Confirm Location Button
                  Expanded(
                    child: ButtonWidget(
                      onPressed: (){
                        Get.back();
                      },
                      label: 'Confirm location',
                      fontSize: AppSize.width(value: 16),
                      fontWeight: FontWeight.w500,
                      backgroundColor: AppColor.backgroundColor,
                      buttonRadius: BorderRadius.circular(AppSize.width(value: 8)),
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