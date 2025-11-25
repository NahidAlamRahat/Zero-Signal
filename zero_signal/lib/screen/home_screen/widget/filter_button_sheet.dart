import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../../constant/app_colors.dart';
import '../../../widget/button_widget/button_widget.dart';
import '../conntroller/filter_controller.dart';

class FilterBottomSheet extends StatelessWidget {
  FilterBottomSheet({super.key}) {
    // Initialize controller in constructor
    if (!Get.isRegistered<FilterController>()) {
      Get.lazyPut(() => FilterController());
    }
  }

  // Getter to access the controller
  FilterController get controller => Get.find<FilterController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColor.bGColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(width: 48),
                  Expanded(
                    child: TextWidget(
                      text: 'Filters',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      fontColor: Colors.black87,
                      textAlignment: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 24),
                    color: Colors.black,
                  ),
                ],
              ),
            ),
      
            // Filter content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GetBuilder<FilterController>(
                  builder: (controller) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...controller.filterCategories.entries.map((category) {
                        return _buildFilterCategory(
                            controller, category.key, category.value);
                      }),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
      
            // Bottom buttons
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: InkWell(
                        onTap: () {
                          controller.clearAll();
                        },
                        child: TextWidget(
                          text: 'Clear All',
                          fontColor: AppColor.yello,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ButtonWidget(
                      buttonWidth: 10,
                      backgroundColor: AppColor.backgroundColor,
                      label: "Show Results",
                      buttonHeight: 48,
                      textColor: Colors.white,
                      onPressed: () {
                        Get.back();
                        Get.delete<FilterController>();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterCategory(
      FilterController controller, String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 12),
          child: TextWidget(
          text:   title,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontColor: AppColor.textColor,
          ),
        ),
        Wrap(
          spacing: 20.w,
          runSpacing: 12.h,
          children: options.map((option) {
            final isSelected = controller.selectedFilters.contains(option);
            return GestureDetector(
              onTap: () => controller.toggleFilter(option),
              child: Material(
                elevation: 0.0,
                borderRadius: BorderRadius.circular(20),

                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.backgroundColor
                        : AppColor.overLayBoxColor,
                    border: Border.all(
                      color: isSelected
                          ? AppColor.backgroundColor
                          :  Color(0xFFD6C8B0),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextWidget(
                   text:  option,
                    // style: TextStyle(
                    //   fontSize: 14,
                    //   fontWeight: FontWeight.w500,
                    //   color: isSelected ? Colors.white : Colors.black87,
                    // ),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontColor: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}