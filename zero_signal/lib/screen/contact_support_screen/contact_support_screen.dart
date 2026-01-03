import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/constant/app_colors.dart';
import 'package:zero_signal/screen/contact_support_screen/controller/contact_support_controller.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/widget/button_widget/button_widget.dart';
import 'package:zero_signal/widget/space_widget.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../gen/assets.gen.dart';

class ContactSupportScreen extends StatelessWidget {
  ContactSupportScreen({super.key});

  final ContactSupportController controller =
      Get.put(ContactSupportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.creamBackgroundColor, // Light beige background
      appBar: AppBar(
        backgroundColor: AppColor.creamBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Contact Support',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modifications label
            const Text(
              'Message',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Text input area
            TextFieldWidget(
              hintText: AppStrings.enterDescriptionHint,
              hintStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              controller: controller.messageController,
              borderColor: AppColor.creamBackgroundColor,
              borderRadius: 16,
              minLines: 7,
              maxLines: 8,
              backgroundColor: const Color.fromRGBO(245, 233, 223, 1),
            ),

            const SizedBox(height: 16),

            const TextWidget(
              text: 'Attach files',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            const SpaceWidget(
              spaceHeight: 12,
            ),

            // Image selection and preview row
            Row(
              children: [
                // Camera button
                GestureDetector(
                  onTap: () => controller.pickImages(),
                  child: Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: AppColor.lightGrayishOrange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        Assets.icons.cameraIcon2.path,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Previews
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(() => Row(
                          children: controller.selectedImages
                              .asMap()
                              .entries
                              .map((entry) {
                            int index = entry.key;
                            File file = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 48.w,
                                    height: 48.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: FileImage(file),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: GestureDetector(
                                      onTap: () =>
                                          controller.removeImage(index),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close,
                                            size: 14, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        )),
                  ),
                ),
              ],
            ),

            // Push everything else to bottom
            const Spacer(),

            // Submit button
            Center(
              child: Obx(() => ButtonWidget(
                    buttonWidth: double.infinity,
                    backgroundColor: AppColor.backgroundColor,
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.submitSupport(),
                    label: controller.isLoading.value
                        ? 'Sending...'
                        : 'Send to Support',
                  )),
            ),
            const SizedBox(height: 16),

            // Thank you message
            Center(
              child: Text(
                'Thank you for contact with us',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
