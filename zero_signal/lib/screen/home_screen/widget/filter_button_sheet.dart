import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zero_signal/widget/text_widget/text_widgets.dart';

import '../../../constant/app_colors.dart';
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
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: AppColor.bGColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with drag indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  // Drag indicator
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  
                  // Title row
                  Row(
                    children: [
                      const SizedBox(width: 48),
                      Expanded(
                        child: TextWidget(
                          text: 'Filters',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          fontColor: Colors.black87,
                          textAlignment: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      
            // Filter content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: GetBuilder<FilterController>(
                  builder: (controller) {
                    // Show loading state
                    if (controller.isLoading) {
                      return SizedBox(
                        height: 200.h,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppColor.backgroundColor),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Loading filters...',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    // Show error state
                    if (controller.errorMessage.isNotEmpty) {
                      return SizedBox(
                        height: 200.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red[400],
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32.w),
                              child: Text(
                                controller.errorMessage,
                                style: TextStyle(
                                  color: Colors.red[600],
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => controller.refreshCategories(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.backgroundColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 12.h,
                                ),
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    // Show filter categories
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...controller.filterCategories.entries.map((category) {
                          return _buildFilterCategory(
                              controller, category.key, category.value);
                        }),
                        SizedBox(height: 20.h),
                      ],
                    );
                  },
                ),
              ),
            ),
      
            // Bottom buttons - Fixed at bottom
            Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  // Clear All button
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () {
                        controller.clearAll();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(double.infinity, 48.h),
                      ),
                      child: TextWidget(
                        text: 'Clear All',
                        fontColor: AppColor.yello,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  
                  // Show Results button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.delete<FilterController>();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.backgroundColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(double.infinity, 48.h),
                      ),
                      child: TextWidget(
                        text: "Show Results",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontColor: Colors.white,
                      ),
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
        // Category title
        Padding(
          padding: EdgeInsets.only(top: 24.h, bottom: 16.h),
          child: Row(
            children: [
              Container(
                width: 4.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: AppColor.backgroundColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 12.w),
              TextWidget(
                text: title,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                fontColor: Colors.black87,
              ),
            ],
          ),
        ),
        
        // Filter options
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: options.map((option) {
            final isSelected = controller.selectedFilters.contains(option);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: GestureDetector(
                onTap: () => controller.toggleFilter(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.backgroundColor
                        : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? AppColor.backgroundColor
                          : Colors.grey[300]!,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: AppColor.backgroundColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      if (!isSelected)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        Padding(
                          padding: EdgeInsets.only(right: 6.w),
                          child: Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      TextWidget(
                        text: option,
                        fontSize: 14.sp,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontColor: isSelected ? Colors.white : Colors.black87,
                      ),
                    ],
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