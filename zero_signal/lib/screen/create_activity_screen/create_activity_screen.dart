import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zero_signal/constant/app_strings.dart';
import 'package:zero_signal/screen/create_activity_screen/controller/create_activity_controller.dart';
import 'package:zero_signal/widget/text_field_widget/text_field_widget.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../constant/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../utils/date_input_formatter.dart';
import '../../widget/button_widget/button_widget.dart';
import '../../widget/custom_dropdown.dart';
import '../sport_details/widget/date_picker_sheet.dart';

class CreateActivityScreen extends GetView<CreateActivityController> {
  const CreateActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CreateActivityController>()) {
      Get.put(CreateActivityController());
    }
    return Scaffold(
      backgroundColor: AppColor.creamBackgroundColor,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColor.creamBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.createActivity,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: AppStrings.activityTitle,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 8.h),
                TextFieldWidget(
                  controller: controller.titleController,
                  textColor: const Color(0xFF484949),
                  hintText: AppStrings.titleOfActivityHint,
                  borderColor: Colors.transparent,
                  backgroundColor: AppColor.lightGrayishOrange,
                  borderRadius: 8,
                ),
                const SizedBox(height: 12),
                TextWidget(
                  text: AppStrings.dateLabel,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 8.h),
                TextFieldWidget(
                  controller: controller.dateController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [DateInputFormatter()],
                  customSuffixIcon: InkWell(
                    onTap: () async {
                      final selectedDate = await showDatePickerSheet(context);
                      if (selectedDate != null) {
                        controller.dateController.text =
                            DateFormat('dd/MM/yyyy').format(selectedDate);
                      }
                    },
                    child: Image.asset(
                      Assets.icons.calender.path,
                      height: 18.h,
                      width: 18.w,
                    ),
                  ),
                  hintText: AppStrings.dateHint,
                  borderColor: Colors.transparent,
                  backgroundColor: AppColor.lightGrayishOrange,
                  borderRadius: 8,
                ),
                const SizedBox(height: 12),
                TextWidget(
                  textAlignment: TextAlign.start,
                  text: AppStrings.routeQuestion,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 8.h),
                CustomDropdown<String>(
                  items: [],
                  hint: AppStrings.selectRouteHint,
                  selectedValue: null,
                  borderRadius: 8,
                  onChanged: (value) {},
                  borderColor: AppColor.creamBackgroundColor,
                  dropdownColor: AppColor.lightGrayishOrange,
                  boxColor: AppColor.lightGrayishOrange,
                ),
                const SizedBox(height: 12),
                TextWidget(
                  text: AppStrings.locationLabel,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 8.h),
                TextFieldWidget(
                  controller: controller.addressController,
                  customSuffixIcon: IconButton(
                    icon: Icon(Icons.close, color: AppColor.backgroundColor),
                    onPressed: () => controller.addressController.clear(),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColor.yello,
                    size: 18,
                  ),
                  hintText: AppStrings.searchPlaceHint,
                  borderColor: Colors.transparent,
                  backgroundColor: AppColor.lightGrayishOrange,
                  borderRadius: 12,
                ),
                const SizedBox(height: 12),
                TextWidget(
                  text: AppStrings.activityTypeLabel,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 8.h),
                CustomDropdown<String>(
                  items:
                      controller.routeTypes.map((e) => e.name ?? "").toList(),
                  hint: AppStrings.selectTypeHint,
                  selectedValue: controller.selectedRouteType.value?.name,
                  borderRadius: 8,
                  onChanged: (value) {
                    controller.selectedRouteType.value = controller.routeTypes
                        .firstWhere((e) => e.name == value);
                  },
                  borderColor: AppColor.creamBackgroundColor,
                  dropdownColor: AppColor.lightGrayishOrange,
                  boxColor: AppColor.lightGrayishOrange,
                ),
                const SizedBox(height: 12),
                TextWidget(
                  text: AppStrings.descriptionHeader,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 8.h),
                TextFieldWidget(
                  controller: controller.descriptionController,
                  hintText: AppStrings.descriptionOfActivityHint,
                  minLines: 4,
                  maxLines: 5,
                  borderColor: Colors.transparent,
                  backgroundColor: AppColor.lightGrayishOrange,
                  borderRadius: 12,
                ),
                const SizedBox(height: 12),
                _uploadImagesBox(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextWidget(
                    text: AppStrings.maxPhotos,
                    fontColor: AppColor.yello,
                    textAlignment: TextAlign.end,
                  ),
                ),
                SizedBox(height: 12.h),
                TextWidget(
                  text: AppStrings.maxAttendees,
                  fontWeight: FontWeight.w400,
                ),
                TextFieldWidget(
                  controller: controller.maxParticipantsController,
                  hintText: AppStrings.enterNumberHint,
                  keyboardType: TextInputType.number,
                  borderColor: Colors.transparent,
                  backgroundColor: AppColor.lightGrayishOrange,
                  borderRadius: 12,
                ),
                SizedBox(height: 30.h),
                Center(
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : ButtonWidget(
                          onPressed: () {
                            controller.publishActivity();
                          },
                          buttonWidth: double.infinity,
                          backgroundColor: AppColor.backgroundColor,
                          label: AppStrings.publish,
                        ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _uploadImagesBox() => Column(
        children: [
          InkWell(
            onTap: () => controller.pickImages(),
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(245, 233, 223, 1),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: const Color.fromRGBO(245, 233, 223, 1)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 40, color: Colors.grey.shade600),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.addImages,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          if (controller.selectedImages.isNotEmpty) ...[
            SizedBox(height: 10.h),
            SizedBox(
              height: 80.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.selectedImages.length,
                separatorBuilder: (context, index) => SizedBox(width: 10.w),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          controller.selectedImages[index],
                          width: 80.w,
                          height: 80.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: InkWell(
                          onTap: () => controller.removeImage(index),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      );

  Future<DateTime?> showDatePickerSheet(BuildContext context) async {
    return await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Container(
          width: Get.width,
          color: AppColor.creamBackgroundColor,
          child: const DatePickerSheet(),
        ),
      ),
    );
  }
}
